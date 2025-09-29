SMODS.Joker({
	key = "prismaticprinter",
	atlas = "entropy",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = {
		x = 0,
		y = 1,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.probabilities.normal,
			},
		}
	end,
	dependencies = "entr",
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			RevosVault.printer_apply("m_entr_prismatic", "m_crv_brightest", nil)
		end
	end,
})

SMODS.Enhancement({
	key = "brightest",
	atlas = "entropy",
	pos = { x = 0, y = 2 },
	shatters = true,
	config = {
		extra = {
			eemult = 2,
			eemult_mod = 0.5,
		},
	},
	dependencies = "entr",
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.eemult,
				card.ability.extra.eemult_mod,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.main_scoring then
			card.ability.extra.eemult = card.ability.extra.eemult + card.ability.extra.eemult_mod
			return {
				emult = card.ability.extra.eemult,
			}
		end
	end,
})

SMODS.Consumable({
	key = "prismaticcontract",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "entropy",
	pos = { x = 0, y = 0 },
	config = {
		extra = {
			eemult = 1,
			eemult_mod = 0.25,
			odds = 4,
			active = false,
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	can_use = function(self, card)
		return card.ability.extra.active == false
	end,
	keep_on_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		card.ability.extra.active = true
		local eval = function()
			return card.ability.extra.active == true
		end
		juice_card_until(card, eval, true)
	end,
	calculate = function(self, card, context)
		if card.ability.extra.active and context.individual and context.cardarea == G.play then
			card.ability.extra.eemult = card.ability.extra.eemult + card.ability.extra.eemult_mod
			return {
				emult = card.ability.extra.eemult,
			}
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and card.ability.extra.active
			and SMODS.has_enhancement(context.destroy_card, "m_entr_prismatic")
		then
			return {
				remove = true,
			}
		end
		if context.end_of_round and card.ability.extra.active then
			SMODS.destroy_cards(card)
		end
	end,
})

--

SMODS.Joker({
	key = "darkprinter",
	atlas = "entropy",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = {
		x = 1,
		y = 1,
	},
	config = {
		extra = {},
	},

	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.probabilities.normal,
			},
		}
	end,
	dependencies = "entr",
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			RevosVault.printer_apply("m_entr_dark", "m_crv_darkest", nil)
		end
	end,
})

SMODS.Enhancement({
	key = "darkest",
	atlas = "entropy",
	pos = { x = 1, y = 2 },
	shatters = true,
	config = {
		extra = {
			eechips = 1,
			eechips_mod = 0.50,
		},
	},
	dependencies = "entr",
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.eechips,
				card.ability.extra.eechips_mod,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.hand and context.main_scoring then
			local cards = {}
			local suits = {}
			for i, v in ipairs(G.play.cards) do
				if
					v.config.center.key == "m_cry_abstract"
					or v.config.center.key == "m_stone"
					or v.config.center.key == "m_wild"
				then
					if not suits[v.config.center.key] then
						suits[v.config.center.key] = true
						cards[#cards + 1] = true
					end
				else
					if not suits[v.base.suit] then
						suits[v.base.suit] = true
						cards[#cards + 1] = true
					end
				end
			end
			for i, v in ipairs(cards) do
				card_eval_status_text(
					card,
					"extra",
					nil,
					nil,
					nil,
					{ message = localize("k_upgrade_ex"), colour = G.C.GREEN }
				)
				card.ability.extra.eechips = card.ability.extra.eechips + card.ability.extra.eechips_mod
				delay(0.3)
			end
			return {
				echips = card.ability.extra.eechips,
			}
		end
	end,
})

SMODS.Consumable({
	key = "darkcontract",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "entropy",
	pos = { x = 1, y = 0 },
	config = {
		extra = {
			xchips = 1,
			xchips_mod = 0.03,
			odds = 4,
			active = false,
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	can_use = function(self, card)
		return card.ability.extra.active == false
	end,
	keep_on_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		card.ability.extra.active = true
		local eval = function()
			return card.ability.extra.active == true
		end
		juice_card_until(card, eval, true)
	end,
	calculate = function(self, card, context)
		if card.ability.extra.active and context.individual and context.cardarea == G.play then
			local cards = {}
			local suits = {}
			for i, v in ipairs(G.play.cards) do
				if v.config.center.key or v.config.center.key == "m_stone" or v.config.center.key == "m_wild" then
					if not suits[v.config.center.key] then
						suits[v.config.center.key] = true
						cards[#cards + 1] = true
					end
				else
					if not suits[v.base.suit] then
						suits[v.base.suit] = true
						cards[#cards + 1] = true
					end
				end
			end
			for i, v in ipairs(cards) do
				card.ability.extra.xchips = card.ability.extra.xchips + card.ability.extra.xchips_mod
				delay(0.3)
			end
			return {
				xchips = card.ability.extra.xchips,
			}
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and card.ability.extra.active
			and SMODS.has_enhancement(context.destroy_card, "m_entr_dark")
		then
			return {
				remove = true,
			}
		end
		if context.end_of_round and card.ability.extra.active then
			SMODS.destroy_cards(card)
		end
	end,
})
