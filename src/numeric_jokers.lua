-- Jokers whose rework is a pure number/rarity/cost change on top of the
-- unmodified vanilla `calculate`. take_ownership only sets `rarity`/`cost`/
-- `config`, so the original hard-coded behaviour in Card:calculate_joker
-- keeps driving these -- just with the new numbers.

local function tweak(key, fields)
    SMODS.Joker:take_ownership(key, fields)
end

-- #30 Red Card: rarity -> Uncommon, Mult growth +6 per skipped pack
tweak('red_card', { rarity = 2, config = { extra = 6 } })
-- #31 Madness: rarity -> Rare, Xmult growth x1 (was x0.5)
tweak('madness', { rarity = 3, config = { extra = 1 } })
-- #35 Shortcut: rarity -> Common
tweak('shortcut', { rarity = 1 })
-- #40 Luchador: rarity -> Common
tweak('luchador', { rarity = 1 })
-- #46 Baseball Card: rarity -> Uncommon
tweak('baseball', { rarity = 2 })
-- #48 Diet Cola: rarity -> Common
tweak('diet_cola', { rarity = 1 })
-- #50 Golden Ticket: rarity -> Uncommon
tweak('ticket', { rarity = 2 })
-- #50 Mr. Bones: rarity -> Common
tweak('mr_bones', { rarity = 1 })
-- #52 Hanging Chad: rarity -> Uncommon, retriggers 3 times (was 2)
tweak('hanging_chad', { rarity = 2, config = { extra = 3 } })
-- #53 Flower Pot: rarity -> Rare (effect reworked in jokers_b.lua)
tweak('flower_pot', { rarity = 3 })
-- #54 The Idol: rarity -> Rare (effect reworked in jokers_b.lua)
tweak('idol', { rarity = 3 })
-- #55 Blueprint / Brainstorm: rarity -> Uncommon
tweak('blueprint', { rarity = 2 })
tweak('brainstorm', { rarity = 2 })
-- #60 Cartomancer: rarity -> Rare (effect reworked in jokers_b.lua)
tweak('cartomancer', { rarity = 3 })
-- #61 Burnt Joker: rarity -> Uncommon (effect reworked in jokers_b.lua)
tweak('burnt', { rarity = 2 })
-- #41 Photograph: rarity -> Uncommon (effect reworked in jokers_b.lua)
tweak('photograph', { rarity = 2 })
-- #47 Bull: rarity -> Rare, +3 Chips per $1 (was +2)
tweak('bull', { rarity = 3, config = { extra = 3 } })

-- pure number tweaks that keep vanilla behaviour unchanged
tweak('8_ball', { config = { extra = 2 } })         -- #8  1 in 2 chance (was 1 in 4)
tweak('space', { config = { extra = 2 } })          -- #17 1 in 2 chance (was 1 in 4)
tweak('ride_the_bus', { config = { extra = 2 } })   -- #19 Mult growth +2 (was +1)
tweak('wee', { config = { extra = { chips = 0, chip_mod = 10 } } }) -- #56 +10 Chips (was +8)
tweak('blue_joker', { config = { extra = 3 } })    -- #23 +31 Chips (was +2)
tweak('hiker', { config = { extra = 15 } })         -- #24 +15 Chips (was +5)
tweak('square', { config = { extra = { chips = 0, chip_mod = 8 } } }) -- #32 +6 Chips (was +4)
tweak('misprint', { config = { extra = { min = 8, max = 30 } } })     -- #9  +4~+30 Mult
tweak('golden', { cost = 4 })                       -- #45 sell/cost -> $4
tweak('supernova', { config = { extra = 5 } })      -- #15 extra Chips factor (jokers_a.lua uses it)
tweak('half', { config = { extra = { mult = 15, size = 3 } } })       -- #2  +15 Mult, <=3 cards
tweak('burglar', { config = { extra = 5 } })        -- #19 +5 Hands (was +3)
tweak('erosion', { config = { extra = 0.2 } })      -- #43 Xmult growth 0.2 (kept, base reworked)
tweak('hit_the_road', { config = { extra = 0.25 } }) -- kept from vanilla
tweak('green_joker', { config = { extra = { hand_add = 2, discard_sub = -2 } } }) -- #25 +2/+2 (was +1/+1)
tweak('invisible', { config = { extra = 2 } })      -- kept: copy leftmost every 5 rounds
tweak('obelisk', { config = { extra = 0.25, Xmult = 1 } }) -- #38 Xmult growth 0.25 (was 0.2)
