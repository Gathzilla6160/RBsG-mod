SMODS.Joker {
    key = 'sawdust_meal',
    atlas = 'jokers_common',
    pos = { x = 2, y = 0 },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            xmult = 1.25,
            mult = -15,
            odd = 3,
        },
    },

    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                -card.ability.extra.mult,
                G.GAME.probabilities.normal or 1,
                card.ability.extra.odds,
            },
        }
    end,

    calculate = function (self, card, context)
        if context.joker_main then
            local ret = { xmult = card.ability.extra.xmult }
            if pseudorandom('sawdust_meal') < G.GAME.probabilities.normal / card.ability.extra.odds then
                ret.mult = card.ability.extra.mult
            end
            return ret
        end
    end,
}