-------------MOD CODE-------------
RevosVault = SMODS.current_mod
RevoConfig = SMODS.current_mod.config

--BEHOLD! THE WORST CODE IN HISTORY UNFOLDS UPON YOUR EYES!
--No but seriously goodluck understanding anything


RevosVault.optional_features = { retrigger_joker = true }

--Kindly took this from Prism :D

local old_config = copy_table(RevosVault.config)
local function should_restart()
	for k, v in pairs(old_config) do
		if v ~= RevosVault.config[k] then
			SMODS.full_restart = 1
			return
		end
	end
	SMODS.full_restart = 0
end

RevosVault.config_tab = function()
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", padding = 0.07, emboss = 0.05, r = 0.1, colour = G.C.BLACK, minh = 4.5, minw = 7 },
		nodes = {
			{
				n = G.UIT.R,
				nodes = {
					{
						n = G.UIT.C,
						nodes = {
							create_toggle({
								label = localize("crv_enable_blinds"),
								ref_table = RevosVault.config,
								ref_value = "blinds_enabled",
								callback = should_restart,
							}),
							create_toggle({
								label = localize("crv_enable_chaoscards"),
								ref_table = RevosVault.config,
								ref_value = "chaos_enabled",
								callback = should_restart,
							}),
							create_toggle({
								label = localize("crv_enable_vaulteds"),
								ref_table = RevosVault.config,
								ref_value = "vault_enabled",
								callback = should_restart,
							}),
							create_toggle({
								label = localize("crv_enable_superior"),
								ref_table = RevosVault.config,
								ref_value = "superior_enabled",
								callback = should_restart,
							}),
							create_toggle({
								label = localize("crv_enable_wip") .. "*",
								ref_table = RevosVault.config,
								ref_value = "experimental_enabled",
								callback = should_restart,
							}),
							create_toggle({
								label = localize("crv_enable_secret"),
								ref_table = RevosVault.config,
								ref_value = "secretjokers_enabled",
								callback = should_restart,
							}),
							create_toggle({
								label = localize("crv_enable_gems"),
								ref_table = RevosVault.config,
								ref_value = "gems_enabled",
								callback = should_restart,
							}),
						},
					},
				},
			},
			{
				n = G.UIT.R,
				config = { align = "cm", minh = 0.6 },
				nodes = {
					{ n = G.UIT.T, config = { text = "Requires restart!", colour = G.C.RED, scale = 0.4 } },
				},
			},
			{
				n = G.UIT.R,
				config = { align = "cm", minh = 0.6 },
				nodes = {
					{ n = G.UIT.T, config = { text = "*" .. "Not Recommended!", colour = G.C.WHITE, scale = 0.4 } },
				},
			},
		},
	}
end

--[[RevosVault.configs = {}

RevosVault.Config = SMODS.GameObject:extend({ -- the arrow thingy
	rarity = 1,
	unlocked = true,
	discovered = true,
	no_collection = true,
	pos = { x = 0, y = 0 },
	cost = 0,
	obj_table = RevosVault.configs,
	obj_buffer = {},
	config = {},
	set = "RVCONF",
	atlas = "Jokers2",
	conf = "blinds_enabled",
	required_params = {
		"key",
	},
    inject = function(self)

	if not G.P_CENTER_POOLS[self.set] then
		G.P_CENTER_POOLS[self.set] = {}
	end

    SMODS.Center.inject(self)

  	end,
	set_card_type_badge = function(self, card, badges) end,
})
RevosVault.Config({ --used for the title screen
	key = "blinds_enabled",
		atlas = "Jokers2",
	rarity = "crv_p",
	pos = {
		x = 0,
		y = 1,
	},
	conf = "blinds_enabled",
})
RevosVault.Config({ --used for the title screen
	key = "chaos_enabled",
		atlas = "Jokers2",
	rarity = "crv_p",
	pos = {
		x = 0,
		y = 1,
	},
	conf = "chaos_enabled",
})
RevosVault.Config({ --used for the title screen
	key = "vault_enabled",
		atlas = "Jokers2",
	rarity = "crv_p",
	pos = {
		x = 0,
		y = 1,
	},
	conf = "vault_enabled",
})
RevosVault.Config({ --used for the title screen
	key = "superior_enabled",
		atlas = "Jokers2",
	rarity = "crv_p",
	pos = {
		x = 0,
		y = 1,
	},
	conf = "superior_enabled",
})
RevosVault.Config({ --used for the title screen
	key = "experimental_enabled",
		atlas = "Jokers2",
	rarity = "crv_p",
	pos = {
		x = 0,
		y = 1,
	},
	conf = "experimental_enabled",
})
RevosVault.Config({ --used for the title screen
	key = "secretjokers_enabled",
		atlas = "Jokers2",
	rarity = "crv_p",
	pos = {
		x = 0,
		y = 1,
	},
	conf = "secretjokers_enabled",
})
RevosVault.Config({ --used for the title screen
	key = "gems_enabled",
		atlas = "Jokers2",
	rarity = "crv_p",
	pos = {
		x = 0,
		y = 1,
	},
	conf = "gems_enabled",
})


local old_config = copy_table(RevosVault.config) -- unused

local click_old = Card.click
function Card:click()
	local ret = click_old(self)
	if (self.area == G.printer_info2) or (self.area == G.printer_info3)then
			self.debuff = RevosVault.config[self.config.center.conf]
			self:juice_up()
			play_sound("tarot1")
			RevosVault.config[self.config.center.conf] = not RevosVault.config[self.config.center.conf]
	else
	end
	return ret
end

RevosVault.config_tab = function()
		G.printer_info2 = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
		G.ROOM.T.h,
		4.25 * G.CARD_W,
		0.95 * G.CARD_H,
		{ card_limit = 4, type = "shop", highlight_limit = 0, collection = true }
	)
		G.printer_info3 = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
		G.ROOM.T.h,
		4.25 * G.CARD_W,
		0.95 * G.CARD_H,
		{ card_limit = 4, type = "shop", highlight_limit = 0, collection = true }
	)
	modNodes = {
		{
			n = G.UIT.R,
			config = { align = "cm" },
			nodes = {
				{
					n = G.UIT.O,
					config = {
						object = DynaText({
							string = "Click to disable/enable",
							colours = { G.C.WHITE },
							shadow = true,
							scale = 0.4,
						}),
					},
				},
			},
		},
		{
		n = G.UIT.R,
			config = { align = "cm", padding = 0.07, no_fill = true },
			nodes = {
				{ n = G.UIT.O, config = { object = G.printer_info2 } },
			},
		},
		first_row = { n = G.UIT.R, config = { align = "tm", padding = 0.05 }, nodes = {} },
		{
		n = G.UIT.R,
		config = { align = "cm", padding = 0.07, no_fill = true },
		nodes = {
			{ n = G.UIT.O, config = { object = G.printer_info3 } },
		},
	}
	}


	for i, key in ipairs({"crv_chaos_enabled","crv_vault_enabled","crv_blinds_enabled","crv_secretjokers_enabled"}) do
		local card = Card(
			G.printer_info2.T.x + G.printer_info2.T.w / 2,
			G.printer_info2.T.y,
			G.CARD_W,
			G.CARD_H,
			G.P_CARDS.empty,
			G.P_CENTERS[key]
		)
		G.printer_info2:emplace(card)
	end
	for i, key in ipairs({"crv_gems_enabled","crv_superior_enabled","crv_experimental_enabled"}) do
	local card2 = Card(
			G.printer_info2.T.x + G.printer_info2.T.w / 2,
			G.printer_info2.T.y,
			G.CARD_W,
			G.CARD_H,
			G.P_CARDS.empty,
			G.P_CENTERS[key]
		)
		G.printer_info3:emplace(card2)
	end

	return {
		n = G.UIT.ROOT,
		config = {
			emboss = 0.05,
			minh = 6,
			r = 0.1,
			minw = 10,
			align = "cm",
			padding = 0.2,
			colour = G.C.BLACK,
		},
		nodes = modNodes,
	}
end]]


RevosVault.Lib = {
	"funcs",
	"hooks",
	"ui",
}
RevosVault.Consumables = {
	"tarots",
	"scrap",
	"superior",
	"contracts"
}
RevosVault.Jokers = {
	"self_inserts",
	"commons",
	"uncommons",
	"rares",
	"printers",
	"legendaries",
	"vault",
	"chaos",
	"secretjokers",
}
RevosVault.Misc = {
	"atlas",
	"rarities",
	"blinds",
	"booster",
	"challenge",
	"decks",
	"editions",
	"enh",
	"gems",
	"misc",
	"seals",
	"stakes",
	"stickers",
	"tags",
	"vouchers",
	"experimental",
	"achievements",
	"boons"
}

RevosVault.CrossMod = {
	"RiftRaft",
	"reverse_tarot",
	"TOGAPack",
	"CardSleeves",
	"JokerDisplay",
	"Bakery",
	"Maximus",
	"MoreFluff",
	"Prism",
	"sdm0sstuff",
	"aikoyorisshenanigans",
	"GARBPACK",
	"partner",
	"tangent",
	"NotVanilla",
	"GrabBag",
	"LuckyRabbit",
	"paradox_ideas",
	"pokerjokers",
	"entr",
	"kino",
	"ortalab",
	"pta_saka",
	"finity",
	"stacked",
	"high_roller",
	"JoyousSpring",
	"Incognito",
	"starspace"
}


--
for k, file in pairs(RevosVault.Lib) do
	SMODS.load_file("items/Lib/" .. file .. ".lua")()
end

for k, file in pairs(RevosVault.Misc) do
	if RevoConfig[file .. "_enabled"] ~= nil then
		if RevoConfig[file .. "_enabled"] ~= false then 
			SMODS.load_file("items/Misc/" .. file .. ".lua")()
		end
	else
		SMODS.load_file("items/Misc/" .. file .. ".lua")()
	end
end

for k, file in pairs(RevosVault.Consumables) do
	if RevoConfig[file .. "_enabled"] ~= nil then
		if RevoConfig[file .. "_enabled"] ~= false then
			SMODS.load_file("items/Consumables/" .. file .. ".lua")()
		end
	else
		SMODS.load_file("items/Consumables/" .. file .. ".lua")()
	end
end

for k, file in pairs(RevosVault.Jokers) do
	if RevoConfig[file .. "_enabled"] ~= nil then
		if RevoConfig[file .. "_enabled"] ~= false then
			SMODS.load_file("items/Jokers/" .. file .. ".lua")()
		end
	else
		SMODS.load_file("items/Jokers/" .. file .. ".lua")()
	end
end

for k, file in pairs(RevosVault.CrossMod) do
	if next(SMODS.find_mod(file)) then
		SMODS.load_file("items/Cross-Mod/" .. file .. ".lua")()
	end
end


SMODS.Joker({ --used for the title screen
	key = "printertitle",
	atlas = "Jokers",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = true,
	no_collection = true,
	pos = {
		x = 0,
		y = 0,
	},
	in_pool = function(self)
		return false
	end,
})

SMODS.Joker({ --used for the title screen
	key = "grossprintertitle",
	atlas = "Jokers",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = true,
	no_collection = true,
	pos = {
		x = 0,
		y = 1,
	},
	in_pool = function(self)
		return false
	end,
})

--Adds Gross Printer to the main menu. Code from Cryptid

local oldfunc = Game.main_menu --ily cryptid x2
Game.main_menu = function(change_context)
	local ret = oldfunc(change_context)

	local newcard = Card(
		G.title_top.T.x,
		G.title_top.T.y,
		G.CARD_W,
		G.CARD_H,
		G.P_CARDS.empty,
		G.P_CENTERS.j_crv_grossprintertitle,
		{ bypass_discovery_center = true }
	)

	G.title_top.T.w = G.title_top.T.w * 1.7675
	G.title_top.T.x = G.title_top.T.x - 0.8
	G.title_top:emplace(newcard)

	newcard.T.w = newcard.T.w * 1.1 * 1.25
	newcard.T.h = newcard.T.h * 1.1 * 1.25
	newcard.no_ui = true
	newcard.states.visible = true
	return ret
end

SMODS.current_mod.reset_game_globals = function(run_start)
	if run_start then
		calculate_modded_printer()
	end

	calculate_modded_printer()

end


--ily cryptid
SMODS.ObjectType({
	key = "Food",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		self:inject_card(G.P_CENTERS.j_gros_michel)
		self:inject_card(G.P_CENTERS.j_egg)
		self:inject_card(G.P_CENTERS.j_ice_cream)
		self:inject_card(G.P_CENTERS.j_cavendish)
		self:inject_card(G.P_CENTERS.j_turtle_bean)
		self:inject_card(G.P_CENTERS.j_diet_cola)
		self:inject_card(G.P_CENTERS.j_popcorn)
		self:inject_card(G.P_CENTERS.j_ramen)
		self:inject_card(G.P_CENTERS.j_selzer)
	end,
})

SMODS.ObjectType({
	key = "BananaPool",
	cards = {
		["j_crv_ghostbanana"] = true,
		["j_crv_plantain"] = true,
		["j_crv_reban"] = true,
		["j_crv_tundan"] = true,
		["j_crv_bluj"] = true,
		["j_crv_bananavine"] = true,
		["j_crv_plainb"] = true,
		["j_crv_tickingb"] = true,
		["j_crv_uneasyb"] = true,
	},
	inject = function(self)
		SMODS.ObjectType.inject(self)
		self:inject_card(G.P_CENTERS.j_gros_michel)
		self:inject_card(G.P_CENTERS.j_cavendish)
	end,
})


local vanilla = {
	"j_joker",
	"j_greedy_joker",
	"j_lusty_joker",
	"j_wrathful_joker",
	"j_gluttenous_joker",
	"j_zany",
	"j_mad",
	"j_crazy",
	"j_droll",
	"j_sly",
	"j_wily",
	"j_clever",
	"j_devious",
	"j_crafty",
	"j_half",
	"j_stencil",
	"j_four_fingers",
	"j_mime",
	"j_credit_card",
	"j_ceremonial",
	"j_banner",
	"j_mystic_summit",
	"j_marble",
	"j_loyalty_card",
	"j_8_ball",
	"j_misprint",
	"j_dusk",
	"j_raised_fist",
	"j_chaos",
	"j_fibonacci",
	"j_steel_joker",
	"j_scary_face",
	"j_abstract",
	"j_delayed_grat",
	"j_hack",
	"j_pareidolia",
	"j_gros_michel",
	"j_even_steven",
	"j_odd_todd",
	"j_scholar",
	"j_business",
	"j_supernova",
	"j_ride_the_bus",
	"j_space",
	"j_egg",
	"j_burglar",
	"j_blackboard",
	"j_runner",
	"j_ice_cream",
	"j_dna",
	"j_splash",
	"j_blue_joker",
	"j_sixth_sense",
	"j_constellation",
	"j_hiker",
	"j_faceless",
	"j_green_joker",
	"j_superposition",
	"j_todo_list",
	"j_cavendish",
	"j_card_sharp",
	"j_red_card",
	"j_madness",
	"j_square",
	"j_seance",
	"j_riff_raff",
	"j_vampire",
	"j_shortcut",
	"j_hologram",
	"j_vagabond",
	"j_baron",
	"j_cloud_9",
	"j_rocket",
	"j_obelisk",
	"j_midas_mask",
	"j_luchador",
	"j_photograph",
	"j_gift",
	"j_turtle_bean",
	"j_erosion",
	"j_reserved_parking",
	"j_mail",
	"j_to_the_moon",
	"j_hallucination",
	"j_fortune_teller",
	"j_juggler",
	"j_drunkard",
	"j_stone",
	"j_golden",
	"j_lucky_cat",
	"j_baseball",
	"j_bull",
	"j_diet_cola",
	"j_trading",
	"j_flash",
	"j_popcorn",
	"j_trousers",
	"j_ancient",
	"j_ramen",
	"j_walkie_talkie",
	"j_selzer",
	"j_castle",
	"j_smiley",
	"j_campfire",
	"j_ticket",
	"j_mr_bones",
	"j_acrobat",
	"j_sock_and_buskin",
	"j_swashbuckler",
	"j_troubadour",
	"j_certificate",
	"j_smeared",
	"j_throwback",
	"j_hanging_chad",
	"j_rough_gem",
	"j_bloodstone",
	"j_arrowhead",
	"j_onyx_agate",
	"j_glass",
	"j_ring_master",
	"j_flower_pot",
	"j_blueprint",
	"j_wee",
	"j_merry_andy",
	"j_oops",
	"j_idol",
	"j_seeing_double",
	"j_matador",
	"j_hit_the_road",
	"j_duo",
	"j_trio",
	"j_family",
	"j_order",
	"j_tribe",
	"j_stuntman",
	"j_invisible",
	"j_brainstorm",
	"j_satellite",
	"j_shoot_the_moon",
	"j_drivers_license",
	"j_cartomancer",
	"j_astronomer",
	"j_burnt",
	"j_bootstraps",
	"j_caino",
	"j_triboulet",
	"j_yorick",
	"j_chicot",
	"j_perkeo",
}