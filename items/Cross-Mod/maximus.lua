if Maximus_config.horoscopes then

SMODS.Joker({
	key = "horosprint",
	config = {
		extra = {
			xmult = 3.14,
		},
	},
	rarity = "crv_p",
	atlas = "maximusc",
	blueprint_compat = false,
	discovered = false,
	pos = {
		x = 0,
		y = 0,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { },
		}
	end,
	calculate = function(self, card, context)
		if context.starting_shop and not context.blueprint then
			if G.GAME.used_vouchers["v_crv_printerup"] == true then
				SMODS.add_card{
                    set = "Horoscope",
                    edition = "e_negative"
                }
			else
				if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then
                    SMODS.add_card{
                        set = "Horoscope",
                    }
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
    set_badges = function(self, card, badges)
        G.C.REV3 = HEX("f51bbc")
        G.C.REV4 = HEX("f8a100")
		badges[#badges+#badges] = create_badge("Maximus", G.C.REV3, G.C.REV4,1)
	end
})

end

SMODS.Joker({
	key = "jimboprinterplus",
	atlas = "maximusc",
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
		extra = {},
	},
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_mxms_joker_plus
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			if G.GAME.used_vouchers["v_crv_printerup"] == true then
				local new_card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_mxms_joker_plus")
				new_card:set_edition({
					negative = true,
				}, true)
				new_card:add_to_deck()
				G.jokers:emplace(new_card)
			else
				if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
					local new_card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_mxms_joker_plus")
					new_card:add_to_deck()
					G.jokers:emplace(new_card)
				end
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
    set_badges = function(self, card, badges)
        G.C.REV3 = HEX("f51bbc")
        G.C.REV4 = HEX("f8a100")
		badges[#badges+#badges] = create_badge("Maximus", G.C.REV3, G.C.REV4,1)
	end
})