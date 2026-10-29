SMODS.Joker {
    key = 'coal_mine',
    atlas = 'jokers_common',
    pos = { x = 3, y = 0 },
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            coal_cards = 1,
            last_ante = 0,
        },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_rbsg_coal
        return {
            vars = {
                card.ability.extra.coal_cards,
            },
        }
    end,

    calculate = function(self, card, context)
        if context.after and not context.blueprint then
            -- Only once per Ante
            local ante = G.GAME.round_resets.ante
            if card.ability.extra.last_ante == ante then
                return
            end

            local unscored = {}
            for _, c in ipairs(context.full_hand or {}) do
                local is_scoring = false
                for _, s in ipairs(context.scoring_hand or {}) do
                    if s == c then
                        is_scoring = true
                        break
                    end
                end
                if not is_scoring then
                    unscored[#unscored + 1] = c
                end
            end

            if #unscored == 0 then
                return
            end

            -- Record this Ante only when a card is actually turned
            card.ability.extra.last_ante = ante

            for _ = 1, math.min(card.ability.extra.coal_cards, #unscored) do
                local idx = math.random(#unscored)
                local target = table.remove(unscored, idx)
                target:set_ability(G.P_CENTERS.m_rbsg_coal)
                target:juice_up(0.5, 0.5)
            end

            return {
                message = 'Coal!',
                colour = G.C.BLACK,
            }
        end
    end,
}