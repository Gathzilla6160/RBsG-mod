SMODS.Joker {
    key = 'renly_baratheon',
    atlas = 'jokers_rare',
    pos = { x = 5, y = 0 },
    rarity = 3,
    cost = 6,
    blueprint_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            xmult = 2,
            decay = 0.5,
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.decay,
            },
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        end

        if context.after and not context.blueprint then
            local name = context.scoring_name
            if name == 'Straight' or name == 'Straight Flush' then
                card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.decay
                if card.ability.extra.xmult <= 0 then
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.RED,
                        remove = true,
                    }
                end
                return {
                    message = 'X' .. card.ability.extra.xmult,
                    colour = G.C.MULT,
                }
            end
        end
    end,
}