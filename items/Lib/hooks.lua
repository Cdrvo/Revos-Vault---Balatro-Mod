local removeold = Card.remove
function Card:remove()
	if self.ability.set == "Joker" and self.added_to_deck then
		if self.area == G.jokers then
			G.GAME.last_destroyed_joker = self
			G.GAME.dont_question = G.GAME.last_destroyed_joker.config.center.key
			SMODS.calculate_context({
				crv_joker_destroyed = true,
				crv_destroyedj = self,
				crv_destroy_area = self.area
			})
		end
	end
	if self.ability.consumeable and self.added_to_deck then
		SMODS.calculate_context({
			crv_cons_destroyed = true,
			crv_destroyedc = self,
		})
	end
	return removeold(self)
end

function Blind:crv_after_play() --Taken from cryptid
	if not self.disabled then
		local obj = self.config.blind
		if obj.crv_after_play and type(obj.crv_after_play) == "function" then
			return obj:crv_after_play()
		end
	end
end

local unlock1, unlock2, unlock3 = nil, nil, nil
local gfep = G.FUNCS.evaluate_play --Taken from cryptid as well
function G.FUNCS.evaluate_play(e)
	gfep(e)
	if SMODS.is_poker_hand_visible("Five of a Kind") and not unlock1 then
		SMODS.insert_pool(G.P_CENTER_POOLS.SuperiorPlanet, G.P_CENTERS.c_crv_supplanetx)
		unlock1 = true
	end
	if SMODS.is_poker_hand_visible("Flush House") and not unlock2 then
		SMODS.insert_pool(G.P_CENTER_POOLS.SuperiorPlanet, G.P_CENTERS.c_crv_supceres)
		unlock2 = true
	end
	if SMODS.is_poker_hand_visible("Flush Five") and not unlock3 then
		SMODS.insert_pool(G.P_CENTER_POOLS.SuperiorPlanet, G.P_CENTERS.c_crv_superis)
		unlock3 = true
	end
	G.GAME.blind:crv_after_play()
end

local rerollold = G.FUNCS.reroll_shop
function G.FUNCS.reroll_shop(e)
	G.GAME.reroll_before = true
	rerollold(e)
	G.GAME.reroll_before = false
end

function Blind:crv_hand_sort()
	if not self.disabled then
		local obj = self.config.blind
		if obj.crv_hand_sort and type(obj.crv_hand_sort) == "function" then
			return obj:crv_hand_sort()
		end
	end
end

local gfep = G.FUNCS.evaluate_play --Taken from cryptid as well
function G.FUNCS.evaluate_play(e)
	gfep(e)
	G.GAME.blind:crv_after_play()
end

local sorthandold = G.FUNCS.sort_hand_value
function G.FUNCS.sort_hand_value(e)
	sorthandold(e)
	G.GAME.blind:crv_hand_sort()
end

local sorthandoldsuit = G.FUNCS.sort_hand_suit
function G.FUNCS.sort_hand_suit(e)
	sorthandoldsuit(e)
	G.GAME.blind:crv_hand_sort()
end

if RevosVault.config.vault_enabled then
	local destroyjoker = Card.remove
	function Card:remove()
		if self.added_to_deck and self.ability.set == "Joker" and 30 > G.GAME.vaultspawn then
			G.GAME.vaultspawn = G.GAME.vaultspawn + 1
		elseif self.added_to_deck and self.ability.set == "Joker" and G.GAME.vaultspawn >= 30 then
			G.GAME.vaultspawn = 0
			play_sound("holo1")
			SMODS.add_card({
				set = "Joker",
				area = G.jokers,
				rarity = "crv_va",
			})
		end
		return destroyjoker(self)
	end
end

if RevosVault.config.superior_enabled then
	SMODS.ObjectType({
		key = "SuperiorTarot",
		cards = {},
	})

	SMODS.ObjectType({
		key = "SuperiorSpectral",
		cards = {},
	})

	SMODS.ObjectType({
		key = "SuperiorPlanet",
		cards = {},
	})

	local shopcreateold = create_card_for_shop
	function create_card_for_shop(area)
		if RevosVault.config.superior_enabled then
			if pseudorandom("supcreate") < 1 / 100 then
				local acard =
					RevosVault.shop_card(pseudorandom_element(G.P_CENTER_POOLS.SuperiorTarot), true, "Tarot", true)
			end
			if pseudorandom("supcreate") < 1 / 100 then
				local acard = RevosVault.shop_card(
					pseudorandom_element(G.P_CENTER_POOLS.SuperiorSpectral),
					true,
					"Spectral",
					true
				)
			end
			if pseudorandom("supcreate") < 1 / 100 then
				local acard =
					RevosVault.shop_card(pseudorandom_element(G.P_CENTER_POOLS.SuperiorPlanet), true, "Planet", true)
			end
			if pseudorandom("supcreate") > 0.9 then
				local acard = RevosVault.shop_card("j_crv_supprinter", true, nil, true, "crv_p", true)
			end
		end
		if RevosVault.config.gem_enabled and not G.CONTROLLER.locks.shop_reroll then --Doesn't work with Handy's Reroll button (its kinda wierd)
			if pseudorandom("supcreate") > 0.79 then
				RevosVault.add_gem()
			end
		end

		--[[if pseudorandom("get_boon") < 1 / 4 then
			ease_colour(RevosVault.C.BOONS.CURRENT, RevosVault.C.BOONS.HAVE_BOONS)
			RevosVault.should_spawn_boon = true
		end]]
		
		return shopcreateold(area)
	end
end

local arer_ref = add_round_eval_row --thank's to haya for this bit :D
function add_round_eval_row(config)
	config.dollars = (config.dollars or 0) * G.GAME.crv_cashout
	return arer_ref(config)
end

local getidold = Card.get_id
function Card:get_id()
	if #SMODS.find_card("j_crv_revoo_") > 0 then
		return 14
	else
		return self.base.id
	end
end

local getoriginalrankold = Card.get_original_rank
function Card:get_original_rank()
	if #SMODS.find_card("j_crv_revoo_") > 0 then
		return "Ace"
	else
		return getoriginalrankold
	end
end

local isfaceold = Card.is_face
function Card:is_face(from_boss)
	if self.debuff and not from_boss then
		return
	end
	if #SMODS.find_card("j_crv_revoo_") > 0 then
		return false
	end
	return isfaceold(self, from_boss)
end

local easedolold = ease_dollars
function ease_dollars(mod, instant)
	SMODS.calculate_context({
		crv_easedollars = to_big(mod),
	})
	return easedolold(mod, instant)
end

local rerol_old = G.FUNCS.reroll_shop
function G.FUNCS.reroll_shop(e)
	if #SMODS.find_card("j_crv_shop_sign") > 0 then
		RevosVault.replacecards(G.shop_vouchers.cards)
		RevosVault.replacecards(G.shop_booster.cards)
	end
	rerol_old(e)
end

local igo = Game.init_game_object
Game.init_game_object = function(self)
	local ret = igo(self)
	ret.overtime_rounds = 3
	ret.mystery_rounds = 3
	ret.reincarnation = 1
	ret.henchmans = 0
	ret.glassodds = 4
	ret.glassxmult = 2
	ret.vaultspawn = 0
	ret.last_destroyed_joker = nil
	ret.dont_question = nil
	ret.hangedmanchips = 0
	ret.SuperiorRates = 0.9
	ret.superiorRatesPlanet = 0.99
	ret.dont_fucking_draw = nil
	ret.crv_cashout = 1
	ret.used_gems = {}
	ret.reroll_before = false
	if next(SMODS.find_mod("JoJoMod")) then
		ret.jojo = true
	else
		ret.jojo = false
	end
	if next(SMODS.find_mod("Talisman")) then
		ret.talisman = 1
	else
		ret.talisman = 0
	end
	return ret
end

SMODS.Enhancement:take_ownership("glass", {
	config = { Xmult = 2, extra = 4 },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.Xmult, G.GAME.probabilities.normal, G.GAME.glassodds },
		}
	end,
	calculate = function(self, card, context)
		if not (#SMODS.find_card("gem_crv_obsidian") > 0) then
			if
				context.destroy_card
				and context.cardarea == G.play
				and context.destroy_card == card
				and pseudorandom("glass") < G.GAME.probabilities.normal / G.GAME.glassodds
			then
				return { remove = true }
			end
		end
	end,
}, true)

local start_run_old = Game.start_run
function Game:start_run(args)
	start_run_old(self, args)
	if G.jokers and G.jokers.config then
		G.jokers.config.highlighted_limit = G.jokers.config.highlighted_limit + 1
	end
end


local add_to_deck_old = Card.add_to_deck
function Card:add_to_deck(from_debuff)
local ret = add_to_deck_old(self, from_debuff)
	if self.config.center.rarity == "crv_p" then
		check_for_unlock({type = "obtain_printer"})
	end
	if self.config.center.rarity == "crv_secret" then
		check_for_unlock({type = "secretify"})
	end
	if self.config.center.key == "j_crv_mycard" then
		check_for_unlock({type = "revoing_it"})
	end
	if self.config.center.rarity == "crv_va" then
		check_for_unlock({type = "vaulting_it"})
	end
return ret
end

local click_old = Card.click
function Card:click()
	local ret = click_old(self)
	if self.config.center.key == "j_crv_clicker" then
		self.ability.extra["clicks"] = self.ability.extra["clicks"] + 1
		self.ability.extra["chips"] = self.ability.extra["chips"] + self.ability.extra["chipgain"]
	end

	if RevosVault.printer_deck_selection then
	if not self.debbuff then
		RevosVault.printer_deck_selection = false

			if RevosVault.sleeve_applied  and G.GAME and G.GAME.selected_sleeve and G.GAME.selected_sleeve == "sleeve_crv_psleeve" then
				RevosVault.sleeve_applied = false
				G.FUNCS:get_printer_box()
			else
				G.FUNCS:exit_overlay_menu()
			end

			local e = SMODS.add_card({
				key = self.config.center.key,
				area = G.jokers,
			})
			e:add_sticker("eternal", true)

			G.E_MANAGER:add_event(Event({
				trigger = "after",
				func = function()
					save_run()
					return true
				end,
			}))
		end
	end
	return ret
end

local update_old = Game.update
function Game:update(dt)
	update_old(self, dt)
	if SMODS then
		for _, area in ipairs(SMODS.get_card_areas("jokers")) do
			if area and area.cards then
				for _, _card in ipairs(area.cards) do
					if _card.debuff and _card.ability.crv_wet then
						_card.debuff = false
					end
				end
			end
		end
	end
end

local old_exit_menu = G.FUNCS.exit_overlay_menu
G.FUNCS.exit_overlay_menu = function()
	RevosVault.printer_deck_selection = false
	old_exit_menu()
end

-- Partner Mod and Printer Deck compat


local skip_partner_old = G.FUNCS.skip_partner
G.FUNCS.skip_partner = function()
	skip_partner_old()
	if RevosVault.partner_fix then
		G.FUNCS.get_printer_box()
		RevosVault.partner_fix = false
	end
end

local select_partner_old = G.FUNCS.select_partner
G.FUNCS.select_partner = function()
	select_partner_old()
	if RevosVault.partner_fix then
		G.FUNCS.get_printer_box()
		RevosVault.partner_fix = false
	end
end