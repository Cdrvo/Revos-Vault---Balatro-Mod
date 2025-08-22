SMODS.Rarity({
	key = "p",
	badge_colour = G.C.RARITY[3],
	pools = {
		["Joker"] = {
			rate = 0.01,
		},
	},
	default_weight = 0.01,
})

SMODS.Rarity({
	key = "holy",
	badge_colour = G.C.RARITY[2],
	pools = {},
})

SMODS.Rarity({
	key = "pedro",
	badge_colour = G.C.RARITY[3],
	pools = {},
})

SMODS.Rarity({
	key = "titan",
	badge_colour = G.C.RARITY[4],

	pools = {},
})

SMODS.Rarity({
	key = "secret",
	badge_colour = G.C.BLACK,
	pools = {},
})

SMODS.Joker({
	key = "revoo_",
	config = {
		extra = {
			xmult = 2,
		},
	},
	rarity = 4,
	atlas = "rev",
	blueprint_compat = false,
	discovered = false,
	pos = {
		x = 1,
		y = 0,
	},
	soul_pos = {
		x = 0,
		y = 0,
	},
	cost = 20,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 14 then
				return {
					xmult = card.ability.extra.xmult,
				}
			end
		end
	end,
})
SMODS.Joker({
	key = "spuzzypp",
	config = {
		extra = {
			chips = 50,
		},
	},
	rarity = 4,
	atlas = "rev",
	blueprint_compat = false,
	discovered = false,
	pos = {
		x = 1,
		y = 1,
	},
	soul_pos = {
		x = 0,
		y = 1,
	},
	cost = 20,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.chips },
		}
	end,
	calculate = function(self, card, context)
		if context.final_scoring_step and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				func = function()
					for k, v in ipairs(context.scoring_hand) do
						if v.ability.effect == "Base" then
							v:juice_up()
							v:set_ability(
								G.P_CENTERS[SMODS.poll_enhancement({
									guaranteed = true,
								})],
								true,
								false
							)
						end
					end
					return true
				end,
			}))
		end
	end,
})
local adamc = { 1, 2, 3 }
local lpmc = { 1, 2, 3, 4 }
local scrapselecta = { 1, 2 }

SMODS.Joker({
	key = "adam_",
	config = {
		extra = {
			xmult = 1,
			xmultg = 0.5,
			scrapc = 0,
		},
	},
	rarity = 4,
	atlas = "rev",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 1,
		y = 2,
	},
	soul_pos = {
		x = 0,
		y = 2,
	},
	cost = 20,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.xmultg, card.ability.extra.scrapc },
		}
	end,
	calculate = function(self, card, context)
		if context.reroll_shop then
			local adamcc = pseudorandom_element(adamc, pseudoseed("lpm"))
			if adamcc == 1 then
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
		if context.using_consumeable then
			if G.GAME.jojo then
				if
					context.consumeable.ability.set == "jojo_Scraps"
					or context.consumeable.ability.set == "scrap" and not context.blueprint
				then
					card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultg
					card.ability.extra.scrapc = card.ability.extra.scrapc + 1
				end
			else
				if context.consumeable.ability.set == "scrap" then
					card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultg
					card.ability.extra.scrapc = card.ability.extra.scrapc + 1
				end
			end
		end
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
		if card.ability.extra.scrapc == 5 then
			card.ability.extra.scrapc = 0
			SMODS.add_card({
				set = "Spectral",
				area = G.consumeables,
				edition = "e_negative",
				soulable = true,
			})
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "chainsawm",
	config = {
		extra = {
			xmult = 2,
			xmultg = 0.05,
		},
	},
	rarity = 4,
	atlas = "rev",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 1,
		y = 3,
	},
	soul_pos = {
		x = 0,
		y = 3,
	},
	cost = 20,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.xmultg },
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if
				not context.other_card:is_face()
				and context.other_card:get_id() ~= 14
				and not context.blueprint
				and not context.repetition
			then
				card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultg
				return {
					xmult = card.ability.extra.xmult,
				}
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "snayn3",
	config = {
		extra = {
			xmult = 3,
			timer = 0,
		},
	},
	rarity = 4,
	atlas = "rev",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 1,
		y = 4,
	},
	soul_pos = {
		x = 0,
		y = 4,
	},
	cost = 20,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.timer },
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.blueprint then
			card.ability.extra.timer = card.ability.extra.timer + 1
		end
		if card.ability.extra.timer > 5 then
			card.ability.extra.timer = 5
		end
		if context.joker_main and G.GAME.current_round.hands_left == 1 and card.ability.extra.timer == 5 then
			card.ability.extra.timer = 0
			card:juice_up(0.3, 0.4)
			card:set_ability("j_crv_snayn32")
			card_eval_status_text(card, "extra", nil, nil, nil, { message = localize("k_evolve_crv") })
		end
		if context.joker_main and not G.GAME.current_round.hands_left == 1 then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
	end,
})

SMODS.Joker({
	key = "snayn32",
	config = {
		extra = {
			xmult = 20,
		},
	},
	rarity = "crv_titan",
	atlas = "rev",
	blueprint_compat = true,
	discovered = false,
	no_collection = true,
	pos = {
		x = 1,
		y = 5,
	},
	soul_pos = {
		x = 0,
		y = 5,
	},
	cost = 25,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
		if context.end_of_round and context.main_eval then
			card:juice_up(0.3, 0.4)
			card:set_ability("j_crv_snayn3")
		end
	end,
})

SMODS.Joker({
	key = "_pease",
	config = {
		extra = {
			xmult = 1.5,
			xmultg = 0.5,
		},
	},
	rarity = 4,
	atlas = "rev",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 3,
		y = 0,
	},
	soul_pos = {
		x = 2,
		y = 0,
	},
	cost = 20,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.xmultg },
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 13 then
				if context.other_card.ability.effect == "Base" then
					context.other_card:set_ability(G.P_CENTERS["m_glass"])
				end
				return {
					x_mult = card.ability.extra.xmult,
					card = card.other_card,
				}
			end
		end
		if context.destroy_card and context.cardarea == G.play then
			if context.destroy_card:get_id() ~= 13 then
				if context.destroy_card:is_face() then
					card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultg
					return {
						remove = true,
						message = localize("k_upgrade_ex"),
					}
				end
			end
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
	end,
})

SMODS.Joker({
	key = "holybanana",
	config = {
		extra = {
			xmult = 4011,
			chips = 4011,
			odds = 4011,
		},
	},
	rarity = "crv_holy",
	atlas = "holybanana",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 0,
		y = 0,
	},
	soul_pos = {
		x = 1,
		y = 0,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult,
				card.ability.extra.chips,
				(G.GAME.probabilities.normal or 1),
				card.ability.extra.odds,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
				chips = card.ability.extra.chips,
			}
		end
		if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
			if pseudorandom("holybanana") < G.GAME.probabilities.normal / card.ability.extra.odds then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
				G.GAME.pool_flags.holybanana_extinct = true
				return {
					message = localize("k_crv_std_ex"),
					delay(0.6),
				}
			else
				return {
					message = localize("k_crv_sbg_ex"),
					delay(0.6),
				}
			end
		end
	end,
})
SMODS.Joker({
	key = "pedro",
	config = {
		extra = {
			xmult = 42831398,
			chips = 42831398,
		},
	},
	rarity = "crv_pedro",
	atlas = "pedro",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 0,
		y = 0,
	},
	soul_pos = {
		x = 1,
		y = 0,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.chips },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
				chips = card.ability.extra.chips,
			}
		end
	end,
})

local cardtomake = { 1, 2, 3 }

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
	key = "pprwork",
	config = {
		extra = {
			chips = 20.4,
			mult = 9.8,
		},
	},
	rarity = 2,
	atlas = "Jokers",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 2,
		y = 2,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.chips, card.ability.extra.mult },
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() >= 2 and context.other_card:get_id() <= 9 then
				return {
					chips = card.ability.extra.chips,
					mult = card.ability.extra.mult,
					card = card.other_card,
				}
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return false
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
				SMODS.add_card({
					set = "Joker",
					area = G.jokers,
					legendary = true,
					edition = "e_negative",
					stickers = { "perishable" },
				})
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return false
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
		info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_glassdocument
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
		info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_steeldocument
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
		info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_devilscontract
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
		info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_megadoc
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
		info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_luckydocument
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
		info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_polydoc
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
		info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_foildoc
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
		info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_holdoc
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
		info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_uedoc
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
			SMODS.add_card({
				set = "Joker",
				rarity = "crv_p",
			})
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
			else
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
			else
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
			else
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

--printers end here [PEP]

SMODS.Joker({
	key = "ghostbanana",
	atlas = "gb",
	rarity = 3,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	perishable_compat = false,
	pos = {
		x = 0,
		y = 0,
	},
	config = {
		extra = {
			chips = 100,
		},
	},
	pools = {
		Food = true,
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_crv_ghostslices
		return {
			vars = { card.ability.extra.chips },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
			}
		end
		if context.setting_blind and #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
			local new_card = create_card("Ghost Slices", G.jokers, nil, nil, nil, nil, "j_crv_ghostslices")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "ghostslices",
	atlas = "gb",
	rarity = 1,
	cost = 1,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	perishable_compat = false,
	pos = {
		x = 1,
		y = 0,
	},
	config = {
		extra = {
			chips = 50,
		},
	},
	pools = {
		Food = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.chips },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Joker({
	key = "plantain",
	atlas = "gban",
	no_pool_flag = "pex",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	perishable_compat = false,
	pos = {
		x = 1,
		y = 0,
	},
	config = {
		extra = {
			timer = 0,
			xmult = 2,
			odds = 12,
		},
	},
	pools = {
		Food = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.timer,
				card.ability.extra.xmult,
				(G.GAME.probabilities.normal or 1),
				card.ability.extra.odds,
			},
		}
	end,
	calculate = function(self, card, context)
		if
			context.end_of_round
			and not context.repetition
			and not context.individual
			and not (card.ability.extra.timer == 3)
		then
			card.ability.extra.timer = card.ability.extra.timer + 1
		end
		if context.joker_main and card.ability.extra.timer == 3 then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
		if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
			if card.ability.extra.timer == 3 then
				if
					pseudorandom("plantin") < G.GAME.probabilities.normal / card.ability.extra.odds
					and not context.blueprint
				then
					G.E_MANAGER:add_event(Event({
						func = function()
							play_sound("tarot1")
							card.T.r = -0.2
							card:juice_up(0.3, 0.4)
							card.states.drag.is = true
							card.children.center.pinch.x = true
							G.E_MANAGER:add_event(Event({
								trigger = "after",
								delay = 0.3,
								blockable = false,
								func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
									return true
								end,
							}))
							return true
						end,
					}))
					G.GAME.pool_flags.pex = true
					return {
						message = localize("k_extinct_ex"),
						delay(0.6),
					}
				else
					return {
						message = localize("k_safe_ex"),
						delay(0.6),
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
	key = "reban",
	atlas = "gban",
	no_pool_flag = "rex",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	perishable_compat = false,
	pos = {
		x = 0,
		y = 0,
	},
	config = {
		extra = {
			mult = 30,
			odds = 8,
		},
	},
	pools = {
		Food = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.mult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.extra.mult,
			}
		end
		if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
			if
				pseudorandom("reban") < G.GAME.probabilities.normal / card.ability.extra.odds and not context.blueprint
			then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
				G.GAME.pool_flags.rex = true
				return {
					message = localize("k_extinct_ex"),
					delay(0.6),
				}
			else
				return {
					message = localize("k_safe_ex"),
					delay(0.6),
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "tundan",
	atlas = "gban",
	no_pool_flag = "lex",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	perishable_compat = false,
	pos = {
		x = 2,
		y = 0,
	},
	config = {
		extra = {
			chips = 0,
			odds = 8,
			chip_gain = 15,
		},
	},
	pools = {
		Food = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips,
				(G.GAME.probabilities.normal or 1),
				card.ability.extra.odds,
				card.ability.extra.chip_gain,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
			}
		end
		if
			context.end_of_round
			and not context.repetition
			and not context.blueprint
			and not context.individual
			and not (#SMODS.find_card("j_gros_michel") >= 1)
		then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
			return {
				message = localize("k_upgrade_ex"),
				colour = G.C.CHIPS,
				card = card,
			}
		end
		if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
			if
				pseudorandom("tundan") < G.GAME.probabilities.normal / card.ability.extra.odds
				and not context.blueprint
			then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
				G.GAME.pool_flags.lex = true
				return {
					message = localize("k_extinct_ex"),
					delay(0.6),
				}
			else
				return {
					message = localize("k_safe_ex"),
					delay(0.6),
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "bluj",
	atlas = "gban",
	no_pool_flag = "bex",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	perishable_compat = false,
	pos = {
		x = 0,
		y = 1,
	},
	config = {
		extra = {
			mult = 25,
			mult_r = 1,
		},
	},
	pools = {
		Food = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.mult, card.ability.extra.mult_r },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.extra.mult,
			}
		end
		if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
			if not (card.ability.extra.mult == 1) then
				card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_r
				return {
					message = localize("k_crv_yum"),
					colour = G.C.MULT,
					card = card,
				}
			else
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
				G.GAME.pool_flags.bex = true
				return {
					message = localize("k_crv_eaten_ex"),
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "bananavine",
	atlas = "gban",
	no_pool_flag = "gex",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	perishable_compat = false,
	pos = {
		x = 1,
		y = 1,
	},
	pools = {
		Food = true,
	},
	config = {
		extra = {
			timer = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_gros_michel
		return {
			vars = { card.ability.extra.timer },
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint and not context.repetition and not context.individual then
			if card.ability.extra.timer < 3 then
				card.ability.extra.timer = card.ability.extra.timer + 1
				local new_card = create_card("Gros Michel", G.jokers, nil, nil, nil, nil, "j_gros_michel")
				new_card:add_to_deck()
				G.jokers:emplace(new_card)
			end
			if context.setting_blind and (card.ability.extra.timer == 3) then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
				G.GAME.pool_flags.gex = true
				return {
					message = localize("k_crv_ofb_ex"),
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "plainb",
	atlas = "gban",
	no_pool_flag = "pex2",
	rarity = 3,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	perishable_compat = false,
	pos = {
		x = 2,
		y = 1,
	},
	pools = {
		Food = true,
	},
	config = {
		extra = {
			extra_value = 3,
			odds = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.extra_value, (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			if
				pseudorandom("plainb") < G.GAME.probabilities.normal / card.ability.extra.odds
				and not context.blueprint
			then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
				G.GAME.pool_flags.pex2 = true
				return {
					message = localize("k_extinct_ex"),
					delay(0.6),
				}
			else
				card.ability.extra_value = card.ability.extra_value + 15
				card:set_cost()
				return {
					message = localize("k_val_up"),
					delay(0.6),
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "tickingb",
	atlas = "gban",
	no_pool_flag = "tex",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	perishable_compat = false,
	pos = {
		x = 1,
		y = 2,
	},
	config = {
		extra = {
			xmult = 15,
			timer = 0,
		},
	},
	pools = {
		Food = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.timer },
		}
	end,
	calculate = function(self, card, context)
		if
			context.end_of_round
			and not context.repetition
			and not context.individual
			and not (card.ability.extra.timer == 3)
			and not context.blueprint
		then
			card.ability.extra.timer = card.ability.extra.timer + 1
		end
		if context.joker_main then
			if card.ability.extra.timer == 3 then
				return {
					x_mult = card.ability.extra.xmult,
				},
					G.E_MANAGER:add_event(Event({
						func = function()
							play_sound("tarot1")
							card.T.r = -0.2
							card:juice_up(0.3, 0.4)
							card.states.drag.is = true
							card.children.center.pinch.x = true
							G.E_MANAGER:add_event(Event({
								trigger = "after",
								delay = 1.5,
								blockable = false,
								func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
									return true
								end,
							}))
							G.GAME.pool_flags.tex = true
							return true
						end,
					}))
			end
		end
	end,
})
local rkeys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }
local rkeyshalf = { "1", "2", "3", "4", "5" }
SMODS.Joker({
	key = "uneasyb",
	config = {
		extra = {
			xmult = 15,
		},
	},
	pools = {
		Food = true,
	},
	rarity = 2,
	atlas = "gban",
	blueprint_compat = false,
	discovered = false,

	pos = {
		x = 0,
		y = 2,
	},
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
		if context.setting_blind and not context.blueprint and card.ability.canactivate then
			local random_key = rkeys[math.random(#rkeys)]
			if (random_key == "5") and not context.repetition and not context.individual then
				G.STATE = G.STATES.GAME_OVER
				G.STATE_COMPLETE = false
			end
		elseif context.setting_blind and not context.blueprint and not card.ability.canactivate then
			card.ability.canactivate = true
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "bananatemp",
	atlas = "gban",
	no_pool_flag = "btex",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	perishable_compat = false,
	pos = {
		x = 2,
		y = 2,
	},
	config = {
		extra = {
			timer = 0,
			odds = 8,
		},
	},
	pools = {
		Food = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.timer },
		}
	end,
	calculate = function(self, card, context)
		if
			context.end_of_round
			and not context.repetition
			and not context.individual
			and not (card.ability.extra.timer == 3)
			and not context.blueprint
		then
			card.ability.extra.timer = card.ability.extra.timer + 1
		end
		if context.setting_blind and not context.blueprint and not context.repetition then
			if card.ability.extra.timer == 3 then
				card:start_dissolve({ HEX("57ecab") }, nil, 0.1)
				SMODS.add_card({
					set = "BananaPool",
				})
			end
		end
	end,
})

SMODS.Joker({
	key = "doubleban",
	atlas = "gban",
	no_pool_flag = "dbex",
	rarity = 3,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	perishable_compat = false,
	pos = {
		x = 3,
		y = 2,
	},
	config = {
		extra = {
			repetitions = 2,
			odds = 8,
		},
	},
	pools = {
		Food = true,
		BananaPool = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.repetitions, card.ability.extra.odds, (G.GAME.probabilities.normal or 1) },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.retrigger_joker_check then
			return {
				repetitions = card.ability.extra.repetitions,
			}
		end
		if
			context.setting_blind
			and not context.blueprint
			and not context.repetition
			and pseudorandom("doubleban") < G.GAME.probabilities.normal / card.ability.extra.odds
		then
			card:start_dissolve({ HEX("57ecab") }, nil, 0.1)
			G.GAME.pool_flags.dbex = true
			for i = 1, 2 do
				SMODS.add_card({
					key = "j_cavendish",
					area = G.jokers,
				})
			end
		end
	end,
})

SMODS.Joker({
	key = "jimban",
	atlas = "gban",
	no_pool_flag = "jbex",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	perishable_compat = false,
	pos = {
		x = 3,
		y = 0,
	},
	config = {
		extra = {
			mult = 8,
			odds = 6,
		},
	},
	pools = {
		Food = true,
		BananaPool = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.mult, card.ability.extra.odds, (G.GAME.probabilities.normal or 1) },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main then
			return {
				mult = crv.mult,
			}
		end
		if
			context.end_of_round
			and not context.blueprint
			and context.main_eval
			and pseudorandom("jimban") < G.GAME.probabilities.normal / card.ability.extra.odds
		then
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card.T.r = -0.2
					card:juice_up(0.3, 0.4)
					card.states.drag.is = true
					card.children.center.pinch.x = true
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 1.5,
						blockable = false,
						func = function()
							G.jokers:remove_card(card)
							card:remove()
							card = nil
							return true
						end,
					}))
					G.GAME.pool_flags.jbex = true
					return true
				end,
			}))
		end
	end,
})

SMODS.Joker({
	key = "divineban",
	atlas = "gban",
	no_pool_flag = "dibex",
	rarity = 1,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	perishable_compat = false,
	pos = {
		x = 3,
		y = 1,
	},
	config = {
		extra = {
			dollars = 2,
			odds = 3,
		},
	},
	pools = {
		Food = true,
		BananaPool = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.dollars, (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if
			context.individual
			and context.cardarea == G.play
			and pseudorandom("divineban") < G.GAME.probabilities.normal / crv.odds
		then
			return {
				dollars = crv.dollars,
			}
		end
	end,
})

SMODS.Joker({
	key = "grosdish",
	atlas = "Jokers2",
	no_pool_flag = "groex",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	perishable_compat = false,
	pos = {
		x = 9,
		y = 11,
	},
	config = {
		extra = {
			chips = 30,
			odds = 6,
		},
	},
	pools = {
		Food = true,
		BananaPool = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.chips, (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main then
			return {
				chips = crv.chips,
			}
		end
		if
			context.end_of_round
			and not context.blueprint
			and context.main_eval
			and pseudorandom("grosdish") < G.GAME.probabilities.normal / card.ability.extra.odds
		then
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card.T.r = -0.2
					card:juice_up(0.3, 0.4)
					card.states.drag.is = true
					card.children.center.pinch.x = true
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 1.5,
						blockable = false,
						func = function()
							G.jokers:remove_card(card)
							card:remove()
							card = nil
							return true
						end,
					}))
					G.GAME.pool_flags.groex = true
					return true
				end,
			}))
			return {
				message = localize("k_extinct_ex"),
				delay(0.6),
			}
		end
	end,
})

SMODS.Joker({
	key = "cavicheal",
	atlas = "Jokers2",
	no_pool_flag = "cavex",
	yes_pool_flag = "groex",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	perishable_compat = false,
	pos = {
		x = 10,
		y = 11,
	},
	config = {
		extra = {
			xchips = 6,
			odds = 1000,
		},
	},
	pools = {
		Food = true,
		BananaPool = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xchips, (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main then
			return {
				xchips = crv.xchips,
			}
		end
		if
			context.end_of_round
			and not context.blueprint
			and context.main_eval
			and pseudorandom("cavicheal") < G.GAME.probabilities.normal / card.ability.extra.odds
		then
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card.T.r = -0.2
					card:juice_up(0.3, 0.4)
					card.states.drag.is = true
					card.children.center.pinch.x = true
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 1.5,
						blockable = false,
						func = function()
							G.jokers:remove_card(card)
							card:remove()
							card = nil
							return true
						end,
					}))
					G.GAME.pool_flags.cavex = true
					return true
				end,
			}))
			return {
				message = localize("k_extinct_ex"),
				delay(0.6),
			}
		end
	end,
})

SMODS.Joker({
	key = "bpj",
	config = {
		extra = {
			x_gain = 0.4,
			RevosVault.check_enhancement(G.playing_cards, "m_crv_bulletproofglass"),
		},
	},

	rarity = 2,
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 0,
		y = 2,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_bulletproofglass
		return {
			vars = {
				card.ability.extra.x_gain * RevosVault.check_enhancement(G.playing_cards, "m_crv_bulletproofglass") + 1,
				card.ability.extra.x_gain,
				RevosVault.check_enhancement(G.playing_cards, "m_crv_bulletproofglass"),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if RevosVault.check_enhancement(G.playing_cards, "m_crv_bulletproofglass") > 0 then
				return {
					x_mult = RevosVault.check_enhancement(G.playing_cards, "m_crv_bulletproofglass")
							* card.ability.extra.x_gain
						+ 1,
				}
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		if RevosVault.check_enhancement(G.playing_cards, "m_crv_bulletproofglass") > 0 then
			return true
		end
		return false
	end,
})

SMODS.Joker({
	key = "dcj",
	config = {
		extra = {
			x_gain = 0.3,
			RevosVault.check_enhancement(G.playing_cards, "m_crv_diamondcard"),
		},
	},
	rarity = 2,
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 2,
		y = 2,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_diamondcard
		return {
			vars = {
				card.ability.extra.x_gain * RevosVault.check_enhancement(G.playing_cards, "m_crv_diamondcard") + 1,
				card.ability.extra.x_gain,
				RevosVault.check_enhancement(G.playing_cards, "m_crv_diamondcard"),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if RevosVault.check_enhancement(G.playing_cards, "m_crv_diamondcard") > 0 then
				return {
					x_mult = RevosVault.check_enhancement(G.playing_cards, "m_crv_diamondcard")
							* card.ability.extra.x_gain
						+ 1,
				}
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		if RevosVault.check_enhancement(G.playing_cards, "m_crv_diamondcard") > 0 then
			return true
		end
		return false
	end,
})

SMODS.Joker({
	key = "mgj",
	config = {
		extra = {
			x_gain = 0.2,
			RevosVault.check_enhancement(G.playing_cards, "m_crv_mugged"),
		},
	},
	rarity = 2,
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 1,
		y = 3,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_mugged
		return {
			vars = {
				card.ability.extra.x_gain * RevosVault.check_enhancement(G.playing_cards, "m_crv_mugged") + 1,
				card.ability.extra.x_gain,
				RevosVault.check_enhancement(G.playing_cards, "m_crv_mugged"),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if RevosVault.check_enhancement(G.playing_cards, "m_crv_mugged") > 0 then
				return {
					x_mult = RevosVault.check_enhancement(G.playing_cards, "m_crv_mugged") * card.ability.extra.x_gain
						+ 1,
				}
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		if RevosVault.check_enhancement(G.playing_cards, "m_crv_mugged") > 0 then
			return true
		end
		return false
	end,
})

SMODS.Joker({
	key = "amj",
	config = {
		extra = {
			x_gain = 0.2,
			RevosVault.check_enhancement(G.playing_cards, "m_crv_aflame"),
		},
	},
	rarity = 2,
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 1,
		y = 2,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_aflame
		return {
			vars = {
				card.ability.extra.x_gain * RevosVault.check_enhancement(G.playing_cards, "m_crv_aflame") + 1,
				card.ability.extra.x_gain,
				RevosVault.check_enhancement(G.playing_cards, "m_crv_aflame"),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if RevosVault.check_enhancement(G.playing_cards, "m_crv_aflame") > 0 then
				return {
					x_mult = RevosVault.check_enhancement(G.playing_cards, "m_crv_aflame") * card.ability.extra.x_gain
						+ 1,
				}
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		if RevosVault.check_enhancement(G.playing_cards, "m_crv_aflame") > 0 then
			return true
		end
		return false
	end,
})

SMODS.Joker({
	key = "mj",
	config = {
		extra = {
			x_gain = 0.4,
			RevosVault.check_enhancement(G.playing_cards, "m_crv_mega"),
		},
	},
	rarity = 2,
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 2,
		y = 1,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		local RCM = RevosVault.check_enhancement(G.playing_cards, "m_crv_mega")
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_mega
		return {
			vars = { card.ability.extra.x_gain * RCM + 1, card.ability.extra.x_gain, RCM },
		}
	end,
	calculate = function(self, card, context)
		local RCM = RevosVault.check_enhancement(G.playing_cards, "m_crv_mega")
		if context.joker_main then
			if RCM > 0 then
				return {
					x_mult = RCM * card.ability.extra.x_gain + 1,
				}
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		if RevosVault.check_enhancement(G.playing_cards, "m_crv_mega") > 0 then
			return true
		end
		return false
	end,
})

SMODS.Joker({
	key = "bj",
	config = {
		extra = {
			x_gain = 0.4,
			RevosVault.check_enhancement("m_crv_blessedcard"),
			mult = 5,
			chips = 10,
		},
	},
	rarity = 2,
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 0,
		y = 3,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		local RCE = RevosVault.check_enhancement(G.playing_cards, "m_crv_blessedcard")
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_blessedcard
		return {
			vars = {
				card.ability.extra.x_gain * RCE + 1,
				card.ability.extra.x_gain,
				RCE,
				card.ability.extra.mult,
				card.ability.extra.chips,
				card.ability.extra.chips * RCE,
				card.ability.extra.mult * RCE,
			},
		}
	end,
	calculate = function(self, card, context)
		local RCE = RevosVault.check_enhancement(G.playing_cards, "m_crv_blessedcard")
		if context.joker_main then
			if RevosVault.check_enhancement(G.playing_cards, "m_crv_blessedcard") > 0 then
				return {
					chips = RCE * card.ability.extra.chips,
					mult = RCE * card.ability.extra.mult,
					x_mult = RCE * card.ability.extra.x_gain + 1,
				}
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		if RevosVault.check_enhancement(G.playing_cards, "m_crv_blessedcard") > 0 then
			return true
		end
		return false
	end,
})

SMODS.Joker({
	key = "t1j",
	config = {
		extra = {
			chips = 15,
			RevosVault.check_enhancement(G.playing_cards, "m_crv_tier1card"),
		},
	},
	rarity = 2,
	atlas = "t",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 0,
		y = 2,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_tier1card
		return {
			vars = {
				RevosVault.check_enhancement(G.playing_cards, "m_crv_tier1card"),
				card.ability.extra.chips,
				card.ability.extra.chips * RevosVault.check_enhancement(G.playing_cards, "m_crv_tier1card"),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if RevosVault.check_enhancement(G.playing_cards, "m_crv_tier1card") > 0 then
				return {
					chips = RevosVault.check_enhancement(G.playing_cards, "m_crv_tier1card") * card.ability.extra.chips,
				}
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		if RevosVault.check_enhancement(G.playing_cards, "m_crv_tier1card") > 0 then
			return true
		end
		return false
	end,
})

SMODS.Joker({
	key = "t2j",
	config = {
		extra = {
			chips = 30,
			mult = 5,
			RevosVault.check_enhancement(G.playing_cards, "m_crv_tier2card"),
		},
	},
	rarity = 2,
	atlas = "t",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 1,
		y = 2,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_tier2card
		return {
			vars = {
				RevosVault.check_enhancement(G.playing_cards, "m_crv_tier2card"),
				card.ability.extra.chips,
				card.ability.extra.mult,
				card.ability.extra.chips * RevosVault.check_enhancement(G.playing_cards, "m_crv_tier2card"),
				card.ability.extra.mult * RevosVault.check_enhancement(G.playing_cards, "m_crv_tier2card"),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if RevosVault.check_enhancement(G.playing_cards, "m_crv_tier2card") > 0 then
				return {
					chips = RevosVault.check_enhancement(G.playing_cards, "m_crv_tier2card") * card.ability.extra.chips,
					mult = RevosVault.check_enhancement(G.playing_cards, "m_crv_tier2card") * card.ability.extra.mult,
				}
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		if RevosVault.check_enhancement(G.playing_cards, "m_crv_tier2card") > 0 then
			return true
		end
		return false
	end,
})

SMODS.Joker({
	key = "t3j",
	config = {
		extra = {
			chips = 50,
			xmult = 0.2,
			RevosVault.check_enhancement(G.playing_cards, "m_crv_tier3card"),
		},
	},
	rarity = 2,
	atlas = "t",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 2,
		y = 2,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_tier3card
		return {
			vars = {
				RevosVault.check_enhancement(G.playing_cards, "m_crv_tier3card"),
				card.ability.extra.chips,
				card.ability.extra.xmult,
				card.ability.extra.chips * RevosVault.check_enhancement(G.playing_cards, "m_crv_tier3card"),
				card.ability.extra.xmult * RevosVault.check_enhancement(G.playing_cards, "m_crv_tier3card") + 1,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if RevosVault.check_enhancement(G.playing_cards, "m_crv_tier3card") > 0 then
				return {
					chips = RevosVault.check_enhancement(G.playing_cards, "m_crv_tier3card") * card.ability.extra.chips,
					x_mult = RevosVault.check_enhancement(G.playing_cards, "m_crv_tier3card")
							* card.ability.extra.xmult
						+ 1,
				}
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		if RevosVault.check_enhancement(G.playing_cards, "m_crv_tier3card") > 0 then
			return true
		end
		return false
	end,
})

SMODS.Joker({
	key = "bh",
	config = {
		extra = {
			hp = 3,
			havecard = 0,
			needs = 0,
			money = 10,
			hand = -1,
		},
	},
	rarity = 3,
	atlas = "Jokers2",
	blueprint_compat = false,
	discovered = false,
	pos = {
		x = 3,
		y = 0,
	},
	cost = 10,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.hp,
				card.ability.extra.havecard,
				card.ability.extra.needs,
				RevosVault.check_enhancement(G.playing_cards, "m_crv_target"),
			},
		}
	end,
	add_to_deck = function(self, card, context)
		card.ability.extra.hp = 3
		card.ability.extra.needs = 0
		card.ability.extra.money = 5
		card.ability.extra.hand = -1
	end,
	calculate = function(self, card, context)
		if
			context.setting_blind
			and not context.blueprint
			and not context.repetition
			and RevosVault.check_enhancement(G.playing_cards, "m_crv_target") == 0
		then
			G.E_MANAGER:add_event(Event({
				func = function()
					local card2 = pseudorandom_element(G.playing_cards, pseudoseed("bh"))
					card2:set_ability(G.P_CENTERS["m_crv_target"])
					return true
				end,
			}))
			return {
				message = localize("k_crv_tset_ex"),
			}
		end
		if
			context.destroy_card
			and not context.blueprint
			and card.ability.extra.needs < 4
			and context.cardarea == G.play
		then
			if SMODS.has_enhancement(context.destroy_card, "m_crv_target") then
				card.ability.extra.needs = card.ability.extra.needs + 1
				ease_dollars(card.ability.extra.money)
				card_eval_status_text(card, "extra", nil, nil, nil, { message = localize("k_crv_telim_ex") })
				return {
					remove = true,
				}
			end
		end
		if context.end_of_round and context.main_eval and card.ability.extra.hp > 0 then
			if card.ability.extra.needs >= 4 then
				SMODS.destroy_cards(card)
				for i = 1, 2 do
					SMODS.add_card({
						legendary = true,
						area = G.jokers,
						set = "Joker",
						edition = "e_negative",
					})
				end
			else
				for k, v in pairs(G.playing_cards) do
					if v.config.center == G.P_CENTERS.m_crv_target then
						card.ability.extra.hp = card.ability.extra.hp - 1
						return {
							message = localize("k_crv_failed_ex"),
						}
					end
				end
			end
		elseif context.end_of_round and context.main_eval and card.ability.extra.hp <= 0 then
			SMODS.destroy_cards(card)
			G.hand:change_size(card.ability.extra.hand)
			return {
				message = localize("k_crv_post_ex"),
			}
		end
	end,
})

SMODS.Joker({
	key = "flytrap",
	atlas = "Jokers2",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 3,
		y = 2,
	},
	config = {
		extra = {
			chipg = 10,
			chip = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.chipg, card.ability.extra.chip },
		}
	end,

	calculate = function(self, card, context)
		if
			context.individual
			and context.cardarea == G.play
			and context.other_card:is_suit("Clubs", true)
			and not context.blueprint
		then
			card.ability.extra.chip = card.ability.extra.chip + card.ability.extra.chipg
		end

		if context.joker_main then
			return {
				chips = card.ability.extra.chip,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "news",
	atlas = "Jokers2",
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 2,
		y = 3,
	},
	config = {
		extra = {
			odds = 4,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,

	calculate = function(self, card, context)
		if
			context.end_of_round
			and not context.repetition
			and not context.individual
			and pseudorandom("couponist") < G.GAME.probabilities.normal / card.ability.extra.odds
		then
			G.E_MANAGER:add_event(Event({
				func = function()
					add_tag(Tag("tag_coupon"))
					play_sound("generic1", 0.9 + math.random() * 0.1, 0.8)
					play_sound("holo1", 1.2 + math.random() * 0.1, 0.4)
					return true
				end,
			}))
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "mtm",
	config = {
		extra = {
			xmult = 3.14,
		},
	},
	rarity = 3,
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 4,
		y = 1,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			for k, v in ipairs(context.scoring_hand) do
				if v:get_id() == 3 then
					return {
						x_mult = card.ability.extra.xmult,
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
	key = "vrev",
	atlas = "Jokers2",
	pos = {
		x = 4,
		y = 2,
	},
	rarity = 3,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	config = {
		extra = {
			odds = 6,
			mult = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.mult },
		}
	end,
	calculate = function(self, card, context)
		if card.ability.extra.odds == 1 then
			card.ability.extra.odds = 6
		end
		if context.setting_blind and not context.blueprint then
			if G.jokers.cards[1] == card or G.jokers.cards[1].ability.eternal then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.3,
					blockable = false,
					func = function()
						G.jokers:remove_card(card)
						card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
						card = nil
						return true
					end,
				}))
			end

			if
				not card.getting_sliced
				and not G.jokers.cards[1].ability.eternal
				and not G.jokers.cards[1].getting_sliced
			then
				if G.jokers.cards[1] ~= card then
					if pseudorandom("vrev") < G.GAME.probabilities.normal / card.ability.extra.odds then
						local sliced_card = G.jokers.cards[1]
						sliced_card.getting_sliced = true
						G.GAME.joker_buffer = G.GAME.joker_buffer - 1
						G.E_MANAGER:add_event(Event({
							func = function()
								G.GAME.joker_buffer = 0
								card.ability.extra.mult = card.ability.extra.mult + sliced_card.sell_cost * 1.5
								card.ability.extra.odds = 6
								card:juice_up(0.8, 0.8)
								sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
								return true
							end,
						}))
						return {
							message = localize("k_crv_hit"),
							delay(0.6),
						}
					else
						local sliced_card = G.jokers.cards[1]
						card.ability.extra.mult = card.ability.extra.mult + sliced_card.sell_cost * 1.5
						card.ability.extra.odds = card.ability.extra.odds - 1
						return {
							message = localize("k_crv_miss"),
						}
					end
				end
			end
		end
		if context.joker_main then
			return {
				x_mult = card.ability.extra.mult,
			}
		end
	end,
})

SMODS.Joker({
	key = "ut",
	atlas = "Jokers2",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 4,
		y = 0,
	},
	config = {
		extra = {
			xmult = 3,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
		}
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			local numbers, all_cards = 0, 0
			for k, v in ipairs(G.hand.cards) do
				all_cards = all_cards + 1
				if v:get_id() >= 2 and v:get_id() <= 6 then
					numbers = numbers + 1
				end
			end
			if numbers == all_cards then
				return {
					x_mult = card.ability.extra.xmult,
				}
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

local suits = { 1, 2, 3, 4 }
SMODS.Joker({
	key = "smbj",
	atlas = "Jokers2",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 5,
		y = 0,
	},
	config = {
		extra = {
			xmult = 3,
			randomsuit = 2,
			setsuit = "Spades",
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.randomsuit, card.ability.extra.xmult, card.ability.extra.setsuit },
		}
	end,

	calculate = function(self, card, context)
		if context.end_of_round and not context.blueprint then
			card.ability.extra.randomsuit = (pseudorandom_element(suits, pseudoseed("ptm")))
			if card.ability.extra.randomsuit == 1 then
				card.ability.extra.setsuit = "Clubs"
			elseif card.ability.extra.randomsuit == 2 then
				card.ability.extra.setsuit = "Spades"
			elseif card.ability.extra.randomsuit == 3 then
				card.ability.extra.setsuit = "Diamonds"
			elseif card.ability.extra.randomsuit == 4 then
				card.ability.extra.setsuit = "Hearts"
			end
		end
		-- all cards calc
		if context.joker_main then
			local all_cards = 0
			for k, v in ipairs(G.hand.cards) do
				all_cards = all_cards + 1
				card.ability.extra.allcards = all_cards
			end
		end

		-- checks for clubs
		if context.joker_main and card.ability.extra.randomsuit == 1 then
			local blackc_suits = 0
			for k, v in ipairs(G.hand.cards) do
				if v:is_suit("Clubs", nil, true) then
					blackc_suits = blackc_suits + 1
				end
			end
			if blackc_suits == card.ability.extra.allcards then
				return {
					x_mult = card.ability.extra.xmult,
				}
			end
			-- checks for spades
		elseif context.joker_main and card.ability.extra.randomsuit == 2 then
			local blacks_suits = 0
			for k, v in ipairs(G.hand.cards) do
				if v:is_suit("Spades", nil, true) then
					blacks_suits = blacks_suits + 1
				end
			end
			if blacks_suits == card.ability.extra.allcards then
				return {
					x_mult = card.ability.extra.xmult,
				}
			end
			-- checks for diamonds
		elseif context.joker_main and card.ability.extra.randomsuit == 3 then
			local redd_suits = 0
			for k, v in ipairs(G.hand.cards) do
				if v:is_suit("Diamonds", nil, true) then
					redd_suits = redd_suits + 1
				end
			end
			if redd_suits == card.ability.extra.allcards then
				return {
					x_mult = card.ability.extra.xmult,
				}
			end
			-- check for hearts
		elseif context.joker_main and card.ability.extra.randomsuit == 4 then
			local redh_suits = 0
			for k, v in ipairs(G.hand.cards) do
				if v:is_suit("Hearts", nil, true) then
					redh_suits = redh_suits + 1
				end
			end
			if redh_suits == card.ability.extra.allcards then
				return {
					x_mult = card.ability.extra.xmult,
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "checkpoint",
	atlas = "Jokers2",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 5,
		y = 1,
	},
	config = {
		extra = {},
	},

	calculate = function(self, card, context)
		if context.selling_self and not context.blueprint then
			G.GAME.chips = G.GAME.chips / 2
			G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + G.GAME.current_round.hands_played
			G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + G.GAME.current_round.discards_used
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "goldenshark",
	atlas = "Jokers2",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 5,
		y = 2,
	},
	config = {
		extra = {
			timer = 0,
			status = "Not Ready",
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.timer, card.ability.extra.status },
		}
	end,
	calculate = function(self, card, context)
		if
			context.end_of_round
			and not context.repetition
			and not context.individual
			and not (card.ability.extra.timer == 3)
		then
			card.ability.extra.timer = card.ability.extra.timer + 1
		end

		if card.ability.extra.timer == 3 then
			card.ability.extra.status = "Ready"
			if context.cardarea == G.play then
				for k, v in ipairs(context.scoring_hand) do
					if context.other_card.ability.effect == "Base" then
						context.other_card:set_ability(G.P_CENTERS.m_gold)
						G.E_MANAGER:add_event(Event({
							func = function()
								return true
							end,
						}))
					end
				end
			end
		end
		if card.ability.extra.timer == 3 and context.final_scoring_step then
			card.ability.extra.timer = 0
			card.ability.extra.status = "Not Ready"
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "sfj",
	atlas = "Jokers2",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 5,
		y = 3,
	},
	config = {
		extra = {
			one = 0,
			chips = 0,
			ok = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.one, card.ability.extra.chips, card.ability.extra.ok },
		}
	end,
	calculate = function(self, card, context)
		if
			context.joker_main
			and G.GAME.talisman == 1
			and card.ability.extra.one == 0
			and card.ability.extra.one == 0
			and not context.blueprint
			and not context.repetition
		then
			card.ability.extra.ok = card.ability.extra.ok + 1
			local chips = hand_chips * mult
			card.ability.extra.chips = chips
			card.ability.extra.one = to_number(card.ability.extra.chips / 2)
			return {
				message = localize("k_crv_stored"),
			}
		elseif
			context.joker_main
			and card.ability.extra.one == 0
			and card.ability.extra.one == 0
			and card.ability.extra.one == 0
			and not context.blueprint
			and not context.repetition
		then
			card.ability.extra.ok = card.ability.extra.ok + 1
			local chips = hand_chips * mult
			card.ability.extra.chips = chips
			card.ability.extra.one = card.ability.extra.chips / 2
			return {
				message = localize("k_crv_stored"),
			}
		end
		if context.joker_main and G.GAME.talisman == 1 and card.ability.extra.ok > 0 then
			if #SMODS.find_card("j_crv_upgr") == 0 then
				return {
					chips = to_number(card.ability.extra.one),
				}
			elseif #SMODS.find_card("j_crv_upgr") > 0 then
				return {
					mult = card.ability.extra.one,
				}
			end
		elseif context.joker_main and card.ability.extra.ok > 0 then
			if #SMODS.find_card("j_crv_upgr") == 0 then
				return {
					chips = card.ability.extra.one,
				}
			elseif #SMODS.find_card("j_crv_upgr") > 0 then
				return {
					mult = card.ability.extra.one,
				}
			end
		end
		if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
			card.ability.extra.ok = 0
			card.ability.extra.one = 0
			return {
				message = localize("k_crv_cleaning"),
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "upgr",
	atlas = "Jokers2",
	rarity = 3,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 6,
		y = 4,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_crv_sfj
		return {
			vars = {},
		}
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

local chances = { 1, 2, 3, 4, 5, 6, 7, 8 }

SMODS.Joker({
	key = "btls",
	atlas = "Jokers2",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 6,
		y = 0,
	},
	config = {
		extra = {},
	},
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.talisman == 1 and not context.blueprint and not context.repetition then
			local cc = (pseudorandom_element(chances, pseudoseed("btls")))
			if cc == 1 then
				return {
					chip_mod = to_number(G.GAME.blind.chips * 4),
					message = localize("k_crv_overscore"),
					colour = G.C.MULT,
				}
			end
		elseif context.joker_main and not context.blueprint and not context.repetition then
			local cc = (pseudorandom_element(chances, pseudoseed("btls")))
			if cc == 1 then
				return {
					chip_mod = G.GAME.blind.chips * 4,
					message = localize("k_crv_overscore"),
					colour = G.C.MULT,
				}
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "psy",
	atlas = "Jokers2",
	rarity = 3,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,

	pos = {
		x = 6,
		y = 1,
	},
	config = {
		extra = {
			xmult = 22,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
		}
	end,

	calculate = function(self, card, context)
		if
			context.cardarea == G.jokers
			and context.joker_main
			and G.GAME.current_round.hands_left == 2
			and G.GAME.current_round.discards_left == 2
		then
			if #context.full_hand == 2 then
				return {
					x_mult = card.ability.extra.xmult,
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "mj4",
	atlas = "Jokers2",
	rarity = 3,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 6,
		y = 2,
	},
	config = {
		extra = {
			xmult = 4.4,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
		}
	end,

	calculate = function(self, card, context)
		if context.joker_main and next(context.poker_hands["Four of a Kind"]) then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
	end,
})

SMODS.Joker({
	key = "tp3",
	atlas = "Jokers2",
	rarity = 3,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 6,
		y = 3,
	},
	config = {
		extra = {
			xmult = 3.3,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
		}
	end,

	calculate = function(self, card, context)
		if context.joker_main and next(context.poker_hands["Three of a Kind"]) then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
	end,
})

SMODS.Joker({
	key = "ml",
	atlas = "Jokers2",
	rarity = 3,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 1,
		y = 5,
	},
	config = {
		extra = {
			xmult = 5,
			dcard = "N/A",
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.dcard },
		}
	end,

	calculate = function(self, card, context)
		if context.setting_blind and not context.repetition and not context.blueprint then
			local jokers = {}
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] ~= self then
					jokers[#jokers + 1] = G.jokers.cards[i]
				end
			end
			if #jokers > 1 then
				if not context.blueprint then
					local chosen_joker = pseudorandom_element(jokers, pseudoseed("ml"))
					chosen_joker:set_debuff(true)
					if context.end_of_round and context.main_eval then
						chosen_joker:set_debuff(false)
					end
				end
			end
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
	key = "vji",
	atlas = "Jokers2",
	rarity = 2,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 2,
		y = 5,
	},
	config = {
		extra = {
			xmult = 1,
			mgain = 0.1,
			limit = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.mgain, card.ability.extra.limit },
		}
	end,

	calculate = function(self, card, context)
		if context.discard and not context.blueprint and not (card.ability.extra.limit >= 10) then
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.mgain
			card.ability.extra.limit = card.ability.extra.limit + 1
			return {
				message = localize("k_upgrade_ex"),
				colour = G.C.MULT,
			}
		end
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
		if context.end_of_round and context.main_eval then
			card.ability.extra.limit = 0
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "dont",
	atlas = "Jokers2",
	rarity = 2,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 3,
		y = 5,
	},
	config = {
		extra = {
			odds = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.odds, (G.GAME.probabilities.normal or 1) },
		}
	end,
	calculate = function(self, card, context)
		if
			context.joker_main
			and not context.blueprint
			and not context.repetition
			and not context.individual
			and G.GAME.current_round.hands_left == 0
		then
			local rr = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					rr = i
					break
				end
			end
			if
				G.jokers.cards[rr + 1] == nil
				and G.GAME.talisman == 1
				and pseudorandom("dont") < G.GAME.probabilities.normal / card.ability.extra.odds
			then
				return {
					chip_mod = to_number(G.GAME.blind.chips * 2),
					message = localize("k_crv_double"),
				}
			elseif G.jokers.cards[rr + 1] == nil and G.GAME.talisman == 1 then
				return {
					x_mult = to_number(G.GAME.blind.chips * 0),
					message = localize("k_crv_nothing"),
				}
			elseif
				G.jokers.cards[rr + 1] == nil
				and pseudorandom("dont") < G.GAME.probabilities.normal / card.ability.extra.odds
			then
				return {
					chip_mod = G.GAME.blind.chips * 2,
					message = localize("k_crv_double"),
				}
			elseif G.jokers.cards[rr + 1] == nil then
				return {
					x_mult = G.GAME.blind.chips * 0,
					message = localize("k_crv_nothing"),
				}
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "tgm",
	atlas = "Jokers2",
	rarity = 2,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 5,
		y = 5,
	},
	config = {
		extra = {
			counter = 0,
			xmult = 1.5,
			xmultlg = 0.5,
			odds = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult,
				card.ability.extra.xmultlg,
				card.ability.extra.odds,
				(G.GAME.probabilities.normal or 1),
			},
		}
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
		if
			context.setting_blind
			and not context.blueprint
			and not context.repetition
			and card.ability.extra.xmult < 5
		then
			if pseudorandom("tgm") < G.GAME.probabilities.normal / card.ability.extra.odds then
				card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultlg
			else
				card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmultlg
			end
		end
		if card.ability.extra.xmult <= 0 then
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card.T.r = -0.2
					card:juice_up(0.3, 0.4)
					card.states.drag.is = true
					card.children.center.pinch.x = true
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.3,
						blockable = false,
						func = function()
							G.jokers:remove_card(card)
							card:remove()
							card = nil
							return true
						end,
					}))
					return true
				end,
			}))
			return {
				message = localize("k_crv_dept"),
				delay(0.6),
			}
		end
	end,
})

SMODS.Joker({
	key = "hteg",
	config = {
		extra = {
			stages = 0,
		},
	},

	rarity = 3,
	atlas = "mm",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 0,
		y = 0,
	},
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.stages },
		}
	end,
	calculate = function(self, card, context)
		if
			context.end_of_round
			and not context.repetition
			and not context.blueprint
			and not context.individual
			and not (#SMODS.find_card("j_crv_jhv") >= 1)
		then
			card.ability.extra.stages = card.ability.extra.stages + 1
		end
		if
			context.setting_blind
			and card.ability.extra.stages >= 3
			and not context.blueprint
			and not context.repetition
		then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.3,
				blockable = false,
				func = function()
					G.jokers:remove_card(card)
					card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
					card = nil
					return true
				end,
			}))
			local new_card = create_card("Jhorah,Hatchling", G.jokers, nil, nil, nil, nil, "j_crv_jhv")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		end

		if context.joker_main and not context.blueprint then
			return {
				message = "!",
			}
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "jhv",
	config = {
		extra = {
			stages = 0,
			stg1b = 30,
		},
	},
	rarity = 3,
	atlas = "mm",
	no_collection = true,
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 1,
		y = 0,
	},
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.stages, card.ability.extra.stg1b },
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
			card.ability.extra.stages = card.ability.extra.stages + 1
		end
		if
			context.setting_blind
			and card.ability.extra.stages >= 3
			and not context.repetition
			and not context.blueprint
			and not context.individual
			and not (#SMODS.find_card("j_crv_jbe") >= 1)
		then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.3,
				blockable = false,
				func = function()
					G.jokers:remove_card(card)
					card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
					card = nil
					return true
				end,
			}))
			local new_card = create_card("Jhorah,Beasty", G.jokers, nil, nil, nil, nil, "j_crv_jbe")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		end

		if context.joker_main then
			return {
				chips = card.ability.extra.stg1b,
			}
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Joker({
	key = "jbe",
	config = {
		extra = {
			stages = 0,
			stg2b = 60,
			stg2b2 = 1.5,
		},
	},

	rarity = 3,
	atlas = "mm",
	blueprint_compat = true,
	discovered = false,
	no_collection = true,
	pos = {
		x = 2,
		y = 0,
	},
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.stages, card.ability.extra.stg2b, card.ability.extra.stg2b2 },
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
			card.ability.extra.stages = card.ability.extra.stages + 1
		end
		if
			context.setting_blind
			and card.ability.extra.stages >= 3
			and not context.repetition
			and not context.blueprint
			and not context.individual
			and not (#SMODS.find_card("j_crv_jma") >= 1)
		then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.3,
				blockable = false,
				func = function()
					G.jokers:remove_card(card)
					card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
					card = nil
					return true
				end,
			}))
			local new_card = create_card("Jhorah,Matured", G.jokers, nil, nil, nil, nil, "j_crv_jma")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		end

		if context.joker_main then
			return {
				chips = card.ability.extra.stg2b,
				x_mult = card.ability.extra.stg2b2,
			}
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return false
	end,
})
SMODS.Joker({
	key = "jma",
	config = {
		extra = {
			stages = 0,
			stg3b = 90,
			stg3b2 = 2,
		},
	},

	rarity = 3,
	atlas = "mm",
	blueprint_compat = true,
	discovered = false,
	no_collection = true,
	pos = {
		x = 3,
		y = 0,
	},
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.stages, card.ability.extra.stg3b, card.ability.extra.stg3b2 },
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
			card.ability.extra.stages = card.ability.extra.stages + 1
		end
		if
			context.setting_blind
			and card.ability.extra.stages >= 3
			and not context.repetition
			and not context.blueprint
			and not context.individual
			and not (#SMODS.find_card("j_crv_jad") >= 1)
		then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.3,
				blockable = false,
				func = function()
					G.jokers:remove_card(card)
					card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
					card = nil
					return true
				end,
			}))
			local new_card = create_card("Jhorah,Adult", G.jokers, nil, nil, nil, nil, "j_crv_jad")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		end

		if context.joker_main then
			return {
				chips = card.ability.extra.stg3b,
				x_mult = card.ability.extra.stg3b2,
			}
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Joker({
	key = "jad",
	config = {
		extra = {
			stages = 0,
			stg4b = 2,
			stg4b2 = 2.5,
		},
	},

	rarity = 3,
	atlas = "mm",
	blueprint_compat = true,
	discovered = false,
	no_collection = true,
	pos = {
		x = 4,
		y = 0,
	},
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.stages, card.ability.extra.stg4b, card.ability.extra.stg4b2 },
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
			card.ability.extra.stages = card.ability.extra.stages + 1
		end
		if
			context.setting_blind
			and card.ability.extra.stages >= 3
			and not context.repetition
			and not context.blueprint
			and not context.individual
			and not (#SMODS.find_card("j_crv_jcbt") >= 1)
		then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.3,
				blockable = false,
				func = function()
					G.jokers:remove_card(card)
					card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
					card = nil
					return true
				end,
			}))
			local new_card = create_card("Jhorah,Chained Beast", G.jokers, nil, nil, nil, nil, "j_crv_jcbt")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		end

		if context.joker_main then
			return {
				xchips = card.ability.extra.stg4b,
				x_mult = card.ability.extra.stg4b2,
			}
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Joker({
	key = "jcbt",
	config = {
		extra = {
			stg5b = 4,
			stg5b2 = 3,
			odds = 4,
		},
	},

	rarity = 3,
	atlas = "mm",
	blueprint_compat = true,
	discovered = false,
	no_collection = true,
	pos = {
		x = 5,
		y = 0,
	},
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.stages,
				card.ability.extra.stg5b,
				card.ability.extra.stg5b2,
				(G.GAME.probabilities.normal or 1),
				card.ability.extra.odds,
			},
		}
	end,
	calculate = function(self, card, context)
		if pseudorandom("jcbt") < G.GAME.probabilities.normal / card.ability.extra.odds then
			if context.individual then
				if context.cardarea == G.play then
					for k, v in ipairs(context.scoring_hand) do
						if context.other_card.ability.effect == "Base" then
							context.other_card:set_ability(
								G.P_CENTERS[SMODS.poll_enhancement({
									guaranteed = true,
								})],
								true,
								false
							)
							G.E_MANAGER:add_event(Event({
								func = function()
									return true
								end,
							}))
						end
					end
				end
			end
		end
		if context.joker_main then
			return {
				xchips = card.ability.extra.stg5b,
				x_mult = card.ability.extra.stg5b2,
			}
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Joker({
	key = "jimp",
	atlas = "Jokers2",
	rarity = 3,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 6,
		y = 5,
	},
	config = {
		extra = {
			xmult = 3,
			xmult2 = 1.5,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.xmult2 },
		}
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			local rr = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					rr = i
					break
				end
			end
			if G.jokers.cards[rr + 1] == nil or G.jokers.cards[rr - 1] == nil then
				return {
					x_mult = card.ability.extra.xmult,
				}
			else
				return {
					x_mult = card.ability.extra.xmult2,
				}
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "jarden",
	atlas = "Jokers2",
	rarity = 3,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 7,
		y = 0,
	},
	config = {
		extra = {
			xmult = 1,
			xmult2 = 0.5,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.xmult2 },
		}
	end,

	calculate = function(self, card, context)
		if context.selling_card and not context.repetition and not context.blueprint then
			card.ability.extra.xmult = 1
			return {
				message = localize("k_reset"),
				colour = G.C.MULT,
			}
		end
		if context.end_of_round and context.main_eval and not context.blueprint then
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult2
			return {
				message = localize("k_upgrade_ex"),
				colour = G.C.MULT,
			}
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
	key = "kit",
	atlas = "Jokers2",
	rarity = 3,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 7,
		y = 1,
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
		if context.final_scoring_step then
			if context.cardarea then
				for k, v in ipairs(context.scoring_hand) do
					G.E_MANAGER:add_event(Event({
						trigger = "before",
						delay = 0.5,
						func = function()
							if v.base.id > 13 then
								v:flip()
								play_sound("card1")
								v:juice_up(0.3, 0.4)
								assert(SMODS.modify_rank(v, -1))
							elseif v.base.id < 13 then
								v:flip()
								play_sound("card1")
								v:juice_up(0.3, 0.4)
								assert(SMODS.modify_rank(v, 1))
							elseif v.base.id == 13 then
								v:flip()
								play_sound("card1")
							end
							return true
						end,
					}))
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 1,
						func = function()
							v:flip()
							v:juice_up(0.3, 0.4)
							return true
						end,
					}))
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "kon",
	config = {
		extra = {
			chips = 25,
		},
	},
	rarity = 3,
	atlas = "Jokers2",
	blueprint_compat = false,
	discovered = false,
	pos = {
		x = 7,
		y = 2,
	},
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.chips },
		}
	end,
	calculate = function(self, card, context)
		if
			context.individual
			and context.cardarea == G.play
			and context.other_card:get_id() >= 7
			and not context.blueprint
		then
			context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
			context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra.chips
			return {
				message = localize("k_upgrade_ex"),
			}
		elseif
			context.destroy_card
			and context.cardarea == G.play
			and context.destroy_card:get_id() < 7
			and not context.blueprint
		then
			return {
				remove = true,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "onj",
	config = {
		extra = {
			xmult = 1,
			multg = 0.25,
		},
	},
	rarity = 3,
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 7,
		y = 3,
	},
	cost = 7,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.multg },
		}
	end,
	calculate = function(self, card, context)
		if
			context.before
			and context.cardarea
			and not context.blueprint
			and not context.repetition
			and not context.individual
		then
			for k, v in ipairs(context.scoring_hand) do
				if v.ability.effect == "Base" then
					v:set_ability("m_stone")
					v:juice_up(0.3, 0.4)
				elseif v.ability.effect == "Stone Card" then
					v:set_ability("c_base")
					v:juice_up(0.3, 0.4)
					card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.multg
				end
			end
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

local rabbits = { "j_crv_rabf", "j_crv_rabflush", "j_crv_rabhigh" }

SMODS.Joker({
	key = "rab",
	config = {
		extra = {
			xmult = 1.50,
			xmultgain = 0.50,
			stage = 0,
		},
	},
	rarity = 3,
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 7,
		y = 5,
	},
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.xmultgain, card.ability.extra.stage },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
		if context.end_of_round and G.GAME.blind.boss and context.main_eval and not context.blueprint then
			local rr = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					rr = i
					break
				end
			end
			if G.jokers.cards[rr + 1] == nil or G.jokers.cards[rr - 1] == nil and context.main_eval then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 1,
					blockable = false,
					func = function()
						G.jokers:remove_card(card)
						card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
						card = nil
						return true
					end,
				}))
				return {
					message = localize("k_crv_rain"),
					message_card = card,
				}
			elseif
				G.jokers.cards[rr + 1] ~= nil
				and G.jokers.cards[rr - 1] ~= nil
				and G.GAME.blind.boss
				and context.main_eval
			then
				card.ability.extra.stage = card.ability.extra.stage + 1
				card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultgain
				return {
					message = localize("k_crv_rain2"),
					message_card = card,
				}
			end
		end
		if
			card.ability.extra.stage >= 5
			and not context.repetition
			and not context.individual
			and not context.blueprint
		then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 1,
				blockable = false,
				func = function()
					G.jokers:remove_card(card)
					card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
					card = nil
					return true
				end,
			}))
			local rabs = pseudorandom_element(rabbits, pseudoseed("rab"))
			card:juice_up(0.3, 0.4)
			card:set_ability(rabs)
			card_eval_status_text(card, "extra", nil, nil, nil, { message = localize("k_evolve_crv") })
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "rabf",
	config = {
		extra = {
			xmult = 4,
			xmultf = 2,
		},
	},
	rarity = "crv_titan",
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	no_collection = true,
	pos = {
		x = 2,
		y = 6,
	},
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.xmultf },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_face() then
				return {
					x_mult = card.ability.extra.xmultf,
				}
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Joker({
	key = "rabflush",
	config = {
		extra = {
			xmult = 4,
			xmultex = 6,
		},
	},
	rarity = "crv_titan",
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	no_collection = true,
	pos = {
		x = 0,
		y = 6,
	},
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.xmultex },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main and next(context.poker_hands["Flush"]) then
			return {
				x_mult = card.ability.extra.xmultex,
			}
		elseif context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Joker({
	key = "rabhigh",
	config = {
		extra = {
			xmult = 4,
			xmultex = 6,
		},
	},
	rarity = "crv_titan",
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	no_collection = true,
	pos = {
		x = 1,
		y = 6,
	},
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.xmultex },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main and next(context.poker_hands["Full House"]) then
			return {
				x_mult = card.ability.extra.xmultex,
			}
		elseif context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

-- thanks to bepisfever on discord for helping with this part :D

local card_highlighted_ref = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and string.find(self.ability.name, "j_crv_brj") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.create_sell_and_switch_buttons(self, {
				sell = true,
				use = true,
			}),
			config = {
				align = "cr",
				offset = {
					x = -0.4,
					y = 0,
				},
				parent = self,
			},
		})
	else
		card_highlighted_ref(self, is_highlighted)
	end
end

RevosVault.create_sell_and_switch_buttons = function(card, args)
	local args = args or {}
	local sell = nil
	local use = nil

	if args.sell then
		sell = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						hover = true,
						shadow = true,
						colour = G.C.UI.BACKGROUND_INACTIVE,
						one_press = true,
						button = "sell_card",
						func = "can_sell_card",
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = 0.1,
								h = 0.6,
							},
						},
						{
							n = G.UIT.C,
							config = {
								align = "tm",
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										maxw = 1.25,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("b_sell"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.4,
												shadow = true,
											},
										},
									},
								},
								{
									n = G.UIT.R,
									config = {
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("$"),
												colour = G.C.WHITE,
												scale = 0.4,
												shadow = true,
											},
										},
										{
											n = G.UIT.T,
											config = {
												ref_table = card,
												ref_value = "sell_cost_label",
												colour = G.C.WHITE,
												scale = 0.55,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	if args.use then
		use = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_modee",
						func = "can_change_mode",
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = 0.1,
								h = 0.6,
							},
						},
						{
							n = G.UIT.C,
							config = {
								align = "tm",
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										maxw = 1.25,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("crv_mode"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.4,
												shadow = true,
											},
										},
									},
								},
								{
									n = G.UIT.R,
									config = {
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("crv_mode2"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.5,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	return {
		n = G.UIT.ROOT,
		config = {
			align = "cr",
			padding = 0,
			colour = G.C.CLEAR,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					padding = 0.15,
					align = "cl",
				},
				nodes = {
					sell and {
						n = G.UIT.R,
						config = {
							align = "cl",
						},
						nodes = { sell },
					} or nil,
					use and {
						n = G.UIT.R,
						config = {
							align = "cl",
						},
						nodes = { use },
					} or nil,
				},
			},
		},
	}
end

G.FUNCS.can_change_mode = function(e)
	local card = e.config.ref_table
	if card.ability.extra["turn"] == "Player" then
		e.config.colour = G.C.RED
		e.config.button = "crv_modee"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.crv_modee = function(e)
	local card = e.config.ref_table
	if card.ability.extra["turn"] == "Player" then
		if card.ability.extra["mode"] == "Joker" then
			card.ability.extra["mode"] = "Self"
		elseif card.ability.extra["mode"] == "Self" then
			card.ability.extra["mode"] = "Joker"
		end
	end
end

-- find a way to localize this (hmmmmmmmhmmmmmmmmm)
local brjk2 = { "Self", "Joker" }
SMODS.Joker({
	key = "brj",
	config = {
		extra = {
			cardhp = 6,
			playerhp = 6,
			mode = "Joker",
			turn = "Player",
			odds2 = 3,
		},
	},
	rarity = 3,
	atlas = "Jokers2",
	blueprint_compat = false,
	discovered = false,
	no_collection = false,
	pos = {
		x = 5,
		y = 6,
	},
	cost = 10,
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.cardhp, crv.playerhp, crv.mode, crv.turn, crv.odds2 },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if
			context.setting_blind
			and not context.repetition
			and not context.individual
			and not context.blueprint
			and crv.turn == "Player"
		then
			if crv.mode == "Self" and pseudorandom("brj") >= 1 / crv.odds2 then
				crv.odds2 = crv.odds2 - 1
				crv.turn = "Player"
				return {
					message = "Miss, Go again!",
				}
			elseif crv.mode == "Self" and pseudorandom("brj") < 1 / crv.odds2 then
				crv.odds2 = 3
				crv.turn = "Joker"
				crv.playerhp = crv.playerhp - 1
				return {
					message = "Ouch!",
				}
			elseif crv.mode == "Joker" and pseudorandom("brj") < 1 / crv.odds2 then
				crv.odds2 = 3
				crv.turn = "Joker"
				crv.cardhp = crv.cardhp - 1
				return {
					message = "Hit!",
				}
			elseif crv.mode == "Joker" and pseudorandom("brj") >= 1 / crv.odds2 then
				crv.odds2 = crv.odds2 - 1
				crv.turn = "Joker"
				return {
					message = "Miss, Changing turns!",
				}
			elseif crv.mode == "Self" then
				crv.turn = "Player"
				crv.odds2 = crv.odds2 - 1
				return {
					message = "Miss, Go again!",
				}
			elseif crv.mode == "Joker" then
				crv.turn = "Enemy"
				crv.odds2 = crv.odds2 - 1
				crv.turn = "Joker"
				return {
					message = "Miss, Changing turns!",
				}
			end
		elseif
			context.setting_blind
			and not context.repetition
			and not context.individual
			and not context.blueprint
			and crv.turn == "Joker"
			and crv.odds2 > 1
		then
			crv.mode = pseudorandom_element(brjk2, pseudoseed("brj"))
			if crv.mode == "Self" and pseudorandom("brj") > 1 / crv.odds2 then
				crv.odds2 = crv.odds2 - 1
				crv.turn = "Player"
				return {
					message = "Safe, your turn!",
				}
			elseif crv.mode == "Self" and pseudorandom("brj") < 1 / crv.odds2 then
				crv.odds2 = 3
				crv.turn = "Player"
				crv.playerhp = crv.playerhp - 1
				return {
					message = "Ouch!",
				}
			elseif crv.mode == "Joker" and pseudorandom("brj") < 1 / crv.odds2 then
				crv.odds2 = 3
				crv.turn = "Player"
				crv.cardhp = crv.cardhp - 1
				return {
					message = "Hit!",
				}
			elseif crv.mode == "Joker" and pseudorandom("brj") > 1 / crv.odds2 then
				crv.odds2 = crv.odds2 - 1
				crv.turn = "Joker"
				return {
					message = "Miss, waiting!",
				}
			elseif crv.mode == "Self" then
				crv.turn = "Player"
				crv.odds2 = crv.odds2 - 1
				return {
					message = "Miss, your turn!",
				}
			elseif crv.mode == "Joker" then
				crv.turn = "Enemy"
				crv.odds2 = crv.odds2 - 1
				crv.turn = "Joker"
				return {
					message = "Miss, waiting!",
				}
			end
		elseif
			context.setting_blind
			and not context.repetition
			and not context.individual
			and not context.blueprint
			and crv.turn == "Joker"
			and crv.odds2 == 1
		then
			crv.odds2 = 3
			crv.turn = "Player"
			crv.playerhp = crv.playerhp - 1
			return {
				message = "Hit!",
			}
		end
		if crv.playerhp == 0 then
			G.STATE = G.STATES.GAME_OVER
			G.STATE_COMPLETE = false
		end
		if
			crv.cardhp == 0
			and not context.blueprint
			and not context.repetition
			and not context.individual
			and context.first_hand_drawn
		then
			G.E_MANAGER:add_event(Event({
				trigger = "immediate",
				delay = 1,
				blockable = false,
				func = function()
					G.jokers:remove_card(card)
					card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
					card = nil
					SMODS.add_card({
						set = "Joker",
						area = G.jokers,
						legendary = true,
						edition = "e_negative",
					})
					SMODS.add_card({
						set = "Joker",
						area = G.jokers,
						legendary = true,
						edition = "e_negative",
					})
					return true
				end,
			}))
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Joker({
	key = "jimshow",
	atlas = "Jokers2",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 6,
		y = 6,
	},
	config = {
		extra = {
			xmult = 1,
			xmultg = 0.05,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.xmultg },
		}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main then
			crv.xmult = crv.xmult + crv.xmultg
			return {
				xmult = card.ability.extra.xmult,
			}
		end
	end,
})

SMODS.Joker({
	key = "rein",
	atlas = "Jokers2",
	rarity = 3,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 7,
		y = 6,
	},
	config = {
		extra = {
			xmult = 2,
			odds = 4,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.xmult * G.GAME.reincarnation, G.GAME.reincarnation, crv.odds, G.GAME.probabilities.normal },
		}
	end,
	remove_from_deck = function(self, card, from_debuff)
		local crv = card.ability.extra
		G.GAME.reincarnation = G.GAME.reincarnation + 1
		if pseudorandom("rein") < G.GAME.probabilities.normal / crv.odds then
			add_tag(Tag("tag_crv_reintag"))
		end
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main then
			return {
				xmult = crv.xmult * G.GAME.reincarnation,
			}
		end
	end,
})

local card_highlighted_ref = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and string.find(self.ability.name, "j_crv_clicker") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.clicker(self, {
				sell = true,
				use = true,
			}),
			config = {
				align = "cr",
				offset = {
					x = -0.4,
					y = 0,
				},
				parent = self,
			},
		})
	else
		card_highlighted_ref(self, is_highlighted)
	end
end

RevosVault.clicker = function(card, args)
	local args = args or {}
	local sell = nil
	local use = nil

	if args.sell then
		sell = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						hover = true,
						shadow = true,
						colour = G.C.UI.BACKGROUND_INACTIVE,
						one_press = true,
						button = "sell_card",
						func = "can_sell_card",
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = 0.1,
								h = 0.6,
							},
						},
						{
							n = G.UIT.C,
							config = {
								align = "tm",
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										maxw = 1.25,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("b_sell"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.4,
												shadow = true,
											},
										},
									},
								},
								{
									n = G.UIT.R,
									config = {
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("$"),
												colour = G.C.WHITE,
												scale = 0.4,
												shadow = true,
											},
										},
										{
											n = G.UIT.T,
											config = {
												ref_table = card,
												ref_value = "sell_cost_label",
												colour = G.C.WHITE,
												scale = 0.55,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	if args.use then
		use = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_clicked",
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = 0.1,
								h = 0.6,
							},
						},
						{
							n = G.UIT.C,
							config = {
								align = "tm",
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										maxw = 1.25,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("crv_click"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.8,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	return {
		n = G.UIT.ROOT,
		config = {
			align = "cr",
			padding = 0,
			colour = G.C.CLEAR,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					padding = 0.15,
					align = "cl",
				},
				nodes = {
					sell and {
						n = G.UIT.R,
						config = {
							align = "cl",
						},
						nodes = { sell },
					} or nil,
					use and {
						n = G.UIT.R,
						config = {
							align = "cl",
						},
						nodes = { use },
					} or nil,
				},
			},
		},
	}
end

G.FUNCS.crv_clicked = function(e)
	local card = e.config.ref_table
	card.ability.extra["clicks"] = card.ability.extra["clicks"] + 1
	card.ability.extra["chips"] = card.ability.extra["chips"] + card.ability.extra["chipgain"]
end

SMODS.Joker({
	key = "clicker",
	config = {
		extra = {
			clicks = 0,
			chips = 0,
			chipgain = 0.1,
		},
	},
	rarity = 3,
	atlas = "Jokers2",
	blueprint_compat = false,
	discovered = false,
	no_collection = false,
	pos = {
		x = 0,
		y = 7,
	},
	cost = 10,
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.clicks, crv.chips, crv.chipgain },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main then
			return {
				chips = crv.chips,
			}
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "hand",
	atlas = "Jokers2",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 1,
		y = 7,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = {},
		}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.setting_blind then
			local my_pos = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					my_pos = i
					break
				end
			end
			if my_pos and G.jokers.cards[my_pos + 1] and not G.jokers.cards[my_pos + 1].getting_sliced then
				local sliced_card = G.jokers.cards[my_pos + 1]
				sliced_card.getting_sliced = true
				G.GAME.joker_buffer = G.GAME.joker_buffer - 1
				G.E_MANAGER:add_event(Event({
					func = function()
						G.GAME.joker_buffer = 0
						card:juice_up(0.8, 0.8)
						sliced_card:start_dissolve({ HEX("57ecab") }, nil, 0.1)
						return true
					end,
				}))
			end
		end
	end,
})

SMODS.Joker({
	key = "giftbox",
	atlas = "Jokers2",
	rarity = 3,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 2,
		y = 7,
	},
	config = {
		extra = {
			timer = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.timer },
		}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.end_of_round and context.main_eval and not context.blueprint then
			crv.timer = crv.timer + 1
		end
		if context.selling_self then
			SMODS.add_card({
				set = "Joker",
				area = G.jokers,
				rarity = 0,
				stickers = { "eternal" },
			})
			SMODS.add_card({
				set = "Joker",
				area = G.jokers,
				legendary = true,
				stickers = { "eternal" },
			})
		end
	end,
})

SMODS.Joker({
	key = "henchman",
	atlas = "Jokers2",
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 3,
		y = 7,
	},
	config = {
		extra = {
			mult = 6,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.mult },
		}
	end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.henchmans = G.GAME.henchmans + 1
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.henchmans = G.GAME.henchmans - 1
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main then
			return {
				mult = crv.mult,
			}
		end
	end,
})

SMODS.Joker({
	key = "jjoker",
	atlas = "Jokers2",
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	rarity = 2,
	pos = {
		x = 4,
		y = 7,
	},
	config = {
		extra = {
			mult = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.mult, G.GAME.henchmans },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main and G.GAME.henchmans > 0 then
			return {
				xmult = crv.mult * G.GAME.henchmans,
			}
		end
	end,
})

SMODS.Joker({
	key = "jimbojam",
	atlas = "Jokers2",
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	rarity = 2,
	pos = {
		x = 5,
		y = 7,
	},
	config = {
		extra = {
			chips = 1,
			chipsg = 0.05,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.chips, card.ability.extra.chipsg },
		}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main then
			crv.chips = crv.chips + crv.chipsg
			return {
				x_chips = card.ability.extra.chips,
			}
		end
	end,
})

SMODS.Joker({
	key = "stockmarket",
	atlas = "Jokers2",
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	rarity = 2,
	pos = {
		x = 6,
		y = 7,
	},
	config = {
		extra = {
			moneymult = 2,
			money = 1,
			odds = 4,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.moneymult, crv.money, G.GAME.probabilities.normal, crv.odds },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.end_of_round and context.main_eval and not context.blueprint then
			if pseudorandom("stockmarket") < G.GAME.probabilities.normal / crv.odds then
				crv.money = 1
			else
				crv.money = crv.money * crv.moneymult
			end
		end
	end,
	calc_dollar_bonus = function(self, card)
		local crv = card.ability.extra
		return crv.money
	end,
})

SMODS.Joker({
	key = "rekoj",
	atlas = "Jokers2",
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	rarity = 1,
	pos = {
		x = 8,
		y = 0,
	},
	config = {
		extra = {
			chips = 40,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.chips },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main then
			return {
				chips = crv.chips,
			}
		end
	end,
})

SMODS.Joker({
	key = "collector",
	atlas = "Jokers2",
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	rarity = 1,
	pos = {
		x = 8,
		y = 1,
	},
	config = {
		extra = {
			mult = 0,
			multg = 0.5,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.mult, crv.multg },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.buying_card and not context.blueprint and not context.blueprint then
			crv.mult = crv.mult + crv.multg
		end
		if context.joker_main then
			return {
				mult = crv.mult,
			}
		end
	end,
})

SMODS.Joker({
	key = "loveletter",
	atlas = "Jokers2",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 8,
		y = 2,
	},
	config = {
		extra = {
			multg = 1,
			mult = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.multg, card.ability.extra.mult },
		}
	end,

	calculate = function(self, card, context)
		if
			context.individual
			and context.cardarea == G.play
			and context.other_card:is_suit("Hearts", true)
			and not context.blueprint
		then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multg
		end

		if context.joker_main then
			return {
				mult = card.ability.extra.mult,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

function stickercheck()
	local st = 0
	if G and G.jokers and G.jokers.cards then
		for _, v in pairs(G.jokers.cards) do
			if v.ability.perishable then
				st = st + 1
			end
		end
		return st
	end
	return 0
end

SMODS.Joker({
	key = "kq",
	atlas = "Jokers2",
	rarity = 3,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 8,
		y = 3,
	},
	config = {
		extra = {
			xmult = 1.5,
			odds = 100,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult * stickercheck() + 1, card.ability.extra.xmult },
		}
	end,

	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			local rr = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					rr = i
					break
				end
			end
			if G.jokers.cards[rr + 1] ~= nil then
				SMODS.Stickers["perishable"]:apply(G.jokers.cards[rr + 1], true)
			end
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult * stickercheck() + 1,
			}
		end
		if RevosVault.config.secret_enabled then
			if context.end_of_round and context.main_eval and not context.blueprint then
				if pseudorandom("kq") < G.GAME.probabilities.normal / card.ability.extra.odds then
					card:juice_up(0.3, 0.4)
					card:set_ability("j_crv_kqb")
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "ccat",
	atlas = "Jokers2",
	rarity = 3,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 8,
		y = 4,
	},
	config = {
		extra = {
			ammount = 3,
			rankdis = "N/A",
			suitdis = "N/A",
			rank = "N/A",
			suit = "N/A",
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.ammount, card.ability.extra.rankdis, card.ability.extra.suitdis },
		}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if
			context.before
			and context.cardarea
			and not context.repetition
			and not context.individual
			and not context.blueprint
		then
			if card.ability.extra.rank == "N/A" then
				card.ability.extra.rank = G.play.cards[1].base.id
				local _rank_suffix = card.ability.extra.rank
				if _rank_suffix < 10 then
					_rank_suffix = tostring(_rank_suffix)
				elseif _rank_suffix == 10 then
					_rank_suffix = "10"
				elseif _rank_suffix == 11 then
					_rank_suffix = "Jack"
				elseif _rank_suffix == 12 then
					_rank_suffix = "Queen"
				elseif _rank_suffix == 13 then
					_rank_suffix = "King"
				elseif _rank_suffix == 14 then
					_rank_suffix = "Ace"
				end
				crv.rankdis = _rank_suffix
			elseif card.ability.extra.suit == "N/A" then
				card.ability.extra.suit = G.play.cards[1].base.suit
				local _suit_suffix = tostring(card.ability.extra.suit)
				crv.suitdis = _suit_suffix
			elseif card.ability.extra.rank ~= "N/A" and card.ability.extra.suit ~= "N/A" then
				local rank_suffix = card.ability.extra.rank
				if rank_suffix < 10 then
					rank_suffix = tostring(rank_suffix)
				elseif rank_suffix == 10 then
					rank_suffix = "10"
				elseif rank_suffix == 11 then
					rank_suffix = "Jack"
				elseif rank_suffix == 12 then
					rank_suffix = "Queen"
				elseif rank_suffix == 13 then
					rank_suffix = "King"
				elseif rank_suffix == 14 then
					rank_suffix = "Ace"
				end
				local suit_suffix = tostring(card.ability.extra.suit)
				for i = 1, 3 do
					local acard = create_playing_card({
						front = G.P_CARDS[card.ability.extra.suit .. "_" .. card.ability.extra.rank],
						center = G.P_CENTERS.c_base,
					}, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
					SMODS.change_base(acard, suit_suffix, rank_suffix)
				end
				card.ability.extra.rank = "N/A"
				card.ability.extra.suit = "N/A"
				crv.rankdis = "N/A"
				crv.suitdis = "N/A"
			end
		end
		if card.ability.extra.rank ~= "N/A" and card.ability.extra.suit ~= "N/A" then
			local eval = function()
				return card.ability.extra.rank ~= "N/A" and card.ability.extra.suit ~= "N/A"
			end
			juice_card_until(card, eval, true)
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "mcycle",
	atlas = "Jokers2",
	rarity = 2,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 8,
		y = 5,
	},
	config = {
		extra = {
			plus = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.plus },
		}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.individual and not context.blueprint then
			if context.cardarea == G.play then
				context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
				context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + crv.plus
				return {
					message = localize("k_upgrade_ex"),
					colour = G.C.MULT,
					message_card = context.other_card,
				}
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})
local numbers = { 2, 3, 4, 5, 6, 7, 8, 9 }

SMODS.Joker({
	key = "safe",
	atlas = "Jokers2",
	rarity = 2,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 8,
		y = 6,
	},
	config = {
		extra = {
			unlocked = false,
			uu = "Locked",
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.uu, crv.d1, crv.d2, crv.d3, crv.d4, crv.unlocked },
		}
	end,
	add_to_deck = function(self, card, from_debuff)
		local crv = card.ability.extra
		local digitone = pseudorandom_element(numbers, pseudoseed("safe"))
		local digittwo = pseudorandom_element(numbers, pseudoseed("safe"))
		local digitthree = pseudorandom_element(numbers, pseudoseed("safe"))
		local digitfour = pseudorandom_element(numbers, pseudoseed("safe"))
		crv.d1 = digitone
		crv.d2 = digittwo
		crv.d3 = digitthree
		crv.d4 = digitfour
		card_eval_status_text(card, "extra", nil, nil, nil, { message = "Password Set!" })
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.end_of_round and context.main_eval and not context.blueprint and G.GAME.blind.boss then
			local digitone = pseudorandom_element(numbers, pseudoseed("safe"))
			local digittwo = pseudorandom_element(numbers, pseudoseed("safe"))
			local digitthree = pseudorandom_element(numbers, pseudoseed("safe"))
			local digitfour = pseudorandom_element(numbers, pseudoseed("safe"))
			crv.d1 = digitone
			crv.d2 = digittwo
			crv.d3 = digitthree
			crv.d4 = digitfour
			card_eval_status_text(card, "extra", nil, nil, nil, { message = "Reset!" })
		end
		if
			context.cardarea == G.play
			and #context.full_hand >= 4
			and not context.repetition
			and not context.individual
			and not context.blueprint
			and crv.unlocked == false
		then
			if
				G.play.cards[1].base.id == crv.d1
				and G.play.cards[2].base.id == crv.d2
				and G.play.cards[3].base.id == crv.d3
				and G.play.cards[4].base.id == crv.d4
			then
				crv.unlocked = true
				crv.uu = "Unlocked"
			end
		end
	end,
	calc_dollar_bonus = function(self, card)
		local crv = card.ability.extra
		if crv.unlocked == true then
			return 25
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "banker",
	atlas = "Jokers2",
	rarity = 2,
	cost = 0,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 8,
		y = 7,
	},
	config = {
		extra = {
			owe = 5,
			owe_limit = 100,
			current_dept = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.owe_limit, crv.owe, crv.current_dept },
		}
	end,
	add_to_deck = function(self, card, from_debuff)
		local crv = card.ability.extra
		card.ability.extra_value = -100 - card.sell_cost
		card:set_cost()
		ease_dollars(crv.owe_limit)
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			card.ability.extra_value = card.ability.extra_value + crv.owe
			crv.current_dept = crv.current_dept + crv.owe
			card:set_cost()
			ease_dollars(-crv.owe)
			card_eval_status_text(card, "dollars", -crv.owe)
			if crv.current_dept >= crv.owe_limit then
				card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
			end
		end
	end,
})

SMODS.Joker({
	key = "crem",
	config = {
		extra = {
			odds = 4,
			xmultadd = 0.5,
		},
	},
	rarity = 3,
	atlas = "Jokers2",
	blueprint_compat = false,
	discovered = false,
	pos = {
		x = 0,
		y = 8,
	},
	cost = 7,
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.xmultadd + 1, (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.repetition and not context.blueprint then
			context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult or 0
			context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult
				+ card.ability.extra.xmultadd
			return {
				message = localize("k_upgrade_ex"),
				colour = G.C.MULT,
			}
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and pseudorandom("crem") < G.GAME.probabilities.normal / card.ability.extra.odds
		then
			return {
				remove = true,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "bee",
	atlas = "Jokers2",
	rarity = 1,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 1,
		y = 8,
	},
	config = {
		extra = {
			a = 1,
			dollars = 5,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_honey
		return {
			vars = { card.ability.extra.dollars },
		}
	end,
	calculate = function(self, card, context)
		if context.individual then
			if context.cardarea == G.play then
				for k, v in ipairs(context.scoring_hand) do
					if SMODS.has_enhancement(v, "m_crv_honey") then
						if context.other_card.ability.effect == "Base" and card.ability.extra.a == 1 then
							context.other_card:set_ability(G.P_CENTERS["m_crv_honey"])
						end
					end
				end
			end
		end
		if context.joker_main then
			return {
				dollars = card.ability.extra.dollars,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "oldjimbo",
	atlas = "Jokers2",
	rarity = 4,
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 3,
		y = 8,
	},
	soul_pos = {
		x = 4,
		y = 8,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.dollars },
		}
	end,
	calculate = function(self, card, context)
		if card.area then
			SMODS.Stickers["eternal"]:apply(card, true)
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		SMODS.add_card({
			set = "Joker",
			area = G.jokers,
			key = "j_crv_adamap",
		})
		SMODS.Stickers["eternal"]:apply(card, true)
	end,
})

local card_highlighted_ref = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and string.find(self.ability.name, "j_crv_adamap") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.eat(self, {
				sell = true,
				use = true,
			}),
			config = {
				align = "cr",
				offset = {
					x = -0.4,
					y = 0,
				},
				parent = self,
			},
		})
	else
		card_highlighted_ref(self, is_highlighted)
	end
end

RevosVault.eat = function(card, args)
	local args = args or {}
	local sell = nil
	local use = nil

	if args.sell then
		sell = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						hover = true,
						shadow = true,
						colour = G.C.UI.BACKGROUND_INACTIVE,
						one_press = true,
						button = "sell_card",
						func = "can_sell_card",
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = 0.1,
								h = 0.6,
							},
						},
						{
							n = G.UIT.C,
							config = {
								align = "tm",
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										maxw = 1.25,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("b_sell"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.4,
												shadow = true,
											},
										},
									},
								},
								{
									n = G.UIT.R,
									config = {
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("$"),
												colour = G.C.WHITE,
												scale = 0.4,
												shadow = true,
											},
										},
										{
											n = G.UIT.T,
											config = {
												ref_table = card,
												ref_value = "sell_cost_label",
												colour = G.C.WHITE,
												scale = 0.55,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	if args.use then
		use = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_eaten",
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = 0.1,
								h = 0.6,
							},
						},
						{
							n = G.UIT.C,
							config = {
								align = "tm",
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										maxw = 1.25,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("crv_eat"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.8,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	return {
		n = G.UIT.ROOT,
		config = {
			align = "cr",
			padding = 0,
			colour = G.C.CLEAR,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					padding = 0.15,
					align = "cl",
				},
				nodes = {
					sell and {
						n = G.UIT.R,
						config = {
							align = "cl",
						},
						nodes = { sell },
					} or nil,
					use and {
						n = G.UIT.R,
						config = {
							align = "cl",
						},
						nodes = { use },
					} or nil,
				},
			},
		},
	}
end

G.FUNCS.crv_eaten = function(e)
	local card = e.config.ref_table
	card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
	if #SMODS.find_card("j_crv_oldjimbo") > 0 then
		for i = 1, #SMODS.find_card("j_crv_oldjimbo") do
			SMODS.find_card("j_crv_oldjimbo")[1]:start_dissolve()
		end
	end
	if G.STATE ~= G.STATES.SELECTING_HAND then
		return
	end
	G.GAME.chips = G.GAME.blind.chips
	G.STATE = G.STATES.HAND_PLAYED
	G.STATE_COMPLETE = true
	end_round()
end

SMODS.Joker({
	key = "adamap",
	atlas = "Jokers2",
	rarity = 4,
	cost = 0,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 5,
		y = 8,
	},
	soul_pos = {
		x = 6,
		y = 8,
	},
	config = {
		extra = {
			xmult = 3,
		},
	},
	pools = {
		Food = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Joker({
	key = "fuj",
	config = {
		extra = {
			xmult = 8.01,
			check = 0,
			check1 = 0,
		},
	},
	rarity = 3,
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 2,
		y = 8,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main then
			for k, v in ipairs(context.scoring_hand) do
				if v:get_id() == 13 then
					crv.check = 1
				end
			end
			for k, v in ipairs(context.scoring_hand) do
				if v:get_id() == 11 then
					crv.check1 = 1
				end
			end
			if crv.check >= 1 and crv.check1 >= 1 then
				return {
					xmult = crv.xmult,
				}
			end
		end
		if context.final_scoring_step then
			crv.check = 0
			crv.check1 = 0
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "tab",
	config = {
		extra = {
			stored = 0,
		},
	},
	rarity = 2,
	atlas = "Jokers2",
	blueprint_compat = false,
	discovered = false,
	pos = {
		x = 7,
		y = 8,
	},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.stored },
		}
	end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + 1
		calculate_reroll_cost(true)
	end,
	remove_from_deck = function(self, card, from_debuff)
		local crv = card.ability.extra
		ease_dollars(-crv.stored)
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.reroll_shop and not context.blueprint and not context.repetition then
			G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + 1
			calculate_reroll_cost(true)
			crv.stored = crv.stored + 5
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "rkn",
	config = {
		extra = {
			xmult = 5,
			discard = 4,
			check = "NXD",
			xmult2 = 5,
			xmultg = 2,
			cardc = 3,
		},
	},
	rarity = 4,
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 0,
		y = 9,
	},
	soul_pos = {
		x = 1,
		y = 9,
	},
	cost = 20,
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.xmult, crv.discard, crv.xmult2, crv.xmultg, crv.cardc },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main and (#SMODS.find_card("j_chicot") > 0) and G.GAME.blind.boss then
			return {
				x_mult = crv.xmult,
			}
		elseif context.joker_main then
			if
				(#SMODS.find_card("j_chicot") > 0)
				or (#SMODS.find_card("j_perkeo") > 0)
				or (#SMODS.find_card("j_triboulet") > 0)
				or (#SMODS.find_card("j_yorick") > 0)
				or (#SMODS.find_card("j_caino") > 0)
			then
				return
			else
				return {
					x_mult = crv.xmult2,
				}
			end
		end
		if context.destroy_card and context.cardarea == G.play then
			if #SMODS.find_card("j_caino") > 0 then
				if context.destroy_card:is_face() then
					return {
						message = "For Canio!",
					}
				end
			end
		end
		if context.ending_shop and (#SMODS.find_card("j_perkeo") > 0) then
			if G.consumeables.cards[1] then
				G.E_MANAGER:add_event(Event({
					func = function()
						local card = copy_card(pseudorandom_element(G.consumeables.cards, pseudoseed("rkn")), nil)
						card:set_edition({ negative = true }, true)
						card:add_to_deck()
						G.consumeables:emplace(card)
						return true
					end,
				}))
				card_eval_status_text(card, "extra", nil, nil, nil, { message = "For Perkeo!" })
			end
			return
		end
		if context.setting_blind and (#SMODS.find_card("j_triboulet") > 0) then
			local faces = { "Queen", "King" }
			local suits = pseudorandom_element(SMODS.Suits, pseudoseed("rkn"))
			local suit = tostring(suits)
			local rank = pseudorandom_element(faces, pseudoseed("rkn"))
			for i = 1, crv.cardc do
				local acard = create_playing_card({
					front = G.P_CARDS[suit .. "_" .. rank],
					center = G.P_CENTERS.c_base,
				}, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
				SMODS.change_base(acard, nil, rank)
			end
		end
		if context.setting_blind and (#SMODS.find_card("j_yorick") > 0) then
			ease_discard(card.ability.extra.discard)
			crv.check = "EXD"
		end
		if context.end_of_round and G.GAME.blind.boss and context.main_eval and (#SMODS.find_card("j_chicot") > 0) then
			crv.xmult = crv.xmult + crv.xmultg
			if crv.check == "EXD" then
				crv.check = "NXD"
				G.GAME.round_resets.discards = G.GAME.round_resets.discards
				return {
					message = "Upgrade!",
				}
			end
		elseif context.end_of_round and context.main_eval then
			if crv.check == "EXD" then
				crv.check = "NXD"
				G.GAME.round_resets.discards = G.GAME.round_resets.discards
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		if
			(#SMODS.find_card("j_chicot") > 0)
			or (#SMODS.find_card("j_perkeo") > 0)
			or (#SMODS.find_card("j_triboulet") > 0)
			or (#SMODS.find_card("j_yorick") > 0)
			or (#SMODS.find_card("j_caino") > 0)
		then
			return true
		else
			return false
		end
	end,
})

SMODS.Joker({
	key = "themoon",
	atlas = "Jokers2",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 2,
		y = 9,
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
		if context.final_scoring_step and not context.blueprint then
			if context.cardarea then
				for k, v in ipairs(context.scoring_hand) do
					if v:is_suit("Hearts", true) then
						v:flip()
						SMODS.change_base(v, "Spades", nil)
						v:flip()
					end
					if v:is_suit("Diamonds", true) then
						v:flip()
						SMODS.change_base(v, "Clubs", nil)
						v:flip()
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
	key = "spin",
	atlas = "Jokers2",
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 3,
		y = 9,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,
	add_to_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit + 1
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - 1
	end,

	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			context.other_card:flip()
			context.other_card:flip()
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "thenightrose",
	atlas = "Jokers2",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 4,
		y = 9,
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
		if context.final_scoring_step and not context.blueprint then
			if context.cardarea then
				for k, v in ipairs(context.scoring_hand) do
					if v:is_suit("Spades", true) then
						v:flip()
						SMODS.change_base(v, "Hearts", nil)
						v:flip()
					end
					if v:is_suit("Clubs", true) then
						v:flip()
						SMODS.change_base(v, "Diamonds", nil)
						v:flip()
					end
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

local card_highlighted_ref = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and string.find(self.ability.name, "j_crv_invest") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.investment(self, {
				sell = true,
				use = true,
			}),
			config = {
				align = "cr",
				offset = {
					x = -0.4,
					y = 0,
				},
				parent = self,
			},
		})
	else
		card_highlighted_ref(self, is_highlighted)
	end
end

RevosVault.investment = function(card, args)
	local args = args or {}
	local sell = nil
	local use = nil

	if args.sell then
		sell = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						hover = true,
						shadow = true,
						colour = G.C.UI.BACKGROUND_INACTIVE,
						one_press = true,
						button = "sell_card",
						func = "can_sell_card",
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = 0.1,
								h = 0.6,
							},
						},
						{
							n = G.UIT.C,
							config = {
								align = "tm",
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										maxw = 1.25,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("b_sell"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.4,
												shadow = true,
											},
										},
									},
								},
								{
									n = G.UIT.R,
									config = {
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("$"),
												colour = G.C.WHITE,
												scale = 0.4,
												shadow = true,
											},
										},
										{
											n = G.UIT.T,
											config = {
												ref_table = card,
												ref_value = "sell_cost_label",
												colour = G.C.WHITE,
												scale = 0.55,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	if args.use then
		use = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_invest",
						func = "crv_can_invest",
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = 0.1,
								h = 0.6,
							},
						},
						{
							n = G.UIT.C,
							config = {
								align = "tm",
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										maxw = 1.25,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("crv_invest"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.6,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	return {
		n = G.UIT.ROOT,
		config = {
			align = "cr",
			padding = 0,
			colour = G.C.CLEAR,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					padding = 0.15,
					align = "cl",
				},
				nodes = {
					sell and {
						n = G.UIT.R,
						config = {
							align = "cl",
						},
						nodes = { sell },
					} or nil,
					use and {
						n = G.UIT.R,
						config = {
							align = "cl",
						},
						nodes = { use },
					} or nil,
				},
			},
		},
	}
end

G.FUNCS.crv_invest = function(e) -- i am way to lazy to fix this right now. I will fix it later.................................................................
	local card = e.config.ref_table
	if card.ability.extra["check"] == false then
		card.ability.extra["check"] = true
		if G.GAME.talisman == 1 then
			card.ability.extra["invested"] = to_number(G.GAME.dollars / 4)
			ease_dollars(-(to_number(G.GAME.dollars / 4)))
		else
			card.ability.extra["invested"] = G.GAME.dollars / 4
			ease_dollars(-(G.GAME.dollars / 4))
		end
	end
end

G.FUNCS.crv_can_invest = function(e)
	local card = e.config.ref_table
	if card.ability.extra["check"] == false then
		e.config.colour = G.C.RED
		e.config.button = "crv_invest"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

SMODS.Joker({
	key = "invest",
	atlas = "Jokers2",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 5,
		y = 9,
	},
	config = {
		extra = {
			card = 1,
			check = false,
			timer = 0,
			invested = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.card, crv.check, crv.timer, crv.invested },
		}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if crv.check == true then
			if context.end_of_round and context.main_eval and not context.blueprint and crv.timer < 3 then
				crv.timer = crv.timer + 1
			elseif context.end_of_round and context.main_eval and not context.blueprint then
				crv.check = false
				crv.timer = 0

				if crv.invested <= 5 then
					SMODS.add_card({
						set = "Joker",
						area = G.jokers,
						rarity = 0,
					})
					crv.invested = 0
				elseif crv.invested > 5 and crv.invested <= 10 then
					SMODS.add_card({
						set = "Joker",
						area = G.jokers,
						rarity = 0.95,
					})
					crv.invested = 0
				elseif crv.invested > 10 and crv.invested <= 15 then
					SMODS.add_card({
						set = "Joker",
						area = G.jokers,
						rarity = 3,
					})
					crv.invested = 0
				elseif crv.invested > 15 and crv.invested <= 20 then
					SMODS.add_card({
						set = "Joker",
						area = G.jokers,
						legendary = true,
					})
					crv.invested = 0
				elseif crv.invested > 20 then
					SMODS.add_card({
						set = "Joker",
						area = G.jokers,
						legendary = true,
						edition = "e_negative",
					})
					crv.invested = 0
				end
			end
		end
		if card.ability.extra.timer >= 3 then
			local eval = function()
				return card.ability.extra.timer >= 3
			end
			juice_card_until(card, eval, true)
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "ihavenoidea",
	atlas = "Jokers2",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 6,
		y = 9,
	},
	config = {
		extra = {
			requirement = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.requirement },
		}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.setting_blind and G.GAME.blind.boss and not context.blueprint then
			G.GAME.blind.chips = G.GAME.blind.chips * 2
			G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
			card:juice_up(0.3, 0.4)
			return {
				message = "Blind Doubled",
			}
		end
		if
			context.end_of_round
			and context.main_eval
			and G.GAME.blind.boss
			and not context.blueprint
			and crv.requirement < 3
		then
			crv.requirement = crv.requirement + 1
		elseif context.end_of_round and context.main_eval and not context.blueprint and crv.requirement >= 3 then
			SMODS.add_card({
				set = "Joker",
				area = G.jokers,
				legendary = true,
			})
			card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
		end
		if crv.requirement >= 3 then
			local eval = function()
				return crv.requirement >= 3
			end
			juice_card_until(card, eval, true)
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "ycard",
	atlas = "Jokers2",
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 8,
		y = 9,
	},
	config = {
		extra = {
			chips = 0,
			chipg = 5,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.chips, crv.chipg },
		}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.open_booster then
			if not context.blueprint then
				crv.chips = crv.chips + crv.chipg
				G.E_MANAGER:add_event(Event({
					func = function()
						card_eval_status_text(card, "extra", nil, nil, nil, {
							message = localize({ type = "variable", key = "a_mult", vars = { crv.chipg } }),
							colour = G.C.CHIPS,
							delay = 0.45,
							card = self,
						})
						return true
					end,
				}))
			end
		end
		if context.joker_main then
			return {
				chips = crv.chips,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "stamp",
	atlas = "Jokers2",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 9,
		y = 0,
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
		if context.individual and not context.blueprint then
			if context.cardarea == G.play then
				for k, v in ipairs(context.scoring_hand) do
					if context.other_card.ability.seal == nil then
						context.other_card:juice_up(0.3, 0.4)
						context.other_card:set_seal(
							SMODS.poll_seal({
								guaranteed = true,
							}),
							true,
							false
						)
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
	key = "cotn",
	atlas = "Jokers2",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 9,
		y = 1,
	},
	config = {
		extra = {
			xmult = 1,
			xmultg = 0.1,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmultg, card.ability.extra.xmult },
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			local rr = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					rr = i
					break
				end
			end
			if G.jokers.cards[rr + 1] ~= nil and not G.jokers.cards[rr + 1].ability.crv_vamp then
				SMODS.Stickers["crv_vamp"]:apply(G.jokers.cards[rr + 1], true)
				card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultg
			end
		end
		if context.joker_main then
			return {
				xmult = card.ability.xmult,
			}
		end
		if context.before then
			for k, v in ipairs(G.play.cards) do
				if v:is_suit("Hearts", true) then
					card.ability.extra.xmultg = card.ability.extra.xmultg + 0.1
				end
				return {
					message = localize("k_upgrade_ex"),
				}
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "mon",
	atlas = "Jokers2",
	rarity = 3,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 9,
		y = 2,
	},
	config = {
		extra = {
			stored = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.stored },
		}
	end,

	calculate = function(self, card, context)
		if context.starting_shop and not context.blueprint and not context.repetition then
			G.E_MANAGER:add_event(Event({
				func = function()
					G.GAME.discount_percent = card.ability.extra.stored
					for k, v in pairs(G.I.CARD) do
						if v.set_cost then
							v:set_cost()
						end
					end

					return true
				end,
			}))
		end
		if
			G.GAME.current_round.hands_played >= 0
			and G.GAME.current_round.hands_played <= 1
			and context.end_of_round
			and context.main_eval
			and not context.blueprint
		then
			card.ability.extra.stored = card.ability.extra.stored + 5
			return {
				message = localize("k_upgrade_ex"),
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "maz",
	atlas = "Jokers2",
	rarity = 3,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 9,
		y = 3,
	},
	config = {
		extra = {
			xmult = 1,
			xmultg = 1.5,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.xmultg },
		}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.setting_blind and not context.repetition and not context.blueprint then
			local jokers = {}
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] ~= card and G.jokers.cards[i].debuff == false then
					jokers[#jokers + 1] = G.jokers.cards[i]
				end
			end
			if #jokers > 0 then
				if not context.blueprint then
					local chosen_joker = pseudorandom_element(jokers, pseudoseed("ml"))
					SMODS.debuff_card(chosen_joker, true, card.config.center.key)
					crv.xmult = crv.xmult + crv.xmultg
					return {
						message = "Painful!",
					}
				end
			end
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
	key = "bocchi",
	atlas = "Jokers2",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 9,
		y = 4,
	},
	config = {
		extra = {
			xmult = 1,
			allcards = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.allcards, card.ability.extra.xmult },
		}
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			local all_cards = 0
			for k, v in ipairs(G.hand.cards) do
				all_cards = all_cards + 1
				card.ability.extra.allcards = all_cards
			end
			if all_cards > 1 then
				return {
					xmult = card.ability.extra.xmult * card.ability.extra.allcards,
				}
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "jhaunted",
	atlas = "Jokers2",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 9,
		y = 5,
	},
	config = {
		extra = {
			cards = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.cards },
		}
	end,

	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			local jokers = {}
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] ~= card then
					jokers[#jokers + 1] = G.jokers.cards[i]
				end
			end
			if #jokers > 0 then
				if #G.jokers.cards <= G.jokers.config.card_limit then
					card_eval_status_text(
						context.blueprint_card or card,
						"extra",
						nil,
						nil,
						nil,
						{ message = localize("k_duplicated_ex") }
					)
					local chosen_joker = pseudorandom_element(jokers, pseudoseed("haunted"))
					local card2 =
						copy_card(chosen_joker, nil, nil, nil, chosen_joker.edition and chosen_joker.edition.negative)
					SMODS.Stickers["crv_haunted"]:apply(card2, true)
					card2:add_to_deck()
					G.jokers:emplace(card2)
				else
					card_eval_status_text(
						context.blueprint_card or card,
						"extra",
						nil,
						nil,
						nil,
						{ message = localize("k_no_room_ex") }
					)
				end
			else
				card_eval_status_text(
					context.blueprint_card or card,
					"extra",
					nil,
					nil,
					nil,
					{ message = localize("k_no_other_jokers") }
				)
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

local card_highlighted_ref = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and string.find(self.ability.name, "j_crv_roulj") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.betchange(self, {
				sell = true,
				use = true,
			}),
			config = {
				align = "cr",
				offset = {
					x = -0.4,
					y = 0,
				},
				parent = self,
			},
		})
	else
		card_highlighted_ref(self, is_highlighted)
	end
end

RevosVault.betchange = function(card, args)
	local args = args or {}
	local sell = nil
	local use = nil

	if args.sell then
		sell = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						hover = true,
						shadow = true,
						colour = G.C.UI.BACKGROUND_INACTIVE,
						one_press = true,
						button = "sell_card",
						func = "can_sell_card",
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = 0.1,
								h = 0.6,
							},
						},
						{
							n = G.UIT.C,
							config = {
								align = "tm",
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										maxw = 1.25,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("b_sell"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.4,
												shadow = true,
											},
										},
									},
								},
								{
									n = G.UIT.R,
									config = {
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("$"),
												colour = G.C.WHITE,
												scale = 0.4,
												shadow = true,
											},
										},
										{
											n = G.UIT.T,
											config = {
												ref_table = card,
												ref_value = "sell_cost_label",
												colour = G.C.WHITE,
												scale = 0.55,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	if args.use then
		use = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_changebet",
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = 0.1,
								h = 0.6,
							},
						},
						{
							n = G.UIT.C,
							config = {
								align = "tm",
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										maxw = 1.25,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("crv_change"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.4,
												shadow = true,
											},
										},
									},
								},
								{
									n = G.UIT.R,
									config = {
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("crv_bet"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.5,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	return {
		n = G.UIT.ROOT,
		config = {
			align = "cr",
			padding = 0,
			colour = G.C.CLEAR,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					padding = 0.15,
					align = "cl",
				},
				nodes = {
					sell and {
						n = G.UIT.R,
						config = {
							align = "cl",
						},
						nodes = { sell },
					} or nil,
					use and {
						n = G.UIT.R,
						config = {
							align = "cl",
						},
						nodes = { use },
					} or nil,
				},
			},
		},
	}
end

G.FUNCS.crv_changebet = function(e)
	local card = e.config.ref_table
	if card.ability.extra["bet"] == "Black" then
		card.ability.extra["bet"] = "Red"
	elseif card.ability.extra["bet"] == "Red" then
		card.ability.extra["bet"] = "Green"
	elseif card.ability.extra["bet"] == "Green" then
		card.ability.extra["bet"] = "Black"
	end
end

-- find a way to localize this
local bets = { "Black", "Green", "Red" }
SMODS.Joker({
	key = "roulj",
	config = {
		extra = {
			bet = "Black",
			max = 20,
			odds = 100,
			green = 500,
		},
	},
	rarity = 3,
	atlas = "Jokers2",
	blueprint_compat = false,
	discovered = false,
	no_collection = false,
	pos = {
		x = 9,
		y = 7,
	},
	cost = 10,
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.bet, G.GAME.probabilities.normal, crv.odds, crv.green, crv.max },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.end_of_round and context.main_eval and not context.blueprint then
			if crv.bet == "Green" then
				if pseudorandom("roulj") < G.GAME.probabilities.normal / card.ability.extra.odds then
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.4,
						func = function()
							play_sound("timpani")
							ease_dollars(crv.green)
							return true
						end,
					}))
					return {
						message = localize("k_crv_jackpot"),
					}, delay(0.6)
				else
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.4,
						func = function()
							play_sound("timpani")
							ease_dollars(-(math.max(0, math.min(G.GAME.dollars, crv.max))), true)
							return true
						end,
					}))
					return {
						message = localize("k_crv_lost"),
					}, delay(0.6)
				end
			end
			if crv.bet ~= "Green" then
				local chosenbet = pseudorandom_element(bets, pseudoseed("roulj"))
				if crv.bet == chosenbet then
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.4,
						func = function()
							play_sound("timpani")
							ease_dollars(math.max(0, math.min(G.GAME.dollars, crv.max)), true)
							return true
						end,
					}))
					return {
						message = localize("k_crv_won"),
					}, delay(0.6)
				else
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.4,
						func = function()
							play_sound("timpani")
							ease_dollars(-(math.max(0, math.min(G.GAME.dollars, crv.max))), true)
							return true
						end,
					}))
					return {
						message = localize("k_crv_lost"),
					}, delay(0.6)
				end
			end
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "nyancat",
	atlas = "Jokers2",
	rarity = 3,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 9,
		y = 8,
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
		if context.final_scoring_step and not context.blueprint then
			if context.cardarea then
				for k, v in ipairs(context.scoring_hand) do
					if not v.edition and not v.ability.polychrome then
						G.E_MANAGER:add_event(Event({
							func = function()
								if not v.edition and not v.ability.polychrome then
									v:juice_up(0.3, 0.4)
									v:set_edition({ polychrome = true }, true)
									return true
								end
							end,
						}))
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
	key = "mathness",
	atlas = "Jokers2",
	rarity = 3,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 10,
		y = 0,
	},
	config = {
		extra = {
			odds = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { G.GAME.probabilities.normal, crv.odds, crv.xmultg, crv.xmult },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.setting_blind and not context.blueprint then
			local jokers = {}
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] ~= card and not G.jokers.cards[i].ability.crv_absolute then
					jokers[#jokers + 1] = G.jokers.cards[i]
				end
			end
			if #jokers > 0 then
				if not context.blueprint then
					local chosen_joker = pseudorandom_element(jokers, pseudoseed("mathness"))
					if pseudorandom("mathness") < G.GAME.probabilities.normal / crv.odds then
						SMODS.Stickers["crv_absolute"]:apply(chosen_joker, true)
					else
						chosen_joker:start_dissolve({ HEX("57ecab") }, nil, 1.6)
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
	key = "radtank",
	atlas = "Jokers2",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 10,
		y = 1,
	},
	config = {
		extra = {
			gain = 15,
			stored = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.gain, card.ability.extra.stored },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.end_of_round and context.main_eval and not context.blueprint then
			local rr = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					rr = i
					break
				end
			end
			local lc = { "Left", "Right" }
			local choosencard = pseudorandom_element(lc, pseudoseed("radtank"))
			if
				choosencard == "Left"
				and G.jokers.cards[rr - 1] ~= nil
				and not G.jokers.cards[rr - 1].ability.crv_radioactive
			then
				SMODS.Stickers["crv_radioactive"]:apply(G.jokers.cards[rr - 1], true)
				crv.stored = crv.stored + crv.gain
			elseif
				choosencard == "Right"
				and G.jokers.cards[rr + 1] ~= nil
				and not G.jokers.cards[rr + 1].ability.crv_radioactive
			then
				SMODS.Stickers["crv_radioactive"]:apply(G.jokers.cards[rr + 1], true)
				crv.stored = crv.stored + crv.gain
			end
		end
		if context.selling_self then
			return {
				dollars = crv.stored,
			}
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

--[[SMODS.Joker({
	key = "again",
	atlas = "Jokers2",
	rarity = 3,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 10,
		y = 4,
	},
	config = {
		extra = {
			repet = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.repet },
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			local random_key = rkeys[math.random(#rkeyshalf)]
			if (random_key == "5") and not context.repetition and not context.individual then
				SMODS.restart_game()
			end
		end
		if context.repetition and context.cardarea == G.play then
			return {
				repetitions = card.ability.extra.repet,
			}
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

local aeae = { 1, 2, 3, 4 }
SMODS.Joker({
	key = "disorder",
	atlas = "Jokers2",
	rarity = 3,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 10,
		y = 5,
	},
	config = {
		extra = {
			xmult = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			local random_key = rkeys[math.random(#aeae)]
			if (random_key == "4") and not context.repetition and not context.individual then
				SMODS.restart_game()
				SMODS.restart_game()
			end
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})]]

SMODS.Joker({
	key = "ketchup",
	atlas = "Jokers2",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 10,
		y = 8,
	},
	config = {
		extra = {
			mult = 25,
			xmult = 2,
		},
	},
	pools = {
		Food = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.mult, card.ability.extra.xmult },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main and (#SMODS.find_card("j_crv_mayo") == 0) then
			return {
				mult = card.ability.extra.mult,
			}
		elseif context.joker_main and (#SMODS.find_card("j_crv_mayo") > 0) then
			return {
				mult = card.ability.extra.mult,
				xmult = card.ability.extra.xmult,
			}
		end
	end,
})
SMODS.Joker({
	key = "mayo",
	atlas = "Jokers2",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 10,
		y = 7,
	},
	config = {
		extra = {
			chips = 50,
			xchips = 2,
		},
	},
	pools = {
		Food = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.chips, card.ability.extra.xchips },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main and (#SMODS.find_card("j_crv_ketchup") == 0) then
			return {
				chips = card.ability.extra.chips,
			}
		elseif context.joker_main and (#SMODS.find_card("j_crv_ketchup") > 0) then
			return {
				chips = card.ability.extra.chips,
				xchips = card.ability.extra.xchips,
			}
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "shjoker",
	atlas = "Jokers2",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
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
		if context.joker_main then
			return {
				mult = card.ability.extra.mult,
			}
		end
	end,
	draw = function(self, card, layer)
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
	key = "kitf",
	atlas = "Jokers2",
	rarity = 3,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 2,
		y = 10,
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
		if context.final_scoring_step then
			if context.cardarea then
				for k, v in ipairs(G.hand.cards) do
					G.E_MANAGER:add_event(Event({
						trigger = "before",
						delay = 0.5,
						func = function()
							if v.base.id > 13 then
								v:flip()
								play_sound("card1")
								v:juice_up(0.3, 0.4)
								assert(SMODS.modify_rank(v, -1))
							elseif v.base.id < 13 then
								v:flip()
								play_sound("card1")
								v:juice_up(0.3, 0.4)
								assert(SMODS.modify_rank(v, 1))
							elseif v.base.id == 13 then
								v:flip()
								play_sound("card1")
							end
							return true
						end,
					}))
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 1,
						func = function()
							v:flip()
							v:juice_up(0.3, 0.4)
							return true
						end,
					}))
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "mycard",
	atlas = "Jokers2",
	rarity = 1,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,

	pos = {
		x = 3,
		y = 10,
	},
	config = {
		extra = {
			mult = 1,
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
				mult = card.ability.extra.mult,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "those",
	atlas = "Jokers2",
	rarity = 3,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,

	pos = {
		x = 5,
		y = 10,
	},
	config = {
		extra = {
			odds = 4,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.odds, (G.GAME.probabilities.normal or 1) },
		}
	end,

	calculate = function(self, card, context)
		if context.setting_blind and pseudorandom("those") < card.ability.extra.odds / G.GAME.probabilities.normal then
			SMODS.add_card({
				key = "j_mr_bones",
				area = G.jokers,
			})
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "acee",
	atlas = "Jokers2",
	rarity = 3,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,

	pos = {
		x = 7,
		y = 10,
	},
	config = {
		extra = {
			rep = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.rep },
		}
	end,

	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and context.other_card:get_id() == 14 then
			return {
				repetitions = card.ability.extra.rep,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "eyes",
	atlas = "Jokers2",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,

	pos = {
		x = 8,
		y = 10,
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
		if context.setting_blind and not context.blueprint then
			local rr = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					rr = i
					break
				end
			end
			if G.jokers.cards[rr - 1] ~= nil and G.jokers.cards[rr + 1] ~= nil or self.area == G.jokers then
				G.jokers.cards[rr - 1]:start_dissolve({ HEX("57ecab") }, nil, 1.6)
				local copied = copy_card(G.jokers.cards[rr + 1], nil)
				copied:add_to_deck()
				G.jokers:emplace(copied)
				card_eval_status_text(card, "extra", nil, nil, nil, { message = "Copied!" })
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "asc",
	atlas = "Jokers2",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,

	pos = {
		x = 9,
		y = 10,
	},
	config = {
		extra = {
			multg = 5,
			mult = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		if G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral > 0 then
			return {
				vars = {
					card.ability.extra.multg,
					(card.ability.extra.mult + (G.GAME.consumeable_usage_total.spectral * card.ability.extra.multg)),
				},
			}
		else
			return {
				vars = { card.ability.extra.multg, card.ability.extra.mult },
			}
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral > 0 then
				return {
					mult = (G.GAME.consumeable_usage_total.spectral * card.ability.extra.multg),
				}
			else
				return {
					mult = card.ability.extra.mult,
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "addiction",
	atlas = "Jokers2",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 4,
		y = 11,
	},
	config = {
		extra = {
			mult = 3,
			odds = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.mult, card.ability.extra.odds, (G.GAME.probabilities.normal or 1) },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main and pseudorandom("addiction") < G.GAME.probabilities.normal / card.ability.extra.odds then
			card.ability.extra.odds = card.ability.extra.odds + 1
			return {
				xmult = card.ability.extra.mult,
			}
		end
		if context.end_of_round and G.GAME.blind.boss then
			card.ability.extra.odds = 1
		end
	end,
})

SMODS.Joker({
	key = "shm",
	atlas = "Jokers2",
	rarity = 2,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 10,
		y = 10,
	},
	config = {
		extra = {
			interest = 3,
			ssize = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.interest, crv.ssize },
		}
	end,
	add_to_deck = function(self, card, from_debuff)
		local crv = card.ability.extra
		change_shop_size(crv.ssize)
	end,
	remove_from_deck = function(self, card, from_debuff)
		local crv = card.ability.extra
		change_shop_size(-crv.ssize)
	end,
})

SMODS.Joker({
	key = "ec",
	atlas = "Jokers2",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 0,
		y = 11,
	},
	config = {
		extra = {
			dollars = 3,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.dollars },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.individual and context.cardarea == G.play then
			if not context.other_card:is_face() then
				return {
					dollars = crv.dollars,
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "ev",
	atlas = "Jokers2",
	rarity = 2,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 1,
		y = 11,
	},
	config = {
		extra = {
			mult = 3,
			chips = 6,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.mult, crv.chips },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_face() then
				return {
					mult = crv.mult,
				}
			else
				return {
					chips = crv.chips,
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "teen",
	atlas = "Jokers2",
	rarity = 2,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 3,
		y = 11,
	},
	config = {
		extra = {
			rep = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.rep },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.repetition and context.cardarea == G.play then
			if context.other_card:get_id() == 11 then
				return {
					repetitions = crv.rep,
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "evt",
	atlas = "Jokers2",
	rarity = 2,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 2,
		y = 11,
	},
	config = {
		extra = {
			xmult = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.xmult },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.individual and context.cardarea == G.play then
			if context.full_hand[1]:get_id() == 10 then
				if context.individual then
					return {
						xmult = crv.xmult,
					}
				end
			end
		end
	end,
})

SMODS.Joker({
	key = "aon",
	atlas = "Jokers2",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 1,
		y = 12,
	},
	config = {
		extra = {
			chips = 50,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.chips },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main then
			local fc = 0
			for k, v in ipairs(context.scoring_hand) do
				if v:is_face() then
					fc = fc + 1
				end
			end
			if fc > 0 then
				return {
					chips = crv.chips * fc,
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "mature",
	atlas = "Jokers2",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 0,
		y = 12,
	},
	config = {
		extra = {
			mult = 0,
			multg = 5,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.mult, crv.multg },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.remove_playing_cards then
			crv.mult = crv.mult + crv.multg
		end
		if context.end_of_round and context.main_eval and G.GAME.blind.boss then
			crv.mult = 0
			return {
				message = "Reset!",
			}
		end
		if context.joker_main then
			return {
				mult = crv.mult,
			}
		end
	end,
})

local card_highlighted_ref = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and string.find(self.ability.name, "j_crv_dealb") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.create_sell_and_switch_buttonsss(self, {
				sell = true,
				use = true,
			}),
			config = {
				align = "cr",
				offset = {
					x = -0.4,
					y = 0,
				},
				parent = self,
			},
		})
	else
		card_highlighted_ref(self, is_highlighted)
	end
end

RevosVault.create_sell_and_switch_buttonsss = function(card, args)
	local args = args or {}
	local sell = nil
	local use = nil

	if args.sell then
		sell = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						hover = true,
						shadow = true,
						colour = G.C.UI.BACKGROUND_INACTIVE,
						one_press = true,
						button = "sell_card",
						func = "can_sell_card",
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = 0.1,
								h = 0.6,
							},
						},
						{
							n = G.UIT.C,
							config = {
								align = "tm",
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										maxw = 1.25,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("b_sell"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.4,
												shadow = true,
											},
										},
									},
								},
								{
									n = G.UIT.R,
									config = {
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("$"),
												colour = G.C.WHITE,
												scale = 0.4,
												shadow = true,
											},
										},
										{
											n = G.UIT.T,
											config = {
												ref_table = card,
												ref_value = "sell_cost_label",
												colour = G.C.WHITE,
												scale = 0.55,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	if args.use then
		use = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_half",
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = 0.1,
								h = 0.6,
							},
						},
						{
							n = G.UIT.C,
							config = {
								align = "tm",
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										maxw = 1.25,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("k_half_crv"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.4,
												shadow = true,
											},
										},
									},
								},
								{
									n = G.UIT.R,
									config = {
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("k_hblind_crv"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.5,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	return {
		n = G.UIT.ROOT,
		config = {
			align = "cr",
			padding = 0,
			colour = G.C.CLEAR,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					padding = 0.15,
					align = "cl",
				},
				nodes = {
					sell and {
						n = G.UIT.R,
						config = {
							align = "cl",
						},
						nodes = { sell },
					} or nil,
					use and {
						n = G.UIT.R,
						config = {
							align = "cl",
						},
						nodes = { use },
					} or nil,
				},
			},
		},
	}
end

G.FUNCS.crv_half = function(e)
	local card = e.config.ref_table
	card.ability.extra["uses"] = card.ability.extra["uses"] - 1
	G.GAME.blind.chips = G.GAME.blind.chips / 2
	G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
end

SMODS.Joker({
	key = "dealb",
	atlas = "Jokers2",
	rarity = 3,
	cost = 7,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 6,
		y = 11,
	},
	config = {
		extra = {
			uses = 3,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.uses },
		}
	end,
	update = function(self, card, context)
		local crv = card.ability.extra
		if crv.uses == 0 then
			card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
			crv.uses = crv.uses + 1
		end
	end,
})

SMODS.Joker({
	key = "rebel",
	atlas = "Jokers2",
	rarity = 3,
	cost = 7,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 8,
		y = 11,
	},
	config = {
		extra = {
			xmult = 3,
		},
	},
	add_to_deck = function(self, card, from_debuff)
		for _, v in pairs(G.playing_cards) do
			if v:is_face() then
				SMODS.destroy_cards(v)
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.xmult },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.destroy_card and context.cardarea then
			if context.destroy_card:is_face() then
				return {
					remove = true,
				}
			end
		end
		if context.joker_main then
			return {
				xmult = crv.xmult,
			}
		end
	end,
})

SMODS.Joker({
	key = "embutton",
	atlas = "Jokers2",
	rarity = 1,
	cost = 3,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 7,
		y = 11,
	},
	config = {
		extra = {
			hands = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.xmult },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.selling_self and not context.blueprint then
			ease_hands_played(card.ability.extra.hands)
		end
	end,
})

SMODS.Joker({
	key = "icece",
	atlas = "Jokers2",
	rarity = 2,
	cost = 1,
	unlocked = true,
	discovered = true,
	pos = {
		x = 3,
		y = 12,
	},
	config = {
		extra = {
			chipx = 3,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.chipx },
		}
	end,
	calculate = function(self, card, context)
		local atp = card.ability.extra
		local hearts = 0
		if
			context.individual
			and context.cardarea == G.play
			and context.other_card:is_suit("Hearts", true)
			and not context.blueprint
		then
			hearts = hearts + 1
		end
		if context.joker_main and hearts == 0 then
			return {
				xchips = atp.chipx,
			}
		end
		if context.after then
			hearts = 0
		end
	end,
})

SMODS.Joker({
	key = "glassgun",
	rarity = 2,
	cost = 4,
	atlas = "Jokers2",
	config = {
		extra = {
			mult = 1,
		},
	},
	pos = { x = 4, y = 12 },
	soul_pos = { x = 4, y = 13 },
	discovered = true,
	blueprint_compat = true,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.glassodds = G.GAME.glassodds / 2
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.glassodds = G.GAME.glassodds / 2
	end,
	calculate = function(self, card, context)
		if
			context.individual
			and context.cardarea == G.play
			and SMODS.has_enhancement(context.other_card, "m_glass")
		then
			context.other_card:set_edition({ polychrome = true }, true)
		end
		if context.remove_playing_cards then
			for _, pcard in ipairs(context.removed) do
				if SMODS.has_enhancement(pcard, "m_glass") then
					local acard = copy_card(pcard, nil, nil, G.playing_card)
					G.deck.config.card_limit = G.deck.config.card_limit + 1
					table.insert(G.playing_cards, acard)
					acard:set_ability(G.P_CENTERS["m_crv_shattered"])
					acard:add_to_deck()
					G.hand:emplace(acard)
					acard.states.visible = nil
					G.E_MANAGER:add_event(Event({
						func = function()
							acard:start_materialize()
							return true
						end,
					}))
				end
			end
		end
	end,
})

--why is this fucking here bro
SMODS.Enhancement:take_ownership("glass", {
	config = { Xmult = 2, extra = 4 },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.Xmult, G.GAME.probabilities.normal, G.GAME.glassodds },
		}
	end,
	calculate = function(self, card, context)
		if not (#SMODS.find_card("gem_crv_obsidian") > 0) then
			if
				context.destroy_card
				and context.cardarea == G.play
				and context.destroy_card == card
				and pseudorandom("glass") < G.GAME.probabilities.normal / G.GAME.glassodds
			then
				return { remove = true }
			end
		end
	end,
}, true)

SMODS.Joker({
	key = "thed6",
	rarity = 3,
	cost = 5,
	atlas = "Jokers2",
	config = {
		extra = {
			shop = nil,
			rerolls = 3,
			limit = 3,
			can_roll = false,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.rerolls },
		}
	end,
	pos = {
		x = 6,
		y = 12,
	},
	discovered = true,
	blueprint_compat = false,
	calculate = function(self, card, context)
		if context.reroll_cards and not context.blueprint then
			RevosVault.replacecards(G.jokers.highlighted, nil, nil, true, card)
			card_eval_status_text(card, "extra", nil, nil, nil, { message = "Reroll!" })
			card.ability.extra.rerolls = card.ability.extra.rerolls - 1
			G.jokers:unhighlight_all()
		end
		if context.end_of_round and context.main_eval then
			card.ability.extra.rerolls = 3
			return {
				message = localize("k_reset"),
			}
		end
	end,
	update = function(self, card, context)
		if card.ability.extra.limit < 3 then
			card.ability.extra.limit = 3
		end
		if card.ability.extra.rerolls > 0 then
			if G and G.jokers and G.jokers.highlighted then
				if #G.jokers.highlighted > 1 and #G.jokers.highlighted < card.ability.extra.limit then
					card.ability.extra.can_roll = true
				else
					card.ability.extra.can_roll = false
				end
			end
		else
			card.ability.extra.can_roll = false
		end
	end,
})

SMODS.Joker({
	key = "holoface",
	atlas = "Jokers2",
	rarity = 2,
	cost = 1,
	unlocked = true,
	discovered = true,
	pos = {
		x = 7,
		y = 12,
	},
	soul_pos = {
		x = 8,
		y = 12,
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = {},
		}
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader("hologram", nil, card.ARGS.send_to_shader)
	end,
	calculate = function(self, card, context) end,
})

--This part is fucked up

local quests = {
	level_one = {
		"Play a Flush",
		"Use a Planet Card",
		"Play a High Card",
		"Use a Strength Tarot Card",
	},
	level_two = {
		"Score a Stone Card",
		"Beat the current blind in one hand",
		"Get 10 Rerolls in one shop",
	},
	level_three = {
		"Play a Four of a Kind",
		"Get 20 Rerolls in one shop",
		"Have over $100 while entering shop",
	},
	level_four = {
		"Play a Five of a Kind",
		"Win a blind without playing your most played hand",
		"Have over $120 while entering shop",
	},
}

SMODS.Joker({
	key = "inga",
	atlas = "Jokers2",
	rarity = 2,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 4,
		y = 5,
	},
	config = {
		extra = {
			one = "Inactive",
			two = "Inactive",
			three = "Inactive",
			four = "Inactive",
			quest = 0,
			questa = 0,
			questb = "Not Set",
			xmult = 2,
			xchips = 4,
			odds = 4,
			counter = 0,
			rerolls = 0,
			perma_mult = 5,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.one, --State of the quest 1
				card.ability.extra.two, --State of the quest 2
				card.ability.extra.three, --State of the quest 3
				card.ability.extra.four, --State of the quest 4
				card.ability.extra.quest, --Completed quest count
				card.ability.extra.questa, -- ?
				card.ability.extra.questb, -- Current quest
				card.ability.extra.xmult, -- The Xmult
				card.ability.extra.xchips, -- The Xchip
				card.ability.extra.odds, -- Not used
				(G.GAME.probabilities.normal or 1), -- Not used
				card.ability.extra.counter, -- ?
				card.ability.extra.rerolls, --Reroll count in one shop
				card.ability.extra.perma_mult, -- perma mult go brrr
			},
		}
	end,

	add_to_deck = function(self, card) --set the first quest
		local crv = card.ability.extra
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			func = function()
				if crv.questb == "Not Set" then
					crv.questb = pseudorandom_element(quests.level_one, pseudoseed("inga"))
				end
				return true
			end,
		}))
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra

		--Starting shop events
		if context.starting_shop then
			if crv.questb == quests.level_three[3] and to_big(G.GAME.dollars) >= to_big(100) then
				crv.three = "Active"
				crv.quest = crv.quest + 1
				SMODS.calculate_context({ change_quest = true, card = card, quest_set = "3" })
			elseif crv.questb == quests.level_four[3] and to_big(G.GAME.dollars) >= to_big(120) then
				crv.four = "Active"
				crv.quest = crv.quest + 1
				SMODS.calculate_context({ change_quest = true, card = card, quest_set = "4" })
			end
		end

		--Ending shop events
		if context.ending_shop then
			crv.rerolls = 0
		end

		--Reroll Shop events
		if context.reroll_shop then
			crv.rerolls = crv.rerolls + 1
			if crv.rerolls >= 10 and crv.questb == quests.level_two[3] then
				crv.two = "Active"
				crv.quest = crv.quest + 1
				SMODS.calculate_context({ change_quest = true, card = card, quest_set = "2" })
			elseif crv.rerolls >= 20 and crv.questb == quests.level_three[2] then
				crv.three = "Active"
				crv.quest = crv.quest + 1
				SMODS.calculate_context({ change_quest = true, card = card, quest_set = "3" })
			end
		end

		--End of round events
		if context.end_of_round and context.main_eval then
			if G.GAME.current_round.hands_played == 1 and crv.questb == quests.level_two[2] then
				crv.two = "Active"
				crv.quest = crv.quest + 1
				SMODS.calculate_context({ change_quest = true, card = card, quest_set = "2" })
			end
		end

		--Individual events
		if context.individual and context.cardarea == G.play then
			if crv.three == "Active" then
				context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
				context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + crv.perma_mult
				return {
					message = localize("k_upgrade_ex"),
				}
			end
			if crv.questb == quests.level_two[1] then
				if SMODS.has_enhancement(context.other_card, "m_stone") then
					crv.two = "Active"
					crv.quest = crv.quest + 1
					SMODS.calculate_context({ change_quest = true, card = card, quest_set = "2" })
				end
			end
		end

		--Joker Main events
		if context.joker_main then
			if crv.one == "Active" and crv.two == "Inactive" then
				return {
					xmult = crv.xmult,
				}
			elseif crv.one == "Active" and crv.two == "Active" then
				return {
					xmult = crv.xmult,
					xchips = crv.xchips,
				}
			end
			if crv.questb == quests.level_one[1] then
				if context.scoring_name == "Flush" then
					crv.one = "Active"
					crv.quest = crv.quest + 1
					SMODS.calculate_context({ change_quest = true, card = card, quest_set = "1" })
				end
			elseif crv.questb == quests.level_one[3] then
				if context.scoring_name == "High Card" then
					crv.one = "Active"
					crv.quest = crv.quest + 1
					SMODS.calculate_context({ change_quest = true, card = card, quest_set = "1" })
				end
			elseif crv.questb == quests.level_three[1] then
				if context.scoring_name == "Four of a Kind" then
					crv.three = "Active"
					crv.quest = crv.quest + 1
					SMODS.calculate_context({ change_quest = true, card = card, quest_set = "3" })
				end
			elseif crv.questb == quests.level_four[1] then
				if context.scoring_name == "Five of a Kind" then
					crv.four = "Active"
					crv.quest = crv.quest + 1
					SMODS.calculate_context({ change_quest = true, card = card, quest_set = "4" })
				end
			elseif crv.questb == quests.level_four[2] then
				if context.scoring_name ~= RevosVault.most_played() then
					crv.four = "Active"
					crv.quest = crv.quest + 1
					SMODS.calculate_context({ change_quest = true, card = card, quest_set = "4" })
				end
			end
		end

		-- Consumable events

		if context.using_consumeable then
			if crv.questb == quests.level_one[2] then
				if context.consumeable.ability.set == "Planet" then
					crv.one = "Active"
					crv.quest = crv.quest + 1
					SMODS.calculate_context({ change_quest = true, card = card, quest_set = "1" })
				end
			elseif crv.questb == quests.level_one[4] then
				if context.consumeable.config.center.key == "c_strength" then
					crv.one = "Active"
					crv.quest = crv.quest + 1
					SMODS.calculate_context({ change_quest = true, card = card, quest_set = "1" })
				end
			end
		else
			if crv.questb == quests.level_four[4] then
				crv.four = "Active"
				crv.quest = crv.quest + 1
				SMODS.calculate_context({ change_quest = true, card = card, quest_set = "4" })
			end
		end

		--Changing quests
		if context.change_quest and context.card == card then
			if context.quest_set == "1" then
				crv.questb = pseudorandom_element(quests.level_two, pseudoseed("inga"))
			elseif context.quest_set == "2" then
				crv.questb = pseudorandom_element(quests.level_three, pseudoseed("inga"))
			elseif context.quest_set == "3" then
				crv.questb = pseudorandom_element(quests.level_four, pseudoseed("inga"))
			elseif context.quest_set == "4" then
				crv.questb = "No More Quests!"
				crv.xmult = crv.xmult * 2
				crv.xchips = crv.xchips * 2
			end
			card_eval_status_text(card, "extra", nil, nil, nil, { message = "New Quest!" })
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

--

local shopframes = { 0, 1, 2, 3 }
SMODS.Joker({
	key = "shop_sign",
	atlas = "Jokers2",
	rarity = 4,
	pos = { x = 0, y = 13 },
	soul_pos = { x = 1, y = 13 },
	calculate = function(self, card, context) end,
	update = function(self, card, context)
		local timer = (G.TIMERS.REAL * 4) -- Thank you TOGA (i found it in #modding_dev)
		local frame_amount = #shopframes
		local wrapped_value = (math.floor(timer) - 1) % frame_amount + 1
		card.children.floating_sprite:set_sprite_pos({ x = shopframes[wrapped_value], y = 14 })
	end,
})

SMODS.Joker({
	key = "pay2win",
	atlas = "Jokers2",
	pos = { x = 1, y = 13 },
	rarity = 3,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { love.timer.getFPS() },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = love.timer.getFPS(),
			}
		end
	end,
})

SMODS.Joker({
	key = "heartfive",
	atlas = "Jokers2",
	pos = { x = 2, y = 13 },
	rarity = 1,
	cost = 5,
	config = {
		extra = {
			mone = 5,
			suit = "Spades",
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.mone,crv.suit },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.end_of_round and context.main_eval and not context.blueprint then
			crv.suit = pseudorandom_element(SMODS.Suits).key
		end
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_suit(crv.suit) then
				return {
					dollars = crv.mone,
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "cogs",
	atlas = "Jokers2",
	pos = { x = 6, y = 13 },
	rarity = 2,
	cost = 4,
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.mone },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.repetition and context.cardarea == G.play and G.GAME.current_round.hands_played == 0 then
			return {
				repetitions = 1,
			}
		end
	end,
})

SMODS.Joker({
	key = "7ball",
	atlas = "Jokers2",
	pos = { x = 3, y = 13 },
	rarity = 2,
	cost = 4,
	config = {
		extra = {
			odds = 6,
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { (G.GAME.probabilities.normal or 1), crv.odds },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.individual and context.cardarea == G.play and context.other_card:get_id() == 7 then
			if pseudorandom("crv_7ball") < G.GAME.probabilities.normal / crv.odds then
				if G.consumeables.config.card_limit > #G.consumeables.cards then
					SMODS.add_card({
						set = "Spectral",
					})
				else
					return {
						message = "No Room!",
					}
				end
			end
		end
	end,
})