Bakery_API.Charm({
	key = "prcharm",
	pos = {
		x = 0,
		y = 0,
	},
	atlas = "bakerycharms",
	config = {},
	loc_vars = function(self, info_queue, card) end,
	calculate = function(self, card, context)
		if context.ending_shop then
			G.E_MANAGER:add_event(Event({
				func = function()
					add_tag(Tag("tag_crv_pst"))
					play_sound("generic1", 0.9 + math.random() * 0.1, 0.8)
					play_sound("holo1", 1.2 + math.random() * 0.1, 0.4)
					return true
				end,
			}))
		end
	end,
	check_for_unlock = function(self, args) end,
	equip = function(self, card) end,
	unequip = function(self, card) end,
})

--[[
not sure on how to implement the idea yet but its there.  Came back to check what ihavedone and i dont remember
Bakery_API.Charm({
	key = "prcharm",
	pos = {
		x = 0,
		y = 0,
	},
	atlas = "bakerycharms",
	config = {},
	loc_vars = function(self, info_queue, card) end,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.before then
				for i = 1, (#context.scoring_hand) do
				local _card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
				_card:add_to_deck()
				G.deck.config.card_limit = G.deck.config.card_limit + 1
				table.insert(G.playing_cards, _card)
				G.hand:emplace(_card)
				_card.states.visible = nil

				G.E_MANAGER:add_event(Event({
					func = function()
						_card:start_materialize()
						return true
					end,
				}))
				return {
					message = "Mutated!",
					colour = G.C.PURPLE,
					playing_cards_created = { true },
				}
            end
	end,
	check_for_unlock = function(self, args) end,
	equip = function(self, card) end,
	unequip = function(self, card) end,
})
}}
]] 
