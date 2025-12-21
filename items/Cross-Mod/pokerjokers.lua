SMODS.Joker({
	key = "trashprinter",
	atlas = "pokerjoker",
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
	dependencies = "pokerjokers",
	loc_vars = function(self, info_queue, center) end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.setting_blind and not context.blueprint then
			if G.GAME.used_vouchers["v_crv_printerup"] == true and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4  or G.GAME.used_vouchers["v_crv_printeruptier"] == true then
				SMODS.add_card({
					key = "j_pok_trash_bin",
					editon = "e_negative",
				})
			else
				if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
					SMODS.add_card({
						key = "j_pok_trash_bin",
					})
				end
			end
		end
	end,
})