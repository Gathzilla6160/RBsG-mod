local WILDFIRE = "e_rbsg_wildfire"

SMODS.Joker{
    key = "flammable_substances",
    atlas = "jokers_uncommon",
    pos = { x = 1, y = 1 },
    rarity = 2,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,


    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[WILDFIRE]
        return {}
    end,

    calculate = function(self, card, context)
        if context.joker_type_destroyed and context.card == card
            and not context.blueprint and not card.rbsg_burned then
            card.rbsg_burned = true

            -- a random card held in hand that doesn't have Wildfire yet
            local hand_targets = {}
            if G.hand and G.hand.cards then
                for _, c in ipairs(G.hand.cards) do
                    if not (c.edition and c.edition.key == WILDFIRE) then
                        hand_targets[#hand_targets + 1] = c
                    end
                end
            end
            local burn = #hand_targets > 0
                and pseudorandom_element(hand_targets, pseudoseed("rbsg_flammable_hand")) or nil

            -- a random other Joker
            local joker_targets = {}
            for _, j in ipairs(G.jokers.cards) do
                if j ~= card and not j.ability.eternal and not j.getting_sliced then
                    joker_targets[#joker_targets + 1] = j
                end
            end
            local victim = #joker_targets > 0
                and pseudorandom_element(joker_targets, pseudoseed("rbsg_flammable_joker")) or nil

            if burn then
                G.E_MANAGER:add_event(Event({
                    trigger = "after", delay = 0.4,
                    func = function()
                        burn:set_edition(WILDFIRE, true)
                        burn:juice_up(0.4, 0.5)
                        play_sound("foil1", 1.1, 0.6)
                        return true
                    end,
                }))
            end
            if victim then
                G.E_MANAGER:add_event(Event({
                    trigger = "after", delay = 0.5,
                    func = function()
                        SMODS.destroy_cards(victim)
                        return true
                    end,
                }))
            end
        end
    end,
}