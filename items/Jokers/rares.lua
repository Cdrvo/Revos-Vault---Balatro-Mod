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
		return #SMODS.find_card("j_crv_sfj") > 0
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
					check_for_unlock({type = "buckshotify"})
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
			vars = { crv.xmult * G.GAME.reincarnation, G.GAME.reincarnation, crv.odds,1 },
		}
	end,
	remove_from_deck = function(self, card, from_debuff)
		local crv = card.ability.extra
		G.GAME.reincarnation = G.GAME.reincarnation + 1
		if pseudorandom("rein") < 1 / crv.odds then
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
		local area = self.area
		if G.jokers and G.jokers.cards then area = G.jokers.cards end

		return {
			vars = {
				card.ability.extra.xmult * RevosVault.stickercheck(area, "perishable") + 1,
				card.ability.extra.xmult,
			},
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
				G.jokers.cards[rr + 1]:add_sticker("perishable", true)
			end
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult * RevosVault.stickercheck(G.jokers.cards, "perishable") + 1,
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
						chosen_joker:add_sticker("crv_absolute", true)
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