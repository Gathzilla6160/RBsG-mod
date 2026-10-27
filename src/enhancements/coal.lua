SMODS.Enhancement {
    key = 'coal',
    atlas = 'enhancements',
    pos = { x = 4, y = 0 },

    no_rank = true,
    no_suit = true,
    always_scores = true,

    config = {
        mult = 15,
    },

    loc_vars = function(self, info_queue, card)
        local ability = card and card.ability or self.config
        return {
            vars = {
                ability.mult,
            },
        }
    end,
}