SMODS.Consumable({
	key = "inkintuition",
	set = "Tarot",
	config = { extra = { odds = 2 } },
	loc_vars = function(self, info_queue, card)
		local cae = card.ability.extra
		local num, den = SMODS.get_probability_vars(card,1,cae.odds,"ink_seed")
		return { vars = { num,  den } }
	end,
	pos = { x = 0, y = 0 },
	atlas = "tarots",
	cost = 3,
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		if #G.jokers.cards < G.jokers.config.card_limit then
			return true
		end
	end,
	use = function(self, card)
		if SMODS.pseudorandom_probability(card,"ink_seed",1,card.ability.extra.odds) then
			SMODS.add_card({ set = "Joker", area = G.jokers, rarity = "crv_p" })
		else
			RevosVault.nope({card = card})
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
		info_queue[#info_queue+1] = G.P_CENTERS["j_crv_head"]
		info_queue[#info_queue+1] = G.P_CENTERS["j_crv_body"]
		info_queue[#info_queue+1] = G.P_CENTERS["j_crv_back"]
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

SMODS.Consumable({
	key = "mastery",
	set = "Tarot",
	discovered = true,
	atlas = "tarots",
	pos = { x = 1, y = 1 },
	config = {
		extra = {
			cards = 2,
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
			then
				for i = 1, #G.hand.highlighted do
					if RevosVault.upgrade_enhancement(G.hand.highlighted[i], true) then
						return true
					end
				end
			end
		end
		return false
	end,
	use = function(self, card, area, copier)
		for i, card in pairs(G.hand.highlighted) do
		if RevosVault.upgrade_enhancement(card, true) then
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					card:flip()
					card:juice_up()
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.5,
				func = function()
					card:set_ability(RevosVault.upgrade_enhancement(card))
					G.hand:unhighlight_all()
					card:flip()
					return true
				end,
			}))
		end
		end
		G.hand:unhighlight_all()
	end,
})

if RevoConfig["8_curses_enabled"] then
	SMODS.Consumable({
		key = "prayer",
		set = "Tarot",
		config = { extra = { cards = 1, odds = 4 } },
		loc_vars = function(self, info_queue, card)
			local cae = card.ability.extra
			local numerator, denominator = SMODS.get_probability_vars(self, 1, cae.odds, "crv_prayer")
			return { vars = { card.ability.extra.cards,numerator,denominator } }
		end,
		pos = { x = 2, y = 0 },
		atlas = "tarots",
		cost = 5,
		unlocked = true,
		discovered = true,
		can_use = function(self, card)
			if G and G.crv_curses then
				if #G.crv_curses.highlighted ~= 0 and #G.crv_curses.highlighted <= card.ability.extra.cards then 
					for k, v in pairs(G.crv_curses.highlighted) do
						if v.config.center.rarity == "crv_curse" then
							return true
						end
					end
				end
			end
			return false
		end,
		use = function(self, card)
			local cae = card.ability.extra
			if SMODS.pseudorandom_probability(card, "crv_prayer", 1, cae.odds) then
				RevosVault.purified_curse = true
				for i, card in pairs(G.crv_curses.highlighted) do
					if card.config.center.rarity == "crv_curse" then
						SMODS.destroy_cards(card, true)
						check_for_unlock({type = "purifying_it"})
					end
				end
			else
				RevosVault.nope({card = card})
			end
		end,
		after_use = function()
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.5,
				func = function()
					if RevosVault.purified_curse then
						RevosVault.purified_curse = false
					end
					return true
				end
			}))
		end,
		in_pool = function(self)
			return (G.crv_curses and (RevosVault.rarity_in("crv_curse", G.crv_curses.cards) and (RevosVault.rarity_in("crv_curse", G.crv_curses.cards)>0)))
		end
	})
end