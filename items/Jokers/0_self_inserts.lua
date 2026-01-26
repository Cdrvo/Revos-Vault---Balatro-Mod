SMODS.Joker({
	key = "revoo_",
	config = {
		extra = {
			xmult = 2,
		},
	},
	rarity = 4,
	atlas = "rev",
	blueprint_compat = true,
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
			odds = 3
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
		info_queue[#info_queue+1] = {set = "Other", key = "crv_fixed_chances"}
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "crv_adam_", nil, true)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.xmultg, card.ability.extra.scrapc, denominator, numerator },
		}
	end,
	calculate = function(self, card, context)

		if context.reroll_shop and not context.blueprint then
			if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then
				SMODS.add_card({
					area = G.consumeables,
					set = "crv_GeneralScrap",
				})
			end
		end
		
				
		if context.using_consumeable and not context.blueprint then
				if context.consumeable.config.center.is_scrap then
					card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultg
					card.ability.extra.scrapc = card.ability.extra.scrapc + 1
				end
			end
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
		if card.ability.extra.scrapc == 5 and not context.blueprint then
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
		info_queue[#info_queue+1] = G.P_CENTERS.j_crv_snayn32
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
		if context.joker_main then
			if G.GAME.current_round.hands_left == 1 and card.ability.extra.timer == 5 then
				card.ability.extra.timer = 0
				card:juice_up(0.3, 0.4)
				card:set_ability("j_crv_snayn32")
				card_eval_status_text(card, "extra", nil, nil, nil, { message = localize("k_evolve_crv") })
			else
			return {
				x_mult = card.ability.extra.xmult,
			}	
		end
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
		if context.destroy_card and context.cardarea == G.play and not context.blueprint then
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
	crv_special =true,
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
	add_to_deck = function(self,card,from_debuff)

		check_for_unlock({type = "pedro_go_brr"})


		G.GAME.modifiers.banana_mayhem = true
		ease_background_colour{new_colour = darken(G.C.RED, 0.5), special_colour = G.C.ORANGE, contrast = 5}
		G.GAME.disable_background_colouring = true
	end,
	remove_from_deck = function(self,card,from_debuff)
		if not G.GAME.modifiers.banana_mayhem_infinite then
			G.GAME.modifiers.banana_mayhem = nil
		end
		G.GAME.disable_background_colouring = nil
		if RevosVault.colour_args then
			ease_background_colour{new_colour = RevosVault.colour_args.new_colour, special_colour = RevosVault.colour_args.special_colour, contrast =  RevosVault.colour_args.contrast }
		end

		for k, v in pairs(G.playing_cards) do
			if v.ability.calculate_cavendish or v.ability.calculate_gros_michel then
				v:set_ability("c_base")
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "crv_special_joker", set = "Other"}
		info_queue[#info_queue + 1] = { key = "crv_banana_mayhem_desc", set = "Other"}
		info_queue[#info_queue + 1] = { key = "crv_banana_mayhem_desc_pedro", set = "Other"}
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.chips },
		}
	end,
	calculate = function(self, card, context)
		if context.final_scoring_step and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0,
				func = function()
					for k, v in pairs(context.scoring_hand) do
						if not v.ability.calculate_cavendish and not v.ability.calculate_gros_michel then
							v:juice_up()
							v:set_ability(pseudorandom_element({"j_cavendish", "j_gros_michel"}, pseudoseed("j_crv_pedro")))
						end
					end
					return true
				end
			}))
		end
	end,
})
