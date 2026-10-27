return {
    descriptions = {
        Joker = {
            j_rbsg_fake_png = {
                name = 'Fake Png',
                text = {
                    '{C:chips}-#1#{} chips',
                    '{C:mult}+#1#{} mult'
                },
            },
            j_rbsg_kingslayer = {
                name = 'Kingslayer',
                text = {
                    "Destroys all {C:attention}Kings{}",
                    "in played hand",
                    "Gains {X:mult,C:white}X#1#{} Mult per",
                    "{C:attention}King{} destroyed",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
                },
            },
            j_rbsg_the_man = {
                name = 'The man who passes the sentence should swing the sword',
                text = {
                    "Each {C:spades}Spade{} held in hand",
                    "gives {X:chips,C:white}X#1#{} Chips",
                },
            },
            j_rbsg_two_finger = {
                name = 'Two Finger',
                text = {
                    "Retriggers the first {C:attention}Pair{}",
                    "in the played hand",
                    "{C:attention}#1#{} additional time"
                },
            },
            j_rbsg_the_generator = {
                name = 'The Generator',
                text = {
                    "Gains {X:mult,C:white}X#1#{} Mult when",
                    "score catches {C:attention}on fire{}",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
                },
            },
            j_rbsg_direwolf_mother = {
                name = 'Direwolf Mother',
                text = {
                    "{C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips",
                    "After {C:attention}#4#{} rounds, destroy this card",
                    "and create {C:attention}5 Wolf Cubs{} and {C:attention}1 White One{}",
                    "with this card's {C:dark_edition}edition{}",
                    "{C:inactive}(#3#/#4#)"
                },
            },
            j_rbsg_wolf_cub = {
                name = 'Wolf Cub',
                text = {
                    "{C:mult}+#1#{} Mult",
                    "Grows into a {C:attention}Direwolf{}",
                    "after {C:attention}#3#{} rounds {C:inactive}(#2#/#3#)",
                },
            },
            j_rbsg_white_one = {
                name= 'White One',
                text = {
                    "{C:mult}+#1#{} Mult",
                    "Grows into {C:attention}Direwolf{}",
                    "after {C:attention}#3#{} rounds {C:inactive}(#2#/#3#)",
                },
            },
            j_rbsg_grey_wind = { name = "Grey Wind", text = { "{X:mult,C:white}X#1#{} Mult" } },
            j_rbsg_lady      = { name = "Lady",      text = { "{X:mult,C:white}X#1#{} Mult" } },
            j_rbsg_nymeria   = { name = "Nymeria",   text = { "{X:mult,C:white}X#1#{} Mult" } },
            j_rbsg_summer    = { name = "Summer",    text = { "{X:mult,C:white}X#1#{} Mult" } },
            j_rbsg_shaggydog = { name = "Shaggydog", text = { "{X:mult,C:white}X#1#{} Mult" } },
            j_rbsg_ghost     = { name = "Ghost",     text = { "{X:mult,C:white}X#1#{} Mult" } },

            j_rbsg_mirror_joker = {
                name = 'Mirror Joker',
                text = {
                    "Copies ability of",
                    "{C:attention}Joker{} to the left",
                },
            },
            j_rbsg_white_walkers = {
                name = 'White Walkers',
                text = {
                    "When Blind is selected,",
                    "turn first card drawn",
                    "into {C:attention}Frostbite{}",
                    "{C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips",
                    "per card turned {C:inactive}(Currently +#3#{C:inactive})",
                },
            },
            j_rbsg_wights_joker = {
                name = 'Wights Joker',
                text = {
                    "When bought, enhance",
                    "{C:attention}#1#{} random cards",
                    "in deck into {C:attention}Frostbite{}",
                    "{C:mult}+#2#{} Mult",
                },
            },
            j_rbsg_a_girl_has_no_name = {
                name = 'A Girl Has No Name',
                text = {
                    "On the first hand each round,",
                    "the rank of the first scored card",
                    "changes to match the rank",
                    "of the last scored card",
                },
            },
            j_rbsg_sawdust_meal = {
                name =  'Sawdust Meal',
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "{C:green}#3# in #4#{} chance for",
                    "{C:red}-#2# Mult",
                },
            },
        },
        Enhanced = {
            m_rbsg_valyrian_steel = {
                name = 'Valyrian Steel',
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "while this card",
                    "stays in hand",
                },
            },
            m_rbsg_lannister_gold = {
                name = 'Lannister Gold',
                text = {
                    "{C:money}$#1#{} when played",
                    "{C:money}$#2#{} if this card is held",
                    "in hand at end of round",
                }
            },
            m_rbsg_frostbite = {
                name = 'Frostbite',
                text = {
                    "{X:chips,C:white}X#1#{} Chips",
                    "while this card",
                    "stays in hand",
                }
            },
            m_rbsg_coal = {
                name = 'Coal',
                text = {
                    "{C:mult}+#1#{} Mult",
                    "Always scores",
                    "No rank or suit",
                }
            }
        },
        Spectral = {
            c_rbsg_the_forge = {
                name = 'The Valyrian Forge',
                text = {
                    "Select {C:attention}#1#{} cards",
                    "{C:attention}Steel Cards{} become {C:attention}Valyrian Steel{}",
                    "If not Steel become {C:attention}Steel Cards{}",
                },
            },
            c_rbsg_the_lannister_mines = {
                name = 'The Lannister Mines',
                text = {
                    "Select {C:attention}#1#{} cards",
                    "{C:attention}Gold Cards{} become {C:attention}Lannister Gold{}",
                    "If not Gold become {C:attention}Gold Cards{}",
                }
            }
        },
        Other = {
            p_rbsg_wishing_pack = {
                name = 'Wishing Pack',
                text = {
                    "Choose {C:attention}#1#{} of {C:attention}#2#{} Jokers",
                    "9 random {C:attention}Common{}, 1 {C:attention}Rare{}",
                    "Your 9th pack contains a ?"
                }
            },
        },
    }
}
