SMODS.Joker {
    key = 'soup',
    atlas = 'jokers_common',
    pos = { x = 0, y = 1 },
    rarity = 1,
    cost = 3,

    config = {
        extra = {
            mult = 3,
            chips = 6
        }
    },

    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.mult,
                card.ability.extra.chips
            }
        }
    end,

    calculate = function (self, card, context)
        if context.joker_main then
            return{
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips
            }
        end
    end
}