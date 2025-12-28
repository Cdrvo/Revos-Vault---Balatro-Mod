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
				G.jokers.cards[rr + 1]:add_sticker("crv_vamp", true)
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
					card2:add_sticker("crv_haunted", true)
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
				G.jokers.cards[rr - 1]:add_sticker("crv_radioactive", true)
				crv.stored = crv.stored + crv.gain
			elseif
				choosencard == "Right"
				and G.jokers.cards[rr + 1] ~= nil
				and not G.jokers.cards[rr + 1].ability.crv_radioactive
			then
				G.jokers.cards[rr + 1]:add_sticker("crv_radioactive", true)
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

SMODS.Joker({
	key = "icece",
	atlas = "Jokers2",
	rarity = 2,
	cost = 3,
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
		"Have over $60 while entering shop",
	},
	level_four = {
		"Play a Five of a Kind",
		"Win a blind without playing your most played hand",
		"Have over $100 while entering shop",
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
			if crv.questb == quests.level_three[3] and to_big(G.GAME.dollars) >= to_big(60) then
				crv.three = "Active"
				crv.quest = crv.quest + 1
				SMODS.calculate_context({ change_quest = true, card = card, quest_set = "3" })
			elseif crv.questb == quests.level_four[3] and to_big(G.GAME.dollars) >= to_big(100) then
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
		end

		-- Hand Quests
		if context.before and not context.blueprint then
			if crv.questb == quests.level_one[1] then
				if context.scoring_name == "Flush" then
					crv.one = "Active"
					crv.quest = crv.quest + 1
					SMODS.calculate_context({ change_quest = true, card = card, quest_set = "1" })
				end
			end
			if crv.questb == quests.level_one[3] then
				if context.scoring_name == "High Card" then
					crv.one = "Active"
					crv.quest = crv.quest + 1
					SMODS.calculate_context({ change_quest = true, card = card, quest_set = "1" })
				end
			end
			if crv.questb == quests.level_three[1] then
				if context.scoring_name == ("Four of a Kind") then
					crv.three = "Active"
					crv.quest = crv.quest + 1
					SMODS.calculate_context({ change_quest = true, card = card, quest_set = "3" })
				end
			end
			if crv.questb == quests.level_four[1] then
				if context.scoring_name == "Five of a Kind" then
					crv.four = "Active"
					crv.quest = crv.quest + 1
					SMODS.calculate_context({ change_quest = true, card = card, quest_set = "4" })
				end
			end
			if crv.questb == quests.level_four[2] then
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