-- None of these jokers can appear in the shop or in booster packs
local function never_in_pool()
    return false
end

-- Turns a joker into another one. The edition (including Negative) is kept.
local function transform(card, new_key)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = function()
            play_sound('card1')
            card:juice_up(0.6, 0.6)
            card:set_ability(G.P_CENTERS[new_key])
            card:juice_up(0.6, 0.6)
            return true
        end,
    }))
end

-- Wolf Cub #1..#5 -> these jokers, in exactly this order
local CUB_FORMS = {
    'j_rbsg_grey_wind',
    'j_rbsg_lady',
    'j_rbsg_nymeria',
    'j_rbsg_summer',
    'j_rbsg_shaggydog',
}

-- Shared logic for the two Uncommon "young" jokers
local function young_calculate(get_form)
    return function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
            }
        end

        if context.end_of_round
            and context.game_over == false
            and context.main_eval
            and not context.blueprint then
            card.ability.extra.rounds = card.ability.extra.rounds + 1

            if card.ability.extra.rounds < card.ability.extra.max_rounds then
                return {
                    message = card.ability.extra.rounds .. '/' .. card.ability.extra.max_rounds,
                    colour = G.C.FILLED_BAR,
                }
            end

            transform(card, get_form(card))
            return {
                message = 'Grown!',
                colour = G.C.GREEN,
            }
        end
    end
end

local function young_loc_vars(self, info_queue, card)
    return {
        vars = {
            card.ability.extra.mult,
            card.ability.extra.rounds,
            card.ability.extra.max_rounds,
        },
    }
end

SMODS.Joker {
    key = 'wolf_cub',
    atlas = 'jokers_uncommon',
    pos = { x = 3, y = 0 },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    in_pool = never_in_pool,
    config = {
        extra = { mult = 10, rounds = 0, max_rounds = 3, index = 1 },
    },
    loc_vars = young_loc_vars,
    calculate = young_calculate(function(card)
        return CUB_FORMS[card.ability.extra.index] or CUB_FORMS[1]
    end),
}

SMODS.Joker {
    key = 'white_one',
    atlas = 'jokers_uncommon',
    pos = { x = 4, y = 0 },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    in_pool = never_in_pool,
    config = {
        extra = { mult = 10, rounds = 0, max_rounds = 3 },
    },
    loc_vars = young_loc_vars,
    calculate = young_calculate(function()
        return 'j_rbsg_ghost'
    end),
}

-- The six grown direwolves: Rare, X1.5 Mult
local DIREWOLVES = {
    { key = 'grey_wind', pos = { x = 0, y = 1 } },
    { key = 'lady',      pos = { x = 1, y = 1 } },
    { key = 'nymeria',   pos = { x = 2, y = 1 } },
    { key = 'summer',    pos = { x = 3, y = 1 } },
    { key = 'shaggydog', pos = { x = 4, y = 1 } },
    { key = 'ghost',     pos = { x = 5, y = 1 } },
}

for _, wolf in ipairs(DIREWOLVES) do
    SMODS.Joker {
        key = wolf.key,
        atlas = 'jokers_rare',
        pos = wolf.pos,
        rarity = 3,
        cost = 8,
        blueprint_compat = true,
        in_pool = never_in_pool,
        config = {
            extra = { xmult = 1.75 },
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = { card.ability.extra.xmult },
            }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult,
                }
            end
        end,
    }
end