-- Shared helpers for every Joker file. Populates the ABR namespace declared
-- in the main file.

-- true during the plain "main scoring" pass of a Joker in G.jokers
function ABR.is_main(context)
    return context and context.joker_main and context.cardarea == G.jokers
end

function ABR.has_joker(name, ignore_debuff)
    for _, v in ipairs(G.jokers.cards) do
        if v.ability.name == name and (ignore_debuff or not v.debuff) then
            return v
        end
    end
end

function ABR.msg_mult(v)
    return localize { type = 'variable', key = 'a_mult', vars = { v } }
end
function ABR.msg_chips(v)
    return localize { type = 'variable', key = 'a_chips', vars = { v } }
end
function ABR.msg_xmult(v)
    return localize { type = 'variable', key = 'a_xmult', vars = { v } }
end
function ABR.msg_upgrade(colour)
    return { message = localize('k_upgrade_ex'), colour = colour or G.C.MULT }
end
function ABR.msg_reset()
    return { message = localize('k_reset'), colour = G.C.RED }
end

-- round a multiplier to 2 decimals for clean floating-text display
function ABR.fmt_mult(x)
    return math.floor(x * 100 + 0.5) / 100
end

--------------------------------------------------------------------------------
-- Blueprint / Brainstorm trigger bookkeeping
--------------------------------------------------------------------------------
-- Blueprint and Brainstorm work by re-running the copied Joker's `calculate`,
-- and every copy pass carries context.blueprint_card = the copier it started
-- from. Counting those *source cards* gives exactly the number of
-- applications vanilla would perform: one for the Joker itself, plus one per
-- Blueprint/Brainstorm resolving to it. Keys here are card objects and must
-- never reach the save file; they are wiped every round in reset_game_globals.
ABR.trigger_sources = {} -- [card] = { hand = <hands_played>, sources = {} }
ABR.upgrade_sources = {} -- Burnt Joker: [card][hand_type] = { event=, frozen=, cap=, used=, sources={} }

-- how many times `card`'s effect triggers for the hand currently being scored
function ABR.trigger_count(card)
    local cell = ABR.trigger_sources[card]
    if cell and cell.hand == G.GAME.hands_played then
        local n = 0
        for _ in pairs(cell.sources) do n = n + 1 end
        if n > 0 then return n end
    end
    return 1
end

-- call from a Joker's own `calculate` during the main scoring pass
function ABR.record_trigger(self, context)
    if not ABR.is_main(context) then return end
    local cell = ABR.trigger_sources[self]
    if not cell or cell.hand ~= G.GAME.hands_played then
        cell = { hand = G.GAME.hands_played, sources = {} }
        ABR.trigger_sources[self] = cell
    end
    cell.sources[context.blueprint_card or self] = true
end

function ABR.hand_name(k)
    return k and localize(k, 'poker_hands') or '?'
end

function ABR.least_played_hand()
    if not G.GAME or not G.GAME.hands then return nil end
    local best, best_n = nil, math.huge
    for k, v in pairs(G.GAME.hands) do
        if v.visible and (v.played or 0) < best_n then
            best, best_n = k, v.played or 0
        end
    end
    return best
end
