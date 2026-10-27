-- Pulls the rank word and suit word out of a card's display name,
-- e.g. "King of Hearts" -> "King", "Hearts"
local function split_name(name)
    return name:match('^(.+) of (.+)$')
end

-- Finds the real card definition matching "<rank> of <suit>"
local function find_base_by_name(target_name)
    for _, v in pairs(G.P_CARDS) do
        if v.name == target_name then
            return v
        end
    end
end 

SMODS.Joker {
    key = 'a_girl_has_no_name',
    atlas = 'jokers_uncommon',
    pos = { x = 0, y = 1 },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            used_this_round = false,
        },
    },

    loc_vars = function(self, info_queue, card)
        return {}
    end,

    calculate = function(self, card, context)
        -- Reset at the start of each round
        if context.setting_blind then
            card.ability.extra.used_this_round = false
            return
        end

        -- Fires once per round, right as the first scoring card of the first hand is about to be scored
        if context.individual
            and context.cardarea == G.play
            and not context.blueprint
            and not card.ability.extra.used_this_round
            and context.scoring_hand
            and #context.scoring_hand >= 2
            and context.other_card == context.scoring_hand[1] then
            card.ability.extra.used_this_round = true

            local first_c = context.scoring_hand[1]
            local last_c = context.scoring_hand[#context.scoring_hand]

            if first_c.base and last_c.base and first_c.base.name and last_c.base.name then
                local _, first_suit = split_name(first_c.base.name)
                local last_rank = split_name(last_c.base.name)

                if first_suit and last_rank then
                    local target_name = last_rank .. ' of ' .. first_suit
                    if target_name ~= first_c.base.name then
                        local new_base = find_base_by_name(target_name)
                        if new_base then
                            first_c:set_base(new_base)
                            first_c:juice_up(0.5, 0.5)
                            return {
                                message = 'No Name!',
                                colour = G.C.PURPLE,
                            }
                        end
                    end
                end
            end
        end
    end,
}