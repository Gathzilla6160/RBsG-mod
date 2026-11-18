SMODS.Joker {
    key = 'charcoal_kiln',
    atlas = 'jokers_uncommon',
    pos = { x = 4, y = 1 },
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {}
    },

    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_rbsg_wood
        info_queue[#info_queue+1] = G.P_CENTERS.m_rbsg_coal
        return {vars = {}}
    end,

    calculate = function (self, card, context)
        if not context then return end
        
        if context.after and not context.blueprint then
            local turned = 0
            for _, c in ipairs(context.scoring_hand or {}) do
                if SMODS.has_enhancement(c, 'm_rbsg_wood') then
                    c:set_ability(G.P_CENTERS.m_rbsg_coal)
                    c:juice_up(0.5, 0.5)
                    turned = turned + 1
                end
            end

            if turned > 0 then
                return {
                    message = 'Coal!',
                    colour = G.C.Black
                }
            end
        end
    end
}