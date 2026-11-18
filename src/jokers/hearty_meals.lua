SMODS.Joker {
    key = 'hearty_meals',
    atlas = 'jokers_rare',
    pos = { x = 0, y = 2 },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            mult = 10,
            chips = 50,
            xmult = 2,
            xmult_loss = 0.25,
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.chips,
                card.ability.extra.xmult,
                card.ability.extra.xmult_loss,
            },
        }
    end,

    calculate = function(self, card, context)
        if not context then return end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips,
                xmult = card.ability.extra.xmult > 1 and card.ability.extra.xmult or nil,
            }
        end

        if context.end_of_round and context.game_over == false and context.main_eval
            and not context.blueprint and G.GAME.blind and G.GAME.blind.boss then
            card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmult_loss
            if card.ability.extra.xmult <= 1 then
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED,
                    remove = true,
                }
            end
            return {
                message = 'X' .. card.ability.extra.xmult,
                colour = G.C.MULT,
            }
        end
    end,
}