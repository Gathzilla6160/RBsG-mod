SMODS.Enhancement {
    key = 'valyrian_steel',
    atlas = 'enhancements',
    pos = { x = 0, y = 0 },
    in_pool = function ()
        return false
    end,

    -- Steel gives X1.5 while stays in hand; Valyrian Steel is the upgraded version
    config = {
        h_x_mult = 1.8,
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card and card.ability.h_x_mult or self.config.h_x_mult,
            },
        }
    end,
}