local cardtomake = { 1, 2, 3 }
local lpmc = { 1, 2, 3, 4 }
local scrapselecta = { 1, 2 }

SMODS.Joker({
	key = "defaultprinter",
	atlas = "Jokers",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 3,
		y = 2,
	},
	config = {
		extra = {},
	},
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				local make = pseudorandom_element(cardtomake, pseudoseed("defaultprinter"))
				local allcons = {}
				for k, _ in pairs(SMODS.ConsumableTypes) do
					table.insert(allcons, k)
				end
				local toadd = pseudorandom_element(allcons, pseudoseed("defaultprinter"))
				if make == 1 then
					SMODS.add_card({
						set = toadd,
						edition = "e_negative",
					})
				elseif make == 2 then
					SMODS.add_card({
						set = "Joker",
						area = G.jokers,
						edition = "e_negative",
					})
				elseif make == 3 then
					local acard = create_playing_card({
						front = G.P_CARDS["" .. "_" .. ""],
						center = G.P_CENTERS[SMODS.poll_enhancement({
							guaranteed = true,
						})],
					}, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
				end
			else
				local make = pseudorandom_element(cardtomake, pseudoseed("defaultprinter"))
				local allcons = {}
				for k, _ in pairs(SMODS.ConsumableTypes) do
					table.insert(allcons, k)
				end
				local toadd = pseudorandom_element(allcons, pseudoseed("anything"))
				if make == 1 then
					if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then
						SMODS.add_card({
							set = toadd,
						})
					else
						return {
							message = "No Space!",
						}
					end
				elseif make == 2 then
					if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
						SMODS.add_card({
							set = "Joker",
							area = G.jokers,
						})
					else
						return {
							message = "No Space!",
						}
					end
				elseif make == 3 then
					local acard = create_playing_card({
						front = G.P_CARDS["" .. "_" .. ""],
						center = G.P_CENTERS[SMODS.poll_enhancement({
							guaranteed = true,
						})],
					}, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "printer",
	atlas = "Jokers",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 0,
		y = 0,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_blueprint
	end,

	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				local new_card = create_card("Blueprint", G.jokers, nil, nil, nil, nil, "j_blueprint")
				new_card:add_to_deck()
				new_card:set_edition({ negative = true }, true)
				G.jokers:emplace(new_card)
			else
				if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
					local new_card = create_card("Blueprint", G.jokers, nil, nil, nil, nil, "j_blueprint")
					new_card:add_to_deck()
					G.jokers:emplace(new_card)
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "rustyprinter",
	atlas = "Jokers",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 1,
		y = 0,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_brainstorm
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				local new_card = create_card("Brainstorm", G.jokers, nil, nil, nil, nil, "j_brainstorm")
				new_card:add_to_deck()
				new_card:set_edition({ negative = true }, true)
				G.jokers:emplace(new_card)
			else
				if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
					local new_card = create_card("Brainstorm", G.jokers, nil, nil, nil, nil, "j_brainstorm")
					new_card:add_to_deck()
					G.jokers:emplace(new_card)
				end
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "jimboprinter",
	atlas = "Jokers",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 2,
		y = 0,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_joker
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				local new_card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_joker")
				new_card:set_edition({
					negative = true,
				}, true)
				new_card:add_to_deck()
				G.jokers:emplace(new_card)
			else
				if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
					local new_card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_joker")
					new_card:add_to_deck()
					G.jokers:emplace(new_card)
				end
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "grossprinter",
	atlas = "Jokers",
	rarity = "crv_p",

	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 0,
		y = 1,
	},
	config = {
		extra = {
			odds = 100,
			odds2 = 1011,
			odds3 = 50,
		},
	},
	pools = {
		Food = true,
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_gros_michel
		info_queue[#info_queue + 1] = G.P_CENTERS.j_cavendish
		info_queue[#info_queue + 1] = G.P_CENTERS.j_crv_holybanana
		info_queue[#info_queue + 1] = G.P_CENTERS.j_crv_pedro
		return {
			vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.odds2 },
		}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if RevosVault.config.secret_enabled then
			if context.end_of_round and context.main_eval and not context.blueprint then
				if pseudorandom("grossprinter") < 1 / crv.odds3 then
					card:juice_up(0.3, 0.4)
					card:set_ability("j_crv_sgrossprinter")
				end
			end
		end
		if
			context.setting_blind
			and pseudorandom("grossprinter") < G.GAME.probabilities.normal / card.ability.extra.odds
			and G.GAME.used_vouchers["v_crv_printerup"] == true
		then
			local new_card = create_card("Cavendish", G.jokers, nil, nil, nil, nil, "j_cavendish")
			new_card:add_to_deck()
			new_card:set_edition({ negative = true }, true)
			G.jokers:emplace(new_card)
		elseif
			context.setting_blind
				and pseudorandom("grossprinter") < G.GAME.probabilities.normal / card.ability.extra.odds
				and #G.jokers.cards < G.jokers.config.card_limit
			or self.area == G.jokers
		then
			local new_card = create_card("Cavendish", G.jokers, nil, nil, nil, nil, "j_cavendish")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		elseif context.setting_blind and G.GAME.used_vouchers["v_crv_printerup"] == true then
			local new_card = create_card("Gros Michel", G.jokers, nil, nil, nil, nil, "j_gros_michel")
			new_card:add_to_deck()
			new_card:set_edition({ negative = true }, true)
			G.jokers:emplace(new_card)
		elseif context.setting_blind and #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
			local new_card = create_card("Gros Michel", G.jokers, nil, nil, nil, nil, "j_gros_michel")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		end
		if
			context.setting_blind
			and pseudorandom("grossprinter") < G.GAME.probabilities.normal / card.ability.extra.odds2
			and G.GAME.used_vouchers["v_crv_printerup"] == true
		then
			local new_card = create_card("Holy Banana", G.jokers, nil, nil, nil, nil, "j_crv_holybanana")
			new_card:add_to_deck()
			new_card:set_edition({ negative = true }, true)
			G.jokers:emplace(new_card)
		elseif
			context.setting_blind
				and pseudorandom("grossprinter") < G.GAME.probabilities.normal / card.ability.extra.odds2
				and #G.jokers.cards < G.jokers.config.card_limit
			or self.area == G.jokers
		then
			local new_card = create_card("Holy Banana", G.jokers, nil, nil, nil, nil, "j_crv_holybanana")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		end
		if
			G.GAME.pool_flags.holybanana_extinct == true
			and context.setting_blind
			and not (#SMODS.find_card("j_crv_pedro") >= 1)
			and G.GAME.used_vouchers["v_crv_printerup"] == true
		then
			local new_card = create_card("Pedro", G.jokers, nil, nil, nil, nil, "j_crv_pedro")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		elseif
			G.GAME.pool_flags.holybanana_extinct == true
			and context.setting_blind
			and not (#SMODS.find_card("j_crv_pedro") >= 1)
		then
			local new_card = create_card("Pedro", G.jokers, nil, nil, nil, nil, "j_crv_pedro")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "obeliskprinter",
	atlas = "Jokers",
	rarity = "crv_p",

	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 1,
		y = 1,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_obelisk
	end,
	calculate = function(self, card, context)
		if context.setting_blind and G.GAME.used_vouchers["v_crv_printerup"] == true then
			local new_card = create_card("Obelisk", G.jokers, nil, nil, nil, nil, "j_obelisk")
			new_card:set_edition({
				negative = true,
			}, true)
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		elseif context.setting_blind and #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
			local new_card = create_card("Obelisk", G.jokers, nil, nil, nil, nil, "j_obelisk")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "moneyprinter",
	atlas = "Jokers",
	rarity = "crv_p",

	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 2,
		y = 1,
	},
	config = {
		extra = {},
	},

	in_pool = function(self, wawa, wawa2)
		return true
	end,

	calc_dollar_bonus = function(self, card)
		return 35
	end,
})

SMODS.Joker({
	key = "brokenprinter",
	atlas = "Jokers",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 0,
		y = 2,
	},
	config = {
		extra = {},
	},
	calculate = function(self, card, context)
		if context.setting_blind then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				SMODS.add_card({
					set = "Joker",
					area = G.jokers,
					edition = "e_negative",
				})
			else
				if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
					SMODS.add_card({
						set = "Joker",
						area = G.jokers,
					})
				end
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "faxprinter",
	config = {
		extra = {
			odds = 4,
		},
	},
	discovered = false,
	unlocked = true,
	rarity = "crv_p",
	atlas = "Jokers",
	blueprint_compat = true,
	pos = {
		x = 1,
		y = 2,
	},
	cost = 10,
	eternal_compat = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_crv_pprwork
		return {
			vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			if pseudorandom("faxprinter") < G.GAME.probabilities.normal / card.ability.extra.odds then
				if
					G.GAME.used_vouchers["v_crv_printerup"] == true
						and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
					or G.GAME.used_vouchers["v_crv_printeruptier"] == true
				then
					local new_card = create_card("Paper Work", G.jokers, nil, nil, nil, nil, "j_crv_pprwork")
					new_card:add_to_deck()
					new_card:set_edition({ negative = true }, true)
					G.jokers:emplace(new_card)
				else
					if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
						local new_card = create_card("Paper Work", G.jokers, nil, nil, nil, nil, "j_crv_pprwork")
						new_card:add_to_deck()
						G.jokers:emplace(new_card)
					end
				end
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "spectralprinter",
	atlas = "Jokers",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 0,
		y = 3,
	},
	config = {
		extra = {},
	},
	calculate = function(self, card, context)
		if context.setting_blind then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				SMODS.add_card({
					set = "Spectral",
					area = G.consumeables,
					edition = "e_negative",
				})
			else
				if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then
					SMODS.add_card({
						set = "Spectral",
						area = G.consumeables,
					})
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "glassprinter",
	atlas = "Jokers",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 2,
		y = 3,
	},
	config = {
		extra = {
			odds = 16,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_bulletproofglass
		return {
			vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			if
				pseudorandom("glassprinter") < G.GAME.probabilities.normal / card.ability.extra.odds
				and G.GAME.used_vouchers["v_crv_printerup"] == true
			then
				RevosVault.printer_apply("m_glass", "m_crv_bulletproofglass", nil)
				G.consumeables:emplace(new_card)
				G.E_MANAGER:add_event(Event({
					func = function()
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							func = function()
								G.jokers:remove_card(card)
								card:shatter()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
			else
				RevosVault.printer_apply("m_glass", "m_crv_bulletproofglass", nil)
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "steelprinter",
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 1,
		y = 0,
	},
	config = {
		extra = {
			xmult = 1.5,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_diamondcard
		return {
			vars = { card.ability.extra.xmult, (G.GAME.probabilities.normal or 1) },
		}
	end,
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			RevosVault.printer_apply("m_steel", "m_crv_diamondcard", nil)
		end
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "smile",
	atlas = "Jokers",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 3,
		y = 0,
	},
	config = {
		extra = {
			odds = 3,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_photograph
		return {
			vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	calculate = function(self, card, context)
		if
			(#SMODS.find_card("j_joker") > 0)
			and context.setting_blind
			and pseudorandom("smile") < G.GAME.probabilities.normal / card.ability.extra.odds
		then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				local new_card = create_card("Photograph", G.jokers, nil, nil, nil, nil, "j_photograph")
				new_card:add_to_deck()
				new_card:set_edition({ negative = true }, true)
				G.jokers:emplace(new_card)
			else
				if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
					local new_card = create_card("Photograph", G.jokers, nil, nil, nil, nil, "j_photograph")
					new_card:add_to_deck()
					G.jokers:emplace(new_card)
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "lpm",
	atlas = "Jokers",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 3,
		y = 1,
	},
	config = {
		extra = {
			mult = 0,
			mult_gain = 15,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.mult, card.ability.extra.mult_gain },
		}
	end,
	calculate = function(self, card, context)
		if context.reroll_shop then
			local lpmcc = pseudorandom_element(lpmc, pseudoseed("lpm"))
			if lpmcc == 1 then
				if
					G.GAME.used_vouchers["v_crv_printerup"] == true
						and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
					or G.GAME.used_vouchers["v_crv_printeruptier"] == true
				then
					local scrapselect = pseudorandom_element(scrapselecta, pseudoseed("lpm"))
					if G.GAME.jojo then
						if scrapselect == 1 then
							SMODS.add_card({
								area = G.consumeables,
								set = "scrap",
								edition = "e_negative",
							})
						else
							SMODS.add_card({
								area = G.consumeables,
								set = "jojo_Scraps",
								edition = "e_negative",
							})
						end
					else
						SMODS.add_card({
							area = G.consumeables,
							set = "scrap",
							edition = "e_negative",
						})
					end
				else
					if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then
						local scrapselect = pseudorandom_element(scrapselecta, pseudoseed("lpm"))
						if G.GAME.jojo then
							if scrapselect == 1 then
								SMODS.add_card({
									area = G.consumeables,
									set = "scrap",
								})
							else
								SMODS.add_card({
									area = G.consumeables,
									set = "jojo_Scraps",
								})
							end
						else
							SMODS.add_card({
								area = G.consumeables,
								set = "scrap",
							})
						end
					end
				end
			end
		end
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize({
					type = "variable",
					key = "a_mult",
					vars = { card.ability.extra.mult },
				}),
			}
		end
		if context.using_consumeable then
			if G.GAME.jojo then
				if
					context.consumeable.ability.set == "jojo_Scraps"
					or context.consumeable.ability.set == "scrap" and not context.blueprint
				then
					card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
					return {
						message = localize("k_crv_cbm_ex"),
						delay = 1.3,
					}
				end
			else
				if context.consumeable.ability.set == "scrap" and not context.blueprint then
					card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
					return {
						message = localize("k_crv_cbm_ex"),
						delay = 1.3,
					}
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "devilishprinter",
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 0,
		y = 0,
	},
	config = {
		extra = {
			odds = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_mugged
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_aflame
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_soulcard
		return {
			vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			local imsobored = pseudorandom_element({ 1, 2 })
			if imsobored == 1 then
				RevosVault.printer_apply("m_crv_mugged", "m_crv_soulcard", nil)
			else
				RevosVault.printer_apply("m_crv_aflame", "m_crv_soulcard", nil)
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "head",
	atlas = "megaprinter",
	rarity = "crv_p",
	no_printer_list = true,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 0,
		y = 0,
	},
	config = {
		extra = {
			mult = 25,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.mult },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize({
					type = "variable",
					key = "a_mult",
					vars = { card.ability.extra.mult },
				}),
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "body",
	atlas = "megaprinter",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	no_printer_list = true,
	pos = {
		x = 1,
		y = 0,
	},
	config = {
		extra = {
			mult = 30,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.mult },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize({
					type = "variable",
					key = "a_mult",
					vars = { card.ability.extra.mult },
				}),
			}
		end
	end,
	update = function(self, card, context)
		if card.area == G.jokers then
			local megap = {}
			local rr
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					rr = i
				end
			end
			if
				(G.jokers.cards[rr - 1] ~= nil and G.jokers.cards[rr - 1].config.center.key == "j_crv_head")
				and (G.jokers.cards[rr + 1] ~= nil and G.jokers.cards[rr + 1].config.center.key == "j_crv_back")
				and not card.fusion
			then
				table.insert(megap, G.jokers.cards[rr + 1])
				table.insert(megap, G.jokers.cards[rr - 1])
				table.insert(megap, G.jokers.cards[rr])
				card.fusion = true
                check_for_unlock({type = "megaify"})
				SMODS.destroy_cards(megap)
				SMODS.add_card({
					key = "j_crv_full",
				})
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "back",
	atlas = "megaprinter",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	no_printer_list = true,
	pos = {
		x = 2,
		y = 0,
	},
	config = {
		extra = {
			mult = 25,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.mult },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize({
					type = "variable",
					key = "a_mult",
					vars = { card.ability.extra.mult },
				}),
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "full",
	atlas = "megaprinterc",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	no_collection = true,
	yes_printer_list = true,
	display_size = {
		w = 172,
		h = 95,
	},
	pos = {
		x = 0,
		y = 0,
	},
	config = {
		extra = {
			mult = 10,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_mega
		return {
			vars = { card.ability.extra.mult, (G.GAME.probabilities.normal or 1) },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.mult,
			}
		end
		if context.first_hand_drawn then
			RevosVault.printer_apply("m_crv_mega")
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Joker({
	key = "tierp",
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 2,
		y = 0,
	},
	config = {
		extra = {
			timer = 0,
			timer2 = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_tier1card
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_tier2card
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_tier3card
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_boostcard
		return {
			vars = { card.ability.extra.timer, card.ability.extra.timer2 },
		}
	end,
	calculate = function(self, card, context)
		if context.first_hand_drawn and card.ability.extra.timer2 < 5 then
			if card.ability.extra.timer >= 15 then
				RevosVault.printer_apply("m_crv_tier3card")
			elseif (card.ability.extra.timer >= 5) and (card.ability.extra.timer < 15) then
				RevosVault.printer_apply("m_crv_tier2card")
			else
				RevosVault.printer_apply("m_crv_tier1card")
			end
		end
		if
			context.end_of_round
			and not context.repetition
			and not context.individual
			and not (card.ability.extra.timer == 15)
			and not context.blueprint
		then
			card.ability.extra.timer = card.ability.extra.timer + 1
		end
		if
			context.end_of_round
			and not context.repetition
			and not context.individual
			and (card.ability.extra.timer == 15)
			and not (card.ability.extra.timer2 == 5)
			and not context.blueprint
		then
			card.ability.extra.timer2 = card.ability.extra.timer2 + 1
		end
		if context.first_hand_drawn and (card.ability.extra.timer2 == 5) then
			RevosVault.printer_apply("m_crv_boostcard")
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "luckyprinter",
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 0,
		y = 1,
	},
	config = {
		extra = {
			odds = 4,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_blessedcard
		return {
			vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			RevosVault.printer_apply("m_lucky", "m_crv_blessedcard", nil)
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "celestialprinter",
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 1,
		y = 1,
	},
	config = {
		extra = {},
	},
	calculate = function(self, card, context)
		if context.setting_blind then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				SMODS.add_card({
					set = "Planet",
					area = G.consumeables,
					edition = "e_negative",
				})
			else
				if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then
					SMODS.add_card({
						set = "Planet",
						area = G.consumeables,
					})
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "pcp",
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
		return {
			vars = { card.ability.extra.xmult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 2,
		y = 4,
	},
	config = {
		extra = {
			xmult = 1.5,
			odds = 4,
		},
	},

	calculate = function(self, card, context)
		if context.first_hand_drawn then
			if pseudorandom("ucp") < G.GAME.probabilities.normal / card.ability.extra.odds then
				RevosVault.printer_apply(nil, nil, "e_polychrome", G.jokers)
			else
				RevosVault.printer_apply(nil, nil, "e_polychrome")
			end
		end
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader("polychrome", nil, card.ARGS.send_to_shader)
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "fcp",
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
		return {
			vars = { card.ability.extra.chips, (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 0,
		y = 4,
	},
	config = {
		extra = {
			chips = 50,
			odds = 4,
		},
	},

	calculate = function(self, card, context)
		if context.first_hand_drawn then
			if pseudorandom("ucp") < G.GAME.probabilities.normal / card.ability.extra.odds then
				RevosVault.printer_apply(nil, nil, "e_foil", G.jokers)
			else
				RevosVault.printer_apply(nil, nil, "e_foil")
			end
		end
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader("foil", nil, card.ARGS.send_to_shader)
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "hcp",
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
		return {
			vars = { card.ability.extra.mult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 1,
		y = 4,
	},
	config = {
		extra = {
			mult = 10,
			odds = 4,
		},
	},

	calculate = function(self, card, context)
		if context.first_hand_drawn then
			if pseudorandom("ucp") < G.GAME.probabilities.normal / card.ability.extra.odds then
				RevosVault.printer_apply(nil, nil, "e_holo", G.jokers)
			else
				RevosVault.printer_apply(nil, nil, "e_holo")
			end
		end
		if context.joker_main then
			return {
				mult = card.ability.extra.mult,
			}
		end
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader("holo", nil, card.ARGS.send_to_shader)
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "ncp",
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		return {
			vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 3,
		y = 4,
	},
	config = {
		extra = {
			odds = 4,
		},
	},

	calculate = function(self, card, context)
		if context.first_hand_drawn then
			if pseudorandom("ucp") < G.GAME.probabilities.normal / card.ability.extra.odds then
				RevosVault.printer_apply(nil, nil, "e_negative", G.jokers)
			else
				RevosVault.printer_apply(nil, nil, "e_negative")
			end
		end
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader("negative", nil, card.ARGS.send_to_shader)
		card.children.center:draw_shader("negative_shine", nil, card.ARGS.send_to_shader)
	end,
	add_to_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit + 1
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - 1
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "ucp",
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_boost
		return {
			vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 4,
		y = 6,
	},
	config = {
		extra = {
			odds = 4,
		},
	},

	calculate = function(self, card, context)
		if context.first_hand_drawn then
			if pseudorandom("ucp") < G.GAME.probabilities.normal / card.ability.extra.odds then
				RevosVault.printer_apply(nil, nil, poll_edition("ucp", nil, false, true), G.jokers)
			else
				RevosVault.printer_apply(nil, nil, poll_edition("ucp", nil, false, true))
			end
		end
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader("polychrome", nil, card.ARGS.send_to_shader)
		card.children.center:draw_shader("negative_shine", nil, card.ARGS.send_to_shader)
	end,
})

SMODS.Joker({
	key = "urp",
	config = {
		extra = {
			one = 0,
		},
	},
	rarity = "crv_p",
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 3,
		y = 1,
	},
	cost = 10,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and #G.jokers.cards > 1 and (card.ability.extra.one == 0) then
			local rr = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					rr = i
					break
				end
			end
			if G.jokers.cards[rr + 1] ~= nil then
				if
					G.GAME.used_vouchers["v_crv_printerup"] == true
						and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
					or G.GAME.used_vouchers["v_crv_printeruptier"] == true
				then
					G.E_MANAGER:add_event(Event({
						func = function()
							local card2 = copy_card(G.jokers.cards[rr + 1], nil, nil, G.jokers.cards[i] == card)
							card2:add_to_deck()
							card2:set_edition({ negative = true }, true)
							G.jokers:emplace(card2)
							return true
						end,
					}))
				else
					if G.jokers.cards[rr + 1].edition and G.jokers.cards[rr + 1].edition.negative then
						G.E_MANAGER:add_event(Event({
							func = function()
								local card2 = copy_card(G.jokers.cards[rr + 1], nil, nil, G.jokers.cards[i] == card)
								card2:add_to_deck()
								G.jokers:emplace(card2)
								return true
							end,
						}))
					else
						if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
							G.E_MANAGER:add_event(Event({
								func = function()
									local card2 = copy_card(G.jokers.cards[rr + 1])
									card2:add_to_deck()
									G.jokers:emplace(card2)
									return true
								end,
							}))
						end
					end
				end

				if rr and G.jokers.cards[rr + 1] then
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "3dp",
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 9,
		y = 6,
	},
	config = {
		extra = {},
	},

	calculate = function(self, card, context)
		if context.starting_shop and not context.blueprint then
			RevosVault.create_booster(pseudorandom_element(G.P_CENTER_POOLS.Booster).key)
		end
	end,
})

SMODS.Joker({
	key = "printerprinter",
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 4,
		y = 10,
	},
	config = {
		extra = {
			mult = 4,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.mult },
		}
	end,

	calculate = function(self, card, context)
		if context.setting_blind then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				SMODS.add_card({
					set = "Joker",
					rarity = "crv_p",
					edition = "e_negative",
				})
			else
				if #G.jokers.cards < G.jokers.config.card_limit then
					SMODS.add_card({
					set = "Joker",
					rarity = "crv_p",
				})
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})
--[[ Not even correct yet
SMODS.Joker({
	key = "cosmicprinter",
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = {
		x = 10,
		y = 9,
	},
	config = {
		extra = {
			mult = 4,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.mult },
		}
	end,

	calculate = function(self, card, context)
		if context.setting_blind then
			SMODS.add_card{
				set = "Joker",
				rarity = "crv_p"
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})
]]

SMODS.Joker({
	key = "foodprinter",
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 1,
		y = 10,
	},
	config = {
		extra = {
			mult = 4,
		},
	},
	pools = {
		Food = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.mult },
		}
	end,

	calculate = function(self, card, context)
		if context.setting_blind then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				SMODS.add_card({
					set = "Food",
					edition = "e_negative",
				})
			elseif #G.jokers.cards < G.jokers.config.card_limit then
				SMODS.add_card({
					set = "Food",
				})
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "rprinter",
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 5,
		y = 11,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,

	calculate = function(self, card, context)
		if context.setting_blind then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				SMODS.add_card({
					area = G.consumeables,
					key = "c_crv_heart",
					edition = "e_negative",
				})
			elseif #G.consumeables.cards < G.consumeables.config.card_limit then
				SMODS.add_card({
					area = G.consumeables,
					key = "c_crv_heart",
				})
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "supprinter",
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 5,
		y = 12,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,

	calculate = function(self, card, context)
		if context.setting_blind then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				SMODS.add_card({
					area = G.consumeables,
					key = pseudorandom_element(G.P_CENTER_POOLS.Superior).key,
					edition = "e_negative",
				})
			elseif #G.consumeables.cards < G.consumeables.config.card_limit then
				SMODS.add_card({
					area = G.consumeables,
					key = pseudorandom_element(G.P_CENTER_POOLS.Superior).key,
				})
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Joker({
	key = "voucher_printer",
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 7,
		y = 13,
	},
	config = {
		extra = {
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			RevosVault.random_voucher()
		end
	end
})


SMODS.Joker({
	key = "modded_printer",
	atlas = "Jokers2",
	rarity = "crv_p",
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 10,
		y = 12,
	},
	config = {
		extra = {
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {(RevosVault.other_mod_display or "Revos Vault"), (RevosVault.other_type or "Joker") },
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			if RevosVault.other_type ~= "Voucher" then
			SMODS.add_card({
				key = RevosVault.other_card
			})
		else
			RevosVault.random_voucher(RevosVault.other_mod)
		end
	end
	end,
})

SMODS.Joker({
	key = "legendaryprinter",
	atlas = "Jokers",
	rarity = 4,
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 1,
		y = 3,
	},
	soul_pos = {
		x = 3,
		y = 3,
	},
	config = {
		extra = {
			odds = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			if pseudorandom("legendaryprinter") < G.GAME.probabilities.normal / card.ability.extra.odds then
				local c = SMODS.add_card({
					set = "Joker",
					area = G.jokers,
					legendary = true,
					edition = "e_negative",
				})
				c:add_sticker("perishable", true)
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

