SMODS.Seal({
	key = "ps",
	atlas = "enh",
	pos = { x = 2, y = 1 },
	discovered = true,
	badge_colour = HEX("A020F0"),
	rarity = 3,
	sound = { sound = "gold_seal", per = 1.2, vol = 0.4 },

	calculate = function(self, card, context)
		if context.main_scoring and context.cardarea == G.play then
			local card = copy_card(card, nil, nil, G.playing_card)
			G.deck.config.card_limit = G.deck.config.card_limit + 1
			table.insert(G.playing_cards, card)
			card:set_seal()
			card:add_to_deck()
			G.hand:emplace(card)
			card.states.visible = nil
			G.E_MANAGER:add_event(Event({
				func = function()
					card:start_materialize()
					return true
				end,
			}))
			return {
				message = "Printed!",
			}
		end
	end,
})

-- am i dumb

--[[SMODS.Seal({
	key = "themoon",
	atlas = "enh",
	pos = { x = 2, y = 1 },
	discovered = true,
	badge_colour = HEX("A020F0"),
	rarity = 3,
	sound = { sound = "gold_seal", per = 1.2, vol = 0.4 },
	calculate = function(self, card, context)
		if context.final_scoring_step and context.cardarea == G.play then
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function()
                local suit = card.base.suit
                local suit_suffix = tostring(suit)
                local rank = card.base.id
            if rank == 11 then
                rank = "Jack"
            elseif rank == 12 then
                rank = "Queen"
            elseif rank == 13 then
                rank = "King"
            elseif rank == 14 then
                rank = "Ace"
            else
                rank = tostring(rank)
            end
				local _rank_suffix = tostring(rank)
                card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
            for i = 1, 2 do
                local acard = create_playing_card({
                    front = G.P_CARDS[suit_suffix .. "_" .. rank],
                    center = G.P_CENTERS.c_base,
                }, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
                assert(SMODS.change_base(acard, suit_suffix, rank))
            end

			RevosVault.c_message(card, localize("k_upgrade"))
			return true
		end
		}))
		end
    end
})]]
