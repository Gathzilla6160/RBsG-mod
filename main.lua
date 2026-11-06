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
--#endregion

--#region File Loading

for _, folder in ipairs({ "enhancements", "jokers", "consumables", "boosters", "editions" }) do
    local src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/" .. folder)
    for _, file in ipairs(src) do
        if file:match("%.lua$") then
            assert(SMODS.load_file("src/" .. folder .. "/" .. file))()
        end
    end
end


--#endregion 