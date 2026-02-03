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

local not_kitty_printer = {
	object_type = "Joker",
	name = "Kitty Printer?",
	key = "not_kitty_printer",
	atlas = "cryp",
	rarity = "crv_p",
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	dependencies = {
		items = {
			"set_cry_exotic",
		},
	},
	gameset_config = {
		modest = {  blueprint_compat = false },
		mainline = { blueprint_compat = false  },
		madness = {  blueprint_compat = true },
	},
	pos = {
		x = 2,
		y = 2,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card, center)
        local key, vars = self.key, {}
	end,

	calculate = function(self, card, context)
        local cae = card.ability.extra
		if context.setting_blind then
            local tab,tab2,no_tab = G.P_CENTER_POOLS.Joker, {}, false
            for k, v2 in pairs(tab) do
                local v = v2.key
                if not no_tab and G.P_CENTERS[v] and (string.find(string.lower(localize({ type = "name_text", key = v, set = "Joker" })), "cat") or string.find(string.lower(localize({ type = "name_text", key = v, set = "Joker" })), "kitty")) then 
                    tab2[#tab2 + 1] = v
                    print(v)
                end
            end
            if #tab2 >= 1 then
                RevosVault.pseudorandom_printer({card = card, area = G.jokers, seed = "kitty_cat",key = pseudorandom_element(tab2)})
            else
                RevosVault.c_message(card, localize("k_crv_no_more"))
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
		y = 3,
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
	yes_printer_list = true,
	dependencies = {
		items = {
			"set_cry_exotic",
		},
	},
	gameset_config = {
		modest = { extra = { odds = 16 }, center = { rarity = "cry_exotic", cost = 50, blueprint_compat = false}},
		mainline = { extra = { odds = 4 }, center = { rarity = "cry_exotic", cost = 45, blueprint_compat = false } },
		madness = { extra = { odds = 1 }, center = { rarity = "cry_exotic", cost = 40, blueprint_compat = true } },
	},
	pos = {
		x = 0,
		y = 0,
	},
	soul_pos = { x = 0, y = 1, extra = { x = 0, y = 2 } },
	config = {
		extra = { odds = 4 },
	},
	loc_vars = function(self, info_queue, card, center)
        local key, vars = self.key, {(G.GAME.probabilities.normal or 1), card.ability.extra.odds }
        if G.PROFILES[G.SETTINGS.profile].cry_gameset == "madness" then
            return {
                vars = vars,
                key = key .. "_madness",
            }
        else
            info_queue[#info_queue + 1] = {set = "Other", key = "crv_fixed_chances"}
            return {
                vars = vars,
                key = key,
            }
        end
	end,

	calculate = function(self, card, context)
        local cae = card.ability.extra
		if context.setting_blind then
            if G.PROFILES[G.SETTINGS.profile].cry_gameset == "madness" then
                RevosVault.pseudorandom_printer({card = card, area = G.jokers, rarity = "cry_exotic", seed = "crv_cry_printorium"})
            elseif not context.blueprint then
                RevosVault.pseudorandom_printer({card = card, area = G.jokers, rarity = "cry_exotic", seed = "crv_cry_printorium", odds = cae.odds, no_odd_mod = true})
            end
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
        brprinter,
        not_kitty_printer,
	},
}
