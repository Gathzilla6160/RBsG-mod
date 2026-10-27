SMODS.Booster {
    key = 'wishing_pack',
    atlas = 'booster_packs',
    weight = 1,
    kind = 'rbsg_boosters',
    group_key = 'k_rbsg_boosters',
    cost = 15,
    pos = { x = 0, y = 0 },
    draw_hand = false,

    config = {
        extra = 10, 
        choose = 1, 
    },

    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = {
                math.min(cfg.choose + (G.GAME.modifiers.booster_choice_mod or 0),
                    math.max(1, cfg.extra + (G.GAME.modifiers.booster_size_mod or 0))),
                math.max(1, cfg.extra + (G.GAME.modifiers.booster_size_mod or 0)),
            },
        }
    end,

    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,

    create_card = function(self, card, i)
        -- Count a new "open" the moment slot 1 is generated
        if i == 1 then
            G.GAME.wishing_pack_opens = (G.GAME.wishing_pack_opens or 0) + 1
        end
        local this_open = G.GAME.wishing_pack_opens or 1

        if i <= 9 then
            return { set = 'Joker', rarity = 0, area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'rbsg_wish' }
        end

        if this_open == 9 then
            return { key = 'c_soul', set = 'Spectral', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'rbsg_wish' }
        end

        return { set = 'Joker', rarity = 0.99, area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'rbsg_wish' }
    end,
}