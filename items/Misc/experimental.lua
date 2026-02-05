SMODS.Rarity({
	key = "WIP",
	badge_colour = SMODS.Gradients["crv_wip"],
})


SMODS.Joker({
	key = "fan",
	atlas = "Jokers2",
	pos = {
		x = 9,
		y = 16,
	},
	config = {
		extra = {
			def = nil
		}
	},
	rarity = "crv_curse",
	blueprint_compat = false,
	cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "crv_curse_desc"}
	end,
	add_to_deck = function(self,card,from_debuff)
		G.GAME.modifiers.curse_no_shop = true
	end,
	remove_from_deck = function(self, card, from_debuff) 
		if not RevosVault.purified_curse then
			local ccard = copy_card(card)
			if card.ability.crv_curse_triggered then
				ccard.ability.crv_curse_triggered = true
			end
			ccard:add_to_deck()
			G.crv_curses:emplace(ccard)
		else
			G.GAME.modifiers.curse_no_shop = false
		end
  	end,
	calculate = function(self,card,context)
		if context.crv_before_before then
			pseudoshuffle(G.jokers.cards)
			pseudoshuffle(G.hand.cards)
			pseudoshuffle(G.consumeables.cards)
			pseudoshuffle(G.play.cards)
		end
	end
})


SMODS.Consumable({
	key = "bottleflip",
	set = "Tarot",
	config = { extra = { odds = 8 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
		local cae = card.ability.extra
		local num, den = SMODS.get_probability_vars(card,1,cae.odds,"bottlingmyflip")
		return { vars = { num,  den } }
	end,
	pos = { x = 2, y = 1 },
	atlas = "tarots",
	cost = 3,
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		for k, v in pairs(G.jokers.cards) do
			if v and not v.edition then
				return true
			end
		end
		return false
	end,
	use = function(self, card)
		if SMODS.pseudorandom_probability(card,"bottlingmyflip",1,card.ability.extra.odds) then
			for k, v in pairs(G.jokers.cards) do
				if not v.edition then
					v:set_edition("e_polychrome")
				end
			end
		else
			RevosVault.nope({card = card})
		end
		delay(0.6)
	end,
})