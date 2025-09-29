
SMODS.Joker({
	key = "burgerpr",
	atlas = "sdm0",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 0,
		y = 0,
	},
	config = {
		extra = {},
	},
	dependencies = "sdm0sstuff",
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_sdm_burger
	end,
	
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
if G.GAME.used_vouchers["v_crv_printerup"] == true and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4  or G.GAME.used_vouchers["v_crv_printeruptier"] == true then
				SMODS.add_card{
                    key = "j_sdm_burger",
                    edition = "e_negative",
                    area = G.jokers
                }
			else
				if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
                    SMODS.add_card{
                        key = "j_sdm_burger",
                        area = G.jokers
                    }
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return SDM_0s_Stuff_Mod.config.sdm_jokers
	end,
})

SMODS.Joker({
	key = "bredprinter",
	atlas = "sdm0",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 1,
		y = 0,
	},
	config = {
		extra = {},
	},
	dependencies = "sdm0sstuff",
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
if G.GAME.used_vouchers["v_crv_printerup"] == true and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4  or G.GAME.used_vouchers["v_crv_printeruptier"] == true then
				SMODS.add_card{
                    set = "Bakery",
                    edition = "e_negative",
                    area = G.consumeables
                }
			else
				if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
				SMODS.add_card{
                    set = "Bakery",
                    area = G.consumeables
                }
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return SDM_0s_Stuff_Mod.config.sdm_bakery
	end,
})






