SMODS.Joker({
	key = "mulmythprinter",
	rarity = "crv_p",
	atlas = "omniverse",
	blueprint_compat = false,
	discovered = false,
	pos = {
		x = 0,
		y = 0,
	},
	cost = 20,
	dependencies = "Multiverse",
	loc_vars = function(self, info_queue, card)
		return {
			vars = { },
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
            if G.GAME.used_vouchers["v_crv_printerup"] == true and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4  or G.GAME.used_vouchers["v_crv_printeruptier"] == true then
				SMODS.add_card{
                    set = "mul_Myth",
                    edition = "e_negative"
                }
			else
				if #G.consumeables.cards < G.consumeables.config.card_limit then
                    SMODS.add_card{
                        set = "mul_Myth",
                    }
				end
			end
		end
	end,
})