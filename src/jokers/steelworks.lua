SMODS.Joker {
    key = 'steelworks',
    atlas = 'jokers_common',
    pos = { x = 5, y = 0 },
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            steel_cards = 1,
            last_ante = 0,
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
        return {
            vars = {
                card.ability.extra.steel_cards,
            },
        }
    end,

    calculate = function(self, card, context)
        if not context then return end

        if context.after and not context.blueprint then
            local ante = G.GAME.round_resets.ante
            if card.ability.extra.last_ante == ante then
                return
            end

            local scored = {}
            for _, c in ipairs(context.scoring_hand or {}) do
                scored[#scored + 1] = c
            end
            if #scored == 0 then
                return
            end

            card.ability.extra.last_ante = ante

            for _ = 1, math.min(card.ability.extra.steel_cards, #scored) do
                local idx = math.random(#scored)
                local target = table.remove(scored, idx)
                target:set_ability(G.P_CENTERS.m_steel)
                target:juice_up(0.5, 0.5)
            end

            return {
                message = 'Steel!',
                colour = G.C.GREY
            }
        end
    end,
}