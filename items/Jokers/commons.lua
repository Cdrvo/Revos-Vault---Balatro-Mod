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
	key = "henchman",
	atlas = "Jokers2",
	cost = 5,
	rarity = 1,
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
			if context.other_card then
				context.other_card:flip()
				context.other_card:flip()
			end
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
	key = "embutton",
	atlas = "Jokers2",
	rarity = 1,
	cost = 2,
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