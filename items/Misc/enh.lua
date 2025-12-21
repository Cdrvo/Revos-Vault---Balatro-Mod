SMODS.Enhancement({
	key = "bulletproofglass",
	atlas = "enh",
	pos = { x = 0, y = 0 },
	discovered = true,
	unlocked = true,
	replace_base_card = false,
	no_rank = false,
	no_suit = false,
	overrides_base_rank = false,
	any_suit = false,
	always_scores = false,
	weight = 0,
	config = { extra = { x_mult = 2, odds = 8 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	calculate = function(self, card, context, effect)
		if context.main_scoring and context.cardarea == G.play then
			return {
				x_mult = card.ability.extra.x_mult,
			}
		end
		if
			context.destroying_card
			and pseudorandom("bulletproofglass") < G.GAME.probabilities.normal / card.ability.extra.odds
		then
			G.E_MANAGER:add_event(Event({

				func = function()
					card:juice_up(0.3, 0.4)
					card:set_ability(G.P_CENTERS["m_glass"])
					card = nil
					return true
				end,
			}))
		end
	end,
})

SMODS.Enhancement({
	key = "diamondcard",
	atlas = "enh",
	pos = { x = 2, y = 0 },
	discovered = true,
	unlocked = true,
	replace_base_card = false,
	no_rank = false,
	no_suit = false,
	overrides_base_rank = false,
	any_suit = false,
	always_scores = false,
	weight = 0,
	config = { extra = { x_mult = 2.5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end,
	calculate = function(self, card, context, effect)
		if context.main_scoring and context.cardarea == G.hand then
			return {
				x_mult = card.ability.extra.x_mult,
			}
		end
	end,
})

SMODS.Enhancement({
	key = "soulcard",
	atlas = "ghost",
	pos = { x = 0, y = 0 },
	discovered = true,
	unlocked = true,
	replace_base_card = true,
	no_rank = true,
	no_suit = true,
	overrides_base_rank = true,
	any_suit = false,
	always_scores = false,
	weight = 0,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Enhancement({
	key = "mugged",
	atlas = "enh",
	pos = { x = 1, y = 1 },
	discovered = true,
	unlocked = true,
	replace_base_card = false,
	no_rank = false,
	no_suit = false,
	overrides_base_rank = false,
	any_suit = false,
	always_scores = false,
	weight = 0,
	config = { extra = { xmult = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context, effect)
		if context.main_scoring and context.cardarea == G.play and next(context.poker_hands["Flush"]) then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
	end,
})

SMODS.Enhancement({
	key = "aflame",
	atlas = "enh",
	pos = { x = 1, y = 0 },
	discovered = true,
	unlocked = true,
	replace_base_card = false,
	no_rank = false,
	no_suit = false,
	overrides_base_rank = false,
	any_suit = false,
	always_scores = false,
	weight = 0,
	config = { extra = { xmult = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context, effect)
		if context.main_scoring and context.cardarea == G.play and next(context.poker_hands["Full House"]) then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
	end,
})

SMODS.Enhancement({
	key = "mega",
	atlas = "megaenh",
	pos = { x = 0, y = 0 },
	discovered = true,
	unlocked = true,
	replace_base_card = false,
	no_rank = false,
	no_suit = false,
	overrides_base_rank = false,
	any_suit = false,
	always_scores = false,
	weight = 0,
	config = { extra = { xmult = 4 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context, effect)
		if context.main_scoring and context.cardarea == G.play then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
	end,
})

SMODS.Enhancement({
	key = "tier1card",
	atlas = "t",
	pos = { x = 0, y = 0 },
	discovered = true,
	unlocked = true,
	replace_base_card = false,
	no_rank = false,
	no_suit = false,
	overrides_base_rank = false,
	any_suit = false,
	always_scores = false,
	weight = 0,
	config = { extra = { chips = 50 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context, effect)
		if context.main_scoring and context.cardarea == G.play then
			return {
				chips = card.ability.extra.chips,
			}
		end
	end,
})

SMODS.Enhancement({
	key = "tier2card",
	atlas = "t",
	pos = { x = 1, y = 0 },
	discovered = true,
	unlocked = true,
	replace_base_card = false,
	no_rank = false,
	no_suit = false,
	overrides_base_rank = false,
	any_suit = false,
	always_scores = false,
	weight = 0,
	config = { extra = { chips = 100, mult = 10 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
	end,
	calculate = function(self, card, context, effect)
		if context.main_scoring and context.cardarea == G.play then
			return {
				chips = card.ability.extra.chips,
				mult = card.ability.extra.mult,
			}
		end
	end,
})

SMODS.Enhancement({
	key = "tier3card",
	atlas = "t",
	pos = { x = 2, y = 0 },
	discovered = true,
	unlocked = true,
	replace_base_card = false,
	no_rank = false,
	no_suit = false,
	overrides_base_rank = false,
	any_suit = false,
	always_scores = false,
	weight = 0,
	config = { extra = { chips = 200, x_mult = 3 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.x_mult } }
	end,
	calculate = function(self, card, context, effect)
		if context.main_scoring and context.cardarea == G.play then
			return {
				chips = card.ability.extra.chips,
				x_mult = card.ability.extra.x_mult,
			}
		end
	end,
})

SMODS.Enhancement({
	key = "boostcard",
	atlas = "t",
	pos = { x = 3, y = 0 },
	discovered = true,
	unlocked = true,
	replace_base_card = false,
	no_rank = false,
	no_suit = false,
	overrides_base_rank = false,
	any_suit = false,
	always_scores = false,
	weight = 0,
	config = { extra = { chips = 250, x_mult = 4, handsp = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.x_mult, card.ability.extra.handsp } }
	end,
	calculate = function(self, card, context, effect)
		if context.main_scoring and context.cardarea == G.play and not (card.ability.extra.handsp == 3) then
			card.ability.extra.handsp = card.ability.extra.handsp + 1
			return {
				chips = card.ability.extra.chips,
				x_mult = card.ability.extra.x_mult,
			}
		end
		if card.ability.extra.handsp == 3 then
			G.E_MANAGER:add_event(Event({
				func = function()
					card:juice_up(0.3, 0.4)
					card:set_ability(G.P_CENTERS["m_crv_tier3card"])
					card = nil
					return true
				end,
			}))
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Enhancement({
	key = "blessedcard",
	atlas = "enh",
	pos = { x = 0, y = 1 },
	discovered = true,
	unlocked = true,
	replace_base_card = false,
	no_rank = false,
	no_suit = false,
	overrides_base_rank = false,
	any_suit = false,
	always_scores = false,
	weight = 0,
	config = {
		extra = { odds = 5, odds2 = 3, odds3 = 2, odds4 = 10, xmult = 3, mult = 25, chips = 100, money = 30 },
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				(G.GAME.probabilities.normal or 1),
				card.ability.extra.odds,
				card.ability.extra.odds2,
				card.ability.extra.odds3,
				card.ability.extra.odds4,
				card.ability.extra.xmult,
				card.ability.extra.mult,
				card.ability.extra.chips,
			},
		}
	end,
	calculate = function(self, card, context, effect)
		local effect = {
			repetition = 0
		}
		if
			pseudorandom("blessedcard") < G.GAME.probabilities.normal / card.ability.extra.odds2
			and context.main_scoring
			and context.cardarea == G.play
		then
			effect.mult = card.ability.extra.mult
		end
		if
			pseudorandom("blessedcard") < G.GAME.probabilities.normal / card.ability.extra.odds
			and context.main_scoring
			and context.cardarea == G.play
		then
			effect.x_mult = card.ability.extra.xmult
		end
		if
			pseudorandom("blessedcard") < G.GAME.probabilities.normal / card.ability.extra.odds3
			and context.main_scoring
			and context.cardarea == G.play
		then
			effect.chips = card.ability.extra.chips
		end
		if
			pseudorandom("blessedcard") < G.GAME.probabilities.normal / card.ability.extra.odds4
			and context.main_scoring
			and context.cardarea == G.play
		then
			effect.dollars = card.ability.extra.money
		end
		return effect
	end,
})

SMODS.Enhancement({
	key = "target",
	atlas = "enh",
	pos = { x = 0, y = 2 },
	discovered = true,
	unlocked = true,
	replace_base_card = true,
	no_rank = true,
	no_suit = true,
	overrides_base_rank = true,
	any_suit = false,
	always_scores = true,
	weight = 0,
	config = { extra = {} },
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Enhancement({
	key = "honey",
	atlas = "enh",
	pos = { x = 1, y = 2 },
	discovered = true,
	unlocked = true,
	replace_base_card = false,
	no_rank = false,
	no_suit = false,
	overrides_base_rank = false,
	any_suit = false,
	always_scores = false,
	weight = 0,
	config = {
		extra = { dollars = 5 },
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.dollars,
			},
		}
	end,
	calculate = function(self, card, context, effect)
		if context.main_scoring and context.cardarea == G.play then
			return {
				dollars = card.ability.extra.dollars,
			}
		end
	end,
})

SMODS.Enhancement({
	key = "shattered",
	atlas = "enh",
	pos = { x = 0, y = 3 },
	discovered = true,
	unlocked = true,
	replace_base_card = true,
	no_rank = true,
	no_suit = true,
	always_scores = true,
	weight = 0,
	config = { extra = { x_mult = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end,
	calculate = function(self, card, context, effect)
		if context.main_scoring and context.cardarea == G.play then
			return {
				x_mult = card.ability.extra.x_mult,
			}
		end
	end,
})

SMODS.Enhancement({
	key = "xmultcard",
	atlas = "enh",
	pos = { x = 3, y = 3 },
	discovered = true,
	unlocked = true,
	replace_base_card = false,
	no_rank = false,
	no_suit = false,
	always_scores = false,
	weight = 0,
	config = { extra = { x_mult = 1.5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end,
	calculate = function(self, card, context, effect)
		if context.main_scoring and context.cardarea == G.play then
			return {
				x_mult = card.ability.extra.x_mult,
			}
		end
	end,
})

SMODS.Enhancement({
	key = "superiore",
	atlas = "enh",
	pos = { x = 4, y = 3 },
	discovered = true,
	unlocked = true,
	replace_base_card = false,
	no_rank = false,
	no_suit = false,
	always_scores = false,
	weight = 0,
	config = { extra = { xchips = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end,
	calculate = function(self, card, context, effect)
		if context.main_scoring and context.cardarea == G.play then
			return {
				xchips = card.base.id * card.ability.extra.xchips / 3,
			}
		end
	end,
})