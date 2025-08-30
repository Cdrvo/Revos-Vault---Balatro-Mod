SMODS.Joker({
	key = "reverseprinter",
	atlas = "rtarot",
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
		extra = {},
	},
	dependencies = "reverse_tarot",
	loc_vars = function(self, info_queue, center) end,

	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
if G.GAME.used_vouchers["v_crv_printerup"] == true and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4  or G.GAME.used_vouchers["v_crv_printeruptier"] == true then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.4,
					func = function()
						play_sound("timpani")
						local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "remp")
						card:set_edition({ negative = true }, true)
						card:add_to_deck()
						G.consumeables:emplace(card)
						return true
					end,
				}))
			else
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.4,
					func = function()
						if G.consumeables.config.card_limit > #G.consumeables.cards then
							play_sound("timpani")
							local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "remp")
							card:add_to_deck()
							G.consumeables:emplace(card)
						end
						return true
					end,
				}))
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "zodiacprinter",
	atlas = "rtarot",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = {
		x = 1,
		y = 0,
	},
	soul_pos = {
		x = 1,
		y = 1
	},
	config = {
		extra = {},
	},
	dependencies = "reverse_tarot",
	calculate = function(self, card, context)
		if context.setting_blind then
if G.GAME.used_vouchers["v_crv_printerup"] == true and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4  or G.GAME.used_vouchers["v_crv_printeruptier"] == true then
				SMODS.add_card({
					set = "Zodiac",
					area = G.consumeables,
					edition = "e_negative",
				})
			else
				if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then
					SMODS.add_card({
						set = "Zodiac",
						area = G.consumeables,
					})
				end
			end
		end
	end,
})

SMODS.Joker({
	key = "quartzprinter",
	atlas = "rtarot",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = {
		x = 1,
		y = 2,
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
	dependencies = "reverse_tarot",
	calculate = function(self, card, context)
			if context.first_hand_drawn then
			RevosVault.printer_apply("m_reverse_crystal", "m_crv_quartz", nil)
		end
	end,
})

SMODS.Enhancement({
	key = "quartz",
	atlas = "rtarot",
	dependencies = "reverse_tarot",
	pos = { x = 0, y = 2 },
	config = {
		extra = {
			xchips = 2,
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
			return { x_chips = card.ability.extra.x_chips }
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and card.ability.extra.active
			and SMODS.has_enhancement(context.destroy_card, "m_reverse_crystal")
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



SMODS.Consumable{
	key = 'crystalcontract', 
	set = 'EnchancedDocuments', 
	discovered = true,
	atlas = 'rtarot', 
	pos = {x = 2, y = 2}, 
	config = {
		extra = {
			cards = 1, odds = 4}
	},
	dependencies = "reverse_tarot",
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	  end,
	can_use = function(self,card)
		if G and G.hand then
			if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then 
				return true
			end
		end
		return false
	end,
	use = function(self,card,area,copier)
		if pseudorandom('crystalcontract') < G.GAME.probabilities.normal / card.ability.extra.odds then
			for i, card in pairs(G.hand.highlighted) do
				card:set_ability(G.P_CENTERS["m_crv_quartz"])
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
				delay(0.5)
			end
	else 
		for i, card in pairs(G.hand.highlighted) do
			card:set_ability(G.P_CENTERS["m_reverse_crystal"])
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
			delay(0.5)
	end
	
	 end
	 
	end,
}

--
SMODS.Joker({
	key = "copperprinter",
	atlas = "rtarot",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = {
		x = 1,
		y = 3,
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
	dependencies = "reverse_tarot",
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			RevosVault.printer_apply("m_reverse_copper", "m_crv_coatedcopper", nil)
		end
	end,
})

SMODS.Enhancement({
	key = "coatedcopper",
	atlas = "rtarot",
	pos = { x = 0, y = 3 },
	shatters = true,
	config = {
		extra = {
			xchips = 2.5,
			xmultg = 0.25,
			odds = 4,
			active = false,
		},
	},
	dependencies = "reverse_tarot",
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
		if card.ability.extra.active and context.individual and context.cardarea == G.hand then
			return { x_chips = card.ability.extra.x_chips }
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and card.ability.extra.active
			and SMODS.has_enhancement(context.destroy_card, "m_reverse_crystal")
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
SMODS.Consumable{
	key = 'coppercontract', 
	set = 'EnchancedDocuments', 
	discovered = true,
	atlas = 'rtarot', 
	pos = {x = 2, y = 3}, 
	config = {
		extra = {
			cards = 1, odds = 4}
	},
	dependencies = "reverse_tarot",
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	  end,
	can_use = function(self,card)
		if G and G.hand then
			if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then 
				return true
			end
		end
		return false
	end,
	use = function(self,card,area,copier)
		if pseudorandom('coppercontract') < G.GAME.probabilities.normal / card.ability.extra.odds then
			for i, card in pairs(G.hand.highlighted) do
				card:set_ability(G.P_CENTERS["m_crv_coatedcopper"])
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
				delay(0.5)
			end
	else 
		for i, card in pairs(G.hand.highlighted) do
			card:set_ability(G.P_CENTERS["m_reverse_copper"])
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
			delay(0.5)
	end
	
	 end
	 
	end,
}

--

SMODS.Joker({
	key = "omniprinter",
	atlas = "rtarot",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = {
		x = 1,
		y = 4,
	},
	config = {
		extra = {},
	},
	dependencies = "reverse_tarot",
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			local aeaeaeae = pseudorandom_element({1,2,3,4})
			if aeaeaeae == 1 then
				RevosVault.printer_apply("m_reverse_secondary_heart")
			elseif aeaeaeae == 2 then
				RevosVault.printer_apply("m_reverse_secondary_spade")
			elseif aeaeaeae == 3 then
				RevosVault.printer_apply("m_reverse_secondary_diamond")
			elseif aeaeaeae == 4 then
				RevosVault.printer_apply("m_reverse_secondary_club")
			end
		
		end
	end,
})


	--[[local omnisuits = {1,2,3,4}
SMODS.Consumable{
	key = 'omnicontract', 
	set = 'EnchancedDocuments', 
	discovered = true,
	atlas = 'rtarot', 
	pos = {x = 2, y = 4}, 
	config = {
		extra = {
			cards = 1, odds = 4}
	},
	dependencies = "reverse_tarot",
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	  end,
	can_use = function(self,card)
		if G and G.hand then
			if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then 
				return true
			end
		end
		return false
	end,
	use = function(self,card,area,copier)
		if pseudorandom('coppercontract') < G.GAME.probabilities.normal / card.ability.extra.odds then
			for i, card in pairs(G.hand.highlighted) do
				card:set_ability(G.P_CENTERS["m_reverse_omnirank"])
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
				delay(0.5)
			end
	else 
		for i, card in pairs(G.hand.highlighted) do
			local ss = pseudorandom_element(omnisuits, pseudoseed("omnicontract"))
			if ss == 1 then
				card:set_ability(G.P_CENTERS["m_reverse_secondary_heart"])
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
				delay(0.5)
			elseif ss == 2 then
				card:set_ability(G.P_CENTERS["m_reverse_secondary_spade"])
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
				delay(0.5)
			elseif ss == 3 then
				card:set_ability(G.P_CENTERS["m_reverse_secondary_diamond"])
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
				delay(0.5)
			elseif ss == 4 then
				card:set_ability(G.P_CENTERS["m_reverse_secondary_club"])
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
				delay(0.5)
			end
	end
	
	 end
	end,

}]]