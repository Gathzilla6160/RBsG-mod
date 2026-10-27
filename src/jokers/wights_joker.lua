SMODS.Joker {
    key = 'wights_joker',
    atlas = 'jokers_common',
    pos = { x = 1, y = 0 },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            mult = 6,
            cards = 3,
        },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_rbsg_frostbite
        return {
            vars = {
                card.ability.extra.cards,
                card.ability.extra.mult,
            },
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
            }
        end

        -- Fires once, when this Joker is bought
        if context.buying_card == card then
            local pool = {}
            for _, c in ipairs(G.playing_cards) do
                if not c.ability.enhancement or c.ability.enhancement.key ~= 'frostbite' then
                    pool[#pool + 1] = c
                end
            end

            local picked = {}
            local n = math.min(card.ability.extra.cards, #pool)
            for i = 1, n do
                local idx = math.random(#pool)
                picked[#picked + 1] = pool[idx]
                table.remove(pool, idx)
            end

            for i, target in ipairs(picked) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1 * i,
                    func = function()
                        target:flip()
                        play_sound('tarot2', 0.7, 0.6)
                        target:juice_up(0.5, 0.5)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.15,
                            func = function()
                                target:set_ability(G.P_CENTERS.m_rbsg_frostbite)
                                target:flip()
                                target:juice_up(0.5, 0.5)
                                return true
                            end,
                        }))
                        return true
                    end,
                }))
            end
        end
    end,
}