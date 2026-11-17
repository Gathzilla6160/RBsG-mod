SMODS.Joker {
    key = 'the_generator',
    atlas = 'jokers_uncommon',
    pos = { x = 2, y = 0 },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            xmult = 1,
            xmult_gain = 0.1,
            hand_start = 0,
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
        if not context then return end

        if context.joker_main then
            card.ability.extra.hand_start = G.GAME.chips or 0
            if card.ability.extra.xmult > 1 then
                return {
                    xmult = card.ability.extra.xmult,
                }
            end
            return
        end

        if context.after and not context.blueprint then
            local required = G.GAME.blind and G.GAME.blind.chips or 0
            local start = card.ability.extra.hand_start or 0
            local now = G.GAME.chips or 0

            if now == start then
                now = start + (hand_chips or 0) * (mult or 0)
            end

            if required > 0 and start < required and now >= required then
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