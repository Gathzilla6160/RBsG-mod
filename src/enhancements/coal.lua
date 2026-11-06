local function find_generator()
    for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
        if j.config and j.config.center and j.config.center.key == 'j_rbsg_the_generator' then
            return j
        end
    end
end

SMODS.Enhancement {
    key = 'coal',
    atlas = 'enhancements',
    pos = { x = 4, y = 0 },

    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,

    config = {
        mult = 10,
        generator_xmult = 0.1,
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_rbsg_the_generator
        local ability = card and card.ability or self.config
        return {
            vars = {
                ability.mult,
                ability.generator_xmult,
            },
        }
    end,

    calculate = function (self, card, context)
        if context.destroy_card and context.destroy_card == card then
            local generator = find_generator()
            if generator then
                generator.ability.extra.xmult = generator.ability.extra.xmult + self.config.generator_xmult
                return {
                    remove = true,
                    message = localize('k_destroyed_ex'),
                    colour = G.C.MULT,
                }
            end
        end
    end,
}