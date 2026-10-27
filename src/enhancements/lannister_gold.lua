SMODS.Enhancement {
    key = 'lannister_gold',
    atlas = 'enhancements',
    pos = { x = 1, y = 0 },
    in_pool = function ()
        return false
    end,
    
    config = {
        h_dollars = 5, -- paid at end of round while held in hand
        extra = {
            play_dollars = 3, -- paid when the card is played and scores
        },
    },

    loc_vars = function(self, info_queue, card)
        local ability = card and card.ability or self.config
        return {
            vars = {
                ability.extra.play_dollars,
                ability.h_dollars,
            },
        }
    end,

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                dollars = card.ability.extra.play_dollars,
            }
        end
    end,
}