SMODS.ConsumableType({
	key = "EnchancedDocuments",

	collection_rows = { 4, 5 },
	primary_colour = G.C.WHITE,
	secondary_colour = G.C.BLACK,
})

SMODS.UndiscoveredSprite({
	key = "EnchancedDocuments",
	atlas = "documents_u",
	pos = { x = 0, y = 0 },
})

SMODS.Consumable({
	key = "glassdocument",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "documents",
	pos = { x = 0, y = 0 },
	config = {
		extra = {
			xmult = 2,
			odds = 4,
			active = false,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["m_glass"]
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
			return {
				xmult = card.ability.extra.xmult,
			}
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and (pseudorandom("glassdocument") < G.GAME.probabilities.normal / G.GAME.glassodds
				or SMODS.has_enhancement(context.destroy_card, "m_glass"))
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

SMODS.Consumable({
	key = "steeldocument",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "documents",
	pos = { x = 3, y = 0 },
	config = {
		extra = {
			xmult = 1.5,
			odds = 4,
			active = false,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["m_steel"]
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
		if card.ability.extra.active and context.individual then
			if context.cardarea == G.hand then
				return {
					xmult = card.ability.extra.xmult,
				}
			end
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and card.ability.extra.active
			and SMODS.has_enhancement(context.destroy_card, "m_steel")
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

SMODS.Consumable({
	key = "devilscontract",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "documents",
	pos = { x = 1, y = 0 },
	config = {
		extra = {
			xmult = 2,
			odds = 4,
			active = false,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["m_crv_mugged"]
		info_queue[#info_queue+1] = G.P_CENTERS["m_crv_aflame"]
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
		if card.ability.extra.active and context.individual then
			if next(context.poker_hands["Flush"]) or next(context.poker_hands["Full House"]) then
				if context.cardarea == G.play then
					return {
						xmult = card.ability.extra.xmult,
					}
				end
			end
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and card.ability.extra.active
			and (
				SMODS.has_enhancement(context.destroy_card, "m_crv_mugged")
				or SMODS.has_enhancement(context.destroy_card, "m_crv_aflame")
			)
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

SMODS.Consumable({
	key = "megadoc",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "megaenh",
	pos = { x = 1, y = 0 },
	config = {
		extra = {
			xmult = 4,
			odds = 4,
			active = false,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["m_crv_mega"]
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
		if card.ability.extra.active and context.individual then
			if context.cardarea == G.play then
				return {
					xmult = card.ability.extra.xmult,
				}
			end
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and card.ability.extra.active
			and SMODS.has_enhancement(context.destroy_card, "m_crv_mega")
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
SMODS.Consumable({
	key = "t1doc",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "t",
	pos = { x = 0, y = 1 },
	config = {
		extra = {
			xmult = 50,
			odds = 4,
			active = false,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["m_crv_tier1card"]
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
		if card.ability.extra.active and context.individual then
			if context.cardarea == G.play then
				return {
					chips = card.ability.extra.xmult,
				}
			end
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and card.ability.extra.active
			and SMODS.has_enhancement(context.destroy_card, "m_crv_tier1card")
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
SMODS.Consumable({
	key = "t2doc",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "t",
	pos = { x = 1, y = 1 },
	config = {
		extra = {
			xmult = 100,
			mult = 10,
			odds = 4,
			active = false,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["m_crv_tier2card"]
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
		if card.ability.extra.active and context.individual then
			if context.cardarea == G.play then
				return {
					chips = card.ability.extra.xmult,
					mult = card.ability.extra.mult,
				}
			end
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and card.ability.extra.active
			and SMODS.has_enhancement(context.destroy_card, "m_crv_tier2card")
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
SMODS.Consumable({
	key = "t3doc",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "t",
	pos = { x = 2, y = 1 },
	config = {
		extra = {
			chips = 200,
			xmult = 3,
			odds = 4,
			active = false,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["m_crv_tier3card"]
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
		if card.ability.extra.active and context.individual then
			if context.cardarea == G.play then
				return {
					chips = card.ability.extra.chips,
					xmult = card.ability.extra.xmult,
				}
			end
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and card.ability.extra.active
			and SMODS.has_enhancement(context.destroy_card, "m_crv_tier3card")
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

--[[SMODS.Consumable({
	key = "boostdoc",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "t",
	pos = { x = 3, y = 1 },
	config = { extra = { cards = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	can_use = function(self, card)
		if G and G.hand then
			if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then
				return true
			end
		end
		return false
	end,
	use = function(self, card, area, copier)
		for i, card in pairs(G.hand.highlighted) do
			card:set_ability(G.P_CENTERS["m_crv_boostcard"])
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
			delay(0.5)
		end
	end,
})]]

SMODS.Consumable({
	key = "luckydocument",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "documents",
	pos = { x = 2, y = 0 },
	config = {
		extra = {
			xmult = 1.5,
			odds = 5,
			odds2 = 15,
			active = false,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["m_lucky"]
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
			local effect = {}
			if pseudorandom("luckydocument") < G.GAME.probabilities.normal / card.ability.extra.odds2 then
				effect.mult = G.P_CENTERS.m_lucky.config.p_dollars
			end
			if pseudorandom("luckydocument") < G.GAME.probabilities.normal / card.ability.extra.odds then
				effect.mult = G.P_CENTERS.m_lucky.config.mult
			end
			return effect
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and card.ability.extra.active
			and SMODS.has_enhancement(context.destroy_card, "m_lucky")
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

--[[SMODS.Consumable({
	key = "polydoc",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "documents",
	pos = { x = 2, y = 1 },
	config = {
		extra = {
			cards = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	can_use = function(self, card)
		if G and G.hand then
			if
				#G.hand.highlighted ~= 0
				and #G.hand.highlighted <= card.ability.extra.cards
				and #G.jokers.highlighted == 0
			then
				return true
			elseif
				#G.jokers.highlighted ~= 0
				and #G.jokers.highlighted <= card.ability.extra.cards
				and #G.hand.highlighted == 0
			then
				return true
			end
		end
		return false
	end,
	use = function(self, card, area, copier)
		for i, card in pairs(G.hand.highlighted) do
			card:set_edition({ polychrome = true }, true)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
			delay(0.5)
		end
		for i, card in pairs(G.jokers.highlighted) do
			card:set_edition({ polychrome = true }, true)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
			delay(0.5)
		end
	end,
})

SMODS.Consumable({
	key = "foildoc",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "documents",
	pos = { x = 0, y = 1 },
	config = {
		extra = {
			cards = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	can_use = function(self, card)
		if G and G.hand then
			if
				#G.hand.highlighted ~= 0
				and #G.hand.highlighted <= card.ability.extra.cards
				and #G.jokers.highlighted == 0
			then
				return true
			elseif
				#G.jokers.highlighted ~= 0
				and #G.jokers.highlighted <= card.ability.extra.cards
				and #G.hand.highlighted == 0
			then
				return true
			end
		end
		return false
	end,
	use = function(self, card, area, copier)
		for i, card in pairs(G.hand.highlighted) do
			card:set_edition({ foil = true }, true)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
			delay(0.5)
		end
		for i, card in pairs(G.jokers.highlighted) do
			card:set_edition({ foil = true }, true)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
			delay(0.5)
		end
	end,
})

SMODS.Consumable({
	key = "holdoc",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "documents",
	pos = { x = 1, y = 1 },
	config = {
		extra = {
			cards = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	can_use = function(self, card)
		if G and G.hand then
			if
				#G.hand.highlighted ~= 0
				and #G.hand.highlighted <= card.ability.extra.cards
				and #G.jokers.highlighted == 0
			then
				return true
			elseif
				#G.jokers.highlighted ~= 0
				and #G.jokers.highlighted <= card.ability.extra.cards
				and #G.hand.highlighted == 0
			then
				return true
			end
		end
		return false
	end,
	use = function(self, card, area, copier)
		for i, card in pairs(G.hand.highlighted) do
			card:set_edition({ holo = true }, true)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
			delay(0.5)
		end
		for i, card in pairs(G.jokers.highlighted) do
			card:set_edition({ holo = true }, true)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
			delay(0.5)
		end
	end,
})

SMODS.Consumable({
	key = "negdoc",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "documents",
	pos = { x = 3, y = 1 },
	config = {
		extra = {
			cards = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	can_use = function(self, card)
		if G and G.hand then
			if
				#G.hand.highlighted ~= 0
				and #G.hand.highlighted <= card.ability.extra.cards
				and #G.jokers.highlighted == 0
			then
				return true
			elseif
				#G.jokers.highlighted ~= 0
				and #G.jokers.highlighted <= card.ability.extra.cards
				and #G.hand.highlighted == 0
			then
				return true
			end
		end
		return false
	end,
	use = function(self, card, area, copier)
		for i, card in pairs(G.hand.highlighted) do
			card:set_edition({ negative = true }, true)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
			delay(0.5)
		end
		for i, card in pairs(G.jokers.highlighted) do
			card:set_edition({ negative = true }, true)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
			delay(0.5)
		end
	end,
})

SMODS.Consumable({
	key = "uedoc",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "documents",
	pos = { x = 0, y = 2 },
	config = {
		extra = {
			cards = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	can_use = function(self, card)
		if G and G.hand then
			if
				#G.hand.highlighted ~= 0
				and #G.hand.highlighted <= card.ability.extra.cards
				and #G.jokers.highlighted == 0
			then
				return true
			elseif
				#G.jokers.highlighted ~= 0
				and #G.jokers.highlighted <= card.ability.extra.cards
				and #G.hand.highlighted == 0
			then
				return true
			end
		end
		return false
	end,
	use = function(self, card, area, copier)
		for i, card in pairs(G.hand.highlighted) do
			card:set_edition(poll_edition(pseudorandom("uedoc"), nil, true, true))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
			delay(0.5)
		end
		for i, card in pairs(G.jokers.highlighted) do
			card:set_edition(poll_edition(pseudorandom("uedoc"), nil, true, true))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
			delay(0.5)
		end
	end,
})

]]