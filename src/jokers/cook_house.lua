local FOOD_JOKERS = {
    'j_egg',
    'j_gros_michel',
    'j_cavendish',
    'j_ice_cream',
    'j_popcorn',
    'j_ramen',
    'j_turtle_bean',
    'j_seltzer',
    'j_rbsg_sawdust_meal'
}

SMODS.Joker {
    key = 'cook_house',
    atlas = 'jokers_uncommon',
    pos = { x = 3, y = 1 },
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            create = 1,
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.create,
            },
        }
    end,

    calculate = function(self, card, context)
        -- When a Blind is defeated: create a random food Joker (if there is room)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local room = G.jokers.config.card_limit - #G.jokers.cards
            if room <= 0 then return end

            for _ = 1, math.min(card.ability.extra.create, room) do
                local key = FOOD_JOKERS[math.random(#FOOD_JOKERS)]
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        SMODS.add_card { key = key }
                        return true
                    end,
                }))
            end

            return {
                message = localize('k_plus_joker'),
                colour = G.C.GREEN,
            }
        end
    end,
}