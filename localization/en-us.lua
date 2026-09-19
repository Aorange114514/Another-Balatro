return {
    descriptions = {
        Joker = {
            j_joker = {
                name = 'Joker',
                text = {
                    '{C:mult}+#1#{} Mult',
                    'This Joker is always {C:dark_edition}Negative{}',
                    '{C:inactive}({C:attention}+1{C:inactive} Joker slot)',
                },
            },
            j_half = {
                name = 'Half Joker',
                text = {
                    '{C:mult}+#1#{} Mult if {C:attention}#2#{} or fewer',
                    'cards are {C:attention}scoring{}',
                },
            },
            j_stencil = {
                name = 'Joker Stencil',
                text = {
                    'Each empty {C:attention}Joker{} slot grants',
                    '{C:chips}+10{} Chips and {X:mult,C:white}X1.5{} Mult',
                    '{s:0.8}Joker Stencil counts as an empty slot',
                    '{C:inactive}(Currently {C:attention}#1#{C:inactive} empty slot(s))',
                },
            },
            j_ceremonial = {
                name = 'Ceremonial Dagger',
                text = {
                    'When a {C:attention}Blind{} is selected, destroy the',
                    'Joker to the right and permanently add',
                    '{C:attention}3x{} its sell value to this Joker\'s {C:mult}Mult{}',
                    '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)',
                },
            },
            j_banner = {
                name = 'Banner',
                text = {
                    'Each remaining {C:attention}discard{} multiplies',
                    '{C:mult}Mult{} by {X:mult,C:white}X1{}',
                    '{C:inactive}(Total = 1 + discards left)',
                },
            },
            j_marble = {
                name = 'Marble Joker',
                text = {
                    'The first card to score in each',
                    '{C:attention}Blind{} becomes a {C:attention}Stone{} card',
                },
            },
            j_loyalty_card = {
                name = 'Loyalty Card',
                text = {
                    'Gives {X:mult,C:white}X#1#{} Mult for each hand played,',
                    'then increases by {X:mult,C:white}X0.5{};',
                    'resets to {X:mult,C:white}X0.5{} once it would exceed {C:attention}X4{}',
                    '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive})',
                },
            },
            j_8_ball = {
                name = '8 Ball',
                text = {
                    '{C:green}#1# in #2#{} chance for each scored',
                    '{C:attention}8{} to create a {C:tarot}Tarot{} card',
                    '{C:inactive}(Must have room)',
                },
            },
            j_misprint = {
                name = 'Misprint',
                text = { '' },
            },
            j_fibonacci = {
                name = 'Fibonacci',
                text = {
                    '{C:mult}+#1#{} Mult and {C:chips}+20{} Chips for each',
                    'scored {C:attention}A{}, 2, 3, 5, 8',
                },
            },
            j_steel_joker = {
                name = 'Steel Joker',
                text = {
                    '{C:attention}Steel{} cards held in hand retrigger once;',
                    'each trigger permanently gives this Joker',
                    '{C:mult}+5{} Mult',
                    '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)',
                },
            },
            j_scary_face = {
                name = 'Scary Face',
                text = {
                    '{C:attention}Face cards{} you play never return',
                    'to your deck',
                    '{C:inactive}(until this Joker is sold or destroyed)',
                },
            },
            j_even_steven = {
                name = 'Even Steven',
                text = {
                    'Scored cards of {C:attention}even{} rank give',
                    '{X:mult,C:white}X1.1{} Mult',
                    '{C:inactive}(10, 8, 6, 4, 2)',
                },
            },
            j_odd_todd = {
                name = 'Odd Todd',
                text = {
                    'Scored cards of {C:attention}odd{} rank give',
                    '{X:chips,C:white}X1.5{} Chips',
                    '{C:inactive}(A, 9, 7, 5, 3)',
                },
            },
            j_scholar = {
                name = 'Scholar',
                text = {
                    'Played {C:attention}Aces{} give {X:mult,C:white}X1.5{} Mult',
                    'and {X:chips,C:white}X1.5{} Chips when scored',
                },
            },
            j_supernova = {
                name = 'Supernova',
                text = {
                    'Adds the number of times a {C:attention}poker hand{}',
                    'has been played this run to {C:mult}Mult{}, plus',
                    '{C:chips}#1#x{} that amount in Chips',
                    '{C:inactive}(Last hand: {C:attention}#4#{C:inactive})',
                    '{C:inactive}({C:mult}+#2#{C:inactive} Mult, {C:chips}+#3#{C:inactive} Chips)',
                },
            },
            j_ride_the_bus = {
                name = 'Ride the Bus',
                text = {
                    'Consecutive hands without a scored',
                    '{C:attention}face card{} give this Joker {C:mult}+#1#{} Mult;',
                    'resets when a face card is scored',
                    '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)',
                },
            },
            j_space = {
                name = 'Space Joker',
                text = {
                    '{C:green}#1# in #2#{} chance to upgrade',
                    'the level of your played {C:attention}poker hand{}',
                },
            },
            j_egg = {
                name = 'Egg',
                text = {
                    'Gains {C:money}$#1#{} of {C:attention}sell value{} at',
                    'end of round',
                    '{C:inactive}(starts {C:money}$3{C:inactive} higher)',
                },
            },
            j_burglar = {
                name = 'Burglar',
                text = {
                    'When {C:attention}Blind{} is selected, gain',
                    '{C:blue}+#1#{} Hands and set your {C:red}Discards{} to 0',
                },
            },
            j_runner = {
                name = 'Runner',
                text = {
                    'Played {C:attention}Straight{} hands multiply',
                    'this Joker\'s Chips by {X:chips,C:white}X#2#{}',
                    '{C:inactive}(Currently {X:chips,C:white}X#1#{C:inactive})',
                },
            },
            j_ice_cream = {
                name = 'Ice Cream',
                text = {
                    '{C:chips}+#1#{} Chips',
                    'Loses {C:chips}#2#{} Chips for every hand played',
                    'and melts at 0',
                    '{C:inactive}(starts with {C:money}-$1{C:inactive} sell value)',
                },
            },
            j_splash = {
                name = 'Splash',
                text = {
                    'Every played card counts in scoring',
                    'You may play any number of cards',
                },
            },
            j_blue_joker = {
                name = 'Blue Joker',
                text = {
                    'Each card remaining in your deck gives',
                    '{C:chips}+#1#{} Chips',
                    '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)',
                },
            },
            j_hiker = {
                name = 'Hiker',
                text = {
                    'Each card that scores permanently gains',
                    '{C:chips}+#1#{} Chips',
                },
            },
            j_green_joker = {
                name = 'Green Joker',
                text = {
                    'Each hand played: {C:mult}+#1#{} Mult',
                    'Each discard action: {C:mult}+#2#{} Mult',
                    '{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)',
                },
            },
            j_superposition = {
                name = 'Superposition',
                text = {
                    'Create a {C:tarot}Tarot{} card if the played hand',
                    'contains an {C:attention}Ace{} and a {C:attention}King{} or {C:attention}2{}',
                    '{C:inactive}(Must have room)',
                },
            },
            j_todo_list = {
                name = 'To Do List',
                text = {
                    'Earn {C:money}$#1#{} when you play your',
                    '{C:attention}least played{} poker hand',
                    '{C:inactive}(Currently: {C:attention}#2#{C:inactive})',
                },
            },
            j_cavendish = {
                name = 'Cavendish',
                text = {
                    '{X:mult,C:white}X3{} Mult',
                    'This Joker never destroys itself at end of round',
                },
            },
            j_card_sharp = {
                name = 'Card Sharp',
                text = {
                    'If the played hand is the same as the',
                    '{C:attention}previous hand{} this round, gain',
                    '{X:mult,C:white}X#2#{} Mult (each repeat adds X1),',
                    'otherwise resets to X1',
                    '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive},',
                    '{C:inactive}previous: {C:attention}#1#{C:inactive})',
                },
            },
            j_red_card = {
                name = 'Red Card',
                text = {
                    'This Joker gains {C:mult}+#1#{} Mult when any',
                    '{C:attention}Booster Pack{} is skipped',
                    '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)',
                },
            },
            j_madness = {
                name = 'Madness',
                text = {
                    'When {C:attention}Small Blind{} or {C:attention}Big Blind{} is',
                    'selected, gain {X:mult,C:white}X#1#{} Mult and',
                    '{C:attention}destroy{} a random Joker',
                    '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)',
                },
            },
            j_square = {
                name = 'Square Joker',
                text = {
                    'This Joker gains {C:chips}+#2#{} Chips when a',
                    'hand of exactly {C:attention}4{} cards is played',
                    '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)',
                },
            },
            j_seance = {
                name = 'Séance',
                text = {
                    'Create a {C:spectral}Spectral{} card when you play',
                    'the required poker hand',
                    'The required hand changes every round',
                    '{C:inactive}(Currently: {C:attention}#1#{C:inactive}; must have room)',
                },
            },
            j_vampire = {
                name = 'Vampire',
                text = {
                    '{C:attention}All{} played Enhanced cards are converted',
                    'to base; each one permanently gives this Joker',
                    '{X:mult,C:white}+X0.1{} Mult',
                    '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)',
                },
            },
            j_vagabond = {
                name = 'Vagabond',
                text = {
                    'Create a {C:dark_edition}Negative{} {C:tarot}Tarot{} card if you',
                    'play a hand with {C:money}$4{} or less',
                    '{C:inactive}(Must have room)',
                },
            },
            j_baron = {
                name = 'Baron',
                text = {
                    'Each {C:attention}King{} in your hand is considered',
                    'a {C:attention}Steel{} card and retriggers once',
                    '{C:inactive}(in hand and when played)',
                },
            },
            j_obelisk = {
                name = 'Obelisk',
                text = {
                    'This Joker gains {X:mult,C:white}X#1#{} Mult for each hand',
                    'played that is not your most played {C:attention}poker hand{};',
                    'resets when it is',
                    '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)',
                },
            },
            j_midas_mask = {
                name = 'Midas Mask',
                text = {
                    'All {C:attention}face cards{} you play become',
                    '{C:attention}Gold{} cards when played',
                },
            },
            j_photograph = {
                name = 'Photograph',
                text = {
                    'The first {C:attention}face card{} scored in each hand',
                    'gives {X:mult,C:white}X2{} Mult',
                },
            },
            j_turtle_bean = {
                name = 'Turtle Bean',
                text = {
                    'Defeat a {C:attention}Boss Blind{} while holding',
                    'this Joker to gain {C:attention}+1{} hand size',
                    '{C:inactive}(Currently +{C:attention}#1#{C:inactive} hand size)',
                },
            },
            j_erosion = {
                name = 'Erosion',
                text = {
                    'Gains {X:mult,C:white}X#2#{} Mult for each card',
                    'missing from your starting deck',
                    '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)',
                },
            },
            j_stone = {
                name = 'Stone Joker',
                text = {
                    'Each {C:attention}Stone{} card in your deck adds',
                    '{X:chips,C:white}X#2#{} to your Chips multiplier',
                    '{C:inactive}(Currently {X:chips,C:white}X#1#{C:inactive})',
                },
            },
            j_bull = {
                name = 'Bull',
                text = {
                    '{C:chips}+#1#{} Chips for each {C:money}$1{} you have',
                    '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)',
                },
            },
            j_smiley = {
                name = 'Smiley Face',
                text = {
                    'Each scored {C:attention}face card{} gives this Joker',
                    'a permanent {C:mult}+1{} Mult',
                    '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)',
                },
            },
            j_throwback = {
                name = 'Throwback',
                text = {
                    'Each skipped {C:attention}Blind{} this run increases',
                    'the exponent on your {C:mult}Mult{} by {C:attention}0.25{}',
                    '{C:inactive}(Currently ^{C:attention}#2#{C:inactive})',
                },
            },
            j_hanging_chad = {
                name = 'Hanging Chad',
                text = {
                    'Retrigger the first scoring card',
                    '{C:attention}3{} times',
                },
            },
            j_flower_pot = {
                name = 'Flower Pot',
                text = {
                    '{X:mult,C:white}X1{} Mult per distinct suit in your',
                    'scoring hand',
                    '{C:inactive}(2 suits = X2, 3 suits = X3, 4 suits = X4)',
                },
            },
            j_idol = {
                name = 'The Idol',
                text = {
                    'Cards with the same rank and suit as the',
                    'first scoring card of the round give',
                    '{X:mult,C:white}X3{} Mult',
                },
            },
            j_wee = {
                name = 'Wee Joker',
                text = {
                    'This Joker gains {C:chips}+#2#{} Chips for each',
                    'scored {C:attention}2{}',
                    '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)',
                },
            },
            j_hit_the_road = {
                name = 'Hit the Road',
                text = {
                    'Each discarded {C:attention}Jack{} gives this Joker',
                    '{X:mult,C:white}+X0.25{} Mult',
                    '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive})',
                    'resets after defeating a {C:attention}Boss Blind{}',
                },
            },
            j_invisible = {
                name = 'Invisible Joker',
                text = {
                    'Every {C:attention}#1#{} rounds, create a',
                    '{C:dark_edition}Negative{} copy of your {C:attention}leftmost{} Joker',
                    '{C:inactive}(Currently {C:attention}#2#{C:inactive}/#1#)',
                },
            },
            j_drivers_license = {
                name = "Driver's License",
                text = {
                    'Each {C:attention}Enhanced{} card in your full deck',
                    'gives {X:mult,C:white}X0.125{} Mult',
                    '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)',
                },
            },
            j_cartomancer = {
                name = 'Cartomancer',
                text = {
                    'Create a {C:dark_edition}Negative{} {C:tarot}Tarot{} card',
                    'when a {C:attention}Blind{} is selected',
                    '{C:inactive}(Must have room)',
                },
            },
            j_burnt = {
                name = 'Burnt Joker',
                text = {
                    'Upgrade the poker hand you discard,',
                    'once per hand type per round',
                },
            },
            j_chicot = {
                name = 'Chicot',
                text = {
                    'The {C:attention}Boss Blind{} chip requirement',
                    'is {C:attention}halved{}',
                },
            },
        },
    },
}
