-- Mechanics that cannot live on a single Joker's `calculate`: they touch
-- shared systems (hand-selection UI, global card-move interception) or need
-- to run whenever ANY Joker with a given name is present.

--------------------------------------------------------------------------------
-- #1 Joker: always Negative (+1 Joker slot), set once when it enters the deck
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('joker', {
    add_to_deck = function(self, card, from_debuff)
        if not card.edition and G.GAME and G.STATE ~= G.STATES.MENU then
            card:set_edition({ negative = true }, true)
        end
    end,
})

--------------------------------------------------------------------------------
-- #18 Egg: default sell value +3.  #21 Ice Cream: default sell value -1.
-- Both use `add_to_deck` so the bonus applies exactly once per card, the same
-- moment vanilla stamps `extra_value` via set_ability.
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('egg', {
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra_value = (card.ability.extra_value or 0) + 3
        card:set_cost()
    end,
})
SMODS.Joker:take_ownership('ice_cream', {
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra_value = (card.ability.extra_value or 0) - 1
        card:set_cost()
    end,
})

--------------------------------------------------------------------------------
-- #37 Baron: Kings in hand count as Steel (x1.5 chip multiplier). This bonus
-- fires once per King regardless of how many Barons/Blueprints are in play,
-- so it lives on the shared Card:get_chip_h_x_mult rather than in `calculate`
-- (the extra retrigger per Baron IS in jokers_b.lua's `calculate`).
--------------------------------------------------------------------------------
local get_chip_h_x_mult_ref = Card.get_chip_h_x_mult
function Card:get_chip_h_x_mult()
    local v = get_chip_h_x_mult_ref(self)
    if not self.debuff and self:get_id() == 13 and ABR.has_joker('Baron') and (not v or v <= 1) then
        return 1.5
    end
    return v
end

--------------------------------------------------------------------------------
-- #22 Splash: keeps its vanilla "every played card scores" behaviour, plus
-- letting the player select and play more than 5 cards while holding it.
--------------------------------------------------------------------------------
local function has_splash()
    return ABR.has_joker('Splash')
end

-- allow the hand to highlight more than 5 cards when Splash is owned
local add_to_highlighted_ref = CardArea.add_to_highlighted
function CardArea:add_to_highlighted(card, silent)
    if self == G.hand then
        self.config.highlighted_limit = has_splash() and (G.hand.config.card_limit or 52) or 5
    end
    return add_to_highlighted_ref(self, card, silent)
end

-- keep the Play button active when more than 5 cards are selected
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

--------------------------------------------------------------------------------
-- #12 Scary Face: played face cards never return to the deck while held.
-- Same pattern as Brook's "Pulp Fiction": mark the card when it moves from
-- play to discard, block it from being drawn discard->deck, and release every
-- marked card via `remove_from_deck` when the last Scary Face leaves play.
--------------------------------------------------------------------------------
SMODS.Joker:take_ownership('scary_face', {
    -- the vanilla "+30 Chips for played face cards" scoring effect is fully
    -- replaced by the passive hooks below, so `calculate` returns nothing
    calculate = function(self, card, context) end,
    remove_from_deck = function(self, card, from_debuff)
        -- Card:remove() already dropped this card from G.jokers.cards before
        -- calling remove_from_deck, so has_joker('Scary Face') below already
        -- excludes it if this was the last copy.
        if ABR.has_joker('Scary Face') or not G.discard then return end
        local n = #G.discard.cards
        for i = 1, n do
            local v = G.discard.cards[i]
            if v.ability.anba_scary then
                v.ability.anba_scary = nil
                draw_card(G.discard, G.deck, i * 100 / n, 'up', nil, v, 0.005, i % 2 == 0, nil, math.max((21 - i) / 20, 0.7))
            end
        end
    end,
})

local draw_card_ref = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
    if from == G.play and to == G.discard and card and card:is_face() and ABR.has_joker('Scary Face') then
        card.ability.anba_scary = true
    end
    -- a marked card must never be drawn back into the deck; guarding here
    -- (rather than only in draw_from_discard_to_deck below) survives load
    -- order against any other mod that reassigns the same global outright
    if from == G.discard and to == G.deck and card and card.ability and card.ability.anba_scary then
        return
    end
    return draw_card_ref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
end

-- draw every discard card back except cards marked by Scary Face
G.FUNCS.draw_from_discard_to_deck = function(e)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            local n = #G.discard.cards
            for i = 1, n do
                local v = G.discard.cards[i]
                if not v.ability.anba_scary then
                    draw_card(G.discard, G.deck, i * 100 / n, 'up', nil, v, 0.005, i % 2 == 0, nil, math.max((21 - i) / 20, 0.7))
                end
            end
            return true
        end
    }))
end

