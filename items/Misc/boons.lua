-- Scrapped i dont like this at all fuck everything


--[[
--TODO: rewrite the rarity system this is ass and the previous one was ass too. im dumb

G.FUNCS.boons_menu = function()
	G.SETTINGS.paused = false
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.boons_menu_ui(),
	})
end

G.UIDEF.boons_menu_ui = function()
	ease_colour(RevosVault.C.BOONS.CURRENT, RevosVault.C.BOONS.DEFAULT) --TODO custom color for each blessing owner
	G.owned_boons = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
		G.ROOM.T.h,
		4.25 * G.CARD_W,
		0.95 * G.CARD_H,
		{ card_limit = 5, type = "shop", highlight_limit = 0 }
	)
	for k, v in pairs(G.boons.cards) do
		if v then
			SMODS.add_card({
				key = v.config.center.key,
				area = G.owned_boons,
			})
		end
	end
	G.buy_boons = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
		G.ROOM.T.h,
		4.25 * G.CARD_W,
		0.95 * G.CARD_H,
		{ card_limit = 5, type = "shop", highlight_limit = 1 }
	)
	if RevosVault.should_spawn_boon then
		RevosVault.should_spawn_boon = nil -- fuck everything

			ease_colour(RevosVault.C.BOONS.CURRENT, RevosVault.C.BOONS.DEFAULT) --TODO custom color for each blessing owner

			local from = pseudorandom_element(RevosVault.Boons.Strings)
			local rarity, real_rarity

			for k, v in pairs(RevosVault.Boons.Rarities) do
				if pseudorandom("boons") < v.rate then
					rarity = v.key
					break
				end
			end

			if not rarity then rarity = "crv_Common" end

			for k, v in pairs(RevosVault.Boons.RarityPools) do
				if string.find(string.lower(rarity), k) then
					real_rarity = v
				end
			end

			local tab, tab2 = {}, {}

			for k, v in pairs(real_rarity) do
				if v.from == from then
					tab[#tab+1] = v
				end
			end

			pseudoshuffle(tab)

			for i = 1, 3 do
				local acard = SMODS.add_card{key = tab[1].key, area = G.buy_boons}
				table.remove(tab, 1)
				create_shop_card_ui(acard)
			end

	end
	local ret = {
		n = G.UIT.C,
		config = { colour = G.C.L_BLACK, minw = 6.5, minh = 3.5, r = 0.15, padding = 0.1, align = "tm" },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0, minh = 2, minw = 5, r = 0.15, colour = G.C.DYN_UI.BOSS_MAIN },
				nodes = {
					{
						n = G.UIT.C,
						config = {
							align = "cm",
							padding = 0,
							minh = 2,
							minw = 5,
							r = 0.15,
							colour = G.C.DYN_UI.BOSS_MAIN,
						},
						nodes = {
							{
								n = G.UIT.C,
								config = {
									align = "cm",
									padding = 0,
									minh = 2,
									minw = 0.2,
									r = 0.15,
									colour = G.C.DYN_UI.BOSS_MAIN,
								},
								nodes = {},
							},
							{
								n = G.UIT.T,
								config = {
									align = "cr",
									text = "OWNED",
									scale = 0.5,
									r = 0.15,
									colour = G.C.L_BLACK,
									vert = true,
								},
							},
							{
								n = G.UIT.C,
								config = {
									align = "cm",
									padding = 0,
									minh = 2,
									minw = 0.1,
									r = 0.15,
									colour = G.C.DYN_UI.BOSS_MAIN,
								},
								nodes = {},
							},
							{ n = G.UIT.O, config = { object = G.owned_boons } },
						},
					},
				},
			},

			{
				n = G.UIT.R,
				config = { align = "tm", padding = 0, minh = 0.3, minw = 5, r = 0.15, colour = G.C.L_BLACK },
				nodes = {},
			},

			{
				n = G.UIT.R,
				config = { align = "tm", padding = 0, minh = 2, minw = 5, r = 0.15, colour = G.C.DYN_UI.BOSS_MAIN },
				nodes = {
					{
						n = G.UIT.C,
						config = {
							align = "cm",
							padding = 0,
							minh = 2,
							minw = 5,
							r = 0.15,
							colour = G.C.DYN_UI.BOSS_MAIN,
						},
						nodes = {
							{
								n = G.UIT.C,
								config = {
									align = "cm",
									padding = 0,
									minh = 2,
									minw = 0.2,
									r = 0.15,
									colour = G.C.DYN_UI.BOSS_MAIN,
								},
								nodes = {},
							},
							{
								n = G.UIT.T,
								config = {
									align = "cr",
									text = "CHOOSE",
									scale = 0.5,
									r = 0.15,
									colour = G.C.L_BLACK,
									vert = true,
								},
							},
							{
								n = G.UIT.C,
								config = {
									align = "cm",
									padding = 0,
									minh = 2,
									minw = 0.1,
									r = 0.15,
									colour = G.C.DYN_UI.BOSS_MAIN,
								},
								nodes = {},
							},
							{ n = G.UIT.O, config = { object = G.buy_boons } },
						},
					},
				},
			},
		},
	}
	return create_UIBox_generic_options({ contents = { ret } })
end

G.UIDEF.active_boons = function()
	local silent = false
	local keys_used = {}
	local area_count = 0
	local voucher_areas = {}
	local voucher_tables = {}
	local voucher_table_rows = {}
	for k, v in ipairs(G.boons.cards or {}) do
		keys_used[#keys_used + 1] = G.P_CENTERS[v.config.center.key]
	end
	for k, v in ipairs(keys_used) do
		if next(v) then
			area_count = area_count + 1
		end
	end
	for k, v in ipairs(keys_used) do
		if next(v) then
			if #voucher_areas == 5 or #voucher_areas == 10 then
				table.insert(
					voucher_table_rows,
					{ n = G.UIT.R, config = { align = "cm", padding = 0, no_fill = true }, nodes = voucher_tables }
				)
				voucher_tables = {}
			end
			voucher_areas[#voucher_areas + 1] = CardArea(
				G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
				G.ROOM.T.h,
				(#v == 1 and 1 or 1.33) * G.CARD_W,
				(area_count >= 10 and 0.75 or 1.07) * G.CARD_H,
				{ card_limit = 2, type = "voucher", highlight_limit = 0 }
			)

			local center = v
			local card = Card(
				voucher_areas[#voucher_areas].T.x + voucher_areas[#voucher_areas].T.w / 2,
				voucher_areas[#voucher_areas].T.y,
				G.CARD_W,
				G.CARD_H,
				nil,
				center,
				{ bypass_discovery_center = true, bypass_discovery_ui = true, bypass_lock = true }
			)
			card:start_materialize(nil, silent)
			silent = true
			voucher_areas[#voucher_areas]:emplace(card)

			card.ability.order = v.order

			table.insert(voucher_tables, {
				n = G.UIT.C,
				config = { align = "cm", padding = 0, no_fill = true },
				nodes = {
					{ n = G.UIT.O, config = { object = voucher_areas[#voucher_areas] } },
				},
			})
		end
	end
	table.insert(
		voucher_table_rows,
		{ n = G.UIT.R, config = { align = "cm", padding = 0, no_fill = true }, nodes = voucher_tables }
	)

	local t = silent
			and {
				n = G.UIT.ROOT,
				config = { align = "cm", colour = G.C.CLEAR },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.O,
								config = {
									object = DynaText({
										string = { "Active Boons" },
										colours = { G.C.UI.TEXT_LIGHT },
										bump = true,
										scale = 0.6,
									}),
								},
							},
						},
					},
					{ n = G.UIT.R, config = { align = "cm", minh = 0.5 }, nodes = {} },
					{
						n = G.UIT.R,
						config = { align = "cm", colour = G.C.BLACK, r = 1, padding = 0.15, emboss = 0.05 },
						nodes = {
							{ n = G.UIT.R, config = { align = "cm" }, nodes = voucher_table_rows },
						},
					},
				},
			}
		or {
			n = G.UIT.ROOT,
			config = { align = "cm", colour = G.C.CLEAR },
			nodes = {
				{
					n = G.UIT.O,
					config = {
						object = DynaText({
							string = { "No Boons" },
							colours = { G.C.UI.TEXT_LIGHT },
							bump = true,
							scale = 0.6,
						}),
					},
				},
			},
		}
	return t
end

G.FUNCS.can_accept = function(e)
	if e.config.ref_table.cost > G.GAME.dollars - G.GAME.bankrupt_at then
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	else
		e.config.colour = G.C.GREEN
		e.config.button = "accept_blessing"
	end
end

G.FUNCS.accept_blessing = function(e)
	local card = e.config.ref_table
	ease_dollars(-card.cost)
	local area = card.area

	card:activate_blessing()

	if area == G.buy_boons then
		for k, v in pairs(G.buy_boons.cards) do
			if v ~= card then
				SMODS.destroy_cards(v)
			end
		end
	end

	for k, v in pairs(G.owned_boons.cards) do
		if card.config.center.type == v.config.center.type then
			SMODS.destroy_cards(v)
		end
	end

	for k, v in pairs(G.boons.cards) do
		if card.config.center.type == v.config.center.type then
			SMODS.destroy_cards(v)
		end
	end

	SMODS.destroy_cards(card)

	local acard = SMODS.add_card({
		key = card.config.center.key,
		area = G.owned_boons,
		set = "Blessing",
	})

    acard.added_to_boons = true

	local aacard = SMODS.add_card({
		key = card.config.center.key,
		area = G.boons,
		set = "Blessing",
	})

    aacard.added_to_boons = true
end

SMODS.Atlas({
	key = "Boons",
	path = "boons.png",
	px = 64,
	py = 64,
})

local function boons_ui()
	local bb = {}

	for k, v in pairs(G.P_CENTER_POOLS.Blessing) do
		bb[#bb + 1] = v
	end

	return SMODS.card_collection_UIBox(bb, { 5, 5 }, {
		snap_back = true,
		hide_single_page = true,
		collapse_single_page = true,
		h_mod = 1.18,
		back_func = "your_collection_other_gameobjects",
	})
end

G.FUNCS.your_collection_crv_boons = function()
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = boons_ui(),
	})
end

function Card:activate_blessing(card)
	if self.activate and type(self.activate) == "function" then
		self:activate(self, card)
	end
end

function poll_boon_rarity()
	table.sort(RevosVault.Boons.Rarities)
	local rarity
	local real_r
	for k, v in pairs(RevosVault.Boons.Rarities) do
		if pseudorandom("poll_rarity") < v.rate then
			rarity = v.key
		end
	end
	for k, v in pairs(RevosVault.Boons.RarityPools) do
		if not rarity then rarity = "crv_Common" end
		rarity = string.lower(rarity)
		if string.find(rarity, k) then
			real_r = v
		end
	end
	return real_r
end

RevosVault.Boons = {
	Types = {},
	C = {
		Calculation = G.C.RED,
		Economy = G.C.GOLD,
		Deckfixing = G.C.BLUE,
		Creation = G.C.PURPLE,
	},
	Rarities = {},
    Strings = {},
    Boons = {},
	RarityPools = {
		common = {},
		rare = {},
		epic = {},
		heroic = {}
	}
}

RevosVault.Boons.Rarities = {}
RevosVault.Rarity = SMODS.GameObject:extend({
	obj_table = RevosVault.Boons.Rarities,
	obj_buffer = {},
	set = "Rarity",
	required_params = {
		"key",
		"rate",
	},
	badge_colour = HEX("FFFFFF"),
	rate = 1,
	inject = function(self)
		RevosVault.Boons.Rarities[self.key] = self
		RevosVault.C.BOONRARITY[self.key] = self.badge_colour
		-- Called every frame, moving deprecated prints here
		if self.gradient and type(self.gradient) == "function" then
			sendWarnMessage(
				('Found `gradient` function on SMODS.Rarity object "%s". This field is deprecated; please use `SMODS.Gradient` API instead.'):format(
					self.key
				),
				"Rarity"
			)
		end
	end,
	process_loc_text = function(self)
		SMODS.process_loc_text(G.localization.misc.labels, "kb_" .. self.key:lower(), self.loc_txt, "name")
		SMODS.process_loc_text(G.localization.misc.dictionary, "kb_" .. self.key:lower(), self.loc_txt, "name")
	end,
	get_rarity_badge = function(self, rarity)
		return localize("k_" .. rarity:lower())
	end,
})

RevosVault.Rarity({
	key = "Common",
	rate = 0.5,
	badge_colour = G.C.RARITY[1],
})
RevosVault.Rarity({
	key = "Rare",
	rate = 0.3,
	badge_colour = G.C.RARITY[3],
})
RevosVault.Rarity({
	key = "Epic",
	rate = 0.08,
	badge_colour = RevosVault.C.BOONS.EPIC,
})
RevosVault.Rarity({
	key = "Heroic",
	rate = 0.02,
	RevosVault.C.BOONS.HEROIC,
})

RevosVault.Boon = SMODS.Center:extend({
	set = "Blessing",
	cost = 10,
	atlas = "Boons",
	display_size = { w = 64, h = 64 },
	type = "Calculation", --idk hades stuff ig
	from = "Jimbo",
	discovered = true,
	unlocked = true,
	available = true,
	pos = { x = 0, y = 0 },
	config = {
		rarities = {
			["crv_Common"] = { config = {} },
			["crv_Rare"] = { config = {} },
			["crv_Epic"] = { config = {} },
			["crv_Heroic"] = { config = {} },

			current_rarity = "crv_Common",
		},
	},
	class_prefix = "bs",
	required_params = {
		"key",
		"type",
		"from",
	},
	register = function(self)
		self.name = self.name or self.key
		RevosVault.Boon.super.register(self)
	end,
	calculate = function(self, card, context) end,
	activate = function(self, card) end,
	inject = function(self)
		if not G.P_CENTER_POOLS[self.set] then
			G.P_CENTER_POOLS[self.set] = {}
		end
		SMODS.Center.inject(self)

		table.insert(RevosVault.Boons.Boons, self)

        if not RevosVault.Boons.Strings[self.from] then  RevosVault.Boons.Strings[# RevosVault.Boons.Strings+1] = self.from end

		for k, v in pairs(RevosVault.Boons.RarityPools) do
			if string.find(self.key, k) then
				table.insert(v, self)
			end
		end

	end,
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge("Boon", G.C.MONEY, nil, 1.2)
        badges[#badges + 1] = create_badge(localize("crv_" .. self.type), RevosVault.Boons.C[self.type], nil, 1)
		badges[#badges + 1] = create_badge(
			localize(card.ability.current_rarity),
			RevosVault.Boons.Rarities[card.ability.current_rarity].badge_colour,
			nil,
			1
		)
	end,
})

-- Jimbo's Blessings

-- Jimbo's Simplicity
RevosVault.Boon({
	key = "jimbo_simplicity_common",
	type = "Calculation",
	atlas = "Boons",
	from = "Jimbo", 
	config = {
		rarities = {
			["crv_Common"] = { config = { mult = 4 } },
			["crv_Rare"] = { config = { mult = 6 } },
			["crv_Epic"] = { config = { mult = 2 } },
			["crv_Heroic"] = { config = { mult = 4 } },
		},

		current_rarity = "crv_Common",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		local key, vars
		if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
			key =(self.key)
		else
			key = self.key
		end
		vars = { ccard.rarities[ccard.current_rarity].config.mult }
		return { key = key, vars = vars }
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.joker_main then
			print("calcing")
			if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
				return {
					mult = ccard.rarities[ccard.current_rarity].config.mult,
				}
			else
				return {
					xmult = ccard.rarities[ccard.current_rarity].config.mult,
				}
			end
		end
	end,
})

RevosVault.Boon({
	key = "jimbo_simplicity_rare",
	type = "Calculation",
	atlas = "Boons",
	from = "Jimbo", 
	no_collection = true,
	config = {
		rarities = {
			["crv_Common"] = { config = { mult = 4 } },
			["crv_Rare"] = { config = { mult = 6 } },
			["crv_Epic"] = { config = { mult = 2 } },
			["crv_Heroic"] = { config = { mult = 4 } },
		},

		current_rarity = "crv_Rare",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		local key, vars
		if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
			key =(self.key)
		else
			key = self.key
		end
		vars = { ccard.rarities[ccard.current_rarity].config.mult }
		return { key = key, vars = vars }
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.joker_main then
			print("calcing")
			if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
				return {
					mult = ccard.rarities[ccard.current_rarity].config.mult,
				}
			else
				return {
					xmult = ccard.rarities[ccard.current_rarity].config.mult,
				}
			end
		end
	end,
})

RevosVault.Boon({
	key = "jimbo_simplicity_epic",
	type = "Calculation",
	atlas = "Boons",
	from = "Jimbo", 
	no_collection = true,
	config = {
		rarities = {
			["crv_Common"] = { config = { mult = 4 } },
			["crv_Rare"] = { config = { mult = 6 } },
			["crv_Epic"] = { config = { mult = 2 } },
			["crv_Heroic"] = { config = { mult = 4 } },
		},

		current_rarity = "crv_Epic",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		local key, vars
		if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
			key =(self.key)
		else
			key = self.key
		end
		vars = { ccard.rarities[ccard.current_rarity].config.mult }
		return { key = key, vars = vars }
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.joker_main then
			print("calcing")
			if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
				return {
					mult = ccard.rarities[ccard.current_rarity].config.mult,
				}
			else
				return {
					xmult = ccard.rarities[ccard.current_rarity].config.mult,
				}
			end
		end
	end,
})

RevosVault.Boon({
	key = "jimbo_simplicity_heroic",
	type = "Calculation",
	atlas = "Boons",
	from = "Jimbo", 
	no_collection = true,
	config = {
		rarities = {
			["crv_Common"] = { config = { mult = 4 } },
			["crv_Rare"] = { config = { mult = 6 } },
			["crv_Epic"] = { config = { mult = 2 } },
			["crv_Heroic"] = { config = { mult = 4 } },
		},

		current_rarity = "crv_Heroic",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		local key, vars
		if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
			key =(self.key)
		else
			key = self.key
		end
		vars = { ccard.rarities[ccard.current_rarity].config.mult }
		return { key = key, vars = vars }
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.joker_main then
			print("calcing")
			if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
				return {
					mult = ccard.rarities[ccard.current_rarity].config.mult,
				}
			else
				return {
					xmult = ccard.rarities[ccard.current_rarity].config.mult,
				}
			end
		end
	end,
})

-- Jimbo's Generousity

RevosVault.Boon({
	key = "jimbo_generousity_common",
	type = "Economy",
	atlas = "Boons",
	from = "Jimbo",
	config = {
		rarities = {
			["crv_Common"] = { config = { dollars = 2 } },
			["crv_Rare"] = { config = { dollars = 4 } },
			["crv_Epic"] = { config = { dollars = 6 } },
			["crv_Heroic"] = { config = { dollars = 10 } },
		},

		current_rarity = "crv_Common",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = { ccard.rarities[ccard.current_rarity].config.dollars },
		}
	end,
	pos = { x = 0, y = 0 },
	calc_dollar_bonus = function(self)
		local ccard = self.config
		return ccard.rarities[ccard.current_rarity].config.dollars
	end,
})


RevosVault.Boon({
	key = "jimbo_generousity_rare",
	type = "Economy",
	atlas = "Boons",
	from = "Jimbo",
	no_collection = true,
	config = {
		rarities = {
			["crv_Common"] = { config = { dollars = 2 } },
			["crv_Rare"] = { config = { dollars = 4 } },
			["crv_Epic"] = { config = { dollars = 6 } },
			["crv_Heroic"] = { config = { dollars = 10 } },
		},

		current_rarity = "crv_Rare",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = { ccard.rarities[ccard.current_rarity].config.dollars },
		}
	end,
	pos = { x = 0, y = 0 },
	calc_dollar_bonus = function(self)
		local ccard = self.config
		return ccard.rarities[ccard.current_rarity].config.dollars
	end,
})


RevosVault.Boon({
	key = "jimbo_generousity_epic",
	type = "Economy",
	atlas = "Boons",
	from = "Jimbo",
	no_collection = true,
	config = {
		rarities = {
			["crv_Common"] = { config = { dollars = 2 } },
			["crv_Rare"] = { config = { dollars = 4 } },
			["crv_Epic"] = { config = { dollars = 6 } },
			["crv_Heroic"] = { config = { dollars = 10 } },
		},

		current_rarity = "crv_Epic",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = { ccard.rarities[ccard.current_rarity].config.dollars },
		}
	end,
	pos = { x = 0, y = 0 },
	calc_dollar_bonus = function(self)
		local ccard = self.config
		return ccard.rarities[ccard.current_rarity].config.dollars
	end,
})


RevosVault.Boon({
	key = "jimbo_generousity_heroic",
	type = "Economy",
	atlas = "Boons",
	from = "Jimbo",
	no_collection = true,
	config = {
		rarities = {
			["crv_Common"] = { config = { dollars = 2 } },
			["crv_Rare"] = { config = { dollars = 4 } },
			["crv_Epic"] = { config = { dollars = 6 } },
			["crv_Heroic"] = { config = { dollars = 10 } },
		},

		current_rarity = "crv_Heroic",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = { ccard.rarities[ccard.current_rarity].config.dollars },
		}
	end,
	pos = { x = 0, y = 0 },
	calc_dollar_bonus = function(self)
		local ccard = self.config
		return ccard.rarities[ccard.current_rarity].config.dollars
	end,
})

-- Jimbo's Supportivity

RevosVault.Boon({
	key = "jimbo_supportivity_common",
	type = "Calculation",
	atlas = "Boons",
	from = "Jimbo",
	config = {
		rarities = {
			["crv_Common"] = { config = { chips = 50 } },
			["crv_Rare"] = { config = { chips = 65 } },
			["crv_Epic"] = { config = { xchips = 3 } },
			["crv_Heroic"] = { config = { xchips = 5 } },
		},

		current_rarity = "crv_Common",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		local key, vars
		if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
			key =(self.key)
			vars = { ccard.rarities[ccard.current_rarity].config.chips }
		else
			key = self.key
			vars = { ccard.rarities[ccard.current_rarity].config.xchips }
		end
		return { key = key, vars = vars }
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.joker_main then
			if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
				return {
					chips = ccard.rarities[ccard.current_rarity].config.chips,
				}
			else
				return {
					xchips = ccard.rarities[ccard.current_rarity].config.xchips,
				}
			end
		end
	end,
})

RevosVault.Boon({
	key = "jimbo_supportivity_rare",
	type = "Calculation",
	atlas = "Boons",
	from = "Jimbo",
	no_collection = true,
	config = {
		rarities = {
			["crv_Common"] = { config = { chips = 50 } },
			["crv_Rare"] = { config = { chips = 65 } },
			["crv_Epic"] = { config = { xchips = 3 } },
			["crv_Heroic"] = { config = { xchips = 5 } },
		},

		current_rarity = "crv_Rare",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		local key, vars
		if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
			key =(self.key)
			vars = { ccard.rarities[ccard.current_rarity].config.chips }
		else
			key = self.key
			vars = { ccard.rarities[ccard.current_rarity].config.xchips }
		end
		return { key = key, vars = vars }
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.joker_main then
			if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
				return {
					chips = ccard.rarities[ccard.current_rarity].config.chips,
				}
			else
				return {
					xchips = ccard.rarities[ccard.current_rarity].config.xchips,
				}
			end
		end
	end,
})

RevosVault.Boon({
	key = "jimbo_supportivity_epic",
	type = "Calculation",
	atlas = "Boons",
	from = "Jimbo",
	no_collection = true,
	config = {
		rarities = {
			["crv_Common"] = { config = { chips = 50 } },
			["crv_Rare"] = { config = { chips = 65 } },
			["crv_Epic"] = { config = { xchips = 3 } },
			["crv_Heroic"] = { config = { xchips = 5 } },
		},

		current_rarity = "crv_Epic",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		local key, vars
		if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
			key =(self.key)
			vars = { ccard.rarities[ccard.current_rarity].config.chips }
		else
			key = self.key
			vars = { ccard.rarities[ccard.current_rarity].config.xchips }
		end
		return { key = key, vars = vars }
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.joker_main then
			if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
				return {
					chips = ccard.rarities[ccard.current_rarity].config.chips,
				}
			else
				return {
					xchips = ccard.rarities[ccard.current_rarity].config.xchips,
				}
			end
		end
	end,
})

RevosVault.Boon({
	key = "jimbo_supportivity_heroic",
	type = "Calculation",
	atlas = "Boons",
	from = "Jimbo",
	no_collection = true,
	config = {
		rarities = {
			["crv_Common"] = { config = { chips = 50 } },
			["crv_Rare"] = { config = { chips = 65 } },
			["crv_Epic"] = { config = { xchips = 3 } },
			["crv_Heroic"] = { config = { xchips = 5 } },
		},

		current_rarity = "crv_Heroic",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		local key, vars
		if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
			key =(self.key)
			vars = { ccard.rarities[ccard.current_rarity].config.chips }
		else
			key = self.key
			vars = { ccard.rarities[ccard.current_rarity].config.xchips }
		end
		return { key = key, vars = vars }
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.joker_main then
			if ccard.current_rarity == "crv_Common" or ccard.current_rarity == "crv_Rare" then
				return {
					chips = ccard.rarities[ccard.current_rarity].config.chips,
				}
			else
				return {
					xchips = ccard.rarities[ccard.current_rarity].config.xchips,
				}
			end
		end
	end,
})

-- Canio's Blessings

-- Canio's Brutality

RevosVault.Boon({
	key = "canio_brutality_common",
	type = "Deckfixing",
	atlas = "Boons",
	from = "Canio",
	config = {
		current_rarity = "crv_Common",

		rarities = {
			["crv_Common"] = { config = { odds = 6 } },
			["crv_Rare"] = { config = { odds = 4 } },
			["crv_Epic"] = { config = { odds = 2 } },
			["crv_Heroic"] = { config = { odds = 1 } },
		},
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = { (G.GAME.probabilities.normal or 1), ccard.rarities[ccard.current_rarity].config.odds },
		}
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.individual and context.cardarea == G.play then
			if
				context.other_card:is_face()
				and pseudorandom("brutality")
					< G.GAME.probabilities.normal / ccard.rarities[ccard.current_rarity].config.odds
			then
				SMODS.destroy_cards(context.other_card)
				return {
					message = "Brutality!",
				}
			end
		end
	end,
})

RevosVault.Boon({
	key = "canio_brutality_rare",
	type = "Deckfixing",
	atlas = "Boons",
	from = "Canio",
	no_collection = true,
	config = {
		current_rarity = "crv_Rare",

		rarities = {
			["crv_Common"] = { config = { odds = 6 } },
			["crv_Rare"] = { config = { odds = 4 } },
			["crv_Epic"] = { config = { odds = 2 } },
			["crv_Heroic"] = { config = { odds = 1 } },
		},
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = { (G.GAME.probabilities.normal or 1), ccard.rarities[ccard.current_rarity].config.odds },
		}
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.individual and context.cardarea == G.play then
			if
				context.other_card:is_face()
				and pseudorandom("brutality")
					< G.GAME.probabilities.normal / ccard.rarities[ccard.current_rarity].config.odds
			then
				SMODS.destroy_cards(context.other_card)
				return {
					message = "Brutality!",
				}
			end
		end
	end,
})

RevosVault.Boon({
	key = "canio_brutality_epic",
	type = "Deckfixing",
	atlas = "Boons",
	from = "Canio",
	no_collection = true,
	config = {
		current_rarity = "crv_Epic",

		rarities = {
			["crv_Common"] = { config = { odds = 6 } },
			["crv_Rare"] = { config = { odds = 4 } },
			["crv_Epic"] = { config = { odds = 2 } },
			["crv_Heroic"] = { config = { odds = 1 } },
		},
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = { (G.GAME.probabilities.normal or 1), ccard.rarities[ccard.current_rarity].config.odds },
		}
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.individual and context.cardarea == G.play then
			if
				context.other_card:is_face()
				and pseudorandom("brutality")
					< G.GAME.probabilities.normal / ccard.rarities[ccard.current_rarity].config.odds
			then
				SMODS.destroy_cards(context.other_card)
				return {
					message = "Brutality!",
				}
			end
		end
	end,
})

RevosVault.Boon({
	key = "canio_brutality_heroic",
	type = "Deckfixing",
	atlas = "Boons",
	from = "Canio",
	no_collection = true,
	config = {
		current_rarity = "crv_Heroic",

		rarities = {
			["crv_Common"] = { config = { odds = 6 } },
			["crv_Rare"] = { config = { odds = 4 } },
			["crv_Epic"] = { config = { odds = 2 } },
			["crv_Heroic"] = { config = { odds = 1 } },
		},
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = { (G.GAME.probabilities.normal or 1), ccard.rarities[ccard.current_rarity].config.odds },
		}
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.individual and context.cardarea == G.play then
			if
				context.other_card:is_face()
				and pseudorandom("brutality")
					< G.GAME.probabilities.normal / ccard.rarities[ccard.current_rarity].config.odds
			then
				SMODS.destroy_cards(context.other_card)
				return {
					message = "Brutality!",
				}
			end
		end
	end,
})

-- Canio's Patiance

RevosVault.Boon({
	key = "canio_patiance_common",
	type = "Creation",
	atlas = "Boons",
	from = "Canio",
	config = {
		rarities = {
			["crv_Common"] = { config = { amount = 1, edition = nil } },
			["crv_Rare"] = { config = { amount = 2, edition = nil } },
			["crv_Epic"] = { config = { amount = 2, edition = "e_negative" } },
			["crv_Heroic"] = { config = { amount = 3, edition = "e_negative" } },
		},
		current_rarity = "crv_Common",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		local key, vars
		if
			ccard.rarities[ccard.current_rarity] == "crv_Epic"
			or ccard.rarities[ccard.current_rarity] == "crv_Heroic"
		then
			key =(self.key)
			vars = {
				ccard.rarities[ccard.current_rarity].config.amount,
				ccard.rarities[ccard.current_rarity].config.edition,
			}
		else
			key = self.key
			vars = { ccard.rarities[ccard.current_rarity].config.amount }
		end
		return { key = key, vars = vars }
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.setting_blind then
			for i = 1, ccard.rarities[ccard.current_rarity].config.amount do
				SMODS.add_card({
					key = "c_death",
					edition = ccard.rarities[ccard.current_rarity].config.edition,
				})
			end
		end
	end,
})

RevosVault.Boon({
	key = "canio_patiance_rare",
	type = "Creation",
	atlas = "Boons",
	from = "Canio",
	config = {
		rarities = {
			["crv_Common"] = { config = { amount = 1, edition = nil } },
			["crv_Rare"] = { config = { amount = 2, edition = nil } },
			["crv_Epic"] = { config = { amount = 2, edition = "e_negative" } },
			["crv_Heroic"] = { config = { amount = 3, edition = "e_negative" } },
		},
		current_rarity = "crv_Rare",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		local key, vars
		if
			ccard.rarities[ccard.current_rarity] == "crv_Epic"
			or ccard.rarities[ccard.current_rarity] == "crv_Heroic"
		then
			key =	(self.key)
			vars = {
				ccard.rarities[ccard.current_rarity].config.amount,
				ccard.rarities[ccard.current_rarity].config.edition,
			}
		else
			key = self.key
			vars = { ccard.rarities[ccard.current_rarity].config.amount }
		end
		return { key = key, vars = vars }
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.setting_blind then
			for i = 1, ccard.rarities[ccard.current_rarity].config.amount do
				SMODS.add_card({
					key = "c_death",
					edition = ccard.rarities[ccard.current_rarity].config.edition,
				})
			end
		end
	end,
})

RevosVault.Boon({
	key = "canio_patiance_epic",
	type = "Creation",
	atlas = "Boons",
	from = "Canio",
	config = {
		rarities = {
			["crv_Common"] = { config = { amount = 1, edition = nil } },
			["crv_Rare"] = { config = { amount = 2, edition = nil } },
			["crv_Epic"] = { config = { amount = 2, edition = "e_negative" } },
			["crv_Heroic"] = { config = { amount = 3, edition = "e_negative" } },
		},
		current_rarity = "crv_Epic",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		local key, vars
		if
			ccard.rarities[ccard.current_rarity] == "crv_Epic"
			or ccard.rarities[ccard.current_rarity] == "crv_Heroic"
		then
			key =(self.key)
			vars = {
				ccard.rarities[ccard.current_rarity].config.amount,
				ccard.rarities[ccard.current_rarity].config.edition,
			}
		else
			key = self.key
			vars = { ccard.rarities[ccard.current_rarity].config.amount }
		end
		return { key = key, vars = vars }
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.setting_blind then
			for i = 1, ccard.rarities[ccard.current_rarity].config.amount do
				SMODS.add_card({
					key = "c_death",
					edition = ccard.rarities[ccard.current_rarity].config.edition,
				})
			end
		end
	end,
})

RevosVault.Boon({
	key = "canio_patiance_heroic",
	type = "Creation",
	atlas = "Boons",
	from = "Canio",
	config = {
		rarities = {
			["crv_Common"] = { config = { amount = 1, edition = nil } },
			["crv_Rare"] = { config = { amount = 2, edition = nil } },
			["crv_Epic"] = { config = { amount = 2, edition = "e_negative" } },
			["crv_Heroic"] = { config = { amount = 3, edition = "e_negative" } },
		},
		current_rarity = "crv_Heroic",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		local key, vars
		if
			ccard.rarities[ccard.current_rarity] == "crv_Epic"
			or ccard.rarities[ccard.current_rarity] == "crv_Heroic"
		then
			key =(self.key)
			vars = {
				ccard.rarities[ccard.current_rarity].config.amount,
				ccard.rarities[ccard.current_rarity].config.edition,
			}
		else
			key = self.key
			vars = { ccard.rarities[ccard.current_rarity].config.amount }
		end
		return { key = key, vars = vars }
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.setting_blind then
			for i = 1, ccard.rarities[ccard.current_rarity].config.amount do
				SMODS.add_card({
					key = "c_death",
					edition = ccard.rarities[ccard.current_rarity].config.edition,
				})
			end
		end
	end,
})

-- Canio's Captivity

RevosVault.Boon({
	key = "canio_captivity_common",
	type = "Calculation",
	atlas = "Boons",
	from = "Canio",
	config = {
		rarities = {
			["crv_Common"] = { config = { xmultg = 0.2, xmult = 1 } },
			["crv_Rare"] = { config = { xmultg = 0.5, xmult = 1 } },
			["crv_Epic"] = { config = { xmultg = 1, xmult = 1 } },
			["crv_Heroic"] = { config = { xmultg = 1.5, xmult = 1 } },
		},
		current_rarity = "crv_Common",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = {
				ccard.rarities[ccard.current_rarity].config.xmult,
				ccard.rarities[ccard.current_rarity].config.xmultg,
			},
		}
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.remove_playing_cards then
			if context.removed:is_face() then
				SMODS.scale_card(card, {
					ref_table = ccard.rarities[ccard.current_rarity].config,
					ref_value = "xmult",
					scalar_value = "xmultg",
				})
			end
		end
		if context.end_of_round and G.GAME.blind.boss then
			ccard.rarities[ccard.current_rarity].config.xmult = 1
			return {
				message = localize("k_reset"),
			}
		end
	end,
})

RevosVault.Boon({
	key = "canio_captivity_rare",
	type = "Calculation",
	atlas = "Boons",
	from = "Canio",
	config = {
		rarities = {
			["crv_Common"] = { config = { xmultg = 0.2, xmult = 1 } },
			["crv_Rare"] = { config = { xmultg = 0.5, xmult = 1 } },
			["crv_Epic"] = { config = { xmultg = 1, xmult = 1 } },
			["crv_Heroic"] = { config = { xmultg = 1.5, xmult = 1 } },
		},
		current_rarity = "crv_Rare",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = {
				ccard.rarities[ccard.current_rarity].config.xmult,
				ccard.rarities[ccard.current_rarity].config.xmultg,
			},
		}
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.remove_playing_cards then
			if context.removed:is_face() then
				SMODS.scale_card(card, {
					ref_table = ccard.rarities[ccard.current_rarity].config,
					ref_value = "xmult",
					scalar_value = "xmultg",
				})
			end
		end
		if context.end_of_round and G.GAME.blind.boss then
			ccard.rarities[ccard.current_rarity].config.xmult = 1
			return {
				message = localize("k_reset"),
			}
		end
	end,
})

RevosVault.Boon({
	key = "canio_captivity_epic",
	type = "Calculation",
	atlas = "Boons",
	from = "Canio",
	config = {
		rarities = {
			["crv_Common"] = { config = { xmultg = 0.2, xmult = 1 } },
			["crv_Rare"] = { config = { xmultg = 0.5, xmult = 1 } },
			["crv_Epic"] = { config = { xmultg = 1, xmult = 1 } },
			["crv_Heroic"] = { config = { xmultg = 1.5, xmult = 1 } },
		},
		current_rarity = "crv_Epic",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = {
				ccard.rarities[ccard.current_rarity].config.xmult,
				ccard.rarities[ccard.current_rarity].config.xmultg,
			},
		}
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.remove_playing_cards then
			if context.removed:is_face() then
				SMODS.scale_card(card, {
					ref_table = ccard.rarities[ccard.current_rarity].config,
					ref_value = "xmult",
					scalar_value = "xmultg",
				})
			end
		end
		if context.end_of_round and G.GAME.blind.boss then
			ccard.rarities[ccard.current_rarity].config.xmult = 1
			return {
				message = localize("k_reset"),
			}
		end
	end,
})

RevosVault.Boon({
	key = "canio_captivity_heroic",
	type = "Calculation",
	atlas = "Boons",
	from = "Canio",
	config = {
		rarities = {
			["crv_Common"] = { config = { xmultg = 0.2, xmult = 1 } },
			["crv_Rare"] = { config = { xmultg = 0.5, xmult = 1 } },
			["crv_Epic"] = { config = { xmultg = 1, xmult = 1 } },
			["crv_Heroic"] = { config = { xmultg = 1.5, xmult = 1 } },
		},
		current_rarity = "crv_Heroic",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = {
				ccard.rarities[ccard.current_rarity].config.xmult,
				ccard.rarities[ccard.current_rarity].config.xmultg,
			},
		}
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.remove_playing_cards then
			if context.removed:is_face() then
				SMODS.scale_card(card, {
					ref_table = ccard.rarities[ccard.current_rarity].config,
					ref_value = "xmult",
					scalar_value = "xmultg",
				})
			end
		end
		if context.end_of_round and G.GAME.blind.boss then
			ccard.rarities[ccard.current_rarity].config.xmult = 1
			return {
				message = localize("k_reset"),
			}
		end
	end,
})

-- Yorick's Blessings

--Yorick's Loyalty

RevosVault.Boon({
	key = "yorick_loyalty_common",
	type = "Deckfixing",
	atlas = "Boons",
	from = "Yorick",
	config = {
		rarities = {
			["crv_Common"] = { config = {increase = 1} },
		},
		current_rarity = "crv_Common",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = {
				ccard.rarities[ccard.current_rarity].config.increase,
			},
		}
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.discard then
			SMODS.modify_rank(context.discard, ccard.rarities[ccard.current_rarity].config.increase)
			return{
				message = "Loyalty!"
			}
		end
	end,
})

RevosVault.Boon({
	key = "yorick_loyalty_rare",
	type = "Deckfixing",
	atlas = "Boons",
	from = "Yorick",
	config = {
		rarities = {
			["crv_Rare"] = { config = { xmultg = 0.2, increase = 2 } },
		},
		current_rarity = "crv_Rare",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = {
				ccard.rarities[ccard.current_rarity].config.increase,
			},
		}
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.discard then
			SMODS.modify_rank(context.discard, ccard.rarities[ccard.current_rarity].config.increase)
			return{
				message = "Loyalty!"
			}
		end
	end,
})

RevosVault.Boon({
	key = "yorick_loyalty_epic",
	type = "Deckfixing",
	atlas = "Boons",
	from = "Yorick",
	config = {
		rarities = {
			["crv_Rare"] = { config = { xmultg = 0.2, increase = 2,enhancement = "m_mult" } },
		},
		current_rarity = "crv_Rare",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = {
				ccard.rarities[ccard.current_rarity].config.increase,
			},
		}
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.discard then
			SMODS.modify_rank(context.discard, ccard.rarities[ccard.current_rarity].config.increase)
			card:set_ability(ccard.rarities[ccard.current_rarity].config.enhancement)
			return{
				message = "Loyalty!"
			}
		end
	end,
})
RevosVault.Boon({
	key = "yorick_loyalty_heroic",
	type = "Deckfixing",
	atlas = "Boons",
	from = "Yorick",
	config = {
		rarities = {
			["crv_Rare"] = { config = { xmultg = 0.2, increase = 3,enhancement = "m_glass" } },
		},
		current_rarity = "crv_Rare",
	},
	loc_vars = function(self, info_queue, card)
		local ccard = card.ability
		return {
			vars = {
				ccard.rarities[ccard.current_rarity].config.increase,
			},
		}
	end,
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		local ccard = card.ability
		if context.discard then
			SMODS.modify_rank(context.discard, ccard.rarities[ccard.current_rarity].config.increase)
			card:set_ability(ccard.rarities[ccard.current_rarity].config.enhancement)
			return{
				message = "Loyalty!"
			}
		end
	end,
})
-- Triboulet's Blessings
-- Perkeo's Blessings
-- Chicot's Blessings

]]