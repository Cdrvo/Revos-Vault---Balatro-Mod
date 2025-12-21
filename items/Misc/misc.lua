SMODS.Sound({ key = "facmult", path = "facmult.ogg" })

if SMODS and SMODS.calculate_individual_effect then
	local calcinvold = SMODS.calculate_individual_effect
	function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
		local ret = calcinvold(effect, scored_card, key, amount, from_edition)
		if ret then
			return ret
		end


		-- Factorial Mult! 

		if
			(key == "f_mult" or key == "F_mult" or key == "Factorial_mult" or key == "factorial_mult")
			and amount ~= 0
		then
			if effect.card then
				juice_card(effect.card)
			end
			mult = mod_chips(RevosVault.factorial(mult) * amount)
			update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
			card_eval_status_text(scored_card, "extra", nil, nil, nil, { message = "Mult! * " .. amount })
			return true
		end

		-- Precentage Mult


		if (key == "p_mult" or key == "P_mult" or key == "perc_mult" or key == "Perc_mult") and amount ~= 0 then
			if effect.card then
				juice_card(effect.card)
			end
			mult = mod_chips(mult + RevosVault.perc(mult,amount))
			update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
			card_eval_status_text(scored_card, "extra", nil, nil, nil, { message = "+%"..amount})
			return true
		end

		-- Precentage Chips
		
		if (key == "p_chips") and amount ~= 0 then
			if effect.card then
				juice_card(effect.card)
			end
			hand_chips = mod_chips(mult + RevosVault.perc(hand_chips,amount))
			update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
			card_eval_status_text(scored_card, "extra", nil, nil, nil, { message = "+%"..amount})
			return true
		end
		
		-- Yes i don't need these


	end
	for _, v in ipairs({ "p_mult", "P_mult", "perc_mult", "Perc_mult", "f_mult", "F_mult", "Factorial_mult", "factorial_mult","p_chips"  }) do
		table.insert(SMODS.calculation_keys, v)
	end
end



RevosVault.C = {
	SUP = HEX("f7baff"),
	Continuity = HEX("96a0ff"),
	Mystery = HEX("8a8a8a"),
	--[[BOONS = {
		DEFAULT = HEX("e8b867"),
		HAVE_BOONS = HEX("88beb0"),
		CURRENT = HEX("e8b867"),
		EPIC = HEX("b472ca"),
		HEROIC = HEX("fd5f55")
	},
	BOONRARITY = {}]]
}

SMODS.Gradient({
	key = "crv_polychrome",
	colours = {
		HEX("e81416"),
		HEX("ffa500"),
		HEX("faeb36"),
		HEX("79c314"),
		HEX("487de7"),
		HEX("4b369d"),
		HEX("70369d"),
	},
	cycle = 5,
})

SMODS.Gradient({
	key = "crv_gem",
	colours = {
		HEX("60ff68"),
		HEX("60fff3"),
		HEX("60a2ff"),
		HEX("aa60ff"),
		HEX("ff60e0"),
		HEX("e4fa63"),
		HEX("b0ff8c"),
	},
	cycle = 5,
})

SMODS.Gradient({
	key = "crv_sunwashed",
	colours = {
		HEX("fff760"),
		HEX("ffd09f"),
	},
})

SMODS.Gradient({
	key = "crv_wip",
	colours = {
		HEX("000000"),
		HEX("343434")
	}
})

SMODS.Gradient({
	key = "crv_temp",
	colours = {
		HEX("000000"),
		HEX("ff0000"),
		cycle =3,
	}
})


local loc_old = loc_colour
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		loc_old()
	end
	G.ARGS.LOC_COLOURS.crv_sup = RevosVault.C.SUP
	G.ARGS.LOC_COLOURS.crv_continuity = RevosVault.C.Continuity
	G.ARGS.LOC_COLOURS.crv_polychrome = SMODS.Gradients["crv_polychrome"]
	G.ARGS.LOC_COLOURS.crv_gem = SMODS.Gradients["crv_gem"]
	G.ARGS.LOC_COLOURS.crv_wip = SMODS.Gradients["crv_wip"]
	G.ARGS.LOC_COLOURS.crv_temp = SMODS.Gradients["crv_temp"]
	G.ARGS.LOC_COLOURS.crv_mystery = RevosVault.C.Mystery

	return loc_old(_c, _default)
end