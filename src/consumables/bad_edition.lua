local EDITION = "e_rbsg_badapple"
local function  get_target()
    local hand = (G.hand and G.hand.highlighted) or {}
    local jokers = (G.jokers and G.jokers.highlighted) or {}
    if #hand + #jokers ~= 1 then return nil end
    return hand[1] or jokers[1]
end

SMODS.Consumable ({
    key = "bad_edition",
    set = "Spectral",
    atlas = "spectrals",
    pos = { x = 2, y = 0 },
    cost = 4,
    hidden = true,
    soul_set = "Spectral",
    soul_rate = 0.33,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[EDITION]
        return {}
    end,
    can_use = function(self, card)
        local t = get_target()
        return t ~= nil and not (t.edition and t.edition.key == EDITION)
    end,
    use = function(self, card, area, copier)
        local target = get_target()
        if not target then return end
        local target_area = target.area

        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.4,
            func = function()
                play_sound("tarot1")
                card:juice_up(0.3, 0.5)
                return true
            end,
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.1,
            func = function()
                target:set_edition(EDITION, true)
                return true
            end,
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.2,
            func = function()
                target_area:unhighlight_all()
                return true
            end,
        }))
        delay(0.5)
    end,
})