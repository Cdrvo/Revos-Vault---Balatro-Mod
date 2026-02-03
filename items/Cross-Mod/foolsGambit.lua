
SMODS.Joker({
	fg_data = {
			is_alternate = true,
			alternate_key ='j_crv_defaultprinter'
		},	
	key = "aberration_printer",
	config = {},
	rarity = "crv_p",
	atlas = "fg",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 0,
		y = 0,
	},
	cost = 10,
	dependencies = "foolsGambit",
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,
	calculate = function(self, card, context)
		if context.starting_shop and not context.blueprint then
			RevosVault.pseudorandom_printer({card = card, area = G.consumeables, sets = "aberration"})
		end
	end,
	in_pool = function (self, args)
		if FG and FG.config.extra_jokers and FG.FUNCS.allow_duplicate(self) and not G.GAME.pool_flags.alternate_spawn then return true else return false end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_printer_qm"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})