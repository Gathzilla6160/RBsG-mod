-- Finds the first (leftmost) pair of same-rank cards in the scoring hand
local function find_first_pair(scoring_hand)
    for i = 1, #scoring_hand do
        local a = scoring_hand[i]
        if not SMODS.has_no_rank(a) then
            for j = i + 1, #scoring_hand do
                local b = scoring_hand[j]
                if not SMODS.has_no_rank(b) and a:get_id() == b:get_id() then
                    return a, b
                end
            end
        end
    end
    return nil, nil
end

SMODS.Joker {
    key = 'two_finger',
    atlas = 'jokers_uncommon',
    pos = { x = 1, y = 0 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            repetitions = 2,
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.repetitions,
            },
        }
    end,

    calculate = function(self, card, context)
        -- Retrigger the cards of the first Pair in the played hand
        if context.repetition
            and context.cardarea == G.play
            and context.scoring_hand then
            local a, b = find_first_pair(context.scoring_hand)
            if a and (context.other_card == a or context.other_card == b) then
                return {
                    repetitions = card.ability.extra.repetitions,
                }
            end
        end
    end,
}