SMODS.Consumable {
    key = 'the_tree',
    set = 'Tarot',
    atlas = 'tarots',
    pos = { x = 0, y = 0 },
    cost = 3,

    config = {
        max_highlighted = 2,
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_rbsg_wood
        return {
            vars = {
                card.ability.max_highlighted,
            },
        }
    end,

    can_use = function(self, card)
        local n = #G.hand.highlighted
        return n >= 1 and n <= card.ability.max_highlighted
    end,

    use = function(self, card, area, copier)
        local count = #G.hand.highlighted

        -- Flip cards face down
        for i = 1, count do
            local percent = 1.15 - (i - 0.999) / (count - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end,
            }))
        end
        delay(0.2)

        -- Every selected card becomes Wood
        for i = 1, count do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i]:set_ability(G.P_CENTERS.m_rbsg_wood)
                    return true
                end,
            }))
        end

        -- Flip cards back face up
        for i = 1, count do
            local percent = 0.85 + (i - 0.999) / (count - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end,
            }))
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end,
        }))
        delay(0.5)
    end,
}