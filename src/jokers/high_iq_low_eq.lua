local FACTS = "Fun facts: The best number is 73. Why? 73 is the 21st prime number. Its mirror, 37, is the 12th, and its mirror, 21, is the product of multiplying seven and three... and in binary, 73 is a palindrome, 1001001, which backwards is 1001001. The correct animal for inter-species super soldier is the koala. You would wind up with an army so cute, it couldn't be attacked. The word valedictorian is from the Latin valedicere, meaning to say farewell. It is primarily used in the United States, Canada, the Philippines and Armenia. Scissors cuts paper, paper covers rock, rock crushes lizard, lizard poisons Spock, Spock smashes scissors, scissors decapitates lizard, lizard eats paper, paper disproves Spock, Spock vaporizes rock, and as it always has, rock crushes scissors."

local WORDS = {}
for w in FACTS:gmatch("%S+") do
    WORDS[#WORDS + 1] = w
end

local WORD_TIME = 0.5

if Card and Card.update then
    local orig_update = Card.update
    function Card:update(dt)
        orig_update(self, dt)
        if self.rbsg_words_idx and self.rbsg_words_idx < #WORDS then
            self.rbsg_words_timer = (self.rbsg_words_timer or 0) + dt
            while self.rbsg_words_timer >= WORD_TIME and self.rbsg_words_idx < #WORDS do
                self.rbsg_words_timer = self.rbsg_words_timer - WORD_TIME
                self.rbsg_words_idx = self.rbsg_words_idx + 1
                card_eval_status_text(self, 'extra', nil, nil, nil, {
                    message = WORDS[self.rbsg_words_idx],
                    colour = G.C.MULT,
                })
            end
        end
    end
end

SMODS.Joker {
    key = 'high_iq_low_eq',
    atlas = 'jokers_common',
    pos = { x = 4, y = 0 },
    rarity = 1,
    cost = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            mult = 18.7,
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
            },
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            -- Start the word popups; the +187 Mult is returned right away
            card.rbsg_words_idx = 0
            card.rbsg_words_timer = 0
            return {
                mult = card.ability.extra.mult,
            }
        end
    end,
}
