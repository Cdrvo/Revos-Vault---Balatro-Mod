SMODS.Rarity({
	key = "secret",
	badge_colour = G.C.BLACK,
	pools = {},
})


-- so much for secret jokers :sob:

SMODS.Joker({
	key = "sgrossprinter", -- ok i did
	atlas = "Jokers2",
	rarity = "crv_secret",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	no_collection = true,
	pos = {
		x = 10,
		y = 3,
	},
	config = {
		extra = {
			odds = 50,
			odds2 = 505,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_cavendish
		info_queue[#info_queue + 1] = G.P_CENTERS.j_crv_holybanana
		info_queue[#info_queue + 1] = G.P_CENTERS.j_crv_pedro
		return {
			vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.odds2 },
		}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.setting_blind and not context.blueprint then
			local tab, manual_michel = {}, true
			for k, v in pairs(get_current_pool("BananaPool")) do
				if G.P_CENTERS[v] and (v ~= "j_cavendish") then
					table.insert(tab, v)
				end
			end
			for k, v in pairs(tab) do
				if v == "j_gros_michel" then
					manual_michel = false
				end
				if v == "j_joker" then
					table.remove(tab, k)
				end
			end
			if manual_michel then
				table.insert(tab, "j_gros_michel")
			end
			local joker_to_make = pseudorandom_element(tab,pseudoseed("grossyprintriy"))
			if SMODS.pseudorandom_probability(card, "grossprinter", 1, crv.odds) then
				joker_to_make = "j_cavendish"
			end
			if SMODS.pseudorandom_probability(card, "grossprinter", 1, crv.odds2) then
				joker_to_make = "j_crv_holybanana"
			end
			if G.GAME.pool_flags.holybanana_extinct == true and (#SMODS.find_card("j_crv_pedro") == 0) then
				joker_to_make = "j_crv_pedro"
			end
			RevosVault.pseudorandom_printer({card = card, key = joker_to_make,seed = "grossprinter" })
		end
	end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})


SMODS.Joker({
	key = "kqb",
	atlas = "Jokers2",
	rarity = "crv_secret",
	cost = 30,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	no_collection = true,
	pos = {
		x = 9,
		y = 9,
	},
	config = {
		extra = {
			xmult = 4,
			save = true
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[1] = {set = "Other", key = "crv_incomplete_joker"}
		return {
			vars = { card.ability.extra.xmult *  RevosVault.stickercheck(G.jokers.cards, {"perishable"}) + 1, card.ability.extra.xmult },
		}
	end,

	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			local rr = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					rr = i
					break
				end
			end
			if card.area == G.real_modicon_area then
				rr = RevosVault.get_key_pos["j_crv_modicon"]
			end
		if rr then
			if G.jokers.cards[rr + 1] ~= nil then
				G.jokers.cards[rr + 1]:add_sticker("perishable", true)
			end
		end
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult *  RevosVault.stickercheck(G.jokers.cards, {"perishable"}) + 1,
			}
		end
		if context.end_of_round and context.game_over and card.ability.extra.save == true then
			card.ability.extra.save = false
			return {
				saved = true,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})