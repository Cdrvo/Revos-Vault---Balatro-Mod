SMODS.Consumable({
	key = "inkintuition",
	set = "Tarot",
	config = { extra = { odds = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	pos = { x = 0, y = 0 },
	atlas = "tarots",
	cost = 3,
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
			return true
		end
	end,
	use = function(self, card)
		if pseudorandom("inkintuition") < G.GAME.probabilities.normal / card.ability.extra.odds then
			SMODS.add_card({ set = "Joker", area = G.jokers, rarity = "crv_p" })
		else
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function()
					attention_text({
						text = localize("k_nope_ex"),
						scale = 1.3,
						hold = 1.4,
						major = card,
						backdrop_colour = G.C.SECONDARY_SET.Tarot,
						align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and "tm" or "cm",
						offset = {
							x = 0,
							y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0,
						},
						silent = true,
					})
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.06 * G.SETTINGS.GAMESPEED,
						blockable = false,
						blocking = false,
						func = function()
							play_sound("tarot2", 0.76, 0.4)
							return true
						end,
					}))
					play_sound("tarot2", 1, 0.4)
					card:juice_up(0.3, 0.5)
					return true
				end,
			}))
		end
		delay(0.6)
	end,
})

local machine_keys = { "j_crv_head", "j_crv_body", "j_crv_back" }

SMODS.ObjectType({
	key = "megaprinter",
	cards = {
		["j_crv_head"] = true,
		["j_crv_body"] = true,
		["j_crv_back"] = true,
	},
})

SMODS.Consumable({
	key = "dreamsdesires",
	set = "Tarot",
	config = { extra = {} },
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	pos = { x = 1, y = 0 },
	atlas = "tarots",
	cost = 3,
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
			return true
		end
	end,
	use = function(self, card)
		SMODS.add_card({ set = "megaprinter", area = G.jokers })
		delay(1.5)
	end,
})

SMODS.Consumable({
	key = "heart",
	set = "Tarot",
	discovered = true,
	atlas = "tarots",
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
			card:set_edition()
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
			card:set_edition()
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
