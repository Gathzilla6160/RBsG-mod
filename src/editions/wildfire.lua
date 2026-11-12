SMODS.Shader({
    key = "wildfire",
    path = "wildfire.fs",
})

SMODS.Edition({
    key = "wildfire",
    shader = "wildfire",
    config = { wf_xmult = 1.736242631225, wf_wild_xmult = 2 },
    in_shop = true,
    weight = 6,
    extra_cost = 5,
    discovered = true,
    unlocked = true,
    apply_to_float = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
        return { vars = { self.config.wf_xmult, self.config.wf_wild_xmult } }
    end,
    calculate = function(self, card, context)
        if context.post_joker
            or (context.main_scoring and context.cardarea == G.play) then
            local x = self.config.wf_xmult
            if SMODS.has_enhancement(card, "m_wild") then
                x = self.config.wf_wild_xmult
            end
            return { xmult = x, colour = G.C.GREEN }
        end
    end,
})