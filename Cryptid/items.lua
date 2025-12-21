local mrinter = {
	object_type = "Joker",
	name = "Mrinter",
	key = "mrinter",
	atlas = "cryp",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	gameset_config = {
		modest = { disabled = true },
		mainline = { center = { rarity = "crv_p", cost = 10, blueprint_compat = false } },
		madness = { center = { rarity = "crv_p", cost = 6, blueprint_compat = true } },
	},
	dependencies = {
		items = {
			"set_cry_m",
		},
	},
	pos = {
		x = 1,
		y = 0,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_cry_m
	end,

	calculate = function(self, card, context)
		if context.setting_blind then
			SMODS.add_card({
				set = "Joker",
				area = G.jokers,
				key = "j_cry_m",
			})
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
	pools = { ["M"] = true },
}

local glprinter = {
	object_type = "Joker",
	name = "Glitched Printer",
	key = "glprinter",
	atlas = "cryp",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	dependencies = {
		items = {
			"set_cry_misc",
		},
	},
	gameset_config = {
		modest = { disabled = true },
		mainline = { center = { rarity = "crv_p", cost = 10, blueprint_compat = false } },
		madness = { center = { rarity = "crv_p", cost = 6, blueprint_compat = true } },
	},
	pos = {
		x = 2,
		y = 0,
	},
	config = {
		extra = {
			odds = 4
		},
	},
	loc_vars = function(self, info_queue, card)
		return{
			vars = {(G.GAME.probabilities.normal or 1),card.ability.extra.odds}
		}
	end,

	calculate = function(self, card, context)
		if context.first_hand_drawn then
			if pseudorandom("ucp") < G.GAME.probabilities.normal / card.ability.extra.odds then
				RevosVault.printer_apply(nil, nil, "e_cry_glitched", G.jokers)
			else
				RevosVault.printer_apply(nil, nil, "e_cry_glitched")
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader("cry_glitched", nil, card.ARGS.send_to_shader)
	end,
}

--[[local gldoc = {
	object_type = "Consumable",
	key = "gldoc",
	name = "Glitched Document",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "cryp",
	pos = { x = 2, y = 1 },
	gameset_config = {
		modest = { disabled = true },
		mainline = { disabled = false },
		madness = { disabled = false },
	},
	dependencies = {
		items = {
			"set_cry_misc",
		},
	},
	config = {
		extra = {
			cards = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_cry_glitched
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
			card:set_edition({ cry_glitched = true }, true)
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
			card:set_edition({ cry_glitched = true }, true)
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
	draw = function(self, card, layer)
		card.children.center:draw_shader("cry_glitched", nil, card.ARGS.send_to_shader)
	end,
}]]

local printorium = {
	object_type = "Joker",
	name = "Printorium",
	key = "printorium",
	atlas = "cryp",
	rarity = "cry_exotic",
	cost = 50,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	dependencies = {
		items = {
			"set_cry_exotic",
		},
	},
	gameset_config = {
		modest = { disabled = true },
		mainline = { extra = { odds = 4 }, center = { rarity = "cry_exotic", cost = 50, blueprint_compat = false } },
		madness = { extra = { odds = 1 }, center = { rarity = "cry_exotic", cost = 45, blueprint_compat = true } },
	},
	pos = {
		x = 0,
		y = 0,
	},
	soul_pos = {
		x = 0,
		y = 1,
	},
	config = {
		extra = { odds = 4 },
	},
	loc_vars = function(self, info_queue, card, center)
		return {
			vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,

	calculate = function(self, card, context)
		if context.setting_blind then
			if pseudorandom("printorium") < G.GAME.probabilities.normal / card.ability.extra.odds then
				SMODS.add_card({ set = "Joker", area = G.jokers, rarity = "cry_exotic" })
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
}

local rtprinter = {
	object_type = "Joker",
	name = "Rooter Printer",
	key = "rtprinter",
	atlas = "cryp",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	dependencies = {
		items = {
			"set_cry_code",
		},
	},
	gameset_config = {
		modest = { disabled = true },
		mainline = { center = { rarity = "crv_p", cost = 10, blueprint_compat = false } },
		madness = { center = { rarity = "crv_p", cost = 6, blueprint_compat = true } },
	},
	pos = {
		x = 1,
		y = 1,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.c_cry_seed
	end,

	calculate = function(self, card, context)
		if context.setting_blind then
			local card = create_card("Consumable", G.consumeables, nil, nil, nil, nil, "c_cry_seed")
			card:add_to_deck()
			G.consumeables:emplace(card)
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
}

local qtprinter = {
	object_type = "Joker",
	name = "Quintuple Printer",
	key = "qtprinter",
	atlas = "cryp",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	dependencies = {
		items = {
			"set_cry_tag",
		},
	},
	gameset_config = {
		modest = { disabled = true },
		mainline = { center = { rarity = "crv_p", cost = 10, blueprint_compat = false } },
		madness = { center = { rarity = "crv_p", cost = 6, blueprint_compat = false } },
	},
	pos = {
		x = 0,
		y = 2,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.tag_cry_quintuple
	end,

	calculate = function(self, card, context)
		if context.end_of_round and not context.repetition and not context.individual then
			G.E_MANAGER:add_event(Event({
				func = function()
					add_tag(Tag("tag_cry_quintuple"))
					play_sound("generic1", 0.9 + math.random() * 0.1, 0.8)
					play_sound("holo1", 1.2 + math.random() * 0.1, 0.4)
					return true
				end,
			}))
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
}

local brprinter = {
	object_type = "Joker",
	name = "Printer Drawing",
	key = "brprinter",
	atlas = "cryp",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	dependencies = {
		items = {
			"set_cry_epic",
		},
	},
	gameset_config = {
		modest = { disabled = true },
		mainline = { center = { rarity = "crv_p", cost = 10, blueprint_compat = false } },
		madness = { center = { rarity = "crv_p", cost = 6, blueprint_compat = false } },
	},
	pos = {
		x = 1,
		y = 2,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_cry_boredom
	end,

	calculate = function(self, card, context)
		if context.setting_blind and not context.repetition and not context.individual then
			SMODS.add_card({
				set = "Joker",
				key = "j_cry_boredom",
			})
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
}

return {
	init = function(self) end,
	items = {
		mrinter,
		glprinter,
		printorium,
		rtprinter,
		qtprinter,
        brprinter
	},
}
