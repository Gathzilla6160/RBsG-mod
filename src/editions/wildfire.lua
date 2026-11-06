SMODS.Shader({
    key = "wildfire",
    path = "wildfire.fs",
})

SMODS.Edition({
    key = "wildfire",
    shader = "wildfire",
    config = { wf_xmult = 1.736242631225 },
    in_shop = true,
    weight = 6,
    extra_cost = 5,
    discovered = true,
    unlocked = true,
    apply_to_float = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.wf_xmult } }
    end,
    calculate = function(self, card, context)
        if context.post_joker
            or (context.main_scoring and context.cardarea == G.play) then
            return { xmult = self.config.wf_xmult }
        end
    end,
})