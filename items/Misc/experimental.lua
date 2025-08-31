SMODS.Rarity({
	key = "WIP",
	badge_colour = SMODS.Gradients["crv_wip"],
})

SMODS.Joker({
	key = "print_tester",
	atlas = "wip",
	rarity = "crv_WIP",
	pos = { x = 0, y = 0 },
	config = {
		extra = {
			timer = 1,
		},
	},
	calculate = function(self,card,context)

		if context.sticker_applied then
			print(context.other_sticker.key, context.other_card.config.center.key, "applied")
		end

		if context.sticker_removed then
			print(context.other_sticker.key, context.other_card.config.center.key, "removed")
		end

	end,
})
