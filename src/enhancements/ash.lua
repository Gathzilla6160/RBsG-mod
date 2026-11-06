SMODS.Enhancement {
    key = 'ash',
    atlas = 'enhancements',
    pos = { x = 5, y = 0 },

    config = {
        extra = {
            odds = 2,
        },
    },
 
    loc_vars = function(self, info_queue, card)
        local extra = (card and card.ability and card.ability.extra) or self.config.extra
        local normal = (G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal) or 1
        return {
            vars = {
                normal,
                extra.odds or self.config.extra.odds,
            },
        }
    end,
 
    calculate = function(self, card, context)
        local odds = (card.ability.extra and card.ability.extra.odds) or self.config.extra.odds
        local normal = (G.GAME.probabilities and G.GAME.probabilities.normal) or 1
 
        -- Destroyed when played
        if context.destroy_card and context.destroy_card == card then
            if pseudorandom('ash_play') < normal / odds then
                return { remove = true }
            end
        end
 
        -- Destroyed when discarded
        if context.discard and context.other_card == card then
            if pseudorandom('ash_discard') < normal / odds then
                for i = #G.playing_cards, 1, -1 do
                    if G.playing_cards[i] == card then
                        table.remove(G.playing_cards, i)
                    end
                end
                card:start_dissolve()
                return {
                    message = 'Ashed!',
                    colour = G.C.GREY,
                }
            end
        end
    end,
}