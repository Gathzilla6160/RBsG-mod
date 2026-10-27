SMODS.Joker {
    key = 'kingslayer',
    atlas = 'jokers_uncommon',
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            xmult = 1,
            xmult_gain = 0.2,
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult_gain,
                card.ability.extra.xmult,
            },
        }
    end,

    calculate = function(self, card, context)
        -- Destroy every King in the played hand and scale
        if context.destroy_card
            and context.cardarea == G.play
            and not context.blueprint
            and context.destroy_card:get_id() == 13 then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            return {
                remove = true,
                message = localize {
                    type = 'variable',
                    key = 'a_xmult',
                    vars = { card.ability.extra.xmult },
                },
                colour = G.C.MULT,
            }
        end

        -- Apply the accumulated XMult
        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end,
}