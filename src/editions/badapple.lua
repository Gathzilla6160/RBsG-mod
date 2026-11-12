local data = NFS.read(SMODS.current_mod.path .. "assets/bad_apple_sprite_sheet.png")
local img = love.graphics.newImage(love.filesystem.newFileData(data, "bad_apple_sprite_sheet.png"))
img:setFilter("nearest", "nearest")

SMODS.Shader({
    key = "badapple",
    path = "badapple.fs",
    send_vars = function(sprite, card)
        local c = card or (sprite and sprite.parent)
        local start = 0
        if c then
            c.rbsg_ba_start = c.rbsg_ba_start or G.TIMERS.REAL
            start = c.rbsg_ba_start
        end
        return { bad_sheet = img, ba_start = start }
    end,
})

SMODS.Edition({
    key = "badapple",
    shader = "badapple",
    config = { ba_xmult = 1.6, ba_xchips = 1.6 },
    in_shop = true,
    weight = 3,
    extra_cost = 4,
    discovered = true,
    unlocked = true,
    apply_to_float = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.ba_xmult, self.config.ba_xchips } }
    end,
    calculate = function(self, card, context)
        -- joker: xmult
        if context.post_joker then
            return { xmult = self.config.ba_xmult}
        end

        if context.main_scoring and context.cardarea == G.play then
            -- No rank: Xchips
            if SMODS.has_no_rank(card) then
                return {xchips = self.config.ba_xchips}
            end
            
            local ret = {}
            -- Light suits: Xmult
            if card:is_suit("Hearts") or card:is_suit("Diamonds") then
                ret.xmult = self.config.ba_xmult
            end
            -- Dark suits: Xchips
            if card:is_suit("Spades") or card:is_suit("Clubs") then
                ret.xchips = self.config.ba_xchips
            end
            if next(ret) then return ret end
        end
    end
})