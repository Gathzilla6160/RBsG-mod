SMODS.Joker {
    key = 'i_am_a_surgeon',
    atlas = 'jokers_rare',
    pos = { x = 4, y = 0 },
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {},
    },

    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local hand = context.full_hand or {}
            if #hand ~= 2 then return end

            local left, right = hand[1], hand[2]
            if not left.edition then return end

            local edition = left.edition
            left:set_edition(nil, true, true)
            right:set_edition(edition, true, true)

            return {
                message = 'Surgery!',
                colour = G.C.GREEN,
            }
        end
    end,
}