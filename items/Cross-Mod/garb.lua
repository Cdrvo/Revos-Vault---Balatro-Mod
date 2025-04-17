SMODS.Joker({
	key = "stamprinter",
	atlas = "garb",
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
	loc_vars = function(self, info_queue, center)
	end,

	calculate = function(self, card, context)
        local crv = card.ability.extra
		if context.setting_blind and not context.blueprint then
			if G.GAME.used_vouchers["v_crv_printerup"] == true then
				SMODS.add_card{
                    set = "Stamp",
                    editon = "e_negative"
                }
			else
				if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
                    SMODS.add_card{
                        set = "Stamp",
                        editon = "e_negative"
                    }
				end
			end
		end
    end,
    in_pool = function(self, args)
        return true
    end,
    set_badges = function(self, card, badges)
        G.C.GARBR = HEX("7E5A7D")
		badges[#badges+#badges] = create_badge("Garbshit",G.C.GARBR,nil,1)
	end
})