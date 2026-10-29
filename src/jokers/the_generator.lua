SMODS.Joker {
    key = 'the_generator',
    atlas = 'jokers_uncommon',
    pos = { x = 2, y = 0 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            xmult = 1,
            xmult_gain = 0.1,
            coal_xmult_gain = 0.1
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult_gain,
                card.ability.extra.xmult,
                card.ability.extra.coal_xmult_gain,
            },
        }
    end,

    calculate = function(self, card, context)
        -- Apply the accumulated XMult
        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                xmult = card.ability.extra.xmult,
            }
        end

        if context.after and not context.blueprint then
            -- Destroy every Coal card in the played hand, gain XMult per card
            local coal = {}
            for _, c in ipairs(context.full_hand or {}) do
                if SMODS.has_enhancement(c, 'm_rbsg_coal') then
                    coal[#coal + 1] = c
                end
            end

            if #coal > 0 then
                for _, c in ipairs(coal) do
                    for i = #G.playing_cards, 1, -1 do
                        if G.playing_cards[i] == c then
                            table.remove(G.playing_cards, i)
                        end
                    end
                    c:start_dissolve()
                end
                card.ability.extra.xmult = card.ability.extra.xmult
                    + card.ability.extra.coal_xmult_gain * #coal
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_xmult',
                        vars = { card.ability.extra.xmult },
                    },
                    colour = G.C.MULT,
                }
            end

            -- Otherwise: did the score catch on fire this hand?
            local required = G.GAME.blind and G.GAME.blind.chips or 0
            local earned = G.GAME.chips + (hand_chips or 0) * (mult or 0)
            if required > 0 and G.GAME.chips < required and earned >= required then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_xmult',
                        vars = { card.ability.extra.xmult },
                    },
                    colour = G.C.MULT,
                }
            end
        end
    end,
}