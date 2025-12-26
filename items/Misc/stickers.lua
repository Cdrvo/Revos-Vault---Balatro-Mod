SMODS.Sticker({
	key = "vamp",
	badge_colour = HEX("830000"),
	atlas = "enh",
	pos = {
		x = 2,
		y = 2,
	},
	sets = {
		Joker = true,
	},
	rate = 0.3,
	needs_enable_flag = true,
	calculate = function(self, card, context)
		if context.setting_blind then
			local rr = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					rr = i
					break
				end
			end
			if G.jokers.cards[rr + 1] == nil or G.jokers.cards[rr - 1] == nil and not context.blueprint then
				card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
			end
		end
	end,
})

SMODS.Sticker({
	key = "haunted",
	badge_colour = HEX("232323"),
	atlas = "enh",
	pos = {
		x = 3,
		y = 2,
	},
	sets = {
		Joker = true,
	},
	rate = 0.06,
	needs_enable_flag = true,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.blueprint then
			card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
		end
	end,
})

SMODS.Sticker({
	key = "radioactive",
	badge_colour = HEX("008c24"),
	atlas = "enh",
	pos = {
		x = 4,
		y = 2,
	},
	sets = {
		Joker = true,
	},
	rate = 0.1,
	needs_enable_flag = true,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.blueprint then
			local rr = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					rr = i
					break
				end
			end
			local lc = { "Left", "Right" }
			local choosencard = pseudorandom_element(lc, pseudoseed("radioactive"))
			if choosencard == "Left" and G.jokers.cards[rr - 1] ~= nil then
				G.jokers.cards[rr - 1]:start_dissolve({ HEX("57ecab") }, nil, 1.6)
			elseif choosencard == "Right" and G.jokers.cards[rr + 1] ~= nil then
				G.jokers.cards[rr + 1]:start_dissolve({ HEX("57ecab") }, nil, 1.6)
			end
		end
	end,
})

SMODS.Sticker({
	key = "absolute",
	badge_colour = HEX("ffe9b5"),
	atlas = "enh",
	pos = {
		x = 2,
		y = 3,
	},
	sets = {
		Joker = true,
	},
	rate = 0.06,
	needs_enable_flag = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { G.GAME.probabilities.normal },
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.blueprint then
			if pseudorandom("absolute") < G.GAME.probabilities.normal / 4 then
				local rr = nil
				for i = 1, #G.jokers.cards do
					if G.jokers.cards[i] == card then
						rr = i
						break
					end
				end
				local card2 = G.jokers.cards[rr].config.center_key
				SMODS.add_card({
					area = G.jokers,
					key = card2,
				})
			end
		end
	end,
})

SMODS.Sticker({
	key = "continuity",
	badge_colour = HEX("96a0ff"),
	atlas = "enh",
	pos = {
		x = 5,
		y = 1,
	},
	sets = {
		Joker = true,
	},
	rate = 0.06,
	needs_enable_flag = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			local table = {}
			table[#table + 1] = card
			RevosVault.replacecards(table, nil, nil, true, nil)
			card_eval_status_text(card, "extra", nil, nil, nil, { message = "Change!" })
		end
		if card.ability.set == "Enhanced" or card.ability.set == "Default" or card.ability.set == "Playing Card" then
			if context.final_scoring_step and context.cardarea == G.play then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.2,
					func = function()
						local table = {}
						table[#table + 1] = card
						RevosVault.replacecards(table, nil, nil, true, nil)
						return true
					end,
				}))
			end
		end
	end,
})

SMODS.Sticker({
	key = "overtime",
	badge_colour = HEX("fdffa8"),
	atlas = "enh",
	pos = {
		x = 5,
		y = 2,
	},
	sets = {
		Joker = true,
	},
	config = {
		ad = {
			timer = 3,
		},
	},
	rate = 0.06,
	needs_enable_flag = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.over_tally, G.GAME.overtime_rounds },
		}
	end,
	applied = function(self, card, val)
		card.ability.over_tally = G.GAME.overtime_rounds
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			if card.ability.crv_overtime and card.ability.over_tally > 0 then
				if card.ability.over_tally == 1 then
					card.ability.over_tally = 0
					local table = {}
					table[#table + 1] = card
					RevosVault.replacecards(table, nil, nil, true, nil)
					card_eval_status_text(card, "extra", nil, nil, nil, { message = "Change!" })
					card.ability.crv_overtime = false
				else
					card.ability.over_tally = card.ability.over_tally - 1
					card_eval_status_text(
						card,
						"extra",
						nil,
						nil,
						nil,
						{
							message = localize({ type = "variable", key = "a_remaining", vars = {
								card.ability.over_tally,
							} }),
							colour = G.C.FILTER,
							delay = 0.45,
						}
					)
				end
			end
		end
	end,
})

SMODS.Sticker({
	key = "temp",
	badge_colour = SMODS.Gradients["crv_temp"],
	atlas = "enh",
	pos = {
		x = 5,
		y = 3,
	},
	sets = {
		Joker = true,
	},
	rate = 0.01,
	needs_enable_flag = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.blueprint and context.main_eval then
			card:start_dissolve()
		end
	end,
})

SMODS.Sticker({
	key = "mystery",
	badge_colour = HEX("8a8a8a"),
	atlas = "enh",
	pos = {
		x = 6,
		y = 1,
	},
	sets = {
		Joker = true,
	},
	config = {},
	rate = 0.04,
	needs_enable_flag = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { G.GAME.mystery_rounds, card.ability.mystery_tally },
		}
	end,
	applied = function(self, card, val)
		card.ability.mystery_tally = G.GAME.mystery_rounds
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			if card.ability.mystery_tally > 0 then
				if card.ability.mystery_tally == 1 then
					card.ability.mystery_tally = 0
					local s = RevosVault.poll_sticker(true, card, true)
					if s then
						card:add_sticker(s, true)
						card_eval_status_text(
							card,
							"extra",
							nil,
							nil,
							nil,
							{ message = (localize({ type = "name_text", key = s, set = "Other" }) .. "!") }
						)
					else
						card_eval_status_text(card, "extra", nil, nil, nil, { message = "No Sticker!" })
					end
					card.ability.crv_mystery = false
				else
					card.ability.mystery_tally = card.ability.mystery_tally - 1
					card_eval_status_text(card, "extra", nil, nil, nil, {
						message = localize({
							type = "variable",
							key = "a_remaining",
							vars = {
								card.ability.mystery_tally,
							},
						}),
						colour = G.C.FILTER,
						delay = 0.45,
					})
				end
			end
		end
	end,
})

SMODS.Sticker({
	key = "cursed",
	badge_colour = HEX("000000"),
	atlas = "enh",
	pos = {
		x = 1,
		y = 3,
	},
	sets = {
		Joker = true,
	},
	config = {},
	rate = 0.04,
	needs_enable_flag = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,
	calculate = function(self, card, context)
		local crv = self.config
		if context.end_of_round and context.main_eval then
			local s = RevosVault.poll_sticker(true, card)
			if s then
				card:add_sticker(s, true)
				card_eval_status_text(
					card,
					"extra",
					nil,
					nil,
					nil,
					{ message = (localize({ type = "name_text", key = s, set = "Other" }) .. "!") }
				)
			end
		end
	end,
})

SMODS.Sticker({
	key = "fan",
	pos = {
		x = 7,
		y = 0,
	},
	badge_colour = HEX("55c6d9"),
	atlas = "enh",
	sets = {
		Joker = true,
	},
	config = {},
	rate = 0.04,
	needs_enable_flag = true,
	loc_vars = function(self, info_queue, card)
	return {
		vars = {},
	}
	end,
	calculate = function(self, card, context)
	if context.initial_scoring_step then
		local ii = 1
		for i = 1, #G.jokers.cards do
			ii = RevosVault.joker_pos(card)
		end
		if G.jokers.cards[ii + 1] and G.jokers.cards[ii + 2] then
			RevosVault.move(G.jokers.cards[ii + 1], ii + 2)
		end
	end
end
})

SMODS.Sticker({
	key = "heavy",
	pos = {
		x = 0,
		y = 4,
	},
	badge_colour = HEX("303030"),
	atlas = "enh",
	sets = {
		Joker = true,
	},
	config = {},
	rate = 0.06,
	needs_enable_flag = true,
	loc_vars = function(self, info_queue, card)
	return {
		vars = {},
	}
	end,
	applied = function(self, card, val)
		if card and card.area and card.area.config and card.area.config.card_limit and card.area ~= G.deck then
			card.area.config.card_limit = card.area.config.card_limit - 1
		end
	end,
	removed = function(self, card, val)
		if card and card.area and card.area.config and card.area.config.card_limit and card.area ~= G.deck then
			card.area.config.card_limit = card.area.config.card_limit + 1
		end
	end,
})

SMODS.Sticker({
	key = "wet",
	pos = {
		x = 2,
		y = 4,
	},
	badge_colour = HEX("0075ff"),
	atlas = "enh",
	sets = {
		Joker = true,
	},
	config = {},
	rate = 0.06,
	needs_enable_flag = true,
	loc_vars = function(self, info_queue, card)
	return {
		vars = {},
	}
	end,
	update = function(self, card, context)
		if card.debuff then card.debuff = nil end
	end
})
