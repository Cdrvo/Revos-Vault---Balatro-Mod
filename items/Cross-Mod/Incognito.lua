
SMODS.Joker({
	key = "tetorinter",
	atlas = "incog",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	config = {extra = {}},
	pos = {
		x = 0,
		y = 1,
	},
	dependencies = "Incognito",
	loc_vars = function(self, info_queue, center) end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.setting_blind and not context.blueprint then
            if G.GAME.used_vouchers["v_crv_printerup"] == true and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4  or G.GAME.used_vouchers["v_crv_printeruptier"] == true then
				SMODS.add_card{
                    set = "Joker",
                    rarity = "nic_teto",
                    edition = "e_negative",
                    area = G.jokers
                }
			else
				if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
                    SMODS.add_card{
                    set = "Joker",
                    rarity = "nic_teto",
                    area = G.jokers
                    }
				end
			end
		end
	end,
})

SMODS.Joker({
	key = "plantinter",
	atlas = "incog",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	config = {extra = {}},
	pos = {
		x = 0,
		y = 0,
	},
	soul_pos = {
		x = 1,
		y = 0,
	},
	dependencies = "Incognito",
	loc_vars = function(self, info_queue, center) 
		info_queue[#info_queue+1] = G.P_CENTERS["j_nic_crazydave"]
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.setting_blind and not context.blueprint then
            if next(SMODS.find_card("j_nic_crazydave")) and (G.GAME.used_vouchers["v_crv_printerup"] == true and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4  or G.GAME.used_vouchers["v_crv_printeruptier"] == true) then
				SMODS.add_card{
                    set = "Joker",
                    rarity = "nic_plants",
                    edition = "e_negative",
                    area = G.zengarden
                }
			else
				if G.zengarden and #G.zengarden.cards < G.zengarden.config.card_limit and next(SMODS.find_card("j_nic_crazydave")) then
                    SMODS.add_card{
                    set = "Joker",
                    rarity = "nic_plants",
                    area = G.zengarden
                    }
				end
			end
		end
	end,
})
