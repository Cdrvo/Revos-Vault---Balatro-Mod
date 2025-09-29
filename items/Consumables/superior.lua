-- Superior Cards

SMODS.ConsumableType({
	key = "Superior",

	collection_rows = { 4, 5 },
	primary_colour = RevosVault.C.SUP,
	secondary_colour = RevosVault.C.SUP,
	default = "c_crv_supfool",
})

SMODS.Consumable({
	name = "Superior Fool",
	key = "supfool",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 0,
		y = 0,
	},
	discovered = true,
	config = {
		extra = { cards = nil },
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		local joka
		local c
		if G.GAME.dont_question then
			joka = localize({ type = "name_text", key = G.GAME.dont_question, set = "Joker" })
			c = G.C.GREEN
		else
			joka = localize("k_none")
			c = G.C.RED
		end
		return {
			main_end = {
				{
					n = G.UIT.C,
					config = { align = "bm", padding = 0.02 },
					nodes = {
						{
							n = G.UIT.C,
							config = { align = "m", colour = c, r = 0.05, padding = 0.05 },
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = " " .. joka .. " ",
										colour = G.C.UI.TEXT_LIGHT,
										scale = 0.3,
										shadow = true,
									},
								},
							},
						},
					},
				},
			},
			vars = {},
		}
	end,
	can_use = function(self, card)
		if G and G.GAME and G.GAME.last_destroyed_joker then
			return true
		end
		return false
	end,
	use = function(self, card, area, copier)
		SMODS.add_card({
			key = G.GAME.dont_question,
		})
	end,
})

SMODS.Consumable({
	key = "supmagician",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 1,
		y = 0,
	},
	discovered = true,
	config = {
		max_highlighted = 3,
		min_highlighted = 1,
		extra = {},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted, card.ability.extra.cards } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					v:set_ability("m_lucky")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			if SMODS.has_enhancement(context.other_card, "m_lucky") then
				return {
					repetitions = 1,
				}
			end
		end
	end,
})

SMODS.Consumable({
	key = "suppriestess",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 2,
		y = 0,
	},
	discovered = true,
	config = {
		extra = { create = 3 },
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.create } }
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		local _planet, _hand = nil, RevosVault.most_played()
		for _, v in pairs(G.P_CENTER_POOLS.Planet) do
			if v.config.hand_type == _hand then
				_planet = v.key
			end
		end
		for i = 1, card.ability.extra.create do
			SMODS.add_card({
				key = _planet,
				edition = "e_negative",
			})
		end
	end,
})

SMODS.Consumable({
	key = "supempress",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 3,
		y = 0,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		min_highlighted = 1,
		extra = {},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted, card.ability.extra.cards } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					v:set_ability("m_crv_xmultcard")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
})

SMODS.Consumable({
	key = "supemperor",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 4,
		y = 0,
	},
	discovered = true,
	config = {
		extra = {},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted, card.ability.extra.cards } }
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		for i = 1, 2 do
			SMODS.add_card({
				key = pseudorandom_element(G.P_CENTER_POOLS.Superior).key,
				area = G.consumeables,
			})
		end
	end,
})

SMODS.Consumable({
	key = "suphierophant",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 5,
		y = 0,
	},
	discovered = true,
	config = {
		max_highlighted = 3,
		min_highlighted = 1,
		extra = {},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted, card.ability.extra.cards } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					v:set_ability("m_bonus")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			if SMODS.has_enhancement(context.other_card, "m_bonus") then
				return {
					repetitions = 1,
				}
			end
		end
	end,
})

SMODS.Consumable({
	key = "suplovers",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 6,
		y = 0,
	},
	discovered = true,
	config = {
		max_highlighted = 3,
		min_highlighted = 1,
		extra = {},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted, card.ability.extra.cards } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					v:set_ability("m_wild")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if SMODS.has_enhancement(context.other_card, "m_wild") then
				return {
					mult = context.other_card.base.id / 2,
				}
			end
		end
	end,
})

SMODS.Consumable({
	key = "supchariot",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 7,
		y = 0,
	},
	discovered = true,
	config = {
		max_highlighted = 3,
		min_highlighted = 1,
		extra = {},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted, card.ability.extra.cards } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					v:set_ability("m_steel")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand then
			if SMODS.has_enhancement(context.other_card, "m_steel") then
				return {
					xchips = 2,
				}
			end
		end
	end,
})

SMODS.Consumable({
	key = "supjustice",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 8,
		y = 0,
	},
	discovered = true,
	config = {
		max_highlighted = 3,
		min_highlighted = 1,
		extra = {},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted, card.ability.extra.cards } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					v:set_ability("m_glass")
					v:set_edition("e_polychrome")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if SMODS.has_enhancement(context.other_card, "m_glass") then
				return {
					mult = context.other_card.base.id / 2,
				}
			end
		end
	end,
})

SMODS.Consumable({
	key = "suphermit",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 9,
		y = 0,
	},
	discovered = true,
	config = {
		extra = {
			money = 100,
			give = 5,
		},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money, card.ability.extra.give } }
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				play_sound("timpani")
				card:juice_up(0.3, 0.5)
				ease_dollars(math.max(0, math.min(G.GAME.dollars + G.GAME.dollars, card.ability.extra.money)), true)
				return true
			end,
		}))
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			return {
				dollars = card.ability.extra.give,
			}
		end
	end,
})

SMODS.Consumable({
	key = "supwof",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 0,
		y = 1,
	},
	discovered = true,
	config = {
		extra = {},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	can_use = function(self, card)
		local jokas = {}
		for i = 1, #G.jokers.cards do
			if not G.jokers.cards[i].edition then
				jokas[#jokas + 1] = G.jokers.cards[i]
			end
		end
		if #G.jokers.cards > 0 and #jokas > 0 then
			return true
		end
	end,
	use = function(self, card, area, copier)
		RevosVault.wheeloffortune(1, G.jokers.cards)
	end,
})

SMODS.Consumable({
	key = "supstrength",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 1,
		y = 1,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		min_highlighted = 1,
		extra = {},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					SMODS.change_base(v, nil, "King")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
})

SMODS.Consumable({
	key = "suphangedman",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 2,
		y = 1,
	},
	pools = {
		SuperiorTarot = true,
	},
	discovered = true,
	config = {
		max_highlighted = 5,
		min_highlighted = 1,
		extra = {
			chips = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		if G and G.GAME then
			return { vars = { self.config.max_highlighted, card.ability.extra.chips } }
		else
			return { vars = { self.config.max_highlighted, G.GAME.hangedmanchips } }
		end
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			G.GAME.hangedmanchips = G.GAME.hangedmanchips + v.base.id
			SMODS.destroy_cards(v)
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = G.GAME.hangedmanchips,
			}
		end
	end,
})

SMODS.Consumable({
	key = "supdeath",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 3,
		y = 1,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		min_highlighted = 1,
		extra = {
			chips = 0,
		},
	},
	pools = {
		SuperiorTarot = true,
	},
	can_use = function(self, card)
		if
			#G.hand.highlighted <= 2
			and #G.hand.highlighted > 0
			and RevosVault.find_lowest(G.playing_cards, nil, true)
		then
			return true
		end
		return false
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					copy_card((RevosVault.find_lowest(G.playing_cards, nil, true)), v)
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
})

SMODS.Consumable({
	key = "suptemp",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 4,
		y = 1,
	},
	discovered = true,
	config = {
		extra = {
			money = 0,
			max = 100,
		},
	},
	pools = {
		SuperiorTarot = true,
	},
	can_use = function(self, card)
		return true
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.max } }
	end,
	use = function(self, card, area, copier)
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].ability.set == "Joker" then
				card.ability.extra.money = card.ability.extra.money + G.jokers.cards[i].sell_cost
			end
		end
		for i = 1, #G.consumeables.cards do
			card.ability.extra.money = card.ability.extra.money + G.consumeables.cards[i].sell_cost
		end
		ease_dollars(math.max(0, math.min(card.ability.extra.money, card.ability.extra.max)), true)
	end,
})

SMODS.Consumable({
	key = "supdevil",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 5,
		y = 1,
	},
	discovered = true,
	config = {
		max_highlighted = 3,
		min_highlighted = 1,
		extra = {
			money = 5,
		},
	},
	pools = {
		SuperiorTarot = true,
	},
	can_use = function(self, card)
		return true
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted, card.ability.extra.money } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					v:set_ability("m_gold")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if SMODS.has_enhancement(context.other_card, "m_gold") then
				return {
					dollars = card.ability.extra.money,
				}
			end
		end
	end,
})

SMODS.Consumable({
	key = "suptower",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 6,
		y = 1,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		min_highlighted = 1,
		extra = {
			money = 0,
		},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					v:set_ability("m_stone")
					v:set_edition("e_negative")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if SMODS.has_enhancement(context.other_card, "m_stone") then
				return {
					xmult = 2,
				}
			end
		end
	end,
})

SMODS.Consumable({
	key = "supstar",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 7,
		y = 1,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		min_highlighted = 1,
		extra = {
			money = 0,
		},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					SMODS.change_base(v, "Diamonds", nil)
					v:set_ability("m_crv_superiore")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
})

SMODS.Consumable({
	key = "supmoon",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 8,
		y = 1,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		min_highlighted = 1,
		extra = {
			money = 0,
		},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					SMODS.change_base(v, "Clubs", nil)
					v:set_ability("m_crv_superiore")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
})

SMODS.Consumable({
	key = "supsun",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 9,
		y = 1,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		min_highlighted = 1,
		extra = {
			money = 0,
		},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					SMODS.change_base(v, "Hearts", nil)
					v:set_ability("m_crv_superiore")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
})

SMODS.Consumable({
	key = "supworld",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 1,
		y = 2,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		min_highlighted = 1,
		extra = {
			money = 0,
		},
	},
	pools = {
		SuperiorTarot = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					SMODS.change_base(v, "Spades", nil)
					v:set_ability("m_crv_superiore")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
})

SMODS.Consumable({
	key = "supjudgement",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Tarot",
	sout_rate = 0.1,
	pos = {
		x = 0,
		y = 2,
	},
	discovered = true,
	config = {
		extra = {
			default = 0,
			default2 = 0,
		},
	},
	pools = {
		SuperiorTarot = true,
	},
	can_use = function(self, card)
		return true
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.max_highlighted } }
	end,
	use = function(self, card, area, copier)
		local one
		local two
		G.E_MANAGER:add_event(Event({
			trigger = "before",
			delay = 0.2,
			blockable = false,
			blocking = false,
			func = function()
				one = SMODS.ObjectTypes["Joker"].rarities[1].weight
				two = SMODS.ObjectTypes["Joker"].rarities[2].weight
				SMODS.ObjectTypes["Joker"].rarities[1].weight = 0
				SMODS.ObjectTypes["Joker"].rarities[2].weight = 0
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			delay = 0.2,
			blockable = false,
			blocking = false,
			func = function()
				local acard = SMODS.add_card({
					set = "Joker",
				})
				local transform = {}
				if acard.config.center.key == "j_joker" then
					print("Jimbo got created. Transforming it into a random rare joker")
					for i = 1, #G.P_CENTER_POOLS.Joker do
						local rcard = G.P_CENTER_POOLS.Joker
						if rcard[i].rarity == 3 then
							transform[#transform + 1] = rcard[i]
						end
					end
					acard:set_ability(pseudorandom_element(transform).key)
				end
				return true
			end,
		}))
		SMODS.ObjectTypes["Joker"].rarities[1].weight = one
		SMODS.ObjectTypes["Joker"].rarities[2].weight = two
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if SMODS.has_enhancement(context.other_card, "m_stone") then
				return {
					xmult = 2,
				}
			end
		end
	end,
})

--Superior Spectrals below

SMODS.DrawStep({
	key = "joker_shine",
	order = 11,
	func = function(self)
		if
			self.config.center.soul_set == "Spectral"
			and self.ability.set == "Superior"
			and self:should_draw_base_shader()
		then
			self.children.center:draw_shader("booster", nil, self.ARGS.send_to_shader)
		end
	end,
	conditions = { vortex = false, facing = "front" },
})

SMODS.Consumable({
	key = "supfamiliar",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 10,
		y = 0,
	},
	pools = {
		SuperiorSpectral = true,
	},
	discovered = true,
	config = {
		extra = { cards = 3 },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	can_use = function(self, card)
		local cards = {}
		if G and G.hand and #G.hand.cards > 0 then
			for i = 1, #G.hand.cards do
				if not G.hand.cards[i]:is_face() then
					cards[#cards + 1] = G.hand.cards[i]
					if #cards > 0 then
						return true
					end
				end
			end
		end
		return false
	end,
	use = function(self, card, area, copier)
		local cards = {}
		for i = 1, #G.hand.cards do
			if not G.hand.cards[i]:is_face() then
				cards[#cards + 1] = G.hand.cards[i]
			end
		end
		SMODS.destroy_cards(pseudorandom_element(cards))
		for i = 1, card.ability.extra.cards do
			SMODS.add_card({
				set = "Enhanced",
				area = G.hand,
				edition = poll_edition(pseudorandom("supfam"), nil, true, true),
				rank = pseudorandom_element(RevosVault.facepool()).card_key,
			})
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supgrim",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 11,
		y = 0,
	},
	pools = {
		SuperiorSpectral = true,
	},
	discovered = true,
	config = {
		extra = { cards = 2 },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	can_use = function(self, card)
		local cards = {}
		if G and G.hand and #G.hand.cards > 0 then
			for i = 1, #G.hand.cards do
				if G.hand.cards[i]:get_id() == 14 then
					cards[#cards + 1] = G.hand.cards[i]
					if #cards > 0 then
						return true
					end
				end
			end
		end
		return false
	end,
	use = function(self, card, area, copier)
		local cards = {}
		for i = 1, #G.hand.cards do
			if G.hand.cards[i]:get_id() == 14 then
				cards[#cards + 1] = G.hand.cards[i]
			end
		end
		SMODS.destroy_cards(pseudorandom_element(cards))
		for i = 1, card.ability.extra.cards do
			SMODS.add_card({
				set = "Enhanced",
				area = G.hand,
				edition = poll_edition(pseudorandom("supgrim"), nil, true, true),
				rank = "Ace",
			})
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supincantation",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 12,
		y = 0,
	},
	pools = {
		SuperiorSpectral = true,
	},
	discovered = true,
	config = {
		extra = { cards = 6 },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	can_use = function(self, card)
		local cards = {}
		if G and G.hand and #G.hand.cards > 0 then
			for i = 1, #G.hand.cards do
				cards[#cards + 1] = G.hand.cards[i]
				if #cards > 0 then
					return true
				end
			end
		end
		return false
	end,
	use = function(self, card, area, copier)
		local cards = {}
		for i = 1, #G.hand.cards do
			cards[#cards + 1] = G.hand.cards[i]
		end
		SMODS.destroy_cards(pseudorandom_element(cards))
		for i = 1, card.ability.extra.cards do
			SMODS.add_card({
				set = "Enhanced",
				area = G.hand,
				edition = poll_edition(pseudorandom("supgrim"), nil, true, true),
				rank = pseudorandom_element(SMODS.Ranks, pseudoseed("unowild")).card_key,
			})
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "suptalisman",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 13,
		y = 0,
	},
	pools = {
		SuperiorSpectral = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { cards = 2 },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	use = function(self, card, area, copier)
		for k, card2 in pairs(G.hand.highlighted) do
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card:juice_up(0.3, 0.5)
					return true
				end,
			}))

			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					card2:set_seal("Gold", nil, true)
					card2:set_ability("m_gold")
					return true
				end,
			}))
			G.hand:unhighlight_all()
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supaura",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 14,
		y = 0,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { cards = 2 },
	},
	pools = {
		SuperiorSpectral = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	can_use = function(self, card)
		if G and G.jokers and #G.jokers.highlighted > 0 and #G.jokers.highlighted < self.config.max_highlighted + 1 then
			return true
		end
		return false
	end,
	use = function(self, card, area, copier)
		for k, card2 in pairs(G.jokers.highlighted) do
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card:juice_up(0.3, 0.5)
					return true
				end,
			}))

			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					card2:set_edition(pseudorandom_element({ "e_polychrome", "e_negative" }))
					return true
				end,
			}))
			G.jokers:unhighlight_all()
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supwraith",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 15,
		y = 0,
	},
	pools = {
		SuperiorSpectral = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { cards = 2, odds = 6 },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards, card.ability.extra.odds, (G.GAME.probabilities.normal or 1) } }
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		if
			pseudorandom("supwraity") < G.GAME.probabilities.normal / card.ability.extra.odds
			and G.jokers.config.card_limit > #G.jokers.cards
		then
			SMODS.add_card({
				set = "Joker",
				legendary = true,
			})
		elseif G.jokers.config.card_limit > #G.jokers.cards then
			SMODS.add_card({
				set = "Joker",
				rarity = "Rare",
			})
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supsigil",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 16,
		y = 0,
	},
	discovered = true,
	config = {
		max_highlighted = 1,
		extra = { cards = 2, odds = 6 },
	},
	pools = {
		SuperiorSpectral = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards, card.ability.extra.odds, (G.GAME.probabilities.normal or 1) } }
	end,
	use = function(self, card, area, copier)
		for i = 1, #G.hand.cards do
			local card2 = G.hand.cards[i]
			local _suit = G.hand.highlighted[1].base.suit
			card2:flip()
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card2:juice_up(0.3, 0.4)
					return true
				end,
			}))

			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					SMODS.change_base(card2, _suit, nil)
					return true
				end,
			}))
			card2:flip()
		end
		G.hand:unhighlight_all()
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supouija",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 17,
		y = 0,
	},
	pools = {
		SuperiorSpectral = true,
	},
	discovered = true,
	config = {
		max_highlighted = 1,
		extra = { cards = 2, odds = 6 },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards, card.ability.extra.odds, (G.GAME.probabilities.normal or 1) } }
	end,
	use = function(self, card, area, copier)
		for i = 1, #G.hand.cards do
			local card2 = G.hand.cards[i]
			local _rank = G.hand.highlighted[1]:get_original_rank()
			if card2 ~= G.hand.highlighted[1] then
				card2:flip()
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card2:juice_up(0.3, 0.4)
						return true
					end,
				}))

				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.1,
					func = function()
						SMODS.change_base(card2, nil, _rank)
						return true
					end,
				}))
				card2:flip()
			end
		end
		G.hand:unhighlight_all()
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supectoplasm",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 18,
		y = 0,
	},
	discovered = true,
	config = {
		extra = { cards = 2 },
	},
	pools = {
		SuperiorSpectral = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	can_use = function(self, card)
		local _cards = {}
		for i = 1, #G.jokers.cards do
			if not G.jokers.cards[i].edition then
				_cards[#_cards + 1] = G.jokers.cards[i]
			end
		end
		if #_cards > 0 then
			return true
		end
	end,
	use = function(self, card, area, copier)
		local crv = card.ability.extra
		local _cards = {}
		for i = 1, #G.jokers.cards do
			if not G.jokers.cards[i].edition then
				_cards[#_cards + 1] = G.jokers.cards[i]
			end
		end
		for i = 1, card.ability.extra.cards do
			if #_cards == 0 then
				break
			end
			local _cards1 = RevosVault.random_joker(_cards)
			local num = RevosVault.index(_cards, _cards1)
			table.remove(_cards, num)
			_cards1:set_edition("e_negative")
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supimmolate",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 19,
		y = 0,
	},
	pools = {
		SuperiorSpectral = true,
	},
	discovered = true,
	config = {
		extra = { cards = 3, dollars = 20 },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards, card.ability.extra.dollars } }
	end,
	can_use = function(self, card)
		local _cards = {}
		if #G.hand.highlighted == card.ability.extra.cards then
			return true
		end
	end,
	use = function(self, card, area, copier)
		for k, cards2 in pairs(G.hand.cards) do
			SMODS.destroy_cards(cards2)
		end
		ease_dollars(card.ability.extra.dollars)
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supankh",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 10,
		y = 1,
	},
	discovered = true,
	config = {
		extra = { cards = 1, odds = 6 },
	},
	pools = {
		SuperiorSpectral = true,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	can_use = function(self, card)
		local _cards = {}
		if #G.jokers.highlighted == 1 then
			return true
		end
	end,
	use = function(self, card, area, copier)
		local acard
		for k, cards2 in pairs(G.jokers.highlighted) do
			acard = copy_card(cards2)
			acard:add_to_deck()
			G.jokers:emplace(acard)
		end
		if pseudorandom("supanky") < G.GAME.probabilities.normal / 3 then
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] ~= acard or G.jokers.cards[i] ~= G.jokers.highlighted[1] then
					SMODS.destroy_cards(G.jokers.cards[i])
				end
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supdejavu",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 11,
		y = 1,
	},
	pools = {
		SuperiorSpectral = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { cards = 2 },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					v:set_seal("Red", nil, true)
					v:set_ability(pseudorandom_element({ "m_lucky", "m_glass" }))
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "suphex",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 12,
		y = 1,
	},
	pools = {
		SuperiorSpectral = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { cards = 2 },
	},
	can_use = function(self, card)
		if #G.jokers.highlighted == 1 then
			return true
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	use = function(self, card, area, copier)
		G.jokers.highlighted[1]:set_edition("e_polychrome")
		local joker = G.jokers.cards
		local rr = RevosVault.index(G.jokers.cards, G.jokers.highlighted[1])
		if joker[rr + 1] and joker[rr - 1] then
			SMODS.destroy_cards(pseudorandom_element({ joker[rr + 1], joker[rr - 1] }))
		elseif joker[rr + 1] then
			SMODS.destroy_cards(joker[rr + 1])
		elseif joker[rr - 1] then
			SMODS.destroy_cards(joker[rr - 1])
		else
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "suptrance",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 13,
		y = 1,
	},
	pools = {
		SuperiorSpectral = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { cards = 2 },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					v:set_seal("Blue", nil, true)
					v:set_ability("m_steel")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supmedium",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 14,
		y = 1,
	},
	pools = {
		SuperiorSpectral = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { cards = 2 },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	use = function(self, card, area, copier)
		for _, v in pairs(G.hand.highlighted) do
			v:flip()
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = function()
					v:set_seal("Purple", nil, true)
					v:set_ability("m_steel")
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					v:flip()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supcryptid",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Spectral",
	sout_rate = 0.1,
	pos = {
		x = 15,
		y = 1,
	},
	pools = {
		SuperiorSpectral = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { cards = 2 },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	use = function(self, card, area, copier)
		for i = 1, card.ability.extra.cards do
			local acard = copy_card(G.hand.highlighted[1])
			G.deck.config.card_limit = G.deck.config.card_limit + 1
			table.insert(G.playing_cards, acard)
			acard:set_edition("e_negative")
			acard:add_to_deck()
			if #G.hand.cards > 0 then
				G.hand:emplace(acard)
			else
				G.deck:emplace(acard)
			end
		end
		G.hand:unhighlight_all()
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_s"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

--Superior planets

SMODS.Consumable({
	key = "suppluto",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Planet",
	sout_rate = 0.1,
	pos = {
		x = 10,
		y = 2,
	},
	pools = {
		SuperiorPlanet = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { can_activate = true, can_keep = true, level = 1 },
	},
	keep_on_use = function(self, card)
		if card.ability.extra.can_keep == true then
			return true
		end
	end,
	can_use = function(self, card)
		if card.ability.extra.can_activate then
			return true
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.hands["High Card"].level,
				"High Card",
				G.GAME.hands["High Card"].mult,
				G.GAME.hands["High Card"].chips,
			},
		}
	end,
	use = function(self, card, area, copier)
		card.ability.extra.can_activate = false
		RevosVault.level_up_hand("High Card", card.ability.extra.level)
		local eval = function()
			return card.ability.extra.can_activate == false
		end
		juice_card_until(card, eval, true)
		card.ability.extra.can_keep = false
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.can_activate == false and context.scoring_name == "High Card" then
			card.ability.extra.can_keep = false
			if G.GAME.talisman == 1 then
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			else
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			end
		end
		if context.end_of_round and context.main_eval then
			if card.ability.extra.can_keep == false then
				SMODS.destroy_cards(card)
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_p"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supmercury",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Planet",
	sout_rate = 0.1,
	pos = {
		x = 2,
		y = 2,
	},
	pools = {
		SuperiorPlanet = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { can_activate = true, can_keep = true, level = 1 },
	},
	keep_on_use = function(self, card)
		if card.ability.extra.can_keep == true then
			return true
		end
	end,
	can_use = function(self, card)
		if card.ability.extra.can_activate then
			return true
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.hands["Pair"].level, "Pair", G.GAME.hands["Pair"].mult, G.GAME.hands["Pair"].chips } }
	end,
	use = function(self, card, area, copier)
		card.ability.extra.can_activate = false
		RevosVault.level_up_hand("Pair", card.ability.extra.level)
		local eval = function()
			return card.ability.extra.can_activate == false
		end
		juice_card_until(card, eval, true)
		card.ability.extra.can_keep = false
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.can_activate == false and context.scoring_name == "Pair" then
			card.ability.extra.can_keep = false
			if G.GAME.talisman == 1 then
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			else
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			end
		end
		if context.end_of_round and context.main_eval then
			if card.ability.extra.can_keep == false then
				SMODS.destroy_cards(card)
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_p"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supvenus",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Planet",
	sout_rate = 0.1,
	pos = {
		x = 3,
		y = 2,
	},
	pools = {
		SuperiorPlanet = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { can_activate = true, can_keep = true, level = 1 },
	},
	keep_on_use = function(self, card)
		if card.ability.extra.can_keep == true then
			return true
		end
	end,
	can_use = function(self, card)
		if card.ability.extra.can_activate then
			return true
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.hands["Three of a Kind"].level,
				"Three of a Kind",
				G.GAME.hands["Three of a Kind"].mult,
				G.GAME.hands["Three of a Kind"].chips,
			},
		}
	end,
	use = function(self, card, area, copier)
		card.ability.extra.can_activate = false
		RevosVault.level_up_hand("Three of a Kind", card.ability.extra.level)
		local eval = function()
			return card.ability.extra.can_activate == false
		end
		juice_card_until(card, eval, true)
		card.ability.extra.can_keep = false
	end,
	calculate = function(self, card, context)
		if
			context.joker_main
			and card.ability.extra.can_activate == false
			and context.scoring_name == "Three of a Kind"
		then
			card.ability.extra.can_keep = false
			if G.GAME.talisman == 1 then
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			else
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			end
		end
		if context.end_of_round and context.main_eval then
			if card.ability.extra.can_keep == false then
				SMODS.destroy_cards(card)
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_p"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supearth",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Planet",
	sout_rate = 0.1,
	pos = {
		x = 4,
		y = 2,
	},
	pools = {
		SuperiorPlanet = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { can_activate = true, can_keep = true, level = 1 },
	},
	keep_on_use = function(self, card)
		if card.ability.extra.can_keep == true then
			return true
		end
	end,
	can_use = function(self, card)
		if card.ability.extra.can_activate then
			return true
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.hands["Full House"].level,
				"Full House",
				G.GAME.hands["Full House"].mult,
				G.GAME.hands["Full House"].chips,
			},
		}
	end,
	use = function(self, card, area, copier)
		card.ability.extra.can_activate = false
		RevosVault.level_up_hand("Full House", card.ability.extra.level)
		local eval = function()
			return card.ability.extra.can_activate == false
		end
		juice_card_until(card, eval, true)
		card.ability.extra.can_keep = false
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.can_activate == false and context.scoring_name == "Full House" then
			card.ability.extra.can_keep = false
			if G.GAME.talisman == 1 then
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			else
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			end
		end
		if context.end_of_round and context.main_eval then
			if card.ability.extra.can_keep == false then
				SMODS.destroy_cards(card)
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_p"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supmars",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Planet",
	sout_rate = 0.1,
	pos = {
		x = 5,
		y = 2,
	},
	pools = {
		SuperiorPlanet = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { can_activate = true, can_keep = true, level = 1 },
	},
	keep_on_use = function(self, card)
		if card.ability.extra.can_keep == true then
			return true
		end
	end,
	can_use = function(self, card)
		if card.ability.extra.can_activate then
			return true
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.hands["Four of a Kind"].level,
				"Four of a Kind",
				G.GAME.hands["Four of a Kind"].mult,
				G.GAME.hands["Four of a Kind"].chips,
			},
		}
	end,
	use = function(self, card, area, copier)
		card.ability.extra.can_activate = false
		RevosVault.level_up_hand("Four of a Kind", card.ability.extra.level)
		local eval = function()
			return card.ability.extra.can_activate == false
		end
		juice_card_until(card, eval, true)
		card.ability.extra.can_keep = false
	end,
	calculate = function(self, card, context)
		if
			context.joker_main
			and card.ability.extra.can_activate == false
			and context.scoring_name == "Four of a Kind"
		then
			card.ability.extra.can_keep = false
			if G.GAME.talisman == 1 then
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			else
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			end
		end
		if context.end_of_round and context.main_eval then
			if card.ability.extra.can_keep == false then
				SMODS.destroy_cards(card)
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_p"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supjupiter",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Planet",
	sout_rate = 0.1,
	pos = {
		x = 6,
		y = 2,
	},
	pools = {
		SuperiorPlanet = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { can_activate = true, can_keep = true, level = 1 },
	},
	keep_on_use = function(self, card)
		if card.ability.extra.can_keep == true then
			return true
		end
	end,
	can_use = function(self, card)
		if card.ability.extra.can_activate then
			return true
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { G.GAME.hands["Flush"].level, "Flush", G.GAME.hands["Flush"].mult, G.GAME.hands["Flush"].chips },
		}
	end,
	use = function(self, card, area, copier)
		card.ability.extra.can_activate = false
		RevosVault.level_up_hand("Flush", card.ability.extra.level)
		local eval = function()
			return card.ability.extra.can_activate == false
		end
		juice_card_until(card, eval, true)
		card.ability.extra.can_keep = false
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.can_activate == false and context.scoring_name == "Flush" then
			card.ability.extra.can_keep = false
			if G.GAME.talisman == 1 then
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			else
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			end
		end
		if context.end_of_round and context.main_eval then
			if card.ability.extra.can_keep == false then
				SMODS.destroy_cards(card)
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_p"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supsaturn",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Planet",
	sout_rate = 0.1,
	pos = {
		x = 7,
		y = 2,
	},
	pools = {
		SuperiorPlanet = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { can_activate = true, can_keep = true, level = 1 },
	},
	keep_on_use = function(self, card)
		if card.ability.extra.can_keep == true then
			return true
		end
	end,
	can_use = function(self, card)
		if card.ability.extra.can_activate then
			return true
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.hands["Straight"].level,
				"Straight",
				G.GAME.hands["Straight"].mult,
				G.GAME.hands["Straight"].chips,
			},
		}
	end,
	use = function(self, card, area, copier)
		card.ability.extra.can_activate = false
		RevosVault.level_up_hand("Straight", card.ability.extra.level)
		local eval = function()
			return card.ability.extra.can_activate == false
		end
		juice_card_until(card, eval, true)
		card.ability.extra.can_keep = false
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.can_activate == false and context.scoring_name == "Straight" then
			card.ability.extra.can_keep = false
			if G.GAME.talisman == 1 then
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			else
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			end
		end
		if context.end_of_round and context.main_eval then
			if card.ability.extra.can_keep == false then
				SMODS.destroy_cards(card)
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_p"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supuranus",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Planet",
	sout_rate = 0.1,
	pos = {
		x = 8,
		y = 2,
	},
	pools = {
		SuperiorPlanet = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { can_activate = true, can_keep = true, level = 1 },
	},
	keep_on_use = function(self, card)
		if card.ability.extra.can_keep == true then
			return true
		end
	end,
	can_use = function(self, card)
		if card.ability.extra.can_activate then
			return true
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.hands["Two Pair"].level,
				"Two Pair",
				G.GAME.hands["Two Pair"].mult,
				G.GAME.hands["Two Pair"].chips,
			},
		}
	end,
	use = function(self, card, area, copier)
		card.ability.extra.can_activate = false
		RevosVault.level_up_hand("Two Pair", card.ability.extra.level)
		local eval = function()
			return card.ability.extra.can_activate == false
		end
		juice_card_until(card, eval, true)
		card.ability.extra.can_keep = false
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.can_activate == false and context.scoring_name == "Two Pair" then
			card.ability.extra.can_keep = false
			if G.GAME.talisman == 1 then
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			else
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			end
		end
		if context.end_of_round and context.main_eval then
			if card.ability.extra.can_keep == false then
				SMODS.destroy_cards(card)
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_p"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supneptune",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Planet",
	sout_rate = 0.1,
	pos = {
		x = 9,
		y = 2,
	},
	pools = {
		SuperiorPlanet = true,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { can_activate = true, can_keep = true, level = 1 },
	},
	keep_on_use = function(self, card)
		if card.ability.extra.can_keep == true then
			return true
		end
	end,
	can_use = function(self, card)
		if card.ability.extra.can_activate then
			return true
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.hands["Straight Flush"].level,
				"Straight Flush",
				G.GAME.hands["Straight Flush"].mult,
				G.GAME.hands["Straight Flush"].chips,
			},
		}
	end,
	use = function(self, card, area, copier)
		card.ability.extra.can_activate = false
		RevosVault.level_up_hand("Straight Flush", card.ability.extra.level)
		local eval = function()
			return card.ability.extra.can_activate == false
		end
		juice_card_until(card, eval, true)
		card.ability.extra.can_keep = false
	end,
	calculate = function(self, card, context)
		if
			context.joker_main
			and card.ability.extra.can_activate == false
			and context.scoring_name == "Straight Flush"
		then
			card.ability.extra.can_keep = false
			if G.GAME.talisman == 1 then
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			else
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			end
		end
		if context.end_of_round and context.main_eval then
			if card.ability.extra.can_keep == false then
				SMODS.destroy_cards(card)
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_p"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "superis",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Planet",
	sout_rate = 0.1,
	pos = {
		x = 11,
		y = 2,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { can_activate = true, can_keep = true, level = 1 },
	},
	keep_on_use = function(self, card)
		if card.ability.extra.can_keep == true then
			return true
		end
	end,
	can_use = function(self, card)
		if card.ability.extra.can_activate then
			return true
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.hands["Flush Five"].level,
				"Flush Five",
				G.GAME.hands["Flush Five"].mult,
				G.GAME.hands["Flush Five"].chips,
			},
		}
	end,
	use = function(self, card, area, copier)
		card.ability.extra.can_activate = false
		RevosVault.level_up_hand("Flush Five", card.ability.extra.level)
		local eval = function()
			return card.ability.extra.can_activate == false
		end
		juice_card_until(card, eval, true)
		card.ability.extra.can_keep = false
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.can_activate == false and context.scoring_name == "Flush Five" then
			card.ability.extra.can_keep = false
			if G.GAME.talisman == 1 then
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			else
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			end
		end
		if context.end_of_round and context.main_eval then
			if card.ability.extra.can_keep == false then
				SMODS.destroy_cards(card)
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_p"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supceres",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Planet",
	sout_rate = 0.1,
	pos = {
		x = 12,
		y = 2,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { can_activate = true, can_keep = true, level = 1 },
	},
	keep_on_use = function(self, card)
		if card.ability.extra.can_keep == true then
			return true
		end
	end,
	can_use = function(self, card)
		if card.ability.extra.can_activate then
			return true
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.hands["Flush House"].level,
				"Flush House",
				G.GAME.hands["Flush House"].mult,
				G.GAME.hands["Flush House"].chips,
			},
		}
	end,
	use = function(self, card, area, copier)
		card.ability.extra.can_activate = false
		RevosVault.level_up_hand("Flush House", card.ability.extra.level)
		local eval = function()
			return card.ability.extra.can_activate == false
		end
		juice_card_until(card, eval, true)
		card.ability.extra.can_keep = false
	end,
	calculate = function(self, card, context)
		if
			context.joker_main
			and card.ability.extra.can_activate == false
			and context.scoring_name == "Flush House"
		then
			card.ability.extra.can_keep = false
			if G.GAME.talisman == 1 then
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			else
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			end
		end
		if context.end_of_round and context.main_eval then
			if card.ability.extra.can_keep == false then
				SMODS.destroy_cards(card)
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_p"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})

SMODS.Consumable({
	key = "supplanetx",
	set = "Superior",
	atlas = "Superior",
	hidden = true,
	soul_set = "Planet",
	sout_rate = 0.1,
	pos = {
		x = 13,
		y = 2,
	},
	discovered = true,
	config = {
		max_highlighted = 2,
		extra = { can_activate = true, can_keep = true, level = 1 },
	},
	keep_on_use = function(self, card)
		if card.ability.extra.can_keep == true then
			return true
		end
	end,
	can_use = function(self, card)
		if card.ability.extra.can_activate then
			return true
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.hands["Five of a Kind"].level,
				"Five of a Kind",
				G.GAME.hands["Five of a Kind"].mult,
				G.GAME.hands["Five of a Kind"].chips,
			},
		}
	end,
	use = function(self, card, area, copier)
		card.ability.extra.can_activate = false
		RevosVault.level_up_hand("Five of a Kind", card.ability.extra.level)
		local eval = function()
			return card.ability.extra.can_activate == false
		end
		juice_card_until(card, eval, true)
		card.ability.extra.can_keep = false
	end,
	calculate = function(self, card, context)
		if
			context.joker_main
			and card.ability.extra.can_activate == false
			and context.scoring_name == "Five of a Kind"
		then
			card.ability.extra.can_keep = false
			if G.GAME.talisman == 1 then
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			else
				return {
					xmult = 1.5,
					xchips = 1.5,
				}
			end
		end
		if context.end_of_round and context.main_eval then
			if card.ability.extra.can_keep == false then
				SMODS.destroy_cards(card)
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_superior_p"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
})
