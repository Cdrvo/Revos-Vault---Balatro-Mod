SMODS.ConsumableType({
	key = "scrap",
	collection_rows = { 4, 5 },
	primary_colour = G.C.RED,
	secondary_colour = G.C.RED,
	shop_rate = nil,
})

SMODS.UndiscoveredSprite({
	key = "scrap",
	atlas = "documents2.png",
	pos = { x = 0, y = 0 },
})

SMODS.Consumable({
	in_pool = function(self)
		return true, { allow_duplicates = true }
	end,
	key = "horn",
	discovered = true,
	unlocked = true,
	set = "scrap",
	atlas = "scrapss",
	cost = 0,
	pos = { x = 2, y = 0 },
	can_use = function(self, card)
		return true
	end,
	use = function()
		return {
			ease_dollars(30),
		}
	end,
})

SMODS.Consumable({
	in_pool = function(self)
		return true, { allow_duplicates = true }
	end,
	key = "pickles",
	discovered = true,
	unlocked = true,
	set = "scrap",
	atlas = "scrapss",
	cost = 0,
	pos = { x = 0, y = 0 },
	can_use = function(self, card)
		return true
	end,
	use = function()
		return {
			ease_dollars(25),
		}
	end,
})
SMODS.Consumable({
	in_pool = function(self)
		return true, { allow_duplicates = true }
	end,
	key = "mp",
	discovered = true,
	unlocked = true,
	set = "scrap",
	atlas = "scrapss",
	cost = 0,
	pos = { x = 1, y = 0 },
	can_use = function(self, card)
		return true
	end,
	use = function()
		return {
			ease_dollars(20),
		}
	end,
})

SMODS.Consumable({
	in_pool = function(self)
		return true, { allow_duplicates = true }
	end,
	key = "ap",
	discovered = true,
	unlocked = true,
	set = "scrap",
	atlas = "scrapss",
	cost = 0,
	pos = { x = 3, y = 0 },
	can_use = function(self, card)
		return true
	end,
	use = function()
		return {
			ease_dollars(35),
		}
	end,
})

SMODS.Consumable({
	in_pool = function(self)
		return true, { allow_duplicates = true }
	end,
	key = "dc",
	discovered = true,
	unlocked = true,
	set = "scrap",
	atlas = "scrapss",
	cost = 0,
	pos = { x = 4, y = 0 },
	can_use = function(self, card)
		return true
	end,
	use = function()
		return {
			ease_dollars(15),
		}
	end,
})