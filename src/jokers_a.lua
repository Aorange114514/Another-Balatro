-- Reworked Jokers (part A: common-to-uncommon rarity range). Each one is
-- registered via SMODS.Joker:take_ownership and carries its own `calculate`
-- (and `loc_vars`/`add_to_deck` where relevant) -- no global hook needed.

--------------------------------------------------------------------------------
-- #2 Half Joker: +15 Mult if 3 or fewer cards score
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('half', {
    calculate = function(self, card, context)
        if ABR.is_main(context) and #context.scoring_hand <= card.ability.extra.size then
            return { mult_mod = card.ability.extra.mult, message = ABR.msg_mult(card.ability.extra.mult), colour = G.C.MULT }
        end
    end,
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.extra.mult, card.ability.extra.size } } end,
})

--------------------------------------------------------------------------------
-- #3 Joker Stencil: each empty Joker slot grants +10 Chips AND X1.5 Mult
--------------------------------------------------------------------------------
local function stencil_empty_slots()
    local empty = G.jokers.config.card_limit - #G.jokers.cards
    for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].ability.name == 'Joker Stencil' then empty = empty + 1 end
    end
    return empty
end

SMODS.Joker:take_ownership('stencil', {
    calculate = function(self, card, context)
        if ABR.is_main(context) then
            local empty = stencil_empty_slots()
            if empty > 0 then
                return {
                    chip_mod = 10 * empty,
                    Xmult_mod = 1 + 0.5 * empty,
                    message = 'X' .. ABR.fmt_mult(1 + 0.5 * empty),
                    colour = G.C.MULT,
                }
            end
        end
    end,
    loc_vars = function(self, info_queue, card) return { vars = { stencil_empty_slots() } } end,
})

--------------------------------------------------------------------------------
-- #4 Ceremonial Dagger: devour the right Joker for 3x its sell value as Mult
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('ceremonial', {
    calculate = function(self, card, context)
        if context.selling_self then return
        elseif context.setting_blind and not context.blueprint then
            local pos
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then pos = i; break end
            end
            local target = pos and G.jokers.cards[pos + 1]
            if target and not card.getting_sliced and not target.ability.eternal and not target.getting_sliced then
                target.getting_sliced = true
                G.GAME.joker_buffer = (G.GAME.joker_buffer or 0) - 1
                G.E_MANAGER:add_event(Event({ func = function()
                    G.GAME.joker_buffer = 0
                    local gain = target.sell_cost * 3
                    card.ability.mult = card.ability.mult + gain
                    card:juice_up(0.8, 0.8)
                    target:start_dissolve({ HEX('57ecab') }, nil, 1.6)
                    play_sound('slice1', 0.96 + math.random() * 0.08)
                    return true
                end }))
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = ABR.msg_mult(card.ability.mult), colour = G.C.MULT, no_juice = true })
            end
        elseif ABR.is_main(context) and card.ability.mult > 0 then
            return { mult_mod = card.ability.mult, message = ABR.msg_mult(card.ability.mult), colour = G.C.MULT }
        end
    end,
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.mult } } end,
})

--------------------------------------------------------------------------------
-- #5 Banner: X1 Chips per remaining discard (total = X(1 + discards left))
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('banner', {
    calculate = function(self, card, context)
        if ABR.is_main(context) and G.GAME.current_round.discards_left > 0 then
            local x = 1 + G.GAME.current_round.discards_left
            return { Xmult_mod = x, message = ABR.msg_xmult(x), colour = G.C.CHIPS }
        end
    end,
})

--------------------------------------------------------------------------------
-- #10 Fibonacci: +8 Mult AND +20 Chips per scoring A,2,3,5,8
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('fibonacci', {
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual then
            local id = context.other_card and context.other_card:get_id()
            if id == 2 or id == 3 or id == 5 or id == 8 or id == 14 then
                return { chips = 20, mult = card.ability.extra, card = card }
            end
        end
    end,
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.extra } } end,
})

--------------------------------------------------------------------------------
-- #15 Supernova: +{times played} Mult AND +{2x times played} Chips
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('supernova', {
    calculate = function(self, card, context)
        if ABR.is_main(context) then
            local played = G.GAME.hands[context.scoring_name].played
            return {
                mult_mod = played,
                chip_mod = card.ability.extra * played,
                message = ABR.msg_mult(played) .. ' / ' .. ABR.msg_chips(card.ability.extra * played),
                colour = G.C.MULT,
            }
        end
    end,
})

--------------------------------------------------------------------------------
-- #13 Even Steven: scoring even-rank cards give X1.1 Mult
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('even_steven', {
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual then
            local id = context.other_card and context.other_card:get_id()
            if id and id <= 10 and id > 0 and id % 2 == 0 then
                return { x_mult = 1.1, colour = G.C.MULT, card = card }
            end
        end
    end,
})

--------------------------------------------------------------------------------
-- #13 Odd Todd: scoring odd-rank cards give X1.5 Chips
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('odd_todd', {
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual then
            local id = context.other_card and context.other_card:get_id()
            if id and ((id <= 10 and id > 0 and id % 2 == 1) or id == 14) then
                return { x_chips = 1.5, card = card }
            end
        end
    end,
})

--------------------------------------------------------------------------------
-- #14 Scholar: scoring Aces give ^1.5 Mult and ^1.5 Chips
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('scholar', {
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual then
            local id = context.other_card and context.other_card:get_id()
            if id == 14 then
                return { x_mult = 1.5, x_chips = 1.5, card = card }
            end
        end
    end,
})

--------------------------------------------------------------------------------
-- #16/#20 Runner: chip multiplier grows +X0.5 per Straight played, starts X1
-- (the multiplier itself is applied in final_scoring.lua so Blueprint copies
-- multiply it a second time; this handler only tracks growth/triggers)
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('runner', {
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if context.poker_hands and next(context.poker_hands['Straight']) then
                card.ability.anba_chips_mult = (card.ability.anba_chips_mult or 1) + 0.5
                return ABR.msg_upgrade(G.C.CHIPS)
            end
        elseif ABR.is_main(context) then
            ABR.record_trigger(card, context)
        end
    end,
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.anba_chips_mult or 1, 0.5 } } end,
})

--------------------------------------------------------------------------------
-- #44 Stone Joker: chip multiplier +X0.1 per Stone card in the deck, starts X1
-- (applied in final_scoring.lua; trigger tracking only)
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('stone', {
    calculate = function(self, card, context)
        ABR.record_trigger(card, context)
    end,
})

--------------------------------------------------------------------------------
-- #43 Erosion: starts X1 Mult, +X0.2 per card missing from the starting deck
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('erosion', {
    calculate = function(self, card, context)
        if ABR.is_main(context) then
            local missing = math.max(0, (G.GAME.starting_deck_size or 0) - #G.playing_cards)
            if missing > 0 then
                local x = 1 + card.ability.extra * missing
                return { Xmult_mod = x, message = ABR.msg_xmult(x), colour = G.C.MULT }
            end
        end
    end,
})

--------------------------------------------------------------------------------
-- #7 Loyalty Card: X0.5 base, +X0.5 every hand played, resets after exceeding X4
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('loyalty_card', {
    calculate = function(self, card, context)
        if ABR.is_main(context) then
            card.ability.anba_x = card.ability.anba_x or 0.5
            if card.ability.anba_x > 4 then
                card.ability.anba_x = 0.5
                return ABR.msg_reset()
            end
            local cur = card.ability.anba_x
            card.ability.anba_x = cur + 0.5
            return { Xmult_mod = cur, message = ABR.msg_xmult(cur), colour = G.C.MULT }
        end
    end,
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.anba_x or 0.5 } } end,
})

--------------------------------------------------------------------------------
-- #25 Green Joker: +2 Mult per hand played AND per discard action
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('green_joker', {
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            card.ability.mult = card.ability.mult + card.ability.extra.hand_add
            return { message = ABR.msg_mult(card.ability.extra.hand_add), colour = G.C.MULT }
        elseif context.discard and not context.blueprint then
            if context.other_card == context.full_hand[#context.full_hand] then
                card.ability.mult = card.ability.mult + card.ability.extra.discard_sub
                return { message = ABR.msg_mult(card.ability.extra.discard_sub), colour = G.C.MULT }
            end
        elseif ABR.is_main(context) and card.ability.mult > 0 then
            return { mult_mod = card.ability.mult, message = ABR.msg_mult(card.ability.mult), colour = G.C.MULT }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hand_add, card.ability.extra.discard_sub, card.ability.mult } }
    end,
})

--------------------------------------------------------------------------------
-- #28 Cavendish: X3 Mult, never destroys itself
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('cavendish', {
    calculate = function(self, card, context)
        if ABR.is_main(context) then
            return { Xmult_mod = card.ability.extra.Xmult, message = ABR.msg_xmult(card.ability.extra.Xmult), colour = G.C.MULT }
        end
    end,
})

--------------------------------------------------------------------------------
-- #6 Marble Joker: the first scoring card of each Blind becomes a Stone card
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('marble', {
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.anba_used = nil
        elseif ABR.is_main(context) and not card.ability.anba_used and not context.blueprint then
            local target = context.scoring_hand and context.scoring_hand[1]
            if target and not target.debuff and target.config.center ~= G.P_CENTERS.m_stone then
                card.ability.anba_used = true
                target:set_ability(G.P_CENTERS.m_stone, nil, true)
                target:juice_up()
                return { message = localize('k_plus_stone'), colour = G.C.SECONDARY_SET.Enhanced, card = card }
            end
        end
    end,
})

