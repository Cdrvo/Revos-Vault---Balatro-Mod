SMODS.Joker({
	key = "dieprint",
	config = {},
	rarity = "crv_p",
	atlas = "highroller",
	blueprint_compat = false,
	discovered = false,
	pos = {
		x = 0,
		y = 0,
	},
	cost = 10,
	dependencies = "high_roller",
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,
	calculate = function(self, card, context)
		if context.starting_shop and not context.blueprint then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				SMODS.add_card({
					set = "hrlr_dice",
					edition = "e_negative",
				})
			else
				if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then
					SMODS.add_card({
						set = "hrlr_dice",
					})
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})
