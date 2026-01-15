SMODS.Rarity({
	key = "p",
	badge_colour = G.C.RARITY[3],
	pools = {
		["Joker"] = {
			rate = 0.01,
		},
	},
	default_weight = 0.01,
})

SMODS.Rarity({
	key = "holy",
	badge_colour = G.C.RARITY[2],
	pools = {},
})

SMODS.Rarity({
	key = "pedro",
	badge_colour = G.C.RARITY[3],
	pools = {},
})

SMODS.Rarity({
	key = "titan",
	badge_colour = G.C.RARITY[4],

	pools = {},
})

SMODS.Rarity({
	key = "curse",
	badge_colour = G.C.BLACK,
	default_weight = 0.001,
	pools = { ["Joker"] = true },
	get_weight = function(self, weight, object_type)
		if G.GAME.modifiers.crv_curse_increase then
			return 0.03
		else
			return SMODS.Rarities["crv_curse"].default_weight
		end
	end,
})