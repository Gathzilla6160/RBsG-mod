SMODS.Shader({
    key = "kaleidoscopic_smoke",
    path = "kaleidoscopic_smoke.fs",
})

SMODS.Edition({
    key = "kaleidoscopic_smoke",
    shader = "kaleidoscopic_smoke",
    config = { ks_xchips = 1.5 },
    in_shop = true,
    weight = 4,
    extra_cost = 4,
    discovered = true,
    unlocked = true,
    apply_to_float = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.ks_xchips } }
    end,
    calculate = function(self, card, context)
        if context.post_joker
            or (context.main_scoring and context.cardarea == G.play) then
            return { xchips = self.config.ks_xchips }
        end
    end,
})