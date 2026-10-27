SMODS.Joker {
    key = 'direwolf_mother',
    atlas = 'jokers_rare',
    pos = { x = 1, y = 0 },
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    eternal_compat = false, -- it destroys itself, so Eternal makes no sense
    perishable_compat = true,

    config = {
        extra = {
            mult = 10,
            chips = 50,
            rounds = 0,
            max_rounds = 3,
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.chips,
                card.ability.extra.rounds,
                card.ability.extra.max_rounds,
            },
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips,
            }
        end

        if context.end_of_round
            and context.game_over == false
            and context.main_eval
            and not context.blueprint then
            card.ability.extra.rounds = card.ability.extra.rounds + 1

            if card.ability.extra.rounds < card.ability.extra.max_rounds then
                return {
                    message = card.ability.extra.rounds .. '/' .. card.ability.extra.max_rounds,
                    colour = G.C.FILLED_BAR,
                }
            end

            -- Remember the edition (including Negative) before this card is gone
            local edition = card.edition and card.edition.key or nil

            -- Destroy the mother
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        blockable = false,
                        func = function()
                            G.jokers:remove_card(card)
                            card:remove()
                            card = nil
                            return true
                        end,
                    }))
                    return true
                end,
            }))

            -- Create 5 Wolf Cubs and 1 White One with the mother's edition
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    for i = 1, 5 do
                        local cub = SMODS.add_card { key = 'j_rbsg_wolf_cub' }
                        cub.ability.extra.index = i -- decides which direwolf it becomes
                        cub:set_edition(edition, true, true)
                    end
                    local white = SMODS.add_card { key = 'j_rbsg_white_one' }
                    white:set_edition(edition, true, true)
                    return true
                end,
            }))

            return {
                message = 'Direwolves!',
                colour = G.C.GREEN,
            }
        end
    end,
}