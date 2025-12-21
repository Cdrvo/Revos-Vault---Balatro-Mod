SMODS.Enhancement({
	key = "ignited",
	atlas = "paradox",
	pos = { x = 2, y = 0 },
	shatters = true,
	config = {
		extra = {
			add = 0.1,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.add },
		}
	end,
	dependencies = "paradox_ideas",
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.play then
			for _, v in ipairs(context.scoring_hand) do
				v.ability.perma_x_mult = (v.ability.perma_x_mult or 0) + card.ability.extra.add
				v:juice_up()
			end
		end
	end,
})

SMODS.Consumable({
	key = "ashencontract",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "paradox",
	pos = { x = 1, y = 0 },
	config = {
		extra = {
			chip_add = 10,
			xmult = 3,
			odds = 3,
			active = false,
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	can_use = function(self, card)
		return card.ability.extra.active == false
	end,
	keep_on_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		card.ability.extra.active = true
		local eval = function()
			return card.ability.extra.active == true
		end
		juice_card_until(card, eval, true)
	end,
	calculate = function(self, card, context)
		if card.ability.extra.active and context.individual then
			if context.cardarea == G.play then
				for _, v in ipairs(context.scoring_hand) do
					v.ability.perma_bonus = (v.ability.perma_bonus or 0) + card.ability.extra.chip_add
					v:juice_up()
				end
			end
		end
		if
			context.destroy_card
			and context.cardarea == G.play
			and card.ability.extra.active
			and (SMODS.has_enhancement(context.destroy_card, "m_para_ashen") or pseudorandom("paraparaashpara") < G.GAME.probabilities.normal / card.ability.extra.odds)
		then
			return {
				remove = true,
			}
		end
		if context.end_of_round and card.ability.extra.active then
			SMODS.destroy_cards(card)
		end
	end,
})

SMODS.Joker({
	key = "ahsenprinter",
	atlas = "paradox",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	pos = {
		x = 0,
		y = 0,
	},
	dependencies = "paradox_ideas",
	loc_vars = function(self, info_queue, center) 
	return{
		vars = {
		G.GAME.probabilities.normal}}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
				if context.first_hand_drawn then
			RevosVault.printer_apply("m_para_ashen", "m_crv_ignited", nil)
		end
	end,
})
