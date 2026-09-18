-- Final-scoring adjustments for Jokers whose "power/chip multiplier" effect
-- vanilla applies as a single value multiplied into the round's chips/mult
-- at the very end (Runner, Stone Joker, Throwback). Hooking Back:trigger_effect
-- at context.final_scoring_step is the same point vanilla itself uses for
-- Plasma-deck-style chip*mult math, so Blueprint/Brainstorm copies (tracked
-- via ABR.trigger_count) apply the multiplier the right number of times.

local back_trigger_effect_ref = Back.trigger_effect
function Back:trigger_effect(args)
    local c, m = back_trigger_effect_ref(self, args)
    if not (args and args.context == 'final_scoring_step') then return c, m end

    local chips, mult = c or args.chips, m or args.mult
    if not (chips and mult) then return c, m end

    for _, j in ipairs(G.jokers.cards) do
        if j.ability and j.ability.set == 'Joker' and not j.debuff then
            local name = j.ability.name
            if name == 'Runner' and j.ability.anba_chips_mult then
                local x = j.ability.anba_chips_mult
                for _ = 1, ABR.trigger_count(j) do
                    chips = chips * x
                    update_hand_text({ delay = 0 }, { chips = math.floor(chips) })
                    card_eval_status_text(j, 'x_chips', ABR.fmt_mult(x))
                end
            elseif name == 'Stone Joker' then
                local tally = 0
                for _, v in pairs(G.playing_cards) do
                    if v.config.center == G.P_CENTERS.m_stone then tally = tally + 1 end
                end
                if tally > 0 then
                    local x = 1 + 0.1 * tally
                    for _ = 1, ABR.trigger_count(j) do
                        chips = chips * x
                        update_hand_text({ delay = 0 }, { chips = math.floor(chips) })
                        card_eval_status_text(j, 'x_chips', ABR.fmt_mult(x))
                    end
                end
            elseif name == 'Throwback' and G.GAME.skips and G.GAME.skips > 0 then
                local x = 1 + 0.25 * G.GAME.skips
                for _ = 1, ABR.trigger_count(j) do
                    mult = mult ^ x
                    update_hand_text({ delay = 0 }, { mult = mult })
                    card_eval_status_text(j, 'extra', nil, nil, nil, { message = '^' .. ABR.fmt_mult(x), colour = G.C.MULT })
                end
            end
        end
    end
    return chips, mult
end
