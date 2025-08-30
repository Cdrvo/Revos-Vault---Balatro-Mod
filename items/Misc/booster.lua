SMODS.Booster({
	key = "pbst",
	atlas = "booster",
	pos = { x = 0, y = 0 },
	config = { extra = 2, choose = 1 },
	group_key = "k_crv_pbstg",
	cost = 4,
	weight = 0.06,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Joker",
			rarity = "crv_p",
		})
	end,
})

SMODS.Booster({
	key = "pbst2",
	atlas = "booster",
	pos = { x = 1, y = 0 },
	config = { extra = 3, choose = 1 },
	group_key = "k_crv_pbstg",
	cost = 4,
	weight = 0.03,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Joker",
			rarity = "crv_p",
		})
	end,
})

SMODS.Booster({
	key = "pbst3",
	atlas = "booster",
	pos = { x = 2, y = 0 },
	config = { extra = 4, choose = 1 },
	group_key = "k_crv_pbstg",
	cost = 4,
	weight = 0.01,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Joker",
			rarity = "crv_p",
		})
	end,
})

SMODS.Booster({
	key = "cbst",
	atlas = "booster",
	pos = { x = 0, y = 1 },
	config = { extra = 2, choose = 1 },
	group_key = "k_crv_cbstg",
	cost = 4,
	weight = 0.03,
	kind = "Contract",
	select_card = "consumeables",
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "EnchancedDocuments",
			skip_materialize = true,
		})
	end,
})

SMODS.Booster({
	key = "cbst2",
	atlas = "booster",
	pos = { x = 1, y = 1 },
	config = { extra = 4, choose = 1 },
	group_key = "k_crv_cbstg",
	cost = 6,
	weight = 0.01,
	kind = "Contract",
	select_card = "consumeables",
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "EnchancedDocuments",
			skip_materialize = true,
		})
	end,
})

SMODS.Booster({
	key = "cbst3",
	atlas = "booster",
	pos = { x = 2, y = 1 },
	config = { extra = 4, choose = 2 },
	group_key = "k_crv_cbstg",
	cost = 8,
	weight = 0.008,
	kind = "Contract",
	select_card = "consumeables",
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "EnchancedDocuments",
			skip_materialize = true,
		})
	end,
})

SMODS.Booster({
	key = "bbst",
	atlas = "booster",
	pos = { x = 0, y = 2 },
	config = { extra = 3, choose = 1 },
	group_key = "k_crv_bbstg",
	cost = 4,
	draw_hand = false,
	weight = 0.09,
	kind = "Banana",
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "BananaPool",
			skip_materialize = true,
		})
	end,
})

SMODS.Booster({
	key = "bbst2",
	atlas = "booster",
	pos = { x = 1, y = 2 },
	config = { extra = 5, choose = 1 },
	group_key = "k_crv_bbstg",
	cost = 6,
	draw_hand = false,
	weight = 0.07,
	kind = "Banana",
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "BananaPool",
			skip_materialize = true,
		})
	end,
})

SMODS.Booster({
	key = "bbst3",
	atlas = "booster",
	pos = { x = 2, y = 2 },
	config = { extra = 5, choose = 2 },
	group_key = "k_crv_bbstg",
	cost = 8,
	draw_hand = false,
	weight = 0.04,
	kind = "Banana",
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "BananaPool",
			skip_materialize = true,
		})
	end,
})
