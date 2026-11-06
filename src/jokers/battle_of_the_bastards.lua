local KING_ID = 13
local JOKER_KEY = 'j_rbsg_battle_of_the_bastards'

local function battle_active()
    if not (G.jokers and G.jokers.cards) then return false end
    for _, j in ipairs(G.jokers.cards) do
        if j.config and j.config.center and j.config.center.key == JOKER_KEY and not j.debuff then
            return true
        end
    end
    return false
end

-- Rank word of a card, e.g. "7", "6" (nil for Stone cards)
local function rank_of(c)
    if c.base and c.base.name then
        return c.base.name:match('^(.+) of ')
    end
end

if Card and Card.get_id then
    local orig_get_id = Card.get_id
    function Card:get_id()
        if self.ability and self.ability.rbsg_as_king and battle_active() then
            return KING_ID
        end
        return orig_get_id(self)
    end
end

-- Face override: a picked card counts as a face card
if Card and Card.is_face then
    local orig_is_face = Card.is_face
    function Card:is_face(from_boss)
        if self.ability and self.ability.rbsg_as_king and battle_active() and (not self.debuff or from_boss) then
            return true
        end
        return orig_is_face(self, from_boss)
    end
end

-- The picked card with the given order (1 or 2), or nil
local function picked_card(order)
    for _, c in ipairs(G.playing_cards or {}) do
        if c.ability and c.ability.rbsg_as_king and c.ability.rbsg_order == order then
            return c
        end
    end
end

SMODS.Joker {
    key = 'battle_of_the_bastards',
    atlas = 'jokers_rare',
    pos = { x = 3, y = 0 },
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            cards = 2,
        },
    },

    loc_vars = function(self, info_queue, card)
        -- Show the picked cards by rank and suit
        local names = {}
        for i = 1, 2 do
            local c = picked_card(i)
            names[i] = c and c.base.name or localize('k_none')
        end
        return {
            vars = {
                card.ability.extra.cards,
                names[1],
                names[2],
            },
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        -- Picked cards already exist (debuff ended, or loaded from a save): keep them
        if picked_card(1) or picked_card(2) then return end

        -- Fresh pick: number cards (2 to 10), skipping Stone cards
        local eligible = {}
        for _, c in ipairs(G.playing_cards or {}) do
            local n = tonumber(rank_of(c))
            if n and n >= 2 and n <= 10 and not SMODS.has_no_rank(c) then
                eligible[#eligible + 1] = c
            end
        end

        for order = 1, math.min(card.ability.extra.cards, #eligible) do
            local idx = math.random(#eligible)
            local c = table.remove(eligible, idx)
            c.ability.rbsg_as_king = true
            c.ability.rbsg_order = order
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if from_debuff then return end
        for _, c in ipairs(G.playing_cards or {}) do
            if c.ability and c.ability.rbsg_as_king then
                c.ability.rbsg_as_king = nil
                c.ability.rbsg_order = nil
            end
        end
    end,
}