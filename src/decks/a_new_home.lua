SMODS.Back {
    key = 'a_new_home',
    atlas = 'decks',
    pos = { x = 0, y = 0 },
    config = {},

    loc_vars = function (self, info_queue, card)
        return { vars = {} }
    end,

    apply = function (self, back)
        G.E_MANAGER:add_event(Event({
            func = function ()
                SMODS.add_card {
                    key = 'j_rbsg_the_generator',
                    edition = 'e_negative'
                }

                local pool = {}
                for _, c in ipairs(G.playing_cards) do
                    pool[#pool+1] = c
                end

                local picks = {}
                for _ = 1, math.min(6,#pool) do
                    local idx = math.random(#pool)
                    picks[#picks+1] = table.remove(pool, idx)
                end

                local enchancements = {
                    'm_rbsg_wood', 'm_rbsg_wood',
                    'm_steel', 'm_steel',
                    'm_rbsg_coal', 'm_rbsg_coal'
                }
                for i, c in ipairs(picks) do
                    c:set_ability(G.P_CENTERS[enchancements[i]])
                end
                return true
            end,
        }))
    end
}