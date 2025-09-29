SMODS.Joker({
	key = "stoneoven",
	atlas = "prismc",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	pos = {
		x = 0,
		y = 0,
	},
	config = {
		extra = {
			pizza = 1,
		},
	},
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_blueprint
	end,
	dependencies = "Prism",
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.setting_blind and not context.blueprint then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				SMODS.add_card{
					set = "Pizza",
					area = G.jokers,
					edition = "e_negative",
				}
		else
			if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
				SMODS.add_card{
					set = "Pizza",
					area = G.jokers,
				}
			end
		end
	end
end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

if G.PRISM.config.myth_enabled then
	SMODS.Joker({
		key = "mythprint",
		atlas = "prismc",
		rarity = "crv_p",
		cost = 10,
		unlocked = true,
		discovered = false,
		blueprint_compat = false,
		eternal_compat = true,
		perishable_compat = false,
		pos = {
			x = 1,
			y = 0,
		},
		config = {
			extra = {
				pizza = 1,
			},
		},
		loc_vars = function(self, info_queue, center)
			info_queue[#info_queue + 1] = G.P_CENTERS.j_blueprint
		end,
		dependencies = "Prism",
		calculate = function(self, card, context)
			if context.setting_blind and not context.blueprint then
				if
					G.GAME.used_vouchers["v_crv_printerup"] == true
						and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
					or G.GAME.used_vouchers["v_crv_printeruptier"] == true
				then
					SMODS.add_card({
						set = "Myth",
						edition = "e_negative",
					})
				else
					if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
						SMODS.add_card({
							set = "Myth",
						})
					end
				end
			end
		end,
		in_pool = function(self, wawa, wawa2)
			return true
		end,
	})
end

SMODS.Enhancement({
	key = "saphire",
	atlas = "prismc",
	pos = { x = 0, y = 1 },
	discovered = false,
	config = { extra = { x_mult = 1, x_gain = 0.75 } },
	effect = "Glass Card",
	loc_vars = function(self, info_queue, card)
		local card_ability = card and card.ability or self.config
		return {
			vars = { card_ability.extra.x_mult, card_ability.extra.x_gain },
		}
	end,
	dependencies = "Prism",
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.main_scoring then
			return {
				xmult = card.ability.extra.x_mult,
			}
		end
		if context.end_of_round and context.cardarea == G.hand and context.playing_card_end_of_round then
			card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_gain
			return {
				colour = G.C.RED,
				message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.x_mult } }),
				card = card,
			}
		end
	end,
})

--[[SMODS.Consumable({
	key = "saphirecontract",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "prismc",
	pos = { x = 2, y = 1 },
	config = {
		extra = {
			xmult = 1,
			xmultg = 0.25,
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
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultg
			return {
				emult = card.ability.extra.xmult,
			}
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and card.ability.extra.active
			and SMODS.has_enhancement(context.destroy_card, "m_prism_crystal")
		then
			return {
				remove = true,
			}
		end
		if context.end_of_round and card.ability.extra.active then
			SMODS.destroy_cards(card)
		end
	end,
})]]

SMODS.Joker({
	key = "crystalprinter",
	atlas = "prismc",
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
		info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_crystalcontract
		return {
			vars = {G.GAME.probabilities.normal},
		}
	end,
	calculate = function(self, card, context)
			if context.first_hand_drawn then
			RevosVault.printer_apply("m_prism_crystal", "m_crv_saphire", nil)
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
	dependencies = "Prism",
})
