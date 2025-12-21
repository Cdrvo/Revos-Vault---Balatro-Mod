SMODS.Blind({
	key = "minimalizm",
	debuff = {
		h_size_le = 3,
	},
	atlas = "blinds",
	pos = { x = 0, y = 1 },
	boss = { min = 3, max = 10 },
	boss_colour = HEX("f84b4b"),
})

SMODS.Blind({
	key = "fragile",
	boss = { min = 3, max = 10 },
	atlas = "blinds",
	pos = { x = 0, y = 0 },
	boss_colour = HEX("ffffff"),
	crv_after_play = function(self, blind, context)
		local cards = {}
		for i = 1, #G.play.cards do
			cards[#cards + 1] = G.play.cards[i]
		end
		local _card = pseudorandom_element(cards, pseudoseed("fragile"))
		if _card then
			SMODS.destroy_cards(_card)
		end
		self.triggered = true
		return true
	end,
})

SMODS.Blind({
	key = "themess",
	boss = {
		min = 1,
		max = 10,
	},
	atlas = "blinds",
	pos = { x = 0, y = 4 },
	boss_colour = HEX("5e5e5e"),
	crv_hand_sort = function(self)
		local cards = {}
		for i, v in pairs(G.hand.cards) do
			cards[#cards + 1] = v
		end
		if #cards > 0 then
			SMODS.destroy_cards(cards)
			G.GAME.blind:wiggle()
		end
	end,
})

SMODS.Blind({
	key = "therent",
	boss = {
		min = 3,
		max = 10,
	},
	atlas = "blinds",
	pos = { x = 0, y = 5 },
	boss_colour = HEX("f0b900"),
	press_play = function(self)
		local cards = {}
		if G.GAME.talisman == 1 then
			if to_number(G.GAME.dollars) > 10 then
				ease_dollars(-3)
			end
		else
			if G.GAME.dollars > 10 then
				ease_dollars(-3)
			end
		end
	end,
})

SMODS.Blind({
	key = "thehater",
	boss = {
		min = 5,
		max = 10,
	},
	atlas = "blinds",
	loc_vars = function(self, info_queue, card)
		return { vars = { (G.GAME.probabilities.normal or 1) } }
	end,
	pos = { x = 0, y = 6 },
	boss_colour = HEX("0d0066"),
	calculate = function(self, card, context)
		if context.final_scoring_step then
			if pseudorandom("thehater") < 1 / 4 then
				hand_chips = 1
				return hand_chips
			end
		end
	end,
})

SMODS.Blind({
	key = "theaneye",
	boss = {
		min = 4,
		max = 10,
	},
	atlas = "blinds",
	pos = { x = 0, y = 7 },
	boss_colour = HEX("ffc954"),
	recalc_debuff = function(self, card, from_blind)
		if card.ability.set == "Enhanced" then
			return true
		end
		return false
	end,
})

SMODS.Blind({
	key = "no",
	boss = { min = 1, max = 10, showdown = true },
	atlas = "blinds",
	pos = { x = 0, y = 3 },
	boss_colour = HEX("c89a00"),
	set_blind = function(self)
		G.GAME.blind.chips = G.GAME.blind.chips * #G.jokers.cards
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
		self.triggered = true
	end,
})

SMODS.Blind({
	key = "rrp",
	boss = {
		min = 1,
		max = 10,
		showdown = true,
	},
	atlas = "blinds",
	pos = { x = 0, y = 2 },
	boss_colour = HEX("3e3e3e"),
	crv_after_play = function(self)
		local jokers = {}
		for i, v in pairs(G.jokers.cards) do
			jokers[#jokers + 1] = v
		end
		if #jokers > 0 then
			self.prepper = false
			local joker = pseudorandom_element(jokers, pseudoseed("cry_landlord"))
			SMODS.destroy_cards(joker)
			G.GAME.blind:wiggle()
		end
	end,
	press_play = function(self)
		self.prepped = true
	end,
})
