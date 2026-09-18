-- Guarantees the vanilla per-name hard-coded chains never run for any Joker
-- in ABR.REWORKED, in either Card:calculate_joker or
-- Card:generate_UIBox_ability_table. Both wrappers route straight to the
-- Joker's own `self.config.center.calculate` / `.loc_vars`; the object's
-- fields are what actually implement each Joker's effect (see jokers_a.lua,
-- jokers_b.lua). This file only decides *whether vanilla runs at all* -- it
-- has no game-specific logic of its own.

local calculate_joker_ref = Card.calculate_joker
function Card:calculate_joker(context)
    if not self.debuff and self.ability.set == 'Joker' and ABR.REWORKED[self.ability.name] then
        return self.config.center:calculate(self, context)
    end
    return calculate_joker_ref(self, context)
end

-- generate_UIBox_ability_table has no `context` to gate on: vanilla's locked/
-- undiscovered/debuff card types must still render through vanilla (their
-- rendering is generic, not per-name), so only short-circuit once execution
-- would otherwise reach the big per-name `elseif self.ability.set == 'Joker'`
-- chain -- i.e. card_type == 'Joker' and not locked/undiscovered/debuffed.
local gen_ui_ref = Card.generate_UIBox_ability_table
function Card:generate_UIBox_ability_table(vars_only)
    local a = self.ability
    if a and a.set == 'Joker' and ABR.REWORKED[a.name] and not self.debuff
        and self.config.center.unlocked ~= false
        and self.config.center.discovered then
        local center = self.config.center
        local loc_vars = {}
        if type(center.loc_vars) == 'function' then
            local res = center:loc_vars(nil, self) or {}
            loc_vars = res.vars or res
        end
        if vars_only then return loc_vars, nil, nil end
        local badges = {}
        if self.bypass_discovery_ui then badges.force_rarity = true end
        if self.edition then badges[#badges + 1] = (self.edition.type == 'holo' and 'holographic' or self.edition.type) end
        if self.seal then badges[#badges + 1] = string.lower(self.seal) .. '_seal' end
        if a.eternal then badges[#badges + 1] = 'eternal' end
        if a.perishable then badges[#badges + 1] = 'perishable' end
        if a.rental then badges[#badges + 1] = 'rental' end
        if self.pinned then badges[#badges + 1] = 'pinned_left' end
        return generate_card_ui(center, nil, loc_vars, 'Joker', badges, nil, nil, nil, self)
    end
    return gen_ui_ref(self, vars_only)
end

