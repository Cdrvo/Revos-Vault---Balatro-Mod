SMODS.Atlas({
    key = "joyous",
    path = "joyous.png",
    px = 71,
    py = 95,
})

SMODS.Joker({
    key = "yugiprinter",
    atlas = "joyous",
    cost = 10,
    rarity = "crv_p",
    pos = { x = 0, y = 0 },
    dependencies = "JoyousSpring",
    calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.starting_shop and not context.blueprint then
            RevosVault.create_booster("p_joy_monster_pack")
        end
	end,
})