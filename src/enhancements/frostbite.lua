SMODS.Enhancement {
    key = 'frostbite',
    atlas = 'enhancements',
    pos = { x = 2, y = 0 },

    config = {
        h_x_chips = 0.85,
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card and card.ability.h_x_chips or self.config.h_x_chips,
            },
        }
    end,
}