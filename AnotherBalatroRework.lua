--- STEAMODDED HEADER
--- MOD_NAME: Another Balatro
--- MOD_ID: AnotherBalatro
--- MOD_AUTHOR: [you]
--- MOD_DESCRIPTION: Experience-improving rebalance for 62 vanilla Jokers.
--- BADGE_COLOUR: 7FC8F8
--- PREFIX: anba
--- VERSION: 2.0.0
--- ----------------------------------------------
--- ------------MOD CODE -------------------------

-- Rebalances 62 vanilla Jokers. Each Joker's rarity/cost/config and its
-- calculate/loc_vars/add_to_deck/remove_from_deck live on the Joker's own
-- SMODS.Joker:take_ownership(...) object, the same way Brook defines its own
-- Jokers -- instead of one giant Card:calculate_joker dispatch table.
--
-- Caveat that makes a thin dispatcher unavoidable: SMODS only ever *adds* a
-- "run obj.calculate first" step in front of the vanilla per-name hard-coded
-- chain in Card:calculate_joker / Card:generate_UIBox_ability_table; it does
-- NOT suppress that vanilla chain when our calculate/loc_vars legitimately
-- return nil for a given context (see smods/lovely/center.toml). Since
-- take_ownership does not rename the card ("Turtle Bean" stays "Turtle
-- Bean"), every context where vanilla still has a same-name branch would
-- keep firing its old hard-coded behaviour side by side with ours. `REWORKED`
-- below is the exact set of names whose vanilla branches must never run; see
-- src/dispatch.lua for the two thin wrappers that guarantee this.

local AB = SMODS.current_mod

-- Shared namespace for helpers used across the split files below (each file
-- loaded via SMODS.load_file runs in its own chunk, so state is shared through
-- this global table rather than upvalues).
ABR = ABR or {}

-- Every reworked Joker name: dispatch.lua routes these straight to
-- `self.config.center` and never falls back to the vanilla per-name chain.
ABR.REWORKED = {
    ['Half Joker'] = true, ['Joker Stencil'] = true, ['Ceremonial Dagger'] = true,
    ['Banner'] = true, ['Fibonacci'] = true, ['Supernova'] = true,
    ['Even Steven'] = true, ['Odd Todd'] = true, ['Scholar'] = true,
    ['Runner'] = true, ['Stone Joker'] = true, ['Erosion'] = true,
    ['Loyalty Card'] = true, ['Green Joker'] = true, ['Cavendish'] = true,
    ['Marble Joker'] = true, ['Superposition'] = true, ['To Do List'] = true,
    ['Card Sharp'] = true, ['Seance'] = true, ['Vampire'] = true,
    ['Midas Mask'] = true, ['Baron'] = true, ['Hanging Chad'] = true,
    ['Vagabond'] = true, ['Cartomancer'] = true, ['Turtle Bean'] = true,
    ['Invisible Joker'] = true, ['Hit the Road'] = true, ['Smiley Face'] = true,
    ['Burnt Joker'] = true, ['Flower Pot'] = true, ['The Idol'] = true,
    ['Chicot'] = true, ['Steel Joker'] = true, ['Throwback'] = true,
    ['Photograph'] = true, ['Scary Face'] = true, ["Driver's License"] = true,
}

--------------------------------------------------------------------------------
-- Steamodded compatibility: some bundled locales (zh_CN/ko) ship *_info keys
-- as plain strings, but create_toggle / create_option_cycle iterate args.info
-- with ipairs(), crashing the config UI. Normalise to a one-element table.
--------------------------------------------------------------------------------
local create_toggle_ref = create_toggle
function create_toggle(args)
    if args and type(args.info) == 'string' then args.info = { args.info } end
    return create_toggle_ref(args)
end

local create_option_cycle_ref = create_option_cycle
function create_option_cycle(args)
    if args and type(args.info) == 'string' then args.info = { args.info } end
    return create_option_cycle_ref(args)
end

--------------------------------------------------------------------------------
-- Per-round state reset (SMODS calls this at the start of every round)
--------------------------------------------------------------------------------
function AB.reset_game_globals(run_start)
    if G.GAME and G.GAME.current_round then
        G.GAME.current_round.anba_idol = nil
    end
    -- transient Blueprint/Brainstorm trigger bookkeeping, keyed by card object
    ABR.trigger_sources = {}
    ABR.upgrade_sources = {}
    if not G.jokers then return end
    for _, j in ipairs(G.jokers.cards) do
        local a = j.ability
        if a then
            if a.name == 'Card Sharp' then a.anba_last = nil end
            if a.name == 'Seance' then a.anba_hand = nil end
            if a.name == 'To Do List' then a.anba_hand = nil end
            if a.name == 'Marble Joker' then a.anba_used = nil end
        end
    end
end

--------------------------------------------------------------------------------
-- Load split files: helpers/dispatch first (define ABR.* and the wrappers),
-- then content, then the few unavoidable global-mechanic hooks.
--------------------------------------------------------------------------------
for _, file in ipairs({
    'helpers',
    'dispatch',
    'numeric_jokers',
    'jokers_a',
    'jokers_b',
    'mechanics',
    'final_scoring',
}) do
    assert(SMODS.load_file('src/' .. file .. '.lua'))()
end

