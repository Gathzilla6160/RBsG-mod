SMODS.Joker {
    key = 'fake_png',
    atlas = 'jokers_common',
    pos = { x = 0, y = 0 },
    rarity= 1,
    cost = 3,
    
    config = {
        extra = {
            chips = 5,
            mult = 5
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.mult
            }
        }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return{
                chips = -card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
}