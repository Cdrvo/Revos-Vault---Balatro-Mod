local ExtraEffects_vault = {
	create_temp_copy = {
		key = "create_temp_copy",
		type = "passive",
		ability = { odds = 3 },
		loc_vars = function(info_queue, card, ability_table)
			return { vars = {(G.GAME.probabilities.normal or 1), ability_table.odds } }
		end,
		calculate = function(card, context, ability_table)
			if
				context.first_hand_drawn
				and pseudorandom("create_temp_copy") < G.GAME.probabilities.normal / ability_table.odds
			then
				local card2 = copy_card(card)
				card2:add_to_deck()
				card2:set_edition({ negative = true }, true)
                card2:add_sticker("crv_temp", true)
				G.jokers:emplace(card2)
			end
		end,
	},
}

for k, v in pairs(ExtraEffects_vault) do
	v.key = k
	if (not v.load_check) or (type(v.load_check) == "function" and v:load_check()) then
		ExtraEffects[k] = v
	end
end
