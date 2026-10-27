SMODS.Joker {
    key = 'the_man',
    atlas = 'jokers_rare',
    pos = { x = 0, y = 0 },
    rarity = 3, 
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    config = {
        extra = {
            xchips = 1.3,
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xchips,
            },
        }
    end,

    calculate = function(self, card, context)
        if context.individual
            and context.cardarea == G.hand
            and not context.end_of_round
            and context.other_card:is_suit('Spades') then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED,
                }
            end
            return {
                xchips = card.ability.extra.xchips,
            }
        end
    end,
}