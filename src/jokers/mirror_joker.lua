SMODS.Joker {
    key = 'mirror_joker',
    atlas = 'jokers_rare',
    pos = { x = 2, y = 0 },
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        return {}
    end,

    calculate = function(self, card, context)
        if not context.joker_main or context.blueprint then
            return
        end

        local area = card.area
        if not area or not area.cards then
            return
        end

        local idx
        for i, c in ipairs(area.cards) do
            if c == card then
                idx = i
                break
            end
        end

        local left = idx and idx > 1 and area.cards[idx - 1]

        if left and left.ability and left.ability.set == 'Joker' and not left.getting_sliced then
            local mirrored_context = context
            mirrored_context.blueprint = true
            mirrored_context.blueprint_card = card
            return left:calculate_joker(mirrored_context)
        end
    end,
}