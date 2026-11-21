--#region Atlases  

SMODS.Atlas {
    key = 'jokers_common',
    path = 'jokers_common.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'jokers_uncommon',
    path = 'jokers_uncommon.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'jokers_rare',
    path = 'jokers_rare.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'enhancements',
    path = 'enhancements.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'spectrals',
    path = 'spectrals.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'tarots',
    path = 'tarots.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'booster_packs',
    path = 'booster_packs.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'decks',
    path = 'decks.png',
    px = 71,
    py = 95,
}

SMODS.current_mod.process_loc_text = function()
    G.localization.misc.labels.rbsg_wildfire = "Wildfire"
    G.localization.misc.labels.rbsg_badapple = "Bad Apple"
    G.localization.misc.labels.rbsg_kaleidoscopic_smoke = "Kaleidoscopic Smoke"
end
--#endregion

-- Make sure owned mod jokers get flagged as "used"
local add_ref = Card.add_to_deck
function Card:add_to_deck(from_debuff)
    add_ref(self, from_debuff)
    if self.ability and self.ability.set == 'Joker' and self.config.center.mod then
        G.GAME.used_jokers[self.config.center.key] = true
    end
end

local remove_ref = Card.remove_from_deck
function Card:remove_from_deck(from_debuff)
    remove_ref(self, from_debuff)
    if self.ability and self.ability.set == 'Joker' and self.config.center.mod then
        -- only clear the flag if no other copy is still owned
        local count = 0 
        for _, j in ipairs(G.jokers and G.jokers.cards or {}) do
            if j ~= self and j.config.center.key == self.config.center.key then count = count + 1 end
        end
        if count == 0 then G.GAME.used_jokers[self.config.center.key] = nil end
    end
end

-- Filter owned jokers out of the pool
local pool_ref = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append)
    local pool, pool_key = pool_ref(_type, _rarity, _legendary, _append)
    if _type == 'Joker' and not next(SMODS.find_card('j_ring_master')) then
        for i, key in ipairs(pool) do
            if key ~= 'UNAVAILABLE' and next(SMODS.find_card(key)) then
                pool[i] = 'UNAVAILABLE'
            end
        end
    end
    return pool, pool_key
end


--#region File Loading
local loc_colour_ref = loc_colour
function loc_colour(_c, _default)
    if not G.ARGS.LOC_COLOURS then loc_colour_ref() end
    G.ARGS.LOC_COLOURS.rbsg_wildfire = HEX("1FCC2B")
    return loc_colour_ref(_c, _default)
end

for _, folder in ipairs({ "enhancements", "jokers", "consumables", "boosters", "editions", "decks" }) do
    local src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/" .. folder)
    for _, file in ipairs(src) do
        if file:match("%.lua$") then
            assert(SMODS.load_file("src/" .. folder .. "/" .. file))()
        end
    end
end


--#endregion 