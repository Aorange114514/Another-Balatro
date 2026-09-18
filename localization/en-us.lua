return {
    descriptions = {
        Joker = {
            j_joker = {
                name = 'Joker',
                text = {
                    '{C:mult}+#1#{} Mult',
                    'This Joker is always {C:dark_edition}Negative{}',
                    '({C:attention}+1{} Joker slot)',
                },
            },
            j_half = {
                name = 'Half Joker',
                text = {
                    '{C:mult}+#1#{} Mult',
                    'if {C:attention}#2#{} or fewer cards',
                    'are {C:attention}scoring{}',
                },
            },
            j_stencil = {
                name = 'Joker Stencil',
                text = {
                    'Each empty Joker slot grants:',
                    '{C:chips}+10{} Chips and',
                    '{X:mult,C:white}X1.5{} Mult',
                    '{C:inactive}({C:attention}#1#{C:inactive} empty slot(s))',
                },
            },
            j_ceremonial = {
                name = 'Ceremonial Dagger',
                text = {
                    'When a Blind is chosen,',
                    'destroy the Joker to the right',
                    'and gain {C:mult}+3x{} its sell value',
                    'as {C:mult}Mult{}',
                    '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)',
                },
            },
            j_banner = {
                name = 'Banner',
                text = {
                    'Each remaining discard increases',
                    'the Chips multiplier by {C:chips}X1{}',
                    '{C:inactive}(Total = X(1 + discards left))',
                },
            },
            j_marble = {
                name = 'Marble Joker',
                text = {
                    'The first card to score',
                    'each {C:attention}Blind{} becomes a',
                    '{C:attention}Stone{} card',
                },
            },
            j_loyalty_card = {
                name = 'Loyalty Card',
                text = {
                    'Gives {X:mult,C:white}X#1#{} Mult',
                    'Gains {X:mult,C:white}X0.5{} each hand played,',
                    'resetting to X0.5 after exceeding X4',
                    '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive})',
                },
            },
            j_8_ball = {
                name = '8 Ball',
                text = {
                    'Every scored {C:attention}8{} has a',
                    '{C:green}1 in 2{} chance to create',
                    'a {C:tarot}Tarot{} card',
                    '{C:inactive}(must have room)',
                },
            },
            j_misprint = {
                name = 'Misprint',
                text = { '' },
            },
            j_fibonacci = {
                name = 'Fibonacci',
                text = {
                    '{C:mult}+#1#{} Mult and',
                    '{C:chips}+20{} Chips for each',
                    'scored {C:attention}A{} , 2, 3, 5, 8',
                },
            },
            j_steel_joker = {
                name = 'Steel Joker',
                text = {
                    '{C:attention}Steel{} cards trigger an extra time',
                    'Each time a {C:attention}Steel{} card triggers,',
                    'this Joker first gains {C:mult}+5{} Mult',
                },
            },
            j_scary_face = {
                name = 'Scary Face',
                text = {
                    '{C:attention}Face cards{} you play',
                    'never return to your deck',
                },
            },
            j_even_steven = {
                name = 'Even Steven',
                text = {
                    'Scored cards with an even rank',
                    '(2, 4, 6, 8, 10) give',
                    '{X:mult,C:white}X1.1{} Mult',
                },
            },
            j_odd_todd = {
                name = 'Odd Todd',
                text = {
                    'Played cards with {C:attention}odd{} rank',
                    'give {C:chips}X1.5{} Chips when scored',
                    '{C:inactive}(A, 9, 7, 5, 3)',
                },
            },
            j_scholar = {
                name = 'Scholar',
                text = {
                    'Played {C:attention}Aces{} give',
                    '{X:mult,C:white}X1.5{} Mult and {C:chips}X1.5{} Chips',
                    'when scored',
                },
            },
            j_supernova = {
                name = 'Supernova',
                text = {
                    'Gives {C:mult}+1{} Mult for every time',
                    'this poker hand was played this run,',
                    'plus {C:chips}+2x{} that amount in Chips',
                },
            },
            j_ride_the_bus = {
                name = 'Ride the Bus',
                text = {
                    'Consecutive hands without',
                    'scored {C:attention}face cards{} give',
                    '{C:mult}+2{} Mult',
                    '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)',
                    'resets when a face card is scored',
                },
            },
            j_space = {
                name = 'Space Joker',
                text = {
                    '{C:green}1 in 2{} chance to upgrade',
                    'the level of your played',
                    '{C:attention}poker hand{}',
                },
            },
            j_egg = {
                name = 'Egg',
                text = {
                    'Sell value is increased by',
                    '{C:money}$3{} each round,',
                    'starting {C:money}$3{} higher',
                },
            },
            j_burglar = {
                name = 'Burglar',
                text = {
                    'When a Blind is chosen, gain',
                    '{C:blue}+5{} Hands and set',
                    'your {C:red}Discards{} to 0',
                },
            },
            j_runner = {
                name = 'Runner',
                text = {
                    'Played {C:attention}Straight{} hands increase',
                    'this Joker\'s Chips multiplier by {C:chips}X#2#{}',
                    '{C:inactive}(Currently {C:chips}X#1#{C:inactive})',
                },
            },
            j_ice_cream = {
                name = 'Ice Cream',
                text = {
                    '{C:chips}+100{} Chips',
                    'Loses {C:chips}-5{} Chips for every',
                    'hand played and melts at 0',
                    'Starts with a {C:money}-$1{} sell value',
                },
            },
            j_splash = {
                name = 'Splash',
                text = {
                    'Every played card counts',
                    'in scoring',
                    'You may play any number of cards',
                },
            },
            j_blue_joker = {
                name = 'Blue Joker',
                text = {
                    'Each card remaining in your',
                    'deck gives {C:chips}+#1#{} Chips',
                    '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)',
                },
            },
            j_hiker = {
                name = 'Hiker',
                text = {
                    'Each card that scores',
                    'permanently gains {C:chips}+15{} Chips',
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
                    'If the played hand contains an',
                    '{C:attention}Ace{} and a {C:attention}King{} or {C:attention}2{},',
                    'create a {C:tarot}Tarot{} card',
                },
            },
            j_todo_list = {
                name = 'To Do List',
                text = {
                    'Earn {C:money}$#1#{} when you play your',
                    'least played poker hand:',
                    '{C:attention}#2#{}',
                },
            },
            j_cavendish = {
                name = 'Cavendish',
                text = {
                    '{X:mult,C:white}X3{} Mult',
                    'This Joker never destroys itself',
                },
            },
            j_card_sharp = {
                name = 'Card Sharp',
                text = {
                    'If the hand played is the same as the',
                    'previous hand this round, gain {X:mult,C:white}X1{}',
                    'per repeat; otherwise reset to X1',
                    '{C:inactive}(Previous hand: {C:attention}#1#{C:inactive})',
                },
            },
            j_red_card = {
                name = 'Red Card',
                text = {
                    'Each skipped {C:attention}Booster Pack{} gives',
                    'this Joker {C:mult}+6{} Mult',
                },
            },
            j_madness = {
                name = 'Madness',
                text = {
                    'When a Blind is chosen, destroy',
                    'a random Joker and gain',
                    '{X:mult,C:white}X1{} Mult',
                },
            },
            j_square = {
                name = 'Square Joker',
                text = {
                    'This Joker gains {C:chips}+6{} Chips',
                    'when a {C:attention}4-card{} hand is played',
                },
            },
            j_seance = {
                name = 'Seance',
                text = {
                    'When you play the required hand:',
                    'create a {C:spectral}Spectral{} card',
                    'The required hand changes every round',
                    '{C:inactive}(Currently: {C:attention}#1#{C:inactive})',
                },
            },
            j_vampire = {
                name = 'Vampire',
                text = {
                    '{C:attention}All{} played Enhanced cards are',
                    'converted to base; each one gives',
                    'this Joker {X:mult,C:white}+X0.1{} Mult',
                },
            },
            j_vagabond = {
                name = 'Vagabond',
                text = {
                    'Whenever you have {C:money}$4{} or less,',
                    'create a {C:dark_edition}Negative{} {C:tarot}Tarot{}',
                },
            },
            j_baron = {
                name = 'Baron',
                text = {
                    'Each {C:attention}King{} in your hand is',
                    'considered a {C:attention}Steel{} card',
                    'and retriggers one extra time',
                    '(in hand and when played)',
                },
            },
            j_obelisk = {
                name = 'Obelisk',
                text = {
                    'This Joker gains {X:mult,C:white}X0.25{} each hand',
                    'played that is not your most played',
                    'poker hand; resets when it is',
                },
            },
            j_midas_mask = {
                name = 'Midas Mask',
                text = {
                    'All {C:attention}face cards{} you play',
                    'become {C:attention}Gold{} cards when played',
                },
            },
            j_photograph = {
                name = 'Photograph',
                text = {
                    'The first face card scored in each',
                    'hand gives {X:mult,C:white}X2{} Mult',
                    '(as long as you have played a',
                    'face card this round)',
                },
            },
            j_turtle_bean = {
                name = 'Turtle Bean',
                text = {
                    'Defeat a {C:attention}Boss Blind{} while',
                    'holding this Joker to gain',
                    '{C:attention}+1{} hand size',
                    '{C:inactive}(Currently +{C:attention}#1#{C:inactive} hand size)',
                },
            },
            j_erosion = {
                name = 'Erosion',
                text = {
                    'Start with {X:mult,C:white}X1{} Mult;',
                    'gains {X:mult,C:white}X0.2{} Mult for every',
                    'card missing from the starting deck',
                },
            },
            j_stone = {
                name = 'Stone Joker',
                text = {
                    'Each {C:attention}Stone{} card in your deck adds',
                    '{C:chips}X0.1{} to your Chips multiplier',
                    '(starting from {C:chips}X1{})',
                },
            },
            j_bull = {
                name = 'Bull',
                text = {
                    'Each {C:money}$1{} gives',
                    '{C:chips}+#1#{} Chips',
                    '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)',
                },
            },
            j_smiley = {
                name = 'Smiley Face',
                text = {
                    'Each scored {C:attention}face card{} gives',
                    'this Joker {C:mult}+1{} Mult',
                    '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)',
                },
            },
            j_throwback = {
                name = 'Throwback',
                text = {
                    'Each skipped Blind raises your',
                    '{C:mult}Mult{} to the power of',
                    '{C:attention}1 + 0.25 × skipped Blinds{}',
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
                    '{C:mult}X1{} per distinct suit in your',
                    'scoring hand (2 suits = X2,',
                    '3 suits = X3, 4 suits = X4)',
                },
            },
            j_idol = {
                name = 'The Idol',
                text = {
                    'Cards matching the first scoring card',
                    'of the round give',
                    '{X:mult,C:white}X3{} Mult',
                },
            },
            j_wee = {
                name = 'Wee Joker',
                text = {
                    'Each scored {C:attention}2{} gives',
                    'this Joker {C:chips}+10{} Chips',
                },
            },
            j_hit_the_road = {
                name = 'Hit the Road',
                text = {
                    'Each discarded {C:attention}Jack{} gives',
                    'this Joker {X:mult,C:white}+X0.25{} Mult',
                    '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive})',
                    'resets after defeating a Boss Blind',
                },
            },
            j_invisible = {
                name = 'Invisible Joker',
                text = {
                    'Every {C:attention}#1#{} rounds, create a',
                    '{C:dark_edition}Negative{} copy of your',
                    '{C:attention}leftmost{} Joker',
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
                    'Create a {C:dark_edition}Negative{} {C:tarot}Tarot{}',
                    'card when a Blind is chosen',
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
                    'The {C:attention}Boss Blind{} chip',
                    'requirement is {C:attention}halved{}',
                },
            },
        },
    },
}
