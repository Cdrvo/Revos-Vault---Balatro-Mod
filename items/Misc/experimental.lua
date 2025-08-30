SMODS.Rarity({
	key = "WIP",
	badge_colour = SMODS.Gradients["crv_wip"],
})

local can_reroll_old = G.FUNCS.can_reroll
function G.FUNCS.can_reroll(e)
	if #SMODS.find_card("j_crv_2") > 0 then
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	else
		return can_reroll_old(e)
	end
end

SMODS.Joker({
	key = "2",
	atlas = "wip",
	rarity = "crv_WIP",
	pos = { x = 0, y = 0 },
	config = {
		extra = {
			timer = 1,
		},
	},
	add_to_deck = function(self, card, context)
		G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + 1
		calculate_reroll_cost(true)
	end,
	update = function(self, card, context)
		if RevosVault.check("inshop") and card.area == G.jokers then
			card.ability.extra.timer = card.ability.extra.timer - G.real_dt
			if card.ability.extra.timer <= 0 then
				G.FUNCS.reroll_shop()
				G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + 1
				G.CONTROLLER.locks.shop_reroll = true
				card.ability.extra.timer = 1
			end
		end
	end,
})
