

SMODS.Joker({
	key = "45degreeprinter",
	config = {
		extra = {
		},
	},
	rarity = "crv_p",
	atlas = "morefluff45",
	blueprint_compat = false,
	discovered = false,
	pos = {
		x = 0,
		y = 0,
	},
    display_size = {
		w = 114,
		h = 114,
	},
	cost = 6,
    dependencies = "MoreFluff",
	loc_vars = function(self, info_queue, card)
		return {
			vars = { },
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			for i = 1, 2 do   --Since John MoreFluff added 45 Degree Rotated Cartomancer i cant create a single one anymore >:(
if G.GAME.used_vouchers["v_crv_printerup"] == true and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4  or G.GAME.used_vouchers["v_crv_printeruptier"] == true then
				SMODS.add_card{
                    set = "Rotarot",
                    edition = "e_negative"
                }
			else
				if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then
                    SMODS.add_card{
                        set = "Rotarot",
                    }
				end
			end
		end
	end
end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

-- Printer Ink colour

FLUFF.Colour({
	key = "printer_ink",
	name = "col_Printer_Ink",
	atlas = "colours",
	dependencies = "MoreFluff",
	pos = { x = 0, y = 0 },
	config = {
		upgrade_rounds = 4,
		create_set = "EnchancedDocuments",
	},
})
