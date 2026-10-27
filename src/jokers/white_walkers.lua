SMODS.Joker {
    key = 'white_walkers',
    atlas = 'jokers_uncommon',
    pos = { x = 5, y = 0 }, 
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            mult = 2,
            chips = 5,
            count = 0, 
        },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_rbsg_frostbite
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.chips,
                card.ability.extra.count,
            },
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult * card.ability.extra.count,
                chips = card.ability.extra.chips * card.ability.extra.count,
            }
        end

        if context.first_hand_drawn and not context.blueprint then
            local target = G.hand.cards[1]
            if target then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        target:flip()
                        play_sound('tarot2', 0.7, 0.6)
                        target:juice_up(0.5, 0.5)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.15,
                            func = function()
                                target:set_ability(G.P_CENTERS.m_rbsg_frostbite)
                                target:flip()
                                target:juice_up(0.5, 0.5)
                                return true
                            end,
                        }))
                        return true
                    end,
                }))

                card.ability.extra.count = card.ability.extra.count + 1
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_mult',
                        vars = { card.ability.extra.mult * card.ability.extra.count },
                    },
                    colour = G.C.MULT,
                }
            end
        end
    end,
}