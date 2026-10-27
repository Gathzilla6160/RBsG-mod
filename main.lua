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
    key = 'booster_packs',
    path = 'booster_packs.png',
    px = 71,
    py = 95,
}
--#endregion

--#region File Loading

    local jokers_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/jokers")
for _, file in ipairs(jokers_src) do
    assert(SMODS.load_file("src/jokers/" .. file))()
end

    local consumables_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/consumables")
for _, file in ipairs(consumables_src) do
    assert(SMODS.load_file("src/consumables/" .. file))()
end

    local enhancements_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/enhancements")
for _, file in ipairs(enhancements_src) do
    assert(SMODS.load_file("src/enhancements/" .. file))()
end

for _, folder in ipairs({ "enhancements", "jokers", "consumables", "boosters" }) do
    local src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/" .. folder)
    for _, file in ipairs(src) do
        if file:match("%.lua$") then
            assert(SMODS.load_file("src/" .. folder .. "/" .. file))()
        end
    end
end


--#endregion 