SMODS.Rarity({
	key = "secret",
	badge_colour = G.C.BLACK,
	pools = {},
})


SMODS.Joker({
	key = "sgrossprinter",
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
		if
			context.setting_blind
			and pseudorandom("grossprinter") < G.GAME.probabilities.normal / card.ability.extra.odds
			and G.GAME.used_vouchers["v_crv_printerup"] == true
		then
			local new_card = create_card("Cavendish", G.jokers, nil, nil, nil, nil, "j_cavendish")
			new_card:add_to_deck()
			new_card:set_edition({ negative = true }, true)
			G.jokers:emplace(new_card)
		elseif
			context.setting_blind
				and pseudorandom("grossprinter") < G.GAME.probabilities.normal / card.ability.extra.odds
				and #G.jokers.cards < G.jokers.config.card_limit
			or self.area == G.jokers
		then
			local new_card = create_card("Cavendish", G.jokers, nil, nil, nil, nil, "j_cavendish")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		elseif context.setting_blind and G.GAME.used_vouchers["v_crv_printerup"] == true then
			SMODS.add_card({
				set = "BananaPool",
				edition = "e_negative",
			})
		elseif context.setting_blind and #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
			SMODS.add_card({
				set = "BananaPool",
			})
		end
		if
			context.setting_blind
			and pseudorandom("grossprinter") < G.GAME.probabilities.normal / card.ability.extra.odds2
			and G.GAME.used_vouchers["v_crv_printerup"] == true
		then
			local new_card = create_card("Holy Banana", G.jokers, nil, nil, nil, nil, "j_crv_holybanana")
			new_card:add_to_deck()
			new_card:set_edition({ negative = true }, true)
			G.jokers:emplace(new_card)
		elseif
			context.setting_blind
				and pseudorandom("grossprinter") < G.GAME.probabilities.normal / card.ability.extra.odds2
				and #G.jokers.cards < G.jokers.config.card_limit
			or self.area == G.jokers
		then
			local new_card = create_card("Holy Banana", G.jokers, nil, nil, nil, nil, "j_crv_holybanana")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		end
		if
			G.GAME.pool_flags.holybanana_extinct == true
			and context.setting_blind
			and not (#SMODS.find_card("j_crv_pedro") >= 1)
			and G.GAME.used_vouchers["v_crv_printerup"] == true
		then
			local new_card = create_card("Pedro", G.jokers, nil, nil, nil, nil, "j_crv_pedro")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
		elseif
			G.GAME.pool_flags.holybanana_extinct == true
			and context.setting_blind
			and not (#SMODS.find_card("j_crv_pedro") >= 1)
		then
			local new_card = create_card("Pedro", G.jokers, nil, nil, nil, nil, "j_crv_pedro")
			new_card:add_to_deck()
			G.jokers:emplace(new_card)
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
		return {
			vars = { card.ability.extra.xmult * RevosVault.stickercheck(G.jokers.cards, "perishable") + 1, card.ability.extra.xmult },
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
			if G.jokers.cards[rr + 1] ~= nil then
				G.jokers.cards[rr + 1]:add_sticker("perishable", true)
			end
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult * RevosVault.stickercheck(G.jokers.cards, "perishable") + 1,
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