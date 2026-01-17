SMODS.Enhancement({
	key = "bulletproofglass",
	from = "m_glass",
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
	in_pool = function(self)
		return false
	end,
})

SMODS.Enhancement({
	key = "diamondcard",
	from = "m_steel",
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
	in_pool = function(self)
		return false
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
	in_pool = function(self)
		return false
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
	in_pool = function(self)
		return false
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
	in_pool = function(self)
		return false
	end,
})

SMODS.Enhancement({
	key = "tier1card",
	from = "m_bonus",
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
	in_pool = function(self)
		return false
	end,
})

SMODS.Enhancement({
	key = "tier2card",
	from = "m_crv_tier1card",
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
	in_pool = function(self)
		return false
	end,
})

SMODS.Enhancement({
	key = "tier3card",
	from = "m_crv_tier2card",
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
	in_pool = function(self)
		return false
	end,
})

SMODS.Enhancement({
	from = "m_crv_tier3card",
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
	from = "m_lucky",
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
			repetition = 0,
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
	in_pool = function(self)
		return false
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
	in_pool = function(self)
		return false
	end,
})

SMODS.Enhancement({
	key = "xmultcard",
	from = "m_mult",
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
	in_pool = function(self)
		return false
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
	in_pool = function(self)
		return false
	end,
})

-- there are WAY better ways of doing this but im bored and this takes time to do
	
--[[SMODS.Enhancement({
	key = "banana",
	atlas = "new_and_cool_special_atlas_for_banana_enhancement_only",
	pos = { x = 0, y = 0 },
	discovered = true,
	unlocked = true,
	replace_base_card = true,
	no_rank = true,
	no_suit = true,
	always_scores = true,
	weight = 0,
	config = {
		extra = {
			cavendish = { x_mult = 3 },
			michel = { mult = 15 },
			ghost_banana = {ghost_chips = 100 },
			jimbo = { jimbanana_mult = 8, jimbanana_odds = 6 },
			blue_java = { java_mult = 25, java_multd = 1 },
			banana_vine = { vine_timer = 3 },
			ticking_banana = { ticking_xmult = 15, ticking_rounds = 0 },
			template = { template_rounds = 0 },
			double = {double_odds = 8},
			red_banana = { red_mult = 30, red_odds = 8 },
			plantain = { plantain_rounds = 0, plantain_odds = 12, plantain_xmult = 2 },
			latundan = { latundan_chipg = 15, latundan_chips = 0, latundan_odds = 8 },
			plain = {plain_odds = 15, plain_dollars=15},
			divine = {divine_odds = 3, divine_dollars = 2},
			uneasy_banana = { unease_odds = 10, unease_xmult = 15 },
			cavicheal = { caveicheal_xchips = 6, caveicheal_odds = 1000 },
			grosdish = { grosdish_chpis = 30, grosdish_odds = 6 },
		},
	},
	loc_vars = function(self, info_queue, card)
		local key, vars
		key = (self.key .. "_" .. card.crv_bananas)
		vars = {}
		for k, v in pairs(card.ability.extra[card.crv_bananas]) do
			table.insert(vars, card.ability.extra[card.crv_bananas][k])
		end
		return { vars = vars, key = key }
	end,
	set_ability = function(self, card, initial, delay_sprites)
	if not card.crv_banana then
		local banana_backgroundx = pseudorandom_element({ 1, 2, 3 }, pseudoseed("BANANA_MAYHEM"))
		local banana_backgroundy = pseudorandom_element({ 1, 2, 3, 4, 5, 6 }, pseudoseed("BANANA_MAYHEM"))

		if banana_backgroundy == 6 then
			banana_backgroundx = pseudorandom_element({ 1, 2 }, pseudoseed("BANANA_MAYHEM"))
		end
		card.children.center:set_sprite_pos({ x = banana_backgroundx - 1, y = banana_backgroundy - 1 })

		-- y = 1
		if banana_backgroundx == 1 and banana_backgroundy == 1 then
			card.crv_bananas = "michel"
		elseif banana_backgroundx == 2 and banana_backgroundy == 1 then
			card.crv_bananas = "cavendish"
		elseif banana_backgroundx == 3 and banana_backgroundy == 1 then
			card.crv_bananas = "ghost_banana"

		-- y = 2
		elseif banana_backgroundx == 1 and banana_backgroundy == 2 then
			card.crv_bananas = "jimbo"
		elseif banana_backgroundx == 2 and banana_backgroundy == 2 then
			card.crv_bananas = "blue_java"
		elseif banana_backgroundx == 3 and banana_backgroundy == 2 then
			card.crv_bananas = "banana_vine"

		-- y = 3
		elseif banana_backgroundx == 1 and banana_backgroundy == 3 then
			card.crv_bananas = "ticking_banana"
		elseif banana_backgroundx == 2 and banana_backgroundy == 3 then
			card.crv_bananas = "template"
		elseif banana_backgroundx == 3 and banana_backgroundy == 3 then
			card.crv_bananas = "double"

		-- y = 4
		elseif banana_backgroundx == 1 and banana_backgroundy == 4 then
			card.crv_bananas = "red_banana"
		elseif banana_backgroundx == 2 and banana_backgroundy == 4 then
			card.crv_bananas = "plantain"
		elseif banana_backgroundx == 3 and banana_backgroundy == 4 then
			card.crv_bananas = "latundan"

		-- y = 5
		elseif banana_backgroundx == 1 and banana_backgroundy == 5 then
			card.crv_bananas = "plain"
		elseif banana_backgroundx == 2 and banana_backgroundy == 5 then
			card.crv_bananas = "divine"
		elseif banana_backgroundx == 3 and banana_backgroundy == 5 then
			card.crv_bananas = "uneasy_banana"

		-- y = 6
		elseif banana_backgroundx == 1 and banana_backgroundy == 6 then
			card.crv_bananas = "cavicheal"
		elseif banana_backgroundx == 2 and banana_backgroundy == 6 then
			card.crv_bananas = "grosdish"
		end
	end
end,
	calculate = function(self, card, context, effect)
		
	end,
	in_pool = function(self)
		return false
	end,
})
]]