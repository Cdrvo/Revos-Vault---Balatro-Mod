SMODS.Rarity({
	key = "chaos",
	badge_colour = G.C.DARK_EDITION,
	pools = {},
})

SMODS.Consumable({
	key = "chaoticsol",
	set = "Spectral",
	hidden = true,
	soul_set = "Spectral",
	soul_rate = 0.0001, --rare boy
	can_repeat_soul = false,
	config = { extra = {} },
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	atlas = "printersoul",
	cost = 3,
	unlocked = true,
	discovered = false,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card)
		SMODS.add_card{
			set = "Joker",
			rarity = "crv_chaos",
			area = G.jokers,
		}
	end,
})

SMODS.Joker({
	key = "chaoticprintermachine",
	atlas = "chaosa",
	rarity = "crv_chaos",
	cost = 30,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = { x = 0, y = 1 },
	config = {
		extra = { odds = 3
 },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	calculate = function(self, card, context)
		if
			context.setting_blind
			and not context.blueprint
			and pseudorandom("chaoticprintermachine") < G.GAME.probabilities.normal / card.ability.extra.odds
		then
						if G.GAME.used_vouchers["v_crv_printerup"] == true and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4  or G.GAME.used_vouchers["v_crv_printeruptier"] == true then
			for i = 1, 27 do
				SMODS.add_card({ set = "Joker", rarity = "crv_p",area = G.jokers,edition = "e_negative" })
			end
		else
			for i = 1, 27 do
				SMODS.add_card({ set = "Joker", rarity = "crv_p",area = G.jokers})
			end
		end
	end
end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "thefaxprinter",
	config = { extra = {} },
	discovered = false,
	unlocked = true,
	rarity = "crv_chaos",
	atlas = "chaosa",
	blueprint_compat = true,
	pos = { x = 1, y = 0 },
	cost = 30,
	eternal_compat = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_crv_promotion
		return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			if G.GAME.used_vouchers["v_crv_printerup"] == true and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4  or G.GAME.used_vouchers["v_crv_printeruptier"] == true then
			local new_card = create_card("Promotion", G.jokers, nil, nil, nil, nil, "j_crv_promotion")
			new_card:add_to_deck()
			new_card:set_edition({negative = true},true)
			G.jokers:emplace(new_card)
			else
			local new_card = create_card("Promotion", G.jokers, nil, nil, nil, nil, "j_crv_promotion")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "promotion",
	config = { extra = { chips = 36286368, xmult = 4153211351420 } },
	rarity = "crv_chaos",
	atlas = "chaosa",
	blueprint_compat = true,
	discovered = false,
	pos = { x = 0, y = 0 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_face() or context.other_card:get_id() == 14 then
				return {
					chips = card.ability.extra.chips,
					x_mult = card.ability.extra.xmult,
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
	key = "dirtinator9999",
	atlas = "chaosa",
	rarity = "crv_chaos",
	cost = 30,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = { x = 2, y = 0 },
	config = { extra = {} },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_dirt
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			RevosVault.printer_apply("m_crv_dirt")
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Consumable({
	key = "dirtdocument", 
	set = "EnchancedDocuments", 
	atlas = "chaosa",
	pos = { x = 2, y = 1 }, 
	discovered = true,
	config = {
		extra = {
			active = false,
			x_mult = 99999999
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	keep_on_use = function(self,card)
		return true
	end,
	can_use = function(self, card)
		return card.ability.extra.active == false
	end,
	use = function(self, card, area, copier)
		card.ability.extra.active = true
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
	calculate = function(self,card,context)
		if card.ability.extra.active and context.individual then
			if SMODS.has_enhancement(context.other_card,"m_crv_dirt") then
				SMODS.destroy_cards(context.other_card)
			else
			return{
				xmult = card.ability.extra.x_mult
			}
		end
	end
		if context.end_of_round and card.ability.extra.active then 
			SMODS.destroy_cards(card)
		end
	end
})

SMODS.Enhancement({
	key = "dirt",
	atlas = "chaosa",
	pos = { x = 1, y = 1 },
	discovered = true,
	unlocked = true,
	replace_base_card = true,
	no_rank = true,
	no_suit = true,
	overrides_base_rank = true,
	any_suit = false,
	always_scores = true,
	weight = 0,
	config = { extra = { x_mult = 99999999 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end,
	calculate = function(self, card, context, effect)
		if
			context.main_scoring and context.cardarea == G.hand
			or context.main_scoring and context.cardarea == G.play
		then
			return {
				x_mult = card.ability.extra.x_mult,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Joker({
	key = "holyprinter",
	atlas = "chaosa",
	rarity = "crv_chaos",
	cost = 30,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = { x = 0, y = 2 },
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_crv_holybanana
		return { vars = {} }
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			if G.GAME.used_vouchers["v_crv_printerup"] == true and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4  or G.GAME.used_vouchers["v_crv_printeruptier"] == true then
			local new_card = create_card("Blueprinter", G.jokers, nil, nil, nil, nil, "j_crv_holybanana")
			new_card:add_to_deck()
			new_card:set_edition({negative= true},true)
			G.jokers:emplace(new_card)
			else
			local new_card = create_card("Blueprinter", G.jokers, nil, nil, nil, nil, "j_crv_holybanana")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "hfj",
	atlas = "Jokers2",
	rarity = "crv_chaos",
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = { x = 5, y = 4 },
	config = {
		extra = { one = 0, chips = 0, ok = 0 },
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.one, card.ability.extra.chips, card.ability.extra.ok } }
	end,

	calculate = function(self, card, context)
		if
			context.joker_main
			and next(SMODS.find_mod("Talisman"))
			and card.ability.extra.one == 0
			and not context.blueprint
			and not context.repetition
		then
			card.ability.extra.ok = card.ability.extra.ok + 1
			local chips = hand_chips
			card.ability.extra.chips = chips
			card.ability.extra.one = to_number(card.ability.extra.chips * 4)
			return {
				message = localize("k_crv_error"),
			}
		elseif
			context.joker_main
			and card.ability.extra.one == 0
			and card.ability.extra.one == 0
			and not context.blueprint
			and not context.repetition
		then
			card.ability.extra.ok = card.ability.extra.ok + 1
			local chips = hand_chips
			card.ability.extra.chips = chips
			card.ability.extra.one = card.ability.extra.chips * 4
			return {
				message = localize("k_crv_error"),
			}
		end
		if context.joker_main and next(SMODS.find_mod("Talisman")) and card.ability.extra.ok > 0 then
			return {
				x_mult = to_number(card.ability.extra.one),
			}
		elseif context.joker_main and card.ability.extra.ok > 0 then
			return {
				x_mult = card.ability.extra.one,
			}
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
	key = "masterofjokers",
	atlas = "chaosa",
	rarity = "crv_chaos",
	cost = 30,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = { x = 1, y = 2 },
	config = {
		extra = {multi = 2},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.multi} }
	end,
	calculate = function(self, card, context)
    if context.joker_main then
      G.jokers.config.card_limit = G.jokers.config.card_limit * card.ability.extra.multi
    end
  end
})

SMODS.Joker({
	key = "crash",
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,
	atlas = "chaosa",
	rarity = "crv_chaos",
	cost = 30,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 2,
		y = 2,
	},
	config = {
		extra = {},
	},

	calculate = function(self, card, context)
		if context.setting_blind and G.GAME.blind.boss then
			for i = 1, G.jokers.config.total_limit - #G.jokers.cards do
		SMODS.add_card{
			key = "j_chicot"
		}
	end
	end
	end,
})
