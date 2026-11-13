SMODS.Joker {
    key = 'catspaw_dagger',
    atlas = 'jokers_uncommon',
    pos = { x = 3, y = 1 }, 
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    perishable_compat = false,

    config = {
        extra = {
            xmult = 1,
            gain_per_dollar = 0.1,
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.gain_per_dollar,
                card.ability.extra.xmult,
            },
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = i
                    break
                end
            end

            local sliced_card = my_pos and my_pos > 1 and G.jokers.cards[my_pos - 1]
            if sliced_card and not SMODS.is_eternal(sliced_card, card) and not sliced_card.getting_sliced then
                sliced_card.getting_sliced = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.ability.extra.xmult = card.ability.extra.xmult
                            + card.ability.extra.gain_per_dollar * sliced_card.sell_cost
                        card:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({ HEX("A069AEBC") }, nil, 1.6)
                        play_sound('slice1', 0.96 + math.random() * 0.08)
                        return true
                    end
                }))
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_xmult',
                        vars = { card.ability.extra.xmult + card.ability.extra.gain_per_dollar * sliced_card.sell_cost },
                    },
                    colour = G.C.MULT,
                    no_juice = true,
                }
            end
        end

        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end,
}