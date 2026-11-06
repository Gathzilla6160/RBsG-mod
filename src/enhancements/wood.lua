if Card and Card.set_debuff then
    local orig_set_debuff = Card.set_debuff
    function Card:set_debuff(should_debuff)
        orig_set_debuff(self, should_debuff)
        if self.config and self.config.center and self.config.center.key == 'm_rbsg_wood' then
            self.debuff = false
        end
    end
end

SMODS.Enhancement {
    key = 'wood',
    atlas = 'enhancements',
    pos = { x = 3, y = 0 },
    config = {
        extra = {
            odds = 4,
        },
    },
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_rbsg_ash
        local extra = (card and card.ability and card.ability.extra) or self.config.extra
        local normal = (G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal) or 1
        return {
            vars = {
                normal,
                extra.odds or self.config.extra.odds,
            },
        }
    end,

    calculate = function(self, card, context)
        if context.after and not context.blueprint then
            local in_hand = false
            for _, c in ipairs(context.full_hand or {}) do
                if c == card then
                    in_hand = true
                    break
                end
            end
            if not in_hand then return end

            local required = G.GAME.blind and G.GAME.blind.chips or 0
            local earned = G.GAME.chips + (hand_chips or 0) * (mult or 0)
            if required > 0 and G.GAME.chips < required and earned >= required then
                local odds = card.ability.extra.odds or self.config.extra.odds
                local normal = (G.GAME.probabilities and G.GAME.probabilities.normal) or 1
                if pseudorandom('wood_ash') < normal / odds then
                    card:set_ability(G.P_CENTERS.m_rbsg_ash)
                    card:juice_up(0.5, 0.5)
                    return {
                        message = 'Ash!',
                        colour = G.C.GREY,
                    }
                end
            end
        end
    end,
}
