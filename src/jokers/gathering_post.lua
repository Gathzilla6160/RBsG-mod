SMODS.Joker {
    key = 'gathering_post',
    atlas = 'jokers_common',
    pos = { x = 7, y = 0 },
    rarity = 1,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,

    config = {
        extra = {
            rounds = 2,
            done = 0,
            cards = 3,
            used = false,
        },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
        info_queue[#info_queue + 1] = G.P_CENTERS.m_rbsg_wood
        info_queue[#info_queue + 1] = G.P_CENTERS.m_rbsg_coal
        return {
            vars = {
                card.ability.extra.rounds,
                math.min(card.ability.extra.done, card.ability.extra.rounds),
            },
        }
    end,

    calculate = function(self, card, context)
        if not context then return end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.done < card.ability.extra.rounds then
                card.ability.extra.done = card.ability.extra.done + 1
                return {
                    message = card.ability.extra.done .. '/' .. card.ability.extra.rounds,
                    colour = G.C.FILLED_BAR,
                }
            end
            return
        end

        if context.selling_self and not context.blueprint and not card.ability.extra.used then
            if card.ability.extra.done < card.ability.extra.rounds then
                return
            end
            card.ability.extra.used = true

            local pool = {}
            for _, c in ipairs(G.playing_cards or {}) do
                pool[#pool + 1] = c
            end
            local picks = {}
            for _ = 1, math.min(card.ability.extra.cards, #pool) do
                local idx = math.random(#pool)
                picks[#picks + 1] = table.remove(pool, idx)
            end

            local enhancements = { 'm_steel', 'm_rbsg_wood', 'm_rbsg_coal' }
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                func = function()
                    for i, c in ipairs(picks) do
                        local center = G.P_CENTERS[enhancements[i]]
                        if center then
                            c:set_ability(center)
                            c:juice_up(0.5, 0.5)
                        end
                    end
                    return true
                end,
            }))

            return {
                message = 'Transformed!',
                colour = G.C.GREEN,
            }
        end
    end,
}