SMODS.ObjectType({
	object_type = "ObjectType",
	key = "TOGAW",
	cards = {
		["j_toga_y2kbug"] = true,
		["j_toga_controlpanel"] = true,
		["j_toga_taskmgr"] = true,
		["j_toga_win95"] = true,
		["j_toga_win98"] = true,
		["j_toga_winmillenium"] = true,
		["j_toga_winnt4"] = true,
		["j_toga_win2000"] = true,
		["j_toga_useraccounts"] = true,
		["j_toga_virtualmemory"] = true,
		["j_toga_computerlock"] = true,
		["j_toga_recyclebin"] = true,
		["j_toga_theinternet"] = true,
		["j_toga_systemrestore"] = true,
	},
})

SMODS.Joker({
	key = "printerexe",
	atlas = "togaw",
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
	display_size = {
		w = 74,
		h = 95,
	},
	config = {
		extra = {},
	},
	calculate = function(self, card, context)
		if context.setting_blind then
if G.GAME.used_vouchers["v_crv_printerup"] == true and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4  or G.GAME.used_vouchers["v_crv_printeruptier"] == true then
				SMODS.add_card({
					set = "TOGAW",
                    edition = "e_negative"
				})
			else
				if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
                    SMODS.add_card({
                        set = "TOGAW",
                    })
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
dependencies = "TOGAPack"
})

local tags = {1,2}

SMODS.Joker({
	key = "printzip",
	atlas = "togap",
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
		},
	},
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.tag_toga_togajokerbooster
        info_queue[#info_queue + 1] = G.P_CENTERS.tag_toga_togajokerziparchive
		return {
			vars = {},
		}
	end,

	calculate = function(self, card, context)
		if
			context.setting_blind
			and not context.repetition
			and not context.individual
			and not context.blueprint 
		then
			local tag = pseudorandom_element(tags, pseudoseed("printzip"))
			if tag == 1 then
			G.E_MANAGER:add_event(Event({
				func = function()
					add_tag(Tag("tag_toga_togajokerziparchive"))
					play_sound("generic1", 0.9 + math.random() * 0.1, 0.8)
					play_sound("holo1", 1.2 + math.random() * 0.1, 0.4)
					return true
				end,
			}))
		elseif tag == 2 then
			G.E_MANAGER:add_event(Event({
				func = function()
					add_tag(Tag("tag_toga_togajokerbooster"))
					play_sound("generic1", 0.9 + math.random() * 0.1, 0.8)
					play_sound("holo1", 1.2 + math.random() * 0.1, 0.4)
					return true
				end,
			}))
		end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
dependencies = "TOGAPack"
})