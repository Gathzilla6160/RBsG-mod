SMODS.Joker {
    key = 'sawmill',
    atlas = 'jokers_common',
    pos = { x = 6, y = 0 },
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            blinds = 3,
            wins = 0,
        },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_rbsg_the_tree
        return {
            vars = {
                card.ability.extra.blinds,
                card.ability.extra.wins,
            },
        }
    end,

    calculate = function(self, card, context)
        if not context then return end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.wins = card.ability.extra.wins + 1
            if card.ability.extra.wins < card.ability.extra.blinds then
                return {
                    message = card.ability.extra.wins .. '/' .. card.ability.extra.blinds,
                    colour = G.C.FILLED_BAR,
                }
            end

            card.ability.extra.wins = 0

            local room = G.consumeables.config.card_limit - #G.consumeables.cards
            if room > 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        SMODS.add_card { key = 'c_rbsg_the_tree' }
                        return true
                    end,
                }))
                return {
                    message = localize('k_plus_tarot'),
                    colour = G.C.PURPLE,
                }
            end
            return {
                message = localize('k_no_space_ex'),
                colour = G.C.RED,
            }
        end
    end,
}