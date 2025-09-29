
	SMODS.Joker({
		key = "riskprinter",
		atlas = "pta",
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
		soul_pos = {
			x = 1,
			y = 0,
		},
		dependencies = "pta_saka",
		loc_vars = function(self, info_queue, center) end,
		calculate = function(self, card, context)
			local crv = card.ability.extra
			if context.setting_blind and not context.blueprint then
				if
					G.GAME.used_vouchers["v_crv_printerup"] == true
						and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
					or G.GAME.used_vouchers["v_crv_printeruptier"] == true
				then
					SMODS.add_card({
						set = "Risk",
						editon = "e_negative",
					})
				else
					if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then
						SMODS.add_card({
							set = "Risk",
						})
					end
				end
			end
		end,
		in_pool = function(self, args)
			return PTASaka.Mod.config["Risk Cards"]
		end,
	})
