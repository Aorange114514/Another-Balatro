--- STEAMODDED HEADER
--- MOD_NAME: Another Balatro
--- MOD_ID: AnotherBalatro
--- MOD_AUTHOR: [you]
--- MOD_DESCRIPTION: Experience-improving rebalance for 62 vanilla Jokers.
--- BADGE_COLOUR: 7FC8F8
--- PREFIX: anba
--- VERSION: 1.0.0
--- ----------------------------------------------
--- ------------MOD CODE -------------------------

-- Rebalances a large set of vanilla Jokers by overwriting centre data
-- (rarity / cost / default config) and by intercepting the hard-coded
-- vanilla behaviour in Card:calculate_joker / Card:generate_UIBox_ability_table
-- for every Joker whose effect (or tooltip variables) is reworked.

local AB = SMODS.current_mod

--------------------------------------------------------------------------------
-- 0) Steamodded compatibility: its zh_CN / ko localization ships some *_info
--    keys as plain strings, but the vanilla create_toggle / create_option_cycle
--    iterate args.info with ipairs(), crashing the config UI. Normalise a string
--    info into a one-element table before delegating (Brook-style hook; no smods
--    changes needed).
--------------------------------------------------------------------------------
local create_toggle_ref = create_toggle
function create_toggle(args)
    if args and type(args.info) == 'string' then
        args.info = { args.info }
    end
    return create_toggle_ref(args)
end

local create_option_cycle_ref = create_option_cycle
function create_option_cycle(args)
    if args and type(args.info) == 'string' then
        args.info = { args.info }
    end
    return create_option_cycle_ref(args)
end

--------------------------------------------------------------------------------
-- helpers
--------------------------------------------------------------------------------

-- true when this is the "plain main scoring" pass for a Joker
local function is_main(context)
    return context and context.joker_main and context.cardarea == G.jokers
end

local function has_joker(name, ignore_debuff)
    for _, v in ipairs(G.jokers.cards) do
        if v.ability.name == name and (ignore_debuff or not v.debuff) then
            return v
        end
    end
end

local function msg_add_mult(v)
    return { message = localize { type = 'variable', key = 'a_mult', vars = { v } }, colour = G.C.MULT }
end
local function msg_add_chips(v)
    return { message = localize { type = 'variable', key = 'a_chips', vars = { v } }, colour = G.C.CHIPS }
end
local function msg_x_mult(v)
    return { message = localize { type = 'variable', key = 'a_xmult', vars = { v } }, colour = G.C.MULT }
end
local function msg_upgrade(colour)
    return { message = localize('k_upgrade_ex'), colour = colour or G.C.MULT }
end
local function msg_reset()
    return { message = localize('k_reset'), colour = G.C.RED }
end

--------------------------------------------------------------------------------
-- 1) centre-data overrides (rarity / cost / default config)
--    These only touch G.P_CENTERS, so freshly generated cards start with the
--    new numbers while the vanilla hard-coded logic keeps driving the effect.
--------------------------------------------------------------------------------

local CONFIG_OVERRIDES = {
    -- rarity targets
    j_red_card = { rarity = 2, config = { extra = 6 } },
    j_madness = { rarity = 3, config = { extra = 1 } },
    j_shortcut = { rarity = 1 },
    j_luchador = { rarity = 1 },
    j_baseball = { rarity = 2 },
    j_diet_cola = { rarity = 1 },
    j_ticket = { rarity = 2 },
    j_mr_bones = { rarity = 1 },
    j_hanging_chad = { rarity = 2, config = { extra = 3 } },
    j_flower_pot = { rarity = 3 },
    j_idol = { rarity = 3 },
    j_blueprint = { rarity = 2 },
    j_brainstorm = { rarity = 2 },
    j_cartomancer = { rarity = 3 },
    j_burnt = { rarity = 2 },
    j_photograph = { rarity = 2 },
    j_bull = { rarity = 3, config = { extra = 3 } },
    -- pure number tweaks that keep vanilla behaviour
    j_8_ball = { config = { extra = 2 } },           -- 1/2 chance
    j_space = { config = { extra = 2 } },            -- 1/2 chance
    j_ride_the_bus = { config = { extra = 2 } },     -- grows by +2
    j_wee = { config = { extra = { chips = 0, chip_mod = 10 } } },
    j_blue_joker = { config = { extra = 31 } },
    j_hiker = { config = { extra = 15 } },
    j_square = { config = { extra = { chips = 0, chip_mod = 6 } } },
    j_misprint = { config = { extra = { min = 4, max = 30 } } },
    j_golden = { cost = 4 },
    j_obelisk = { config = { extra = 0.25, Xmult = 1 } },
    j_supernova = { config = { extra = 2 } },        -- chips = 2 * times hand played
    j_half = { config = { extra = { mult = 15, size = 3 } } },
    j_burglar = { config = { extra = 5 } },
    j_erosion = { config = { extra = 0.2 } },
    j_hit_the_road = { config = { extra = 0.25 } },
    j_green_joker = { config = { extra = { hand_add = 2, discard_sub = 2 } } },
    j_red_card = { rarity = 2, config = { extra = 6 } },
    j_invisible = { config = { extra = 5 } },            -- copy leftmost every 5 rounds
}

for key, ov in pairs(CONFIG_OVERRIDES) do
    local c = G.P_CENTERS[key]
    if c then
        if ov.rarity then c.rarity = ov.rarity end
        if ov.cost then c.cost = ov.cost end
        if ov.config then c.config = ov.config end
    end
end

-- Egg: default sell value +3 (sell_cost = floor(cost/2) + extra_value)
-- Ice Cream: default sell value -1 (still at least $1)
local set_ability_ref = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    set_ability_ref(self, center, initial, delay_sprites)
    if center and center.set == 'Joker' then
        if self.ability.name == 'Egg' and not self.ability.ab_egg_base then
            self.ability.extra_value = (self.ability.extra_value or 0) + 3
            self.ability.ab_egg_base = true
            if G.GAME and self.set_cost then self:set_cost() end
        elseif self.ability.name == 'Ice Cream' and not self.ability.ab_ice_base then
            self.ability.extra_value = (self.ability.extra_value or 0) - 1
            self.ability.ab_ice_base = true
            if G.GAME and self.set_cost then self:set_cost() end
        elseif self.ability.name == 'Turtle Bean' then
            -- reworked: no base +5 hand size, no decay
            self.ability.extra.h_size = 0
            self.ability.extra.h_mod = 0
        elseif self.ability.name == 'Joker' and not self.ability.anba_neg then
            -- the base "Joker" joker is inherently Negative (+1 joker slot)
            self.ability.anba_neg = true
            if not self.edition and G.GAME and G.STATE ~= G.STATES.MENU then
                self:set_edition({ negative = true }, true)
            end
        end
    end
end

--------------------------------------------------------------------------------
-- 2) Joker rework handlers
--    Every handler is called *instead of* the vanilla calculate_joker chain for
--    that Joker name, for every context; handlers simply return nil when the
--    context is not relevant.
--------------------------------------------------------------------------------

local REWORK = {}

-- helper for per-hand odd/face tallies used by final scoring adjustments
local function anba_hand_trigger(self, context, key)
    if context.cardarea == G.play and context.individual then
        self.ability[key] = (self.ability[key] or 0) + 1
    end
end

-- Trigger bookkeeping for Jokers whose effect is settled outside of their own
-- calculate_joker return value (Burnt Joker / Runner / Stone Joker / Throwback).
-- Blueprint and Brainstorm work by re-running the copied Joker's calculate_joker, and
-- every copy pass carries context.blueprint_card = the copier it started from. Counting
-- those *source cards* therefore gives exactly the number of applications vanilla would
-- have performed: one for the Joker itself plus one per Blueprint / Brainstorm that
-- resolves to it (a chain of Blueprints contributes one per Blueprint, and two
-- Brainstorms copying the same leftmost Joker contribute two).
-- Source cards are used as set keys, which must never reach the save file, so nothing
-- is written to card.ability here: these tables are transient and are cleared every
-- round in reset_game_globals (anba_trigger_sources is also stamped per hand).
local anba_upgrade_sources = {} -- Burnt Joker: [card][hand_type] = { event = <discards_used>, frozen = bool, cap = n, used = n, sources = {} }
local anba_trigger_sources = {} -- Runner / Stone Joker / Throwback: [card] = { hand = <hands_played>, sources = {} }

-- how many times `card`'s effect is triggered by the hand currently being scored
-- (1 = nothing copied it)
local function anba_trigger_count(card)
    local cell = anba_trigger_sources[card]
    if cell and cell.hand == G.GAME.hands_played then
        local n = 0
        for _ in pairs(cell.sources) do n = n + 1 end
        if n > 0 then return n end
    end
    return 1
end

-- called from the Joker's own calculate_joker during the main scoring pass
local function anba_record_triggers(self, context)
    if not is_main(context) then return end
    local cell = anba_trigger_sources[self]
    if not cell or cell.hand ~= G.GAME.hands_played then
        cell = { hand = G.GAME.hands_played, sources = {} }
        anba_trigger_sources[self] = cell
    end
    cell.sources[context.blueprint_card or self] = true
end

--------------------------------------------------------------------------------
-- Half Joker: +15 Mult if 3 or fewer scoring cards
--------------------------------------------------------------------------------
REWORK['Half Joker'] = function(self, context)
    if is_main(context) and #context.scoring_hand <= 3 then
        return { mult_mod = 15, message = msg_add_mult(15).message, colour = G.C.MULT }
    end
end

--------------------------------------------------------------------------------
-- Joker Stencil: each empty Joker slot grants +10 Chips AND X1.5 Mult
--------------------------------------------------------------------------------
REWORK['Joker Stencil'] = function(self, context)
    if is_main(context) then
        local empty = G.jokers.config.card_limit - #G.jokers.cards
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.name == 'Joker Stencil' then empty = empty + 1 end
        end
        if empty > 0 then
            return {
                chip_mod = 10 * empty,
                Xmult_mod = 1 + 0.5 * empty,
                message = 'X1.5/+10 x' .. empty,
                colour = G.C.MULT,
            }
        end
    end
end

--------------------------------------------------------------------------------
-- Ceremonial Dagger: devour rightmost Joker for 3x its sell value
--------------------------------------------------------------------------------
REWORK['Ceremonial Dagger'] = function(self, context)
    if context.selling_self then
        return
    elseif context.setting_blind and not context.blueprint then
        local my_pos = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == self then my_pos = i break end
        end
        if my_pos and G.jokers.cards[my_pos + 1] and not self.getting_sliced
            and not G.jokers.cards[my_pos + 1].ability.eternal
            and not G.jokers.cards[my_pos + 1].getting_sliced then
            local sliced = G.jokers.cards[my_pos + 1]
            sliced.getting_sliced = true
            G.GAME.joker_buffer = (G.GAME.joker_buffer or 0) - 1
            G.E_MANAGER:add_event(Event({ func = function()
                G.GAME.joker_buffer = 0
                local gain = sliced.sell_cost * 3
                self.ability.mult = self.ability.mult + gain
                self:juice_up(0.8, 0.8)
                sliced:start_dissolve({ HEX('57ecab') }, nil, 1.6)
                play_sound('slice1', 0.96 + math.random() * 0.08)
                return true
            end }))
            card_eval_status_text(self, 'extra', nil, nil, nil,
                { message = localize { type = 'variable', key = 'a_mult', vars = { self.ability.mult } }, colour = G.C.MULT, no_juice = true })
        end
    elseif is_main(context) and self.ability.mult > 0 then
        return { mult_mod = self.ability.mult, message = msg_add_mult(self.ability.mult).message, colour = G.C.MULT }
    end
end

--------------------------------------------------------------------------------
-- Banner: each remaining discard gives X1 Chips (additive X on the score):
-- effective multiplier = (1 + discards_left) applied to the score via Xmult
--------------------------------------------------------------------------------
REWORK['Banner'] = function(self, context)
    if is_main(context) and G.GAME.current_round.discards_left > 0 then
        local x = 1 + G.GAME.current_round.discards_left
        return {
            Xmult_mod = x,
            message = localize { type = 'variable', key = 'a_xmult', vars = { x } },
            colour = G.C.CHIPS,
        }
    end
end

--------------------------------------------------------------------------------
-- Fibonacci: +8 Mult AND +20 Chips per scoring A,2,3,5,8
--------------------------------------------------------------------------------
REWORK['Fibonacci'] = function(self, context)
    if context.cardarea == G.play and context.individual then
        local id = context.other_card and context.other_card:get_id()
        if id == 2 or id == 3 or id == 5 or id == 8 or id == 14 then
            return { chips = 20, mult = self.ability.extra, card = self }
        end
    end
end

--------------------------------------------------------------------------------
-- Supernova: +{times played} Mult plus +{2 x times played} Chips
--------------------------------------------------------------------------------
REWORK['Supernova'] = function(self, context)
    if is_main(context) then
        local played = G.GAME.hands[context.scoring_name].played
        return {
            mult_mod = played,
            chip_mod = 2 * played,
            message = msg_add_mult(played).message .. ' / ' .. msg_add_chips(2 * played).message,
            colour = G.C.MULT,
        }
    end
end

--------------------------------------------------------------------------------
-- Even Steven: scoring even-numbered cards give X1.1 Mult
--------------------------------------------------------------------------------
REWORK['Even Steven'] = function(self, context)
    if context.cardarea == G.play and context.individual then
        local id = context.other_card and context.other_card:get_id()
        if id and id <= 10 and id > 0 and id % 2 == 0 then
            return { x_mult = 1.1, colour = G.C.MULT, card = self }
        end
    end
end

--------------------------------------------------------------------------------
-- Odd Todd: 每张计分的奇数牌（A、3、5、7、9）使筹码 ×1.5
--------------------------------------------------------------------------------
REWORK['Odd Todd'] = function(self, context)
    if context.cardarea == G.play and context.individual then
        local id = context.other_card and context.other_card:get_id()
        if id and ((id <= 10 and id > 0 and id % 2 == 1) or id == 14) then
            return { x_chips = 1.5, card = self }
        end
    end
end

--------------------------------------------------------------------------------
-- Scholar: 每张计分的 A 使倍率 ×1.5 且筹码 ×1.5
--------------------------------------------------------------------------------
REWORK['Scholar'] = function(self, context)
    if context.cardarea == G.play and context.individual then
        local id = context.other_card and context.other_card:get_id()
        if id == 14 then
            return { x_mult = 1.5, x_chips = 1.5, card = self }
        end
    end
end

REWORK['Runner'] = function(self, context)
    if context.before and not context.blueprint then
        if context.poker_hands and next(context.poker_hands['Straight']) then
            self.ability.anba_chips_mult = (self.ability.anba_chips_mult or 1) + 0.5
            return msg_upgrade(G.C.CHIPS)
        end
    elseif is_main(context) then
        -- the chips multiplier itself is applied at the final scoring step; record how
        -- many times this Joker is triggered so Blueprint / Brainstorm copies count too
        anba_record_triggers(self, context)
    end
end

REWORK['Stone Joker'] = function(self, context)
    -- effect applied at the final scoring step (chip multiplier); the trigger count is
    -- recorded here so Blueprint / Brainstorm copies multiply the chips a second time
    anba_record_triggers(self, context)
end

REWORK['Erosion'] = function(self, context)
    if is_main(context) then
        local missing = math.max(0, (G.GAME.starting_deck_size or 0) - #G.playing_cards)
        if missing > 0 then
            local x = 1 + self.ability.extra * missing
            return { Xmult_mod = x, message = localize { type = 'variable', key = 'a_xmult', vars = { x } }, colour = G.C.MULT }
        end
    end
end

--------------------------------------------------------------------------------
-- Loyalty Card: X0.5 base, +X0.5 every hand played, reset after X4 is exceeded
--------------------------------------------------------------------------------
REWORK['Loyalty Card'] = function(self, context)
    if is_main(context) then
        self.ability.anba_x = self.ability.anba_x or 0.5
        if self.ability.anba_x > 4 then
            self.ability.anba_x = 0.5
            return msg_reset()
        end
        local cur = self.ability.anba_x
        self.ability.anba_x = cur + 0.5
        return {
            Xmult_mod = cur,
            message = localize { type = 'variable', key = 'a_xmult', vars = { cur } },
            colour = G.C.MULT,
        }
    end
end

--------------------------------------------------------------------------------
-- Green Joker: +2 Mult each hand played AND each discard action
--------------------------------------------------------------------------------
REWORK['Green Joker'] = function(self, context)
    if context.before and not context.blueprint then
        self.ability.mult = self.ability.mult + self.ability.extra.hand_add
        return { message = msg_add_mult(self.ability.extra.hand_add).message, colour = G.C.MULT }
    elseif context.discard and not context.blueprint then
        if context.other_card == context.full_hand[#context.full_hand] then
            self.ability.mult = self.ability.mult + self.ability.extra.discard_sub
            return { message = msg_add_mult(self.ability.extra.discard_sub).message, colour = G.C.MULT }
        end
    elseif is_main(context) and self.ability.mult > 0 then
        return { mult_mod = self.ability.mult, message = msg_add_mult(self.ability.mult).message, colour = G.C.MULT }
    end
end

--------------------------------------------------------------------------------
-- Cavendish: X3 Mult, never destroys itself
--------------------------------------------------------------------------------
REWORK['Cavendish'] = function(self, context)
    if is_main(context) then
        return {
            Xmult_mod = self.ability.extra.Xmult,
            message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.extra.Xmult } },
            colour = G.C.MULT,
        }
    end
end

--------------------------------------------------------------------------------
-- Marble Joker: the first scoring card of each Blind becomes a Stone card
--------------------------------------------------------------------------------
REWORK['Marble Joker'] = function(self, context)
    if context.setting_blind then
        self.ability.anba_used = nil
    elseif is_main(context) and not self.ability.anba_used and not context.blueprint then
        local target = context.scoring_hand and context.scoring_hand[1]
        if target and not target.debuff and target.config.center ~= G.P_CENTERS.m_stone then
            self.ability.anba_used = true
            target:set_ability(G.P_CENTERS.m_stone, nil, true)
            target:juice_up()
            return { message = localize('k_stone_ex'), colour = G.C.SECONDARY_SET.Enhanced, card = self }
        end
    end
end

--------------------------------------------------------------------------------
-- Superposition: contains an Ace AND a King or 2
--------------------------------------------------------------------------------
REWORK['Superposition'] = function(self, context)
    if is_main(context) then
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local has = { a = false, k2 = false }
            for _, v in ipairs(context.scoring_hand) do
                local id = v:get_id()
                if id == 14 then has.a = true
                elseif id == 13 or id == 2 then has.k2 = true end
            end
            if has.a and has.k2 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({ trigger = 'before', delay = 0.0, func = (function()
                    local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'anba_sup')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end) }))
                return { message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot, card = self }
            end
        end
    end
end

--------------------------------------------------------------------------------
-- To Do List: always the least played hand type, pays $20
--------------------------------------------------------------------------------
local function least_played_hand()
    if not G.GAME or not G.GAME.hands then return nil end
    local best, best_n = nil, math.huge
    for k, v in pairs(G.GAME.hands) do
        if v.visible and (v.played or 0) < best_n then
            best, best_n = k, v.played or 0
        end
    end
    return best
end

REWORK['To Do List'] = function(self, context)
    if is_main(context) then
        local target = least_played_hand()
        self.ability.anba_hand = target
        if context.scoring_name == target then
            ease_dollars(20)
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 20
            G.E_MANAGER:add_event(Event({ func = (function() G.GAME.dollar_buffer = 0 return true end) }))
            return { message = '$20', dollars = 20, colour = G.C.MONEY }
        end
    end
end

--------------------------------------------------------------------------------
-- Card Sharp: repeat of the round's previous hand gains X1 each time
--------------------------------------------------------------------------------
REWORK['Card Sharp'] = function(self, context)
    if is_main(context) then
        local cur = context.scoring_name
        if cur and cur == self.ability.anba_last then
            self.ability.anba_x = (self.ability.anba_x or 1) + 1
            self.ability.anba_last = cur
            return {
                Xmult_mod = self.ability.anba_x,
                message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.anba_x } },
                colour = G.C.MULT,
            }
        else
            local was = self.ability.anba_x or 1
            self.ability.anba_x = 1
            self.ability.anba_last = cur
            if was > 1 then return msg_reset() end
        end
    end
end

--------------------------------------------------------------------------------
-- Seance: required hand type changes every round
--------------------------------------------------------------------------------
local SEANCE_HANDS = { 'High Card', 'Pair', 'Two Pair', 'Three of a Kind', 'Straight', 'Flush', 'Full House', 'Four of a Kind', 'Straight Flush' }

REWORK['Seance'] = function(self, context)
    if is_main(context) then
        local target = self.ability.anba_hand
        if not target then
            local pool = {}
            for _, h in ipairs(SEANCE_HANDS) do
                if G.GAME.hands[h] and G.GAME.hands[h].visible then pool[#pool + 1] = h end
            end
            if pool[1] then
                target = pseudorandom_element(pool, pseudoseed('anba_seance' .. (G.GAME.round_resets.ante or 1)))
                self.ability.anba_hand = target
            end
        end
        if target and context.scoring_name == target and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({ trigger = 'before', delay = 0.0, func = (function()
                local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'anba_sea')
                card:add_to_deck()
                G.consumeables:emplace(card)
                G.GAME.consumeable_buffer = 0
                return true
            end) }))
            return { message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral, card = self }
        end
    end
end

--------------------------------------------------------------------------------
-- Vampire: strips enhancements from ALL played cards (not just scoring)
--------------------------------------------------------------------------------
REWORK['Vampire'] = function(self, context)
    if context.before and not context.blueprint then
        local enhanced = {}
        for _, v in ipairs(context.full_hand) do
            if v.config.center ~= G.P_CENTERS.c_base and not v.debuff and not v.vampired then
                enhanced[#enhanced + 1] = v
                v.vampired = true
                v:set_ability(G.P_CENTERS.c_base, nil, true)
                G.E_MANAGER:add_event(Event({ func = function()
                    v:juice_up()
                    v.vampired = nil
                    return true
                end }))
            end
        end
        if #enhanced > 0 then
            self.ability.x_mult = self.ability.x_mult + self.ability.extra * #enhanced
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.x_mult } },
                colour = G.C.MULT,
                card = self,
            }
        end
    elseif is_main(context) and self.ability.x_mult > 1 then
        return { Xmult_mod = self.ability.x_mult, message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.x_mult } }, colour = G.C.MULT }
    end
end

--------------------------------------------------------------------------------
-- Midas Mask: turns ALL played face cards into Gold
--------------------------------------------------------------------------------
REWORK['Midas Mask'] = function(self, context)
    if context.before and not context.blueprint then
        local faces = {}
        for _, v in ipairs(context.full_hand) do
            if v:is_face() then
                faces[#faces + 1] = v
                v:set_ability(G.P_CENTERS.m_gold, nil, true)
                G.E_MANAGER:add_event(Event({ func = function()
                    v:juice_up()
                    return true
                end }))
            end
        end
        if #faces > 0 then
            return { message = localize('k_gold'), colour = G.C.MONEY, card = self }
        end
    end
end

--------------------------------------------------------------------------------
-- Baron: Kings in hand count as Steel; Kings retrigger once (hand & play)
--------------------------------------------------------------------------------
-- The "Kings count as Steel" base x1.5 is applied at the card level
-- (Card:get_chip_h_x_mult), so it fires once per King regardless of how many
-- Barons / Blueprint copies you own. The retrigger below then adds one
-- extra trigger per Baron (n Barons => x1.5 applied 1 + n times per King).
local get_chip_h_x_mult_ref = Card.get_chip_h_x_mult
function Card:get_chip_h_x_mult()
    local v = get_chip_h_x_mult_ref(self)
    if not self.debuff and self:get_id() == 13 and has_joker('Baron') and (not v or v <= 1) then
        return 1.5
    end
    return v
end

REWORK['Baron'] = function(self, context)
    local id = context.other_card and context.other_card:get_id()
    if not context.end_of_round and context.cardarea == G.hand and context.individual and id == 13 then
        if context.other_card.debuff then
            return { message = localize('k_debuffed'), colour = G.C.RED, card = self }
        end
        -- x1.5 applied once per King via Card:get_chip_h_x_mult (see above)
    elseif context.repetition and id == 13 and (context.cardarea == G.hand or context.cardarea == G.play) then
        local ce = context.card_effects
        if ce and (next(ce[1] or {}) or #ce > 1) then
            return { message = localize('k_again_ex'), repetitions = 1, card = self }
        end
    end
end

--------------------------------------------------------------------------------
-- Hanging Chad: retrigger the first scoring card 3 times
--------------------------------------------------------------------------------
REWORK['Hanging Chad'] = function(self, context)
    if context.repetition and context.cardarea == G.play
        and context.other_card == context.scoring_hand[1] then
        return { message = localize('k_again_ex'), repetitions = self.ability.extra, card = self }
    end
end

--------------------------------------------------------------------------------
-- Vagabond: generated Tarots are Negative
--------------------------------------------------------------------------------
REWORK['Vagabond'] = function(self, context)
    if is_main(context) then
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and G.GAME.dollars <= self.ability.extra then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({ trigger = 'before', delay = 0.0, func = (function()
                local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'anba_vag')
                card:set_edition({ negative = true }, true)
                card:add_to_deck()
                G.consumeables:emplace(card)
                G.GAME.consumeable_buffer = 0
                return true
            end) }))
            return { message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot, card = self }
        end
    end
end

--------------------------------------------------------------------------------
-- Cartomancer: Tarot created each Blind is Negative
--------------------------------------------------------------------------------
REWORK['Cartomancer'] = function(self, context)
    if context.setting_blind and not (context.blueprint_card or self).getting_sliced
        and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({ func = (function()
            G.E_MANAGER:add_event(Event({ func = function()
                local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'anba_car')
                card:set_edition({ negative = true }, true)
                card:add_to_deck()
                G.consumeables:emplace(card)
                G.GAME.consumeable_buffer = 0
                return true
            end }))
            card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, { message = localize('k_plus_tarot'), colour = G.C.PURPLE })
            return true
        end) }))
    end
end

--------------------------------------------------------------------------------
-- Turtle Bean: +1 hand size every Boss Blind beaten with it
--------------------------------------------------------------------------------
REWORK['Turtle Bean'] = function(self, context)
    if context.end_of_round and context.main_eval and not context.blueprint then
        if G.GAME.blind and G.GAME.blind.boss then
            self.ability.anba_bonus = (self.ability.anba_bonus or 0) + 1
            G.hand:change_size(1)
            return { message = localize { type = 'variable', key = 'a_handsize', vars = { 1 } }, colour = G.C.DARK_EDITION }
        end
    elseif context.selling_self and not context.blueprint and (self.ability.anba_bonus or 0) > 0 then
        G.hand:change_size(-self.ability.anba_bonus)
        self.ability.anba_bonus = 0
    end
end

--------------------------------------------------------------------------------
-- Invisible Joker: every 5 rounds, create a Negative copy of the LEFTMOST Joker.
-- It never copies itself, and the actual copy is deferred out of the end-of-round
-- iteration so G.jokers.cards is not mutated while end_round() loops over it.
--------------------------------------------------------------------------------
REWORK['Invisible Joker'] = function(self, context)
    if context.end_of_round and not context.blueprint
        and not context.individual and not context.repetition then
        self.ability.invis_rounds = (self.ability.invis_rounds or 0) + 1
        if self.ability.invis_rounds >= self.ability.extra then
            -- the leftmost Joker that is NOT this Invisible Joker itself
            local target = (G.jokers.cards[1] ~= self) and G.jokers.cards[1] or G.jokers.cards[2]
            if target and not target.REMOVED then
                self.ability.invis_rounds = 0
                local src, owner = target, self
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        if src and not src.REMOVED and owner and not owner.REMOVED then
                            local copy = copy_card(src, nil)
                            copy:set_edition({ negative = true }, true)
                            copy:add_to_deck()
                            G.jokers:emplace(copy)
                            card_eval_status_text(owner, 'extra', nil, nil, nil, {
                                message = localize('k_duplicated_ex'), colour = G.C.DARK_EDITION })
                        end
                        return true
                    end
                }))
                return { message = localize('k_active_ex'), colour = G.C.FILTER }
            else
                -- no other Joker to copy: stay ready for a later round
                self.ability.invis_rounds = self.ability.extra
                return { message = localize('k_no_other_jokers'), colour = G.C.FILTER }
            end
        end
        return { message = (self.ability.invis_rounds .. '/' .. self.ability.extra), colour = G.C.FILTER }
    end
end

--------------------------------------------------------------------------------
-- Hit the Road: each discarded Jack gives +X0.25, reset after Boss Blinds
--------------------------------------------------------------------------------
REWORK['Hit the Road'] = function(self, context)
    if context.discard and not context.blueprint then
        local id = context.other_card and context.other_card:get_id()
        if id == 11 then
            self.ability.x_mult = self.ability.x_mult + self.ability.extra
            return { message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.x_mult } }, colour = G.C.RED, card = self }
        end
    elseif context.end_of_round and context.main_eval and not context.blueprint and G.GAME.blind and G.GAME.blind.boss and self.ability.x_mult > 1 then
        self.ability.x_mult = 1
        return msg_reset()
    elseif is_main(context) and self.ability.x_mult > 1 then
        return { Xmult_mod = self.ability.x_mult, message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.x_mult } }, colour = G.C.MULT }
    end
end

--------------------------------------------------------------------------------
-- Smiley Face: scoring face cards give this Joker +1 Mult (permanent)
--------------------------------------------------------------------------------
REWORK['Smiley Face'] = function(self, context)
    if context.cardarea == G.play and context.individual and context.other_card and context.other_card:is_face() then
        self.ability.mult = self.ability.mult + 1
        return { message = localize('k_upgrade_ex'), colour = G.C.MULT, card = self }
    elseif is_main(context) and self.ability.mult > 0 then
        return { mult_mod = self.ability.mult, message = msg_add_mult(self.ability.mult).message, colour = G.C.MULT }
    end
end

--------------------------------------------------------------------------------
-- Driver's License: X1 + X0.125 per Enhanced card in the full deck
--------------------------------------------------------------------------------
REWORK["Driver's License"] = function(self, context)
    if is_main(context) then
        local tally = 0
        for _, v in pairs(G.playing_cards) do
            if v.config.center ~= G.P_CENTERS.c_base then tally = tally + 1 end
        end
        local x = 1 + 0.125 * tally
        return { Xmult_mod = x, message = localize { type = 'variable', key = 'a_xmult', vars = { x } }, colour = G.C.MULT }
    end
end

--------------------------------------------------------------------------------
-- Burnt Joker: upgrade the discarded hand type once per round, +1 for every
-- Blueprint / Brainstorm taking part in that first discard event
--------------------------------------------------------------------------------
REWORK['Burnt Joker'] = function(self, context)
    -- Blueprint / Brainstorm copies are allowed through, exactly like the vanilla
    -- hard-coded branch (which has no `not context.blueprint` guard): the copy simply
    -- runs this same handler.
    -- A hand type is settled exactly once per round, on the first discard event in which
    -- it is discarded: every source card taking part in *that* event -- this Joker itself
    -- plus each Blueprint / Brainstorm copy resolving to it, whatever their positions --
    -- adds one upgrade. Discarding the same hand type again, or re-pointing a Blueprint
    -- at this Joker later in the round, no longer adds upgrades, so a level-up is never
    -- credited to a copier while the Joker itself stays silent.
    if context.pre_discard and not context.hook then
        local text = G.FUNCS.get_poker_hand_info(context.full_hand)
        text = text and text or 'High Card'
        -- discards_used is constant for the whole pass sequence of one discard and is
        -- incremented right afterwards (state_events.lua), so it stamps the event
        local event = (G.GAME.current_round and G.GAME.current_round.discards_used) or 0
        local per_card = anba_upgrade_sources[self]
        if not per_card then per_card = {}; anba_upgrade_sources[self] = per_card end
        local cell = per_card[text]
        if not cell then
            cell = { event = event, frozen = false, cap = 0, used = 0, sources = {} }
            per_card[text] = cell
        elseif cell.event ~= event then
            cell.frozen = true
        end
        local src = context.blueprint_card or self
        if not cell.sources[src] then
            cell.sources[src] = true
            if not cell.frozen then cell.cap = cell.cap + 1 end
        end
        if cell.used < cell.cap then
            cell.used = cell.used + 1
            card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex') })
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
                { handname = localize(text, 'poker_hands'), chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level = G.GAME.hands[text].level })
            level_up_hand(context.blueprint_card or self, text, nil, 1)
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 }, { mult = 0, chips = 0, handname = '', level = '' })
            return nil, true -- "this Joker triggered", consumed by SMODS' retrigger pipeline
        end
    end
end

--------------------------------------------------------------------------------
-- Flower Pot: X per distinct suit in the scoring hand (2 suits = X2, ...)
--------------------------------------------------------------------------------
REWORK['Flower Pot'] = function(self, context)
    if is_main(context) then
        local suits = {}
        for _, v in ipairs(context.scoring_hand) do
            for _, s in ipairs({ 'Hearts', 'Diamonds', 'Spades', 'Clubs' }) do
                if v:is_suit(s, true) and not suits[s] then suits[s] = true end
            end
        end
        local n = 0
        for _ in pairs(suits) do n = n + 1 end
        if n >= 2 then
            return { Xmult_mod = n, message = 'X' .. n, colour = G.C.MULT }
        end
    end
end

--------------------------------------------------------------------------------
-- Idol: X3 for cards matching the first scoring card of the round
--------------------------------------------------------------------------------
REWORK['The Idol'] = function(self, context)
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
            return { x_mult = 3, colour = G.C.RED, card = self }
        end
    end
end

--------------------------------------------------------------------------------
-- Chicot: Boss Blind chip requirement is halved
--------------------------------------------------------------------------------
REWORK['Chicot'] = function(self, context)
    if context.setting_blind and not context.blueprint then
        -- `context.blind` is G.GAME.round_resets.blind (the blind *definition*),
        -- which carries no `chips` field. The active blind G.GAME.blind has had
        -- its `chips` computed by set_blind() in new_round() already.
        if context.blind and context.blind.boss and G.GAME.blind and G.GAME.blind.chips then
            G.GAME.blind.chips = math.max(1, math.ceil(G.GAME.blind.chips / 2))
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            card_eval_status_text(self, 'extra', nil, nil, nil, { message = '1/2', colour = G.C.RED })
        end
    end
end

--------------------------------------------------------------------------------
-- Steel Joker: Steel cards retrigger once; +5 Mult each time Steel triggers
--------------------------------------------------------------------------------
local function is_steel(v)
    return v and not v.debuff and v.config.center == G.P_CENTERS.m_steel
end

REWORK['Steel Joker'] = function(self, context)
    if not context.end_of_round and context.cardarea == G.hand and context.individual and is_steel(context.other_card) then
        self.ability.mult = (self.ability.mult or 0) + 5
        return { h_mult = 5, card = self }
    elseif not context.end_of_round and context.repetition and context.cardarea == G.hand and is_steel(context.other_card) then
        local ce = context.card_effects
        if ce and (next(ce[1] or {}) or #ce > 1) then
            return { message = localize('k_again_ex'), repetitions = 1, card = self }
        end
    end
end

--------------------------------------------------------------------------------
-- Throwback: the extra Mult from skipped Blinds now powers (^) the Mult
--------------------------------------------------------------------------------
REWORK['Throwback'] = function(self, context)
    -- The exponent itself is applied at the final scoring step, so nothing may be
    -- returned here. Recording the trigger count is what makes Blueprint / Brainstorm
    -- copies work: vanilla applies this Joker through the generic "ability.x_mult > 1"
    -- block of Card:calculate_joker, which every copier re-runs for the copied card.
    anba_record_triggers(self, context)
end

--------------------------------------------------------------------------------
-- Photograph: first face card of each scored hand gives X2
-- (kept behaviour, rarity raised to uncommon)
--------------------------------------------------------------------------------
REWORK['Photograph'] = function(self, context)
    if context.cardarea == G.play and context.individual then
        local first_face
        for _, v in ipairs(context.scoring_hand) do
            if v:is_face() then first_face = v break end
        end
        if context.other_card == first_face then
            return { x_mult = self.ability.extra, colour = G.C.RED, card = self }
        end
    end
end

--------------------------------------------------------------------------------
-- 3) Hook the vanilla hard-coded calculate_joker chain
--------------------------------------------------------------------------------
local calculate_joker_ref = Card.calculate_joker
function Card:calculate_joker(context, ...)
    if self.ability and self.ability.set == 'Joker' and not self.debuff then
        local fn = REWORK[self.ability.name]
        if fn then
            -- forward the second return value ("this Joker triggered"): SMODS'
            -- better_calc uses it to drive its retrigger pipeline
            local ret, triggered = fn(self, context, ...)
            return ret, triggered
        end
    end
    return calculate_joker_ref(self, context, ...)
end

--------------------------------------------------------------------------------
-- 4) Scary Face rework: played face cards never return to the deck while
--    Scary Face is held. They stay parked in the discard pile and are returned
--    to the deck when Scary Face is sold or destroyed (Brook "Pulp Fiction" style).
--------------------------------------------------------------------------------

-- Disable the vanilla "+30 Chips for played face cards" scoring effect: the
-- reworked Scary Face is a passive effect handled entirely by the hooks below.
REWORK['Scary Face'] = function(self, context)
end

local has_scary = function()
    return has_joker('Scary Face')
end

local draw_card_ref = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
    -- Mark a played face card as parked by Scary Face.
    if from == G.play and to == G.discard and card and card:is_face() and has_scary() then
        card.ability.anba_scary = true
    end
    -- A parked face card must never be drawn back into the deck. This guard lives
    -- in draw_card itself (not only in the G.FUNCS.draw_from_discard_to_deck
    -- override below), because every mod assigns that global outright and the
    -- last one loaded wins: Brook sorts after AnotherBalatro and replaces it with
    -- a version that only knows about `pulp`, which would silently drop our
    -- `anba_scary` handling. Both implementations pass the card explicitly to
    -- draw_card, so intercepting here is independent of mod load order.
    if from == G.discard and to == G.deck and card and card.ability and card.ability.anba_scary then
        return
    end
    return draw_card_ref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
end

-- Draw every discard card back to the deck, except the face cards parked by
-- Scary Face. draw_card only *queues* the move (as an event), so G.discard.cards
-- stays stable during this loop -- no skipped cards and no nil index (unlike a
-- synchronous Card:remove inside the loop).
G.FUNCS.draw_from_discard_to_deck = function(e)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            local discard_count = #G.discard.cards
            for i = 1, discard_count do
                local v = G.discard.cards[i]
                if not v.ability.anba_scary then
                    draw_card(G.discard, G.deck, i * 100 / discard_count, 'up', nil, v, 0.005, i % 2 == 0, nil, math.max((21 - i) / 20, 0.7))
                end
            end
            return true
        end
    }))
end

-- When Scary Face leaves the joker area (sold/destroyed), release every parked
-- face card back to the deck. Card:remove() takes the Joker out of G.jokers.cards
-- *before* calling remove_from_deck, so has_scary() already excludes it here --
-- exactly mirroring Pulp Fiction's "no_return" guard for duplicate copies.
local remove_from_deck_ref = Card.remove_from_deck
function Card:remove_from_deck(from_debuff)
    local was_scary = self.ability and self.ability.name == 'Scary Face'
    remove_from_deck_ref(self, from_debuff)
    if was_scary and G.jokers and G.discard and not has_scary() then
        local discard_count = #G.discard.cards
        for i = 1, discard_count do
            local v = G.discard.cards[i]
            if v.ability.anba_scary then
                v.ability.anba_scary = nil
                draw_card(G.discard, G.deck, i * 100 / discard_count, 'up', nil, v, 0.005, i % 2 == 0, nil, math.max((21 - i) / 20, 0.7))
            end
        end
    end
end

--------------------------------------------------------------------------------
-- 5) per-round state resets (SMODS calls this on every round start)
--------------------------------------------------------------------------------
function SMODS.current_mod.reset_game_globals(run_start)
    if G.GAME and G.GAME.current_round then
        G.GAME.current_round.anba_idol = nil
    end
    -- drop the transient trigger bookkeeping of the finished round: it is keyed by card
    -- objects (Blueprint / Brainstorm sources) and must never reach the save file
    anba_upgrade_sources = {}
    anba_trigger_sources = {}
    if not G.jokers then return end
    for _, j in ipairs(G.jokers.cards) do
        if j.ability then
            if j.ability.name == 'Card Sharp' then j.ability.anba_last = nil end
            if j.ability.name == 'Seance' then j.ability.anba_hand = nil end
            if j.ability.name == 'Burnt Joker' then j.ability.anba_upgraded = nil end
            if j.ability.name == 'Marble Joker' then j.ability.anba_used = nil end
            if j.ability.name == 'To Do List' then j.ability.anba_hand = nil end
        end
    end
end

--------------------------------------------------------------------------------
-- 6) Tooltip variable overrides for reworked Jokers
--------------------------------------------------------------------------------
local gen_ui_ref = Card.generate_UIBox_ability_table

local function hand_name_key(k)
    return k and localize(k, 'poker_hands') or '?'
end

local AB_UI_LOC = {}

AB_UI_LOC['Card Sharp'] = function(self)
    return { hand_name_key(self.ability.anba_last) }
end

AB_UI_LOC['Seance'] = function(self)
    return { hand_name_key(self.ability.anba_hand) }
end

AB_UI_LOC['To Do List'] = function(self)
    return { 20, hand_name_key(self.ability.anba_hand or least_played_hand()) }
end

AB_UI_LOC['Hit the Road'] = function(self)
    return { self.ability.x_mult or 1 }
end

AB_UI_LOC['Turtle Bean'] = function(self)
    return { self.ability.anba_bonus or 0 }
end

AB_UI_LOC['Loyalty Card'] = function(self)
    return { self.ability.anba_x or 0.5 }
end

AB_UI_LOC["Driver's License"] = function(self)
    if not G.playing_cards then return { 1 } end
    local tally = 0
    for _, v in pairs(G.playing_cards) do
        if v.config.center ~= G.P_CENTERS.c_base then tally = tally + 1 end
    end
    return { 1 + 0.125 * tally }
end

function Card:generate_UIBox_ability_table(...)
    local vars_only = ...
    local name = self.ability and self.ability.name
    local f = name and AB_UI_LOC[name]
    if not f then return gen_ui_ref(self, ...) end
    -- fall back to the vanilla builder for locked/undiscovered/debuff states
    if (self.config.center.unlocked == false and not self.bypass_lock)
        or ((self.ability.set == 'Joker') and not self.config.center.discovered and not self.bypass_discovery_ui)
        or self.debuff then
        return gen_ui_ref(self, ...)
    end

    local card_type = 'Joker'
    local loc_vars = f(self)
    if vars_only then return loc_vars, nil, nil end
    local badges = {}
    badges.card_type = card_type
    if self.bypass_discovery_ui then badges.force_rarity = true end
    if self.edition then
        if self.edition.type == 'negative' and self.ability.consumeable then
            badges[#badges + 1] = 'negative_consumable'
        else
            badges[#badges + 1] = (self.edition.type == 'holo' and 'holographic' or self.edition.type)
        end
    end
    if self.seal then badges[#badges + 1] = string.lower(self.seal) .. '_seal' end
    if self.ability.eternal then badges[#badges + 1] = 'eternal' end
    if self.ability.perishable then badges[#badges + 1] = 'perishable' end
    if self.ability.rental then badges[#badges + 1] = 'rental' end
    if self.pinned then badges[#badges + 1] = 'pinned_left' end

    return generate_card_ui(self.config.center, nil, loc_vars, card_type, badges, nil, nil, nil, self)
end

--------------------------------------------------------------------------------
-- 7) Final scoring adjustments for chip-scaling / power-scaling Jokers
--    Runs inside the deck-back "final_scoring_step", after the vanilla back
--    had its chance (so plasma-style decks still work).
--
--    These Jokers would otherwise fire with no visible feedback. To match the
--    vanilla X-mult feel, each one now:
--      * juices the card while applying the multiplier (card_eval_status_text)
--      * rolls the hand chips/mult counter (update_hand_text)
--      * floats "X#1# Chips" / "X#1# Mult" via SMODS's x_chips / x_mult types
--------------------------------------------------------------------------------
-- round a multiplier to 2 decimals for clean floating-text display
local function fmt_mult(x)
    return math.floor(x * 100 + 0.5) / 100
end

local back_te_ref = Back.trigger_effect
function Back:trigger_effect(args)
    local c, m = back_te_ref(self, args)
    if args and args.context == 'final_scoring_step' then
        local chips = c or args.chips
        local mult = m or args.mult
        if chips and mult then
            for _, j in ipairs(G.jokers.cards) do
                if j.ability and j.ability.set == 'Joker' and not j.debuff then
                    local n = j.ability.name
                    if n == 'Runner' and j.ability.anba_chips_mult then
                        local x = j.ability.anba_chips_mult
                        for _ = 1, anba_trigger_count(j) do
                            chips = chips * x
                            update_hand_text({ delay = 0 }, { chips = math.floor(chips) })
                            card_eval_status_text(j, 'x_chips', fmt_mult(x))
                        end
                    elseif n == 'Stone Joker' then
                        local tally = 0
                        for _, v in pairs(G.playing_cards) do
                            if v.config.center == G.P_CENTERS.m_stone then tally = tally + 1 end
                        end
                        if tally > 0 then
                            local x = 1 + 0.1 * tally
                            for _ = 1, anba_trigger_count(j) do
                                chips = chips * x
                                update_hand_text({ delay = 0 }, { chips = math.floor(chips) })
                                card_eval_status_text(j, 'x_chips', fmt_mult(x))
                            end
                        end
                    elseif n == 'Throwback' and G.GAME.skips and G.GAME.skips > 0 then
                        local x = 1 + 0.25 * G.GAME.skips
                        for _ = 1, anba_trigger_count(j) do
                            mult = mult ^ x
                            update_hand_text({ delay = 0 }, { mult = mult })
                            card_eval_status_text(j, 'extra', nil, nil, nil, { message = '^' .. fmt_mult(x), colour = G.C.MULT })
                        end
                    end
                end
            end
            return chips, mult
        end
    end
    return c, m
end

AB_UI_LOC['Runner'] = function(self)
    local x = self.ability.anba_chips_mult or 1
    return { x, 0.5 }
end

AB_UI_LOC['Smiley Face'] = function(self)
    return { self.ability.mult or 0 }
end

AB_UI_LOC['Joker Stencil'] = function(self)
    if not G.jokers then return { 0 } end
    local empty = G.jokers.config.card_limit - #G.jokers.cards
    for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].ability.name == 'Joker Stencil' then empty = empty + 1 end
    end
    return { empty }
end

--------------------------------------------------------------------------------
-- 8) Splash rework: while owned (and not debuffed) you may select and play
--    any number of hand cards instead of the usual 5.
--------------------------------------------------------------------------------
local has_splash = function()
    return has_joker('Splash')
end

-- (a) Let the hand highlight more than 5 cards when Splash is owned.
local add_to_highlighted_ref = CardArea.add_to_highlighted
function CardArea:add_to_highlighted(card, silent)
    if self == G.hand then
        self.config.highlighted_limit = has_splash() and (G.hand.config.card_limit or 52) or 5
    end
    return add_to_highlighted_ref(self, card, silent)
end

-- (b) Keep the Play button active when more than 5 cards are selected.
local can_play_ref = G.FUNCS.can_play
function G.FUNCS.can_play(e)
    if has_splash() then
        if #G.hand.highlighted <= 0 or G.GAME.blind.block_play then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.BLUE
            e.config.button = 'play_cards_from_highlighted'
        end
        return
    end
    return can_play_ref(e)
end


