SMODS.Joker {
    key = 'stonemason',
    atlas = 'jokers_uncommon',
    pos = { x = 2, y = 1 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            repetitions = 1,
        },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        return {
            vars = {
                card.ability.extra.repetitions,
            },
        }
    end,

    calculate = function(self, card, context)
        if context.repetition
            and context.cardarea == G.play
            and context.other_card
            and SMODS.has_no_rank(context.other_card) then
            return {
                repetitions = card.ability.extra.repetitions,
            }
        end
    end,
}