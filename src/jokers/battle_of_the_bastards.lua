local KING_ID = 13
local JOKER_KEY = 'j_rbsg_battle_of_the_bastards'

local function battle_joker()
    if not (G.jokers and G.jokers.cards) then return nil end
    for _, j in ipairs(G.jokers.cards) do
        if j.config and j.config.center and j.config.center.key == JOKER_KEY and not j.debuff then
            return j
        end
    end
    return nil
end

local function is_picked(c)
    local j = battle_joker()
    if not j or not (c.base and c.base.name) then return false end
    for _, name in ipairs(j.ability.extra.picked or {}) do
        if name == c.base.name then return true end
    end
    return false
end

local function rank_of(c)
    if c.base and c.base.name then
        return c.base.name:match('^(.+) of ')
    end
end

if Card and Card.get_id then
    local orig_get_id = Card.get_id
    function Card:get_id()
        if is_picked(self) then
            return KING_ID
        end
        return orig_get_id(self)
    end
end

-- Face override: a picked card counts as a face card
if Card and Card.is_face then
    local orig_is_face = Card.is_face
    function Card:is_face(from_boss)
        if is_picked(self) and (not self.debuff or from_boss) then
            return true
        end
        return orig_is_face(self, from_boss)
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
            picked = {}, 
        },
    },

    loc_vars = function(self, info_queue, card)
        local picked = (card and card.ability and card.ability.extra and card.ability.extra.picked) or {}
        return {
            vars = {
                self.config.extra.cards,
                picked[1] or localize('k_none'),
                picked[2] or localize('k_none'),
            },
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if card.ability.extra.picked and #card.ability.extra.picked > 0 then return end

        local eligible = {}
        for _, c in ipairs(G.playing_cards or {}) do
            local n = tonumber(rank_of(c))
            if n and n >= 2 and n <= 10 and not SMODS.has_no_rank(c) then
                eligible[#eligible + 1] = c
            end
        end

        card.ability.extra.picked = {}
        for _ = 1, math.min(card.ability.extra.cards, #eligible) do
            local idx = math.random(#eligible)
            local c = table.remove(eligible, idx)
            card.ability.extra.picked[#card.ability.extra.picked + 1] = c.base.name
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if from_debuff then return end
        card.ability.extra.picked = {}
    end,
}