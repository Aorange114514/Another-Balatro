-- Reworked Jokers (part B: uncommon-to-legendary rarity range).

--------------------------------------------------------------------------------
-- #26 Superposition: playing an Ace AND a King or 2 creates a Tarot card
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('superposition', {
    calculate = function(self, card, context)
        if ABR.is_main(context) and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local has_ace, has_k2 = false, false
            for _, v in ipairs(context.scoring_hand) do
                local id = v:get_id()
                if id == 14 then has_ace = true
                elseif id == 13 or id == 2 then has_k2 = true end
            end
            if has_ace and has_k2 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({ trigger = 'before', func = function()
                    local c = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'anba_sup')
                    c:add_to_deck()
                    G.consumeables:emplace(c)
                    G.GAME.consumeable_buffer = 0
                    return true
                end }))
                return { message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot, card = card }
            end
        end
    end,
})
--------------------------------------------------------------------------------
-- #27 To Do List: always the least-played hand type, pays $20
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('todo_list', {
    calculate = function(self, card, context)
        if ABR.is_main(context) then
            local target = ABR.least_played_hand()
            card.ability.anba_hand = target
            if context.scoring_name == target then
                ease_dollars(20)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 20
                G.E_MANAGER:add_event(Event({ func = function() G.GAME.dollar_buffer = 0; return true end }))
                return { message = '$20', dollars = 20, colour = G.C.MONEY }
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { 20, ABR.hand_name(card.ability.anba_hand or ABR.least_played_hand()) } }
    end,
})

--------------------------------------------------------------------------------
-- #29 Card Sharp: repeating the round's previous hand gains +X1 each time
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('card_sharp', {
    calculate = function(self, card, context)
        if ABR.is_main(context) then
            local cur = context.scoring_name
            if cur and cur == card.ability.anba_last then
                card.ability.anba_x = (card.ability.anba_x or 1) + 1
                card.ability.anba_last = cur
                return { Xmult_mod = card.ability.anba_x, message = ABR.msg_xmult(card.ability.anba_x), colour = G.C.MULT }
            else
                local was = card.ability.anba_x or 1
                card.ability.anba_x = 1
                card.ability.anba_last = cur
                if was > 1 then return ABR.msg_reset() end
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { ABR.hand_name(card.ability.anba_last), card.ability.anba_x or 1 } }
    end,
})

--------------------------------------------------------------------------------
-- #33 Seance: required hand type changes every round
--------------------------------------------------------------------------------
local SEANCE_HANDS = { 'High Card', 'Pair', 'Two Pair', 'Three of a Kind', 'Straight', 'Flush', 'Full House', 'Four of a Kind', 'Straight Flush' }

SMODS.Joker:take_ownership('seance', {
    calculate = function(self, card, context)
        if ABR.is_main(context) then
            local target = card.ability.anba_hand
            if not target then
                local pool = {}
                for _, h in ipairs(SEANCE_HANDS) do
                    if G.GAME.hands[h] and G.GAME.hands[h].visible then pool[#pool + 1] = h end
                end
                if pool[1] then
                    target = pseudorandom_element(pool, pseudoseed('anba_seance' .. (G.GAME.round_resets.ante or 1)))
                    card.ability.anba_hand = target
                end
            end
            if target and context.scoring_name == target
                and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({ trigger = 'before', func = function()
                    local c = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'anba_sea')
                    c:add_to_deck()
                    G.consumeables:emplace(c)
                    G.GAME.consumeable_buffer = 0
                    return true
                end }))
                return { message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral, card = card }
            end
        end
    end,
    loc_vars = function(self, info_queue, card) return { vars = { ABR.hand_name(card.ability.anba_hand) } } end,
})

--------------------------------------------------------------------------------
-- #34 Vampire: strips enhancements from ALL played cards (not just scoring)
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('vampire', {
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local n = 0
            for _, v in ipairs(context.full_hand) do
                if v.config.center ~= G.P_CENTERS.c_base and not v.debuff and not v.anba_vampired then
                    n = n + 1
                    v.anba_vampired = true
                    v:set_ability(G.P_CENTERS.c_base, nil, true)
                    G.E_MANAGER:add_event(Event({ func = function()
                        v:juice_up()
                        v.anba_vampired = nil
                        return true
                    end }))
                end
            end
            if n > 0 then
                card.ability.x_mult = card.ability.x_mult + card.ability.extra * n
                return { message = ABR.msg_xmult(card.ability.x_mult), colour = G.C.MULT, card = card }
            end
        elseif ABR.is_main(context) and card.ability.x_mult > 1 then
            return { Xmult_mod = card.ability.x_mult, message = ABR.msg_xmult(card.ability.x_mult), colour = G.C.MULT }
        end
    end,
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.x_mult or 1 } } end,
})

--------------------------------------------------------------------------------
-- #39 Midas Mask: turns ALL played face cards into Gold (not just scoring)
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('midas_mask', {
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local n = 0
            for _, v in ipairs(context.full_hand) do
                if v:is_face() then
                    n = n + 1
                    v:set_ability(G.P_CENTERS.m_gold, nil, true)
                    G.E_MANAGER:add_event(Event({ func = function() v:juice_up(); return true end }))
                end
            end
            if n > 0 then return { message = localize('k_gold'), colour = G.C.MONEY, card = card } end
        end
    end,
})

--------------------------------------------------------------------------------
-- #37 Baron: Kings in hand count as Steel and retrigger once, in hand and
-- when played. The x1.5 Steel-card bonus applies via Card:get_chip_h_x_mult
-- (mechanics.lua), so this handler only grants the extra retrigger.
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('baron', {
    calculate = function(self, card, context)
        local id = context.other_card and context.other_card:get_id()
        if not context.end_of_round and context.cardarea == G.hand and context.individual and id == 13 then
            if context.other_card.debuff then
                return { message = localize('k_debuffed'), colour = G.C.RED, card = card }
            end
        elseif context.repetition and id == 13 and (context.cardarea == G.hand or context.cardarea == G.play) then
            local ce = context.card_effects
            if ce and (next(ce[1] or {}) or #ce > 1) then
                return { message = localize('k_again_ex'), repetitions = 1, card = card }
            end
        end
    end,
})

--------------------------------------------------------------------------------
-- #52 Hanging Chad: retrigger the first scoring card 3 times (was 2)
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('hanging_chad', {
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
            return { message = localize('k_again_ex'), repetitions = card.ability.extra, card = card }
        end
    end,
})

--------------------------------------------------------------------------------
-- #36 Vagabond: generated Tarots are Negative
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('vagabond', {
    calculate = function(self, card, context)
        if ABR.is_main(context) and G.GAME.dollars <= card.ability.extra
            and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({ trigger = 'before', func = function()
                local c = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'anba_vag')
                c:set_edition({ negative = true }, true)
                c:add_to_deck()
                G.consumeables:emplace(c)
                G.GAME.consumeable_buffer = 0
                return true
            end }))
            return { message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot, card = card }
        end
    end,
})

--------------------------------------------------------------------------------
-- #60 Cartomancer: Tarot created on each chosen Blind is Negative
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('cartomancer', {
    calculate = function(self, card, context)
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced
            and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({ func = function()
                G.E_MANAGER:add_event(Event({ func = function()
                    local c = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'anba_car')
                    c:set_edition({ negative = true }, true)
                    c:add_to_deck()
                    G.consumeables:emplace(c)
                    G.GAME.consumeable_buffer = 0
                    return true
                end }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                    { message = localize('k_plus_tarot'), colour = G.C.PURPLE })
                return true
            end }))
        end
    end,
})

--------------------------------------------------------------------------------
-- #42 Turtle Bean: +1 hand size every Boss Blind beaten with it held
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('turtle_bean', {
    add_to_deck = function(self, card, from_debuff)
        -- reworked: no vanilla base +5 hand size, no decay over hands played
        card.ability.extra.h_size = 0
        card.ability.extra.h_mod = 0
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            if G.GAME.blind and G.GAME.blind.boss then
                card.ability.anba_bonus = (card.ability.anba_bonus or 0) + 1
                G.hand:change_size(1)
                return { message = localize { type = 'variable', key = 'a_handsize', vars = { 1 } }, colour = G.C.DARK_EDITION }
            end
        elseif context.selling_self and not context.blueprint and (card.ability.anba_bonus or 0) > 0 then
            G.hand:change_size(-card.ability.anba_bonus)
            card.ability.anba_bonus = 0
        end
    end,
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.anba_bonus or 0 } } end,
})

--------------------------------------------------------------------------------
-- #58 Invisible Joker: every N rounds, create a Negative copy of the LEFTMOST
-- Joker (never itself); the copy is deferred to an Event so end_round()'s own
-- loop over G.jokers.cards is not mutated mid-iteration.
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('invisible', {
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            card.ability.invis_rounds = (card.ability.invis_rounds or 0) + 1
            if card.ability.invis_rounds >= card.ability.extra then
                local target = (G.jokers.cards[1] ~= card) and G.jokers.cards[1] or G.jokers.cards[2]
                if target and not target.REMOVED then
                    card.ability.invis_rounds = 0
                    local src, owner = target, card
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.4,
                        func = function()
                            if src and not src.REMOVED and owner and not owner.REMOVED then
                                local copy = copy_card(src, nil)
                                copy:set_edition({ negative = true }, true)
                                copy:add_to_deck()
                                G.jokers:emplace(copy)
                                card_eval_status_text(owner, 'extra', nil, nil, nil, { message = localize('k_duplicated_ex'), colour = G.C.DARK_EDITION })
                            end
                            return true
                        end
                    }))
                    return { message = localize('k_active_ex'), colour = G.C.FILTER }
                else
                    card.ability.invis_rounds = card.ability.extra
                    return { message = localize('k_no_other_jokers'), colour = G.C.FILTER }
                end
            end
            return { message = (card.ability.invis_rounds .. '/' .. card.ability.extra), colour = G.C.FILTER }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra, card.ability.invis_rounds or 0 } }
    end,
})

--------------------------------------------------------------------------------
-- Hit the Road: each discarded Jack gives +X0.25, resets after Boss Blinds
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('hit_the_road', {
    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
            local id = context.other_card and context.other_card:get_id()
            if id == 11 then
                card.ability.x_mult = card.ability.x_mult + card.ability.extra
                return { message = ABR.msg_xmult(card.ability.x_mult), colour = G.C.RED, card = card }
            end
        elseif context.end_of_round and context.main_eval and not context.blueprint
            and G.GAME.blind and G.GAME.blind.boss and card.ability.x_mult > 1 then
            card.ability.x_mult = 1
            return ABR.msg_reset()
        elseif ABR.is_main(context) and card.ability.x_mult > 1 then
            return { Xmult_mod = card.ability.x_mult, message = ABR.msg_xmult(card.ability.x_mult), colour = G.C.MULT }
        end
    end,
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.x_mult or 1 } } end,
})

--------------------------------------------------------------------------------
-- #49 Smiley Face: scoring face cards give this Joker permanent +1 Mult
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('smiley', {
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card and context.other_card:is_face() then
            card.ability.mult = card.ability.mult + 1
            return { message = localize('k_upgrade_ex'), colour = G.C.MULT, card = card }
        elseif ABR.is_main(context) and card.ability.mult > 0 then
            return { mult_mod = card.ability.mult, message = ABR.msg_mult(card.ability.mult), colour = G.C.MULT }
        end
    end,
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.mult or 0 } } end,
})

--------------------------------------------------------------------------------
-- #59 Driver's License: X1 + X0.125 per Enhanced card in the full deck
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('drivers_license', {
    calculate = function(self, card, context)
        if ABR.is_main(context) then
            local n = 0
            for _, v in pairs(G.playing_cards) do
                if v.config.center ~= G.P_CENTERS.c_base then n = n + 1 end
            end
            local x = 1 + 0.125 * n
            return { Xmult_mod = x, message = ABR.msg_xmult(x), colour = G.C.MULT }
        end
    end,
    loc_vars = function(self, info_queue, card)
        local n = 0
        local base = G.P_CENTERS and G.P_CENTERS.c_base
        for _, v in pairs(G.playing_cards or {}) do
            if v.config.center ~= base then n = n + 1 end
        end
        return { vars = { 1 + 0.125 * n } }
    end,
})

--------------------------------------------------------------------------------
-- #61 Burnt Joker: upgrade the poker hand you discard, once per hand type
-- per round. A hand type is settled on the FIRST discard event in which it
-- is discarded; every source card taking part in that event -- this Joker
-- itself plus each Blueprint/Brainstorm resolving to it -- adds one upgrade.
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('burnt', {
    calculate = function(self, card, context)
        if context.pre_discard and not context.hook then
            local text = G.FUNCS.get_poker_hand_info(context.full_hand) or 'High Card'
            -- discards_used is constant through one discard's pass sequence,
            -- then bumped right after (state_events.lua): it stamps the event
            local event = (G.GAME.current_round and G.GAME.current_round.discards_used) or 0
            local per_card = ABR.upgrade_sources[card]
            if not per_card then per_card = {}; ABR.upgrade_sources[card] = per_card end
            local cell = per_card[text]
            if not cell then
                cell = { event = event, frozen = false, cap = 0, used = 0, sources = {} }
                per_card[text] = cell
            elseif cell.event ~= event then
                cell.frozen = true
            end
            local src = context.blueprint_card or card
            if not cell.sources[src] then
                cell.sources[src] = true
                if not cell.frozen then cell.cap = cell.cap + 1 end
            end
            if cell.used < cell.cap then
                cell.used = cell.used + 1
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex') })
                update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
                    { handname = localize(text, 'poker_hands'), chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level = G.GAME.hands[text].level })
                level_up_hand(context.blueprint_card or card, text, nil, 1)
                update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 }, { mult = 0, chips = 0, handname = '', level = '' })
                return nil, true -- "this Joker triggered", consumed by SMODS' retrigger pipeline
            end
        end
    end,
})

--------------------------------------------------------------------------------
-- #53 Flower Pot: Xn per distinct suit in the scoring hand (2 suits = X2, ...)
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('flower_pot', {
    calculate = function(self, card, context)
        if ABR.is_main(context) then
            local suits, n = {}, 0
            for _, v in ipairs(context.scoring_hand) do
                for _, s in ipairs({ 'Hearts', 'Diamonds', 'Spades', 'Clubs' }) do
                    if v:is_suit(s, true) and not suits[s] then suits[s] = true; n = n + 1 end
                end
            end
            if n >= 2 then
                return { Xmult_mod = n, message = 'X' .. n, colour = G.C.MULT }
            end
        end
    end,
})

--------------------------------------------------------------------------------
-- #54 The Idol: X3 Mult for cards matching the round's first scoring card
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('idol', {
    calculate = function(self, card, context)
        if context.before then
            if not G.GAME.current_round.anba_idol and context.scoring_hand and context.scoring_hand[1] then
                G.GAME.current_round.anba_idol = {
                    value = context.scoring_hand[1].base.value,
                    suit = context.scoring_hand[1].base.suit,
                }
            end
        elseif context.cardarea == G.play and context.individual and context.other_card then
            local t = G.GAME.current_round.anba_idol
            if t and context.other_card.base.value == t.value and context.other_card.base.suit == t.suit then
                return { x_mult = 3, colour = G.C.RED, card = card }
            end
        end
    end,
})

--------------------------------------------------------------------------------
-- #62 Chicot: Boss Blind chip requirement is halved
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('chicot', {
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            -- context.blind is the blind *definition* (no chips field); the
            -- active G.GAME.blind already had chips computed by set_blind()
            if context.blind and context.blind.boss and G.GAME.blind and G.GAME.blind.chips then
                G.GAME.blind.chips = math.max(1, math.ceil(G.GAME.blind.chips / 2))
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = '1/2', colour = G.C.RED })
            end
        end
    end,
})

--------------------------------------------------------------------------------
-- #11 Steel Joker: Steel cards retrigger once; +5 Mult each time one triggers
--------------------------------------------------------------------------------
local function is_steel(v)
    return v and not v.debuff and v.config.center == G.P_CENTERS.m_steel
end

SMODS.Joker:take_ownership('steel_joker', {
    calculate = function(self, card, context)
        if not context.end_of_round and context.cardarea == G.hand and context.individual and is_steel(context.other_card) then
            card.ability.mult = (card.ability.mult or 0) + 5
            return { h_mult = 5, card = card }
        elseif not context.end_of_round and context.repetition and context.cardarea == G.hand and is_steel(context.other_card) then
            local ce = context.card_effects
            if ce and (next(ce[1] or {}) or #ce > 1) then
                return { message = localize('k_again_ex'), repetitions = 1, card = card }
            end
        end
    end,
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.mult or 0 } } end,
})

--------------------------------------------------------------------------------
-- #51 Throwback: skipped Blinds raise Mult to the power of (1 + 0.25 x skips)
-- (exponent applied in final_scoring.lua; trigger tracking only)
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('throwback', {
    calculate = function(self, card, context)
        ABR.record_trigger(card, context)
    end,
    -- exponent actually applied in final_scoring.lua: 1 + extra x skipped Blinds
    loc_vars = function(self, info_queue, card)
        local skips = G.GAME and G.GAME.skips or 0
        local extra = card.ability.extra or 0.25
        return { vars = { extra, ABR.fmt_mult(1 + extra * skips) } }
    end,
})

--------------------------------------------------------------------------------
-- #41 Photograph: first face card of each scored hand gives X2 (kept)
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('photograph', {
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual then
            local first_face
            for _, v in ipairs(context.scoring_hand) do
                if v:is_face() then first_face = v; break end
            end
            if context.other_card == first_face then
                return { x_mult = card.ability.extra, colour = G.C.RED, card = card }
            end
        end
    end,
})

