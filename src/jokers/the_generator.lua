SMODS.Joker {
    key = 'the_generator',
    atlas = 'jokers_uncommon',
    pos = { x = 2, y = 0 },
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
        -- Apply the accumulated XMult
        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                xmult = card.ability.extra.xmult,
            }
        end

        -- After the hand is scored: did the score catch on fire?
        -- (round total reaches the blind requirement)
        if context.after and not context.blueprint then
            local required = G.GAME.blind and G.GAME.blind.chips or 0
            local earned = G.GAME.chips + (hand_chips or 0) * (mult or 0)
            if required > 0 and G.GAME.chips < required and earned >= required then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_xmult',
                        vars = { card.ability.extra.xmult },
                    },
                    colour = G.C.MULT,
                }
            end
        end
    end,
}