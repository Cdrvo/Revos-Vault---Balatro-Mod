
function RevosVault.check_enhancement(area, enhancement)
	local blss = 0
	if area and type(area) == "table" then
		for _, v in pairs(area) do
			if enhancement then
				if SMODS.has_enhancement(v, enhancement) then
					blss = blss + 1
				end
			else
				if v.ability.set == "Enhanced" then
					blss = blss + 1
				end
			end
		end
		return blss
	end
	return 0
end

function RevosVault.check_edition(area, edition)
	local blss = 0
	if area and type(area) == "table" then
		for _, v in pairs(area) do
			if edition then
				if v.edition and v.edition.key == edition then
					blss = blss + 1
				end
			else
				if v.edition then
					blss = blss + 1
				end
			end
		end
		return blss
	end
	return 0
end

function RevosVault.stencil(area, to_add, _edition)
	local tab = 0
	local total = G.jokers.config.card_limit - #G.jokers.cards
	local num = 0
	for k, v in pairs(area) do
		if _edition and v.edition then
			if v.edition.key == _edition then
				tab = tab + 1
			end
		end
		if v.config.center.key == to_add then
			if v.edition then
				if v.edition.key ~= _edition then
					tab = tab + 1
				end
			else
				tab = tab + 1
			end
		end
	end
	num = total + tab
	return num
end

function joker_add(jKey)
	if type(jKey) == "string" then
		local j = SMODS.create_card({
			key = jKey,
		})

		j:add_to_deck()
		G.jokers:emplace(j)
		-- (Credit to @AstroLighz for the deck codes) --My dumbass couldn't figure this out back then ;-;
		j:add_sticker("eternal", true)
	end
end

function RevosVault.suitcheck(suit, area)
	local suitcheck = 0
	if G.playing_cards then
		for _, v in pairs(area) do
			if v:is_suit(suit, nil, true) then
				suitcheck = suitcheck + 1
			end
		end
		return suitcheck
	end
	return 0
end

function RevosVault.discard(ammount, area)
	G.E_MANAGER:add_event(Event({
		trigger = "before",
		delay = 1,
		func = function()
			local any_selected = nil
			local _cards = {}
			for i = 1, #area do
				_cards[#_cards + 1] = area[i]
			end
			RevosVault.discard_limit(ammount)
			for i = 1, ammount do
				if #area > 0 then
					local selected_card, card_key = pseudorandom_element(_cards, pseudoseed("hook"))
					G.hand:add_to_highlighted(selected_card, true)
					table.remove(_cards, card_key)
					any_selected = true
					play_sound("card1", 1)
				end
			end
			if any_selected then
				G.FUNCS.discard_cards_from_highlighted(nil, true)
				RevosVault.discard_limit(-ammount)
			end
			return true
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 1,
		func = function()
			if ammount > #area then
				for i = 1, #area do
					draw_card(G.deck, G.hand, i * 100 / #area, "up", true)
				end
			elseif ammount <= #area then
				for i = 1, ammount do
					draw_card(G.deck, G.hand, i * 100 / ammount, "up", true)
				end
			end
			return true
		end,
	}))
end

--what the fuck is this
function RevosVault.draw_new_hand()
	local put = 0
	for i = 1, #G.hand.cards do
		draw_card(G.hand, G.discard, 1, "up", true)
		put = put + 1
	end
	for i = 1, G.hand.config.card_limit do
		draw_card(G.deck, G.hand, 1, "up", true)
	end
	for i = 1, put do
		draw_card(G.discard, G.deck, 1, "up", true)
	end
end

--Silent discard and play increase (idk if exists)
--Taken straight from SMODS

function RevosVault.discard_limit(mod)
	G.GAME.starting_params.discard_limit = G.GAME.starting_params.discard_limit + mod
	if G.GAME.starting_params.discard_limit < 0 then
		sendErrorMessage("Discard limit is less than 0", "HandLimitAPI")
	end
	G.hand.config.highlighted_limit =
		math.max(G.GAME.starting_params.discard_limit, G.GAME.starting_params.play_limit, 5)
end

function RevosVault.play_limit(mod)
	G.GAME.starting_params.play_limit = G.GAME.starting_params.play_limit + mod
	if G.GAME.starting_params.play_limit < 1 then
		sendErrorMessage("Play limit is less than 1", "HandLimitAPI")
	end
	G.hand.config.highlighted_limit =
		math.max(G.GAME.starting_params.discard_limit, G.GAME.starting_params.play_limit, 5)
end

function RevosVault.total_limit(mod, silent)
	if silent then
		RevosVault.discard_limit(mod)
		RevosVault.play_limit(mod)
	else
		SMODS.change_discard_limit(mod)
		SMODS.change_play_limit(mod)
	end
end

function RevosVault.joker_limit(mod) end

function RevosVault.defeat()
	G.E_MANAGER:add_event(Event({
		blocking = false,
		func = function()
			if G.STATE == G.STATES.SELECTING_HAND then
				G.GAME.chips = G.GAME.blind.chips
				G.STATE = G.STATES.HAND_PLAYED
				G.STATE_COMPLETE = true
				end_round()
				return true
			end
		end,
	}))
end

function RevosVault.find_lowest(area, reverse, card)
	if not card then
		if reverse then
			local low = 1
			local key = nil
			for i = 1, #area do
				if low <= area[i].base.id then
					low = area[i].base.id
					key = area[i]
				end
			end
			return key
		else
			local high = 15
			local key = nil
			for i = 1, #area do
				if high >= area[i].base.id then
					high = area[i].base.id
					key = area[i]
				end
			end
			return key
		end
	else
		if not reverse then
			local high = 0
			local key

			for i = 1, #area do
				local rcard = area
				if rcard[i].base.times_played > high then
					high = rcard[i].base.times_played
					key = rcard[i]
				end
			end
			return key
		else
			local high = 15
			local key

			for i = 1, #area do
				local rcard = area
				if rcard[i].base.times_played < high then
					high = rcard[i].base.times_played
					key = rcard[i]
				end
			end
			return key
		end
	end
end

function RevosVault.add_tag(random, ammount, key)
	if random and ammount then
		local tags = {}
		for k, v in pairs(G.P_TAGS) do
			table.insert(tags, v.key)
		end
		play_sound("generic1", 0.9 + math.random() * 0.1, 0.8)
		play_sound("holo1", 1.2 + math.random() * 0.1, 0.4)
		for i = 1, ammount do
			G.E_MANAGER:add_event(Event({
				func = function()
					add_tag(Tag(pseudorandom_element(tags, pseudoseed("jud_add_tag"))))
					return true
				end,
			}))
		end
	elseif key then
		play_sound("generic1", 0.9 + math.random() * 0.1, 0.8)
		play_sound("holo1", 1.2 + math.random() * 0.1, 0.4)
		for i = 1, ammount do
			G.E_MANAGER:add_event(Event({
				func = function()
					add_tag(Tag(key))
					return true
				end,
			}))
		end
	end
end

function RevosVault.random_joker(area, exclude_card)
	local jokers = {}
	for i = 1, #area do
		if area[i] ~= exclude_card then
			jokers[#jokers + 1] = area[i]
		end
	end
	local result = pseudorandom_element(jokers, pseudoseed("jud_random_joker"))
	return result
end

function RevosVault.wheeloffortune(odds, area)
	local jokas = {}
	if pseudorandom("wof") < G.GAME.probabilities.normal / odds then
		for i = 1, #area do
			if not area[i].edition then
				jokas[#jokas + 1] = area[i]
			end
		end
		RevosVault.random_joker(jokas):set_edition(poll_edition("wheel_of_fortune", nil, true, true))
	end
end

function RevosVault.level_up_hand(hand, level)
	update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 }, {
		handname = localize(hand, "poker_hands"),
		chips = G.GAME.hands[hand].chips,
		mult = G.GAME.hands[hand].mult,
		level = G.GAME.hands[hand].level,
	})
	level_up_hand(used_consumable, hand, nil, level)
	update_hand_text({ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 }, {
		mult = 0,
		chips = 0,
		handname = localize(hand, "poker_hands"),
		level = G.GAME.hands[hand].level,
	})
end

function RevosVault.most_played()
	local _hand, _tally = nil, -1
	for k, v in ipairs(G.handlist) do
		if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
			_hand = v
			_tally = G.GAME.hands[v].played
		end
	end
	return _hand
end

function RevosVault.create_booster(pack)
	local key = pack
	local card = Card(
		G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
		G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
		G.CARD_W * 1.27,
		G.CARD_H * 1.27,
		G.P_CARDS.empty,
		G.P_CENTERS[key],
		{ bypass_discovery_center = true, bypass_discovery_ui = true }
	)
	card.cost = 0
	G.FUNCS.use_card({ config = { ref_table = card } })
	card:start_materialize()
	return true
end

function RevosVault.facepool(exclude)
	if not exclude then
		exclude = "1"
	end
	local faces = {}
	for _, v in ipairs(SMODS.Rank.obj_buffer) do
		local r = SMODS.Ranks[v]
		if r.face and r.key ~= exclude then
			table.insert(faces, r)
		end
	end
	return faces
end

function RevosVault.remove_all(area)
	for _, v in pairs(area) do
		if #area > 0 then
			SMODS.destroy_cards(v)
		end
	end
end

function RevosVault.crash()
	G.E_MANAGER:add_event(Event({
		trigger = "immediate",
		func = function()
			error(message or "Force Crash")
		end,
	}))
end

function RevosVault.shop_card(with, replace, set, keep, rarity, specific)
	local c = false
	if replace and set or rarity then
		local inshop = {}
		if set then
			for i = 1, #G.shop_jokers.cards do
				if G.shop_jokers.cards[i].ability.set == set then
					inshop[#inshop + 1] = G.shop_jokers.cards[i]
				end
			end
		elseif rarity then
			for i = 1, #G.shop_jokers.cards do
				if G.shop_jokers.cards[i].config.center.rarity == rarity then
					inshop[#inshop + 1] = G.shop_jokers.cards[i]
				end
			end
		end
		if #inshop > 0 then
			if keep then
				if not specific then
					local ca = pseudorandom_element(inshop)
					ca:juice_up()
					ca:set_ability(with.key)
				else
					local ca = pseudorandom_element(inshop)
					ca:juice_up()
					ca:set_ability(with)
				end
			else
				SMODS.destroy_cards(pseudorandom_element(inshop), true, true)
			end
			c = true
		else
			c = false
		end
	end
	if not replace then
		local carde = SMODS.create_card({
			key = with.key,
			area = G.shop_jokers,
			skip_materialize = true,
		})
		create_shop_card_ui(carde, "Joker", G.shop_jokers)
		carde.states.visible = false
		carde:start_materialize()
		carde.ability.couponed = true
		carde:set_cost()
		G.shop_jokers:emplace(carde)
	end
end

function RevosVault.index(table, cards)
	for i, v in ipairs(table) do
		if v == cards then
			return i
		end
	end
	return nil
end

function Card:is_playing_card()
    if self.ability.set == "Default" or self.ability.set == "Enhanced" then
        return true
    end
    return false
end


--ok you see nothing. there is nothing for 241 lines
-- _flip works?
-- i feel like i need to remake this

-- Playing cards broken

-- RevosVault.replacecards(G.hand.cards,nil,nil,true,nil,nil)

function RevosVault.replacecards(area, replace, bypass_eternal, keep, keeporiginal, _flip) --Cards not keeping editions/seals/stickers is intended. //Probably extremely inefficient /// Like why tf did i make the keep n entire seperate section. I probably wont even use "replace" or teh destruction part of this like ever.
	local playing_card_detected = false
	for k, v in pairs(area) do
		if v:is_playing_card() then
			playing_card_detected = true
		end
	end
	if playing_card_detected then
		sendWarnMessage("replacecards does not work with playing cards.", "RevosVault")
		sendWarnMessage("use .replace_playing_cards instead", "RevosVault")
	end
	if _flip and not keep then
		sendWarnMessage("Cannot flip while destroying", "RevosVault")
	end
	if G.shop_booster and area == G.shop_booster.cards or G.shop_vouchers and area == G.shop_vouchers.cards then --Setting the area as these 2 disables the entire thing below and will not have a support for them anytime soon cause NONE of the jokers does anything with destroyed booster PACKS and VOUCHERS. Including mods --???
		if area == G.shop_booster.cards then
			for i = 1, #area do
				local tab = {}
				for i = 1, #G.P_CENTER_POOLS.Booster do
					tab[#tab + 1] = G.P_CENTER_POOLS.Booster[i].key
				end
				if area[i] ~= keeporiginal and area[i].ability.set == "Booster" then
					local tab2 = pseudorandom_element(tab)
					if _flip then
						area[i]:flip()
						G.E_MANAGER:add_event(Event({
							trigger = "before",
							delay = 1,
							func = function()
								area[i]:set_ability(tab2)
								return true
							end,
						}))
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 1,
							func = function()
								area[i]:juice_up()
								area[i]:flip()
								return true
							end,
						}))
					else
						area[i]:juice_up()
						area[i]:set_ability(pseudorandom_element(tab))
					end
				end
				tab = {}
			end
		end
		if area == G.shop_vouchers.cards then
			for i = 1, #area do
				local tab = {}
				for i = 1, #G.P_CENTER_POOLS.Voucher do
					if not  G.P_CENTER_POOLS.Voucher[i].requires then
						if not G.GAME.used_vouchers[G.P_CENTER_POOLS.Voucher[i].key] then
							tab[#tab + 1] = G.P_CENTER_POOLS.Voucher[i].key
						end
					else
						for k, v in pairs(G.P_CENTER_POOLS.Voucher[i].requires) do
							if G.GAME.used_vouchers[v] then
								tab[#tab + 1] = G.P_CENTER_POOLS.Voucher[i].key
							end
						end
					end
				end
				if area[i] ~= keeporiginal and area[i].ability.set == "Voucher" then
					local tab2 = pseudorandom_element(tab)
					if _flip then
						area[i]:flip()
						G.E_MANAGER:add_event(Event({
							trigger = "before",
							delay = 1,
							func = function()
								area[i]:set_ability(tab2)
								return true
							end,
						}))
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 1,
							func = function()
								area[i]:juice_up()
								area[i]:flip()
								return true
							end,
						}))
					else
						area[i]:juice_up()
						area[i]:set_ability(pseudorandom_element(tab))
					end
				end
				tab = {}
			end
		end
	else
		if keep then
			for i = 1, #area do
				if area[i].config.center.rarity then
					local b
					local rarity
					if not replace then
						for k, v in pairs(G.P_JOKER_RARITY_POOLS) do
							if area[i].config.center.rarity == k then
								rarity = k
								b = k
							end
						end
						if rarity == 1 then
							rarity = "Common"
						elseif rarity == 2 then
							rarity = "Uncommon"
						elseif rarity == 3 then
							rarity = "Rare"
						elseif rarity == 4 then
							rarity = "Legendary"
						end
						local set = area[i].ability.set
						local tab = {}
						for i = 1, #G.P_CENTER_POOLS.Joker do
							if G.P_CENTER_POOLS.Joker[i].rarity == b then
								tab[#tab + 1] = G.P_CENTER_POOLS.Joker[i].key
							end
						end
						if area[i] ~= keeporiginal then
							local tab2 = pseudorandom_element(tab)
							if _flip then
								area[i]:flip()
								G.E_MANAGER:add_event(Event({
									trigger = "before",
									delay = 1,
									func = function()
										area[i]:set_ability(tab2)
										return true
									end,
								}))
								G.E_MANAGER:add_event(Event({
									trigger = "after",
									delay = 1,
									func = function()
										area[i]:juice_up()
										area[i]:flip()
										return true
									end,
								}))
							else
								area[i]:juice_up()
								area[i]:set_ability(pseudorandom_element(tab))
								tab = {}
							end
						end
					else
						local set = area[i].ability.set
						local rarity = SMODS.poll_rarity(set)
						local b = rarity
						if rarity == 1 then
							rarity = "Common"
						elseif rarity == 2 then
							rarity = "Uncommon"
						elseif rarity == 3 then
							rarity = "Rare"
						elseif rarity == 4 then
							rarity = "Legendary"
						end
						local tab = {}
						for i = 1, #G.P_CENTER_POOLS.Joker do
							if G.P_CENTER_POOLS.Joker[i].rarity == b then
								tab[#tab + 1] = G.P_CENTER_POOLS.Joker[i].key
							end
						end
						if area[i] ~= keeporiginal then
							local tab2 = pseudorandom_element(tab)
							if _flip then
								area[i]:flip()
								G.E_MANAGER:add_event(Event({
									trigger = "before",
									delay = 1,
									func = function()
										area[i]:set_ability(tab2)
										return true
									end,
								}))
								G.E_MANAGER:add_event(Event({
									trigger = "after",
									delay = 1,
									func = function()
										area[i]:juice_up()
										area[i]:flip()
										return true
									end,
								}))
							else
								area[i]:juice_up()
								area[i]:set_ability(pseudorandom_element(tab))
							end
						end
						tab = {}
					end
				elseif area[i].ability.set then
					local set = area[i].ability.set
					local tab = {}

					for i = 1, #G.P_CENTER_POOLS.Consumeables do
						if G.P_CENTER_POOLS.Consumeables[i].set == set then
							tab[#tab + 1] = G.P_CENTER_POOLS.Consumeables[i].key
						end
					end

					if area[i] ~= keeporiginal then
						local tab2 = pseudorandom_element(tab)
						if _flip then
							area[i]:flip()
							G.E_MANAGER:add_event(Event({
								trigger = "before",
								delay = 1,
								func = function()
									area[i]:set_ability(tab2)
									return true
								end,
							}))
							G.E_MANAGER:add_event(Event({
								trigger = "after",
								delay = 1,
								func = function()
									area[i]:juice_up()
									area[i]:flip()
									return true
								end,
							}))
						else
							area[i]:juice_up()
							area[i]:set_ability(pseudorandom_element(tab))
						end
					end
				end
			end
		else
			if replace then --Doesnt stick to joker rarities
				for i = 1, #area do
					if bypass_eternal then
						if area[i].ability.set and area[i] ~= keeporiginal then
							local set = area[i].ability.set
							SMODS.destroy_cards(area[i], true)
							SMODS.add_card({
								set = set,
								area = G.pack_cards,
							})
						end
					else
						if area[i].ability.set and not area[i].ability.eternal and area[i] ~= keeporiginal then
							local set = area[i].ability.set
							SMODS.destroy_cards(area[i])
							SMODS.add_card({
								set = set,
								area = G.pack_cards,
							})
						end
					end
				end
			else
				for i = 1, #area do
					if bypass_eternal then
						if area[i].config.center.rarity and area[i] ~= keeporiginal then --Reroll them while keeping the same rarity
							local rarity
							if area[i].config.center.rarity == 1 then
								rarity = "Common"
							elseif area[i].config.center.rarity == 2 then
								rarity = "Uncommon"
							elseif area[i].config.center.rarity == 3 then
								rarity = "Rare"
							elseif area[i].config.center.rarity == 4 then
								rarity = "Legendary"
							else
								rarity = area[i].config.center.rarity
							end
							local set = area[i].ability.set
							SMODS.destroy_cards(area[i], true)
							SMODS.add_card({
								set = set,
								rarity = rarity,
								area = G.pack_cards,
							})
						elseif area[i].ability.set and area[i] ~= keeporiginal then
							for i = 1, #G.P_CENTER_POOLS.Consumeables do
								if G.P_CENTER_POOLS.Consumeables[i].set == set then
									tab[#tab + 1] = G.P_CENTER_POOLS.Consumeables[i].key --unused?
								end
							end

							local set = area[i].ability.set
							SMODS.destroy_cards(area[i], true)
							SMODS.add_card({
								set = set,
								area = G.pack_cards,
							})
						end
					else
						if area[i].config.center.rarity and not area[i].ability.eternal and area[i] ~= keeporiginal then
							local rarity
							if area[i].config.center.rarity == 1 then
								rarity = "Common"
							elseif area[i].config.center.rarity == 2 then
								rarity = "Uncommon"
							elseif area[i].config.center.rarity == 3 then
								rarity = "Rare"
							elseif area[i].config.center.rarity == 4 then
								rarity = "Legendary"
							else
								rarity = area[i].config.center.rarity
							end
							local set = area[i].ability.set
							SMODS.destroy_cards(area[i])
							SMODS.add_card({
								set = set,
								rarity = rarity,
								area = G.pack_cards,
							})
						elseif area[i].ability.set and not area[i].ability.eternal and area[i] ~= keeporiginal then
							local set = area[i].ability.set
							SMODS.destroy_cards(area[i])
							SMODS.add_card({
								set = set,
								area = G.pack_cards,
							})
						end
					end
				end
			end
		end
	end
end

function RevosVault.replace_playing_cards(area, _flip) -- FUCK
	for i = 1, #area do
		if area[i]:get_id() then
			if _flip then
				area[i]:flip()
				G.E_MANAGER:add_event(Event({
					trigger = "before",
					delay = 1,
					func = function()
						local _suit, _rank =
							pseudorandom_element(SMODS.Suits).key, pseudorandom_element(SMODS.Ranks).card_key
						SMODS.change_base(area[i], _suit, _rank)
						local ed, enh = poll_edition(), SMODS.poll_enhancement()
						if ed then
							area[i]:set_edition(ed)
						end
						if enh then
							area[i]:set_ability(enh)
						end
						return true
					end,
				}))
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 1,
					func = function()
						area[i]:juice_up()
						area[i]:flip()
						return true
					end,
				}))
			else
				area[i]:juice_up()
				local _suit, _rank = pseudorandom_element(SMODS.Suits).key, pseudorandom_element(SMODS.Ranks).card_key
				SMODS.change_base(area[i], _suit, _rank)
				local ed, enh = poll_edition(), SMODS.poll_enhancement()
				if ed then
					area[i]:set_edition(ed)
				end
				if enh then
					area[i]:set_ability(enh)
				end
			end
		end
	end
end

-- Nothing to see here

function RevosVault.check(check, area)
	if check == "inblind" then
		return G.STATE == G.STATES.SELECTING_HAND
	elseif check == "hasjoker" then
		if #G.jokers.cards > 0 then
			return true
		end
	elseif check == "inshop" then
		return G.STATE == G.STATES.SHOP
	elseif check == "highlight" then
		if #area.highlighted > 0 then
			return #area.highlighted
		end
	end
end

--Sadly this requires manually adding/removing cards. :((
function RevosVault.modify_rarity(card, by)
	local shouldgo = true
	local rarity_order = {
		1,
		2,
		3,
		4,
		"crv_p",
	}

	if RevosVault.config.vault_enabled then
		table.insert(rarity_order, 6, "crv_va")
	end
	if Cryptid then
		table.insert(rarity_order, 1, "cry_candy")
		table.insert(rarity_order, 5, "cry_epic")
		table.insert(rarity_order, "cry_exotic")
	end
	if RevosVault.config.chaos_enabled then
		table.insert(rarity_order, "crv_chaos")
	end
	if card and by then
		local current_rarity = card.config.center.rarity or card.rarity
		local future_rarity = nil
		for i = 1, #rarity_order do
			if rarity_order[i] == current_rarity then
				if rarity_order[i + by] ~= nil then
					future_rarity = rarity_order[i + by]
				else
					sendWarnMessage("No next or previous rarity found", "RevosVault")
					shouldgo = nil
				end
			end
		end
		if shouldgo then
			local new_card = pseudorandom_element(G.P_JOKER_RARITY_POOLS[future_rarity]).key
			card:juice_up()
			card:set_ability(new_card)
		end
	else
		return rarity_order -- if you leave it with nothing it returns the table itself >:D
	end
end

function RevosVault.printer_apply(enhancement, upgraded_enhancement, edition, area, odds)
	if not odds then
		odds = 4
	end --Default odds
	if not area then
		area = G.hand
	end --Default area
	local ecards = {}
	local emcards = {}
	local card
	for i = 1, #area.cards do
		if not area.cards[i].edition then
			ecards[#ecards + 1] = area.cards[i]
		end
		if area.cards[i].ability.effect == "Base" then
			emcards[#emcards + 1] = area.cards[i]
		end
	end
	if enhancement then
		card = pseudorandom_element(emcards, pseudoseed("printer_apply"))
	elseif edition then
		card = pseudorandom_element(ecards, pseudoseed("printer_apply"))
	end
	if not edition then
		if #emcards > 0 then
			if pseudorandom("enh_printers") < G.GAME.probabilities.normal / odds then
				if upgraded_enhancement then
					card:set_ability(upgraded_enhancement)
					return upgraded_enhancement
				else
					card:set_ability(enhancement)
					return enhancement
				end
			else
				if enhancement then
					card:set_ability(enhancement)
					return enhancement
				end
			end
		end
	else
		if #ecards > 0 then
			card:set_edition(edition)
			return edition
		end
	end
end

function RevosVault.stickercheck(area, stickers)
	local st = 0
	if area then
		for _, v in pairs(area) do
			for i = 1, #stickers do
				if v.stickers then
				end
			end
		end
		return st
	end
	return 0
end

function RevosVault.get_name(key, set)
	local name
	name = localize({ type = "name_text", key = key, set = set })
	return name
end

--idk made an advanced searcg

function RevosVault.joker_search(key, name, rarity, cost, edition, stickers, debuff, area)
	if not area then
		area = G.jokers.cards
	end
	local cards = {}
	for i = 1, #area do
		cards[#cards + 1] = area[i]
	end
	if key then
		for k, v in pairs(cards) do
			print(#cards)
			if v.config.center.key ~= key then
				local i = RevosVault.index(cards, v)
				table.remove(cards, i)
			end
		end
	end
	if name then
		for k, v in pairs(cards) do
			local vsname = localize({ type = "name_text", key = v.config.center.key, set = "Joker" })
			for i = 1, #name do
				if not string.find(vsname, name[i]) then
					local i = RevosVault.index(cards, v)
					table.remove(cards, i)
				end
			end
		end
	end
	if rarity then
		for k, v in pairs(cards) do
			if v.config.center.rarity ~= rarity then
				local i = RevosVault.index(cards, v)
				table.remove(cards, i)
			end
		end
	end
	if cost then
		for k, v in pairs(cards) do
			if v.cost ~= cost then
				local i = RevosVault.index(cards, v)
				table.remove(cards, i)
			end
		end
	end
	if edition then
		for k, v in pairs(cards) do
			if v.edition and not v.edition.key ~= edition then
				local i = RevosVault.index(cards, v)
				table.remove(cards, i)
			end
		end
	end
	if stickers then
		for k, v in pairs(cards) do
			for i = 1, #stickers do
				if v.ability[stickers[i]] then
					break
				else
					local i = RevosVault.index(cards, v)
					table.remove(cards, i)
				end
			end
		end
	end
	if debuff then
		for k, v in pairs(cards) do
			for i = 1, #stickers do
				if v.debuff then
					local i = RevosVault.index(cards, v)
					table.remove(cards, i)
				end
			end
		end
	end
	return cards
end

--I aint risking my shit istg fuck talisman

to_big = to_big or function(x)
	return x
end

function RevosVault.factorial(mod)
	if to_big(mod) <= to_big(0) then
		return 1
	else
		return to_big(mod) * RevosVault.factorial(to_big(mod) - to_big(1))
	end
end

function RevosVault.perc(mod, perc)
	local per = (to_big(mod) / 100) * perc
	return per
end

function RevosVault.remove_gem(key)
	local index = RevosVault.index(G.GAME.used_gems, key)
	table.remove(G.GAME.used_gems, index)
	for k, v in pairs(G.vouchers.cards) do
		if v.config.center.key == key then
			v:start_dissolve(nil, true)
		end
	end
end

function RevosVault.add_gem(key, set)
	local acard
	if key then
		acard = SMODS.add_card({ key = key, set = "Gem", area = G.shop_vouchers })
		create_shop_card_ui(acard)
		G.shop_vouchers:align_cards()
	else
		acard = SMODS.add_card({ set = "Gem", area = G.shop_vouchers })
		create_shop_card_ui(acard)
		G.shop_vouchers:align_cards()
	end
end

--I tried some stuff don't question this part. Is this efficent? probably not.
function RevosVault.values(card, num, extra, only_extra, orig)
	local orig = {
		name = {},
		val = {},
	}
	if num == 0 then
		num = 0.1
	end
	if not only_extra then
		for k, v in pairs(card.ability) do
			if
				k ~= "x_mult"
				and k ~= "x_chips"
				and k ~= "order"
				and v ~= 0
				and k ~= "h_x_chips" -- ?
				and k ~= "cry_prob" -- ?
			then
				if type(v) == "number" then
					card.ability[k] = card.ability[k] * num
				end
			end
		end
	end
	if extra and card.ability.extra then
		if type(card.ability.extra) == "table" then
			for l, m in pairs(card.ability.extra) do
				if type(m) == "number" then
					card.ability.extra[l] = card.ability.extra[l] * num
				end
			end
		end
	end
end

-- Fcked up random bullshit

--taking a look afterwards what did i even do here ;-;
function RevosVault.table_check(card)
	local full_table = {}
	for k, v in pairs(card.ability) do
		if
			k ~= "x_mult"
			and k ~= "x_chips"
			and k ~= "order"
			and v ~= 0
			and k ~= "h_x_chips" -- ?
			and k ~= "cry_prob" -- ?
		then
			if type(v) == "number" then
				full_table[#full_table + 1] = k
				full_table[#full_table + 1] = v
			end
		end
	end
	if card.ability.extra then
		if type(card.ability.extra) == "table" then
			for l, m in pairs(card.ability.extra) do
				if type(m) == "number" then
					full_table[#full_table + 1] = l
					full_table[#full_table + 1] = m
				end
			end
		end
	end
	return full_table
end

--Surely there is a better way to do this but im too lazy to check it sakdjnsdaskdaslkdagagahjgfah
function RevosVault.combine_table(areas, w)
	local full_tab = {}
	if type(areas) == "table" then
		for i = 1, #areas do
			if type(areas[i]) == "table" then
				for k, v in pairs(areas[i]) do
					full_tab[#full_tab + 1] = v
				end
			else
				sendWarnMessage(tostring(areas[i]) .. " is not a table", "RevosVault")
			end
		end
	else
		sendWarnMessage(tostring(areas) .. " is not a table", "RevosVault")
	end
	if #full_tab > 0 then
		return full_tab
	elseif #full_tab == 0 and w then
		sendWarnMessage("Nothing to return!", "RevosVault")
	end
end

function RevosVault.poll_sticker(guaranteed, check, check_allowed)
	local tab = {}
	for k, v in pairs(SMODS.Stickers) do
		if check ~= nil then
			if not check.ability[k] and not check[k] then
				if check_allowed then
					if
						G.GAME.modifiers["enable_" .. k] == true
						or G.GAME.modifiers["enable_" .. k .. "s_in_shop"] == true
					then
						tab[#tab + 1] = v
					end
				else
					tab[#tab + 1] = v
				end
			end
		else
			if check_allowed then
				if
					G.GAME.modifiers["enable_" .. k] == true
					or G.GAME.modifiers["enable_" .. k .. "s_in_shop"] == true
				then
					tab[#tab + 1] = v
				end
			else
				tab[#tab + 1] = v
			end
		end
	end
	local random_sticker = pseudorandom_element(tab)
	if not guaranteed then
		if not (pseudorandom("poll_sticker") < tonumber(random_sticker.rate)) then
			random_sticker = nil
		end
	end
	if random_sticker then
		return random_sticker.key
	end
end

function RevosVault.all_stickers(card)
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 1,
		func = function()
			for k, v in pairs(SMODS.Stickers) do
				card:add_sticker(k, true)
			end
		end
	}))
end


function Card:remove_sticker_calc(sticker, card) 
    sticker:removed(self, card)
	SMODS.calculate_context({sticker_removed = true, other_sticker = sticker, other_card = card})
end

function Card:apply_sticker_calc(sticker, card) 
    sticker:applied(self, card)
	SMODS.calculate_context({sticker_applied = true, other_sticker = sticker, other_card = card})
	RevosVault.sticker_thingy(card)
end

function RevosVault.joker_pos(card)
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i] == card then
			return i
		end
	end
end

function RevosVault.move(card, by)
	local area
	local cardpos
	local move
	if card and card.area then
		area = G.jokers
		cardpos = RevosVault.joker_pos(card)
	end

	if by > area.config.card_limit then
		sendWarnMessage("num big adashfdgvasdk")
	else

		area:remove_card(card)
		table.insert(area.cards, by, card)
		card.area = area
	end
end

function RevosVault.sticker_thingy(card)
	local eligable = {}
	if card and card.ability then
		for k, v in pairs(SMODS.Stickers) do
			if string.find(k, "crv") then
				eligable[#eligable+1] = k
			end
		end

		for k, v in pairs(eligable) do
			if not card.ability[v] then
				break 
			else
				check_for_unlock({type = "howdidwegethere"})
			end
		end
	end
end

--[[
	local event
	event = Event({
		blockable = false,
		blocking = false,
		trigger = "after",
		delay = delay or 0.1,
		timer = "UPTIME",
		func = function()
			if condition then
				ease_colour(c1, c2)
				RevosVault.ease_color_until(c1, c2, condition, first, delay)
			end
			return true
		end,
	})
	G.E_MANAGER:add_event(event)]]

function RevosVault.vanilla_cards(args) -- incomplete
	local tab = {}
	if not args.type then
		args.type = "Joker"
	end
	args.rarity = args.rarity or nil
	args.set = args.set or nil

	if args.type == "Voucher" then
		for k, v in pairs(get_current_pool("Voucher")) do
			if G.P_CENTERS[v] and not G.P_CENTERS[v].mod and v ~= "UNAVAILABLE" then
				tab[#tab + 1] = v
			end
		end
	end
	return tab
end


function RevosVault.random_voucher(mod) --i love overcomplicating stuff
	local mode
	if not mod then
		if pseudorandom_element({ "Mod", "Vanilla" }) == "Mod" then
			mode = "Mod"
			reset_other_types()
			get_eligable_mods()
			if #RevosVault.mod_categories.with_voucher > 0 then
				mod = pseudorandom_element(RevosVault.mod_categories.with_voucher, pseudoseed("rv_random_voucher"))
			else
				mode = "Vanilla"
			end
		else
			mode = "Vanilla"
		end
	else
		mode = "Mod"
	end


	local vouchers = {}
	if mode == "Mod" then
		vouchers = RevosVault.get_eligable_vouchers(mod)
	else
		vouchers = RevosVault.vanilla_cards({type = "Voucher"})
	end
	local voucher_key = nil
	local real_voucher = nil
	if vouchers then
		voucher_key = pseudorandom_element(vouchers)
	end

	
	if voucher_key then
		real_voucher = SMODS.create_card{
			key = voucher_key
		}
	end

	if real_voucher then
		real_voucher:add_to_deck()


		RevosVault.redeem(real_voucher, 0, true)
	end
end

function RevosVault.get_eligable_vouchers(mod)
	local vv = get_current_pool('Voucher')
        local tab = {}
        for k, v in pairs(vv) do
            if v ~= 'UNAVAILABLE' and G.P_CENTERS[v] and G.P_CENTERS[v].mod and G.P_CENTERS[v].mod.id == mod then
                tab[#tab+1] = v
			end
        end
	return tab
end

function RevosVault.redeem(card, cost, reset_to_shop)

	local old_state = G.STATE

	if card.area then
		card.area:remove(card)
		card:add_to_deck()
	end

	card.cost = 0
	card:redeem()
	G.play:emplace(card)

	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 1,
		func = function()
			card:start_dissolve()
			G.STATE = old_state
			return true
		end
	}))

end

function RevosVault.get_consumable_pool(mod)
	local tab = {}
	for k, v in pairs(SMODS.ConsumableTypes) do
		for k, vv in pairs(get_current_pool(k)) do
			if vv ~= "UNAVAILABLE" and G.P_CENTERS[vv] and G.P_CENTERS[vv].mod and G.P_CENTERS[vv].mod.id == mod then
				tab[#tab+1] = G.P_CENTERS[vv]
			end
		end
	end
	return tab
end

function reset_other_types()

	if not RevosVault.mod_categories then RevosVault.mod_categories = {} end

	RevosVault.mod_categories = {
		with_voucher = {},
		with_consumable = {},
		with_joker = {}
	}
end

function check_mod_contents(mod)

	local rvm = RevosVault.mod_categories

	local avb = 0
	local joker, consumable, voucher = false, false, false
	for _, vv in pairs(get_current_pool("Joker")) do
		if vv ~= "UNAVAILABLE" then
			if G.P_CENTERS[vv] and G.P_CENTERS[vv].mod and G.P_CENTERS[vv].mod.id == mod then
				avb = avb + 1
				joker = true
				rvm.with_joker[#rvm.with_joker + 1] = mod
				break
			end
		end
	end
	for k, v in pairs(SMODS.ConsumableTypes) do
		for k, vv in pairs(get_current_pool(k)) do
			if vv ~= "UNAVAILABLE" then
				if G.P_CENTERS[vv] and G.P_CENTERS[vv].mod and G.P_CENTERS[vv].mod.id == mod then
					avb = avb + 1
					consumable = true
					rvm.with_consumable[#rvm.with_consumable + 1] = mod
					break
				end
			end
		end
	end
	for _, vv in pairs(get_current_pool("Voucher")) do
		if vv ~= "UNAVAILABLE" then
			if G.P_CENTERS[vv] and G.P_CENTERS[vv].mod and G.P_CENTERS[vv].mod.id == mod then
				avb = avb + 1
				voucher = true
				rvm.with_voucher[#rvm.with_voucher + 1] = mod
				break
			end
		end
	end

	if avb > 0 then
		return true
	end
	return false
end

	

function get_eligable_mods()
    local tab = {}
    for k, v in pairs(SMODS.Mods) do
        if v.can_load then
            if check_mod_contents(v.id) then
				tab[v.id] = v.id
			end
        end
    end
	return tab
end

function get_eligable_cards(mod, type)
	G.GAME.unvaulted_jokers = {}
	G.GAME.unvaulted_cons = {}
	G.GAME.unvaulted_vouchers = {}


	
	if type == "Joker" then
		for _, v in pairs(get_current_pool("Joker")) do
			if G.P_CENTERS[v] and G.P_CENTERS[v].mod and G.P_CENTERS[v].mod.id == mod and not G.P_CENTERS[v].no_collection and v ~= "UNAVAILABLE" then
				G.GAME.unvaulted_jokers[#G.GAME.unvaulted_jokers+1] = v
			end
		end
	elseif type == "Consumable" then
			for k, v in pairs(RevosVault.get_consumable_pool(mod)) do
				if v.mod and v.mod.id == mod and not v.no_collection then
					G.GAME.unvaulted_cons[#G.GAME.unvaulted_cons+1] = v.key
				end
			end
	elseif type == "Voucher" then
		-- hmm
	end


	if type == "Joker" then
		return pseudorandom_element(G.GAME.unvaulted_jokers, pseudoseed("crv_kys"))
	elseif type == "Consumable" then
		return pseudorandom_element(G.GAME.unvaulted_cons, pseudoseed("crv_kys"))
	else
		return pseudorandom_element(RevosVault.get_eligable_vouchers(), pseudoseed("crv_kys")) -- unused
	end
end


function calculate_modded_printer()	
if G.GAME then

	reset_other_types()

	RevosVault.other_card = "j_joker"
	RevosVault.other_type = "Consumable"
	RevosVault.other_mod = "RevosVault"
	RevosVault.other_mod_display = "Revo's Vault"
	

	get_eligable_mods()
	
	local categs = {}
	if #RevosVault.mod_categories.with_joker > 0 then
		table.insert(categs, "Joker")
	end

	if #RevosVault.mod_categories.with_consumable > 0 then
		table.insert(categs, "Consumable")
	end

	if #RevosVault.mod_categories.with_voucher > 0 then
		table.insert(categs, "Voucher")
	end
	RevosVault.other_type = pseudorandom_element(categs, pseudoseed("wewewewe"))

	if RevosVault.other_type == "Joker" then
		RevosVault.other_mod = pseudorandom_element(RevosVault.mod_categories.with_joker)
	elseif RevosVault.other_type == "Consumable" then
		RevosVault.other_mod = pseudorandom_element(RevosVault.mod_categories.with_consumable)
	else
		RevosVault.other_mod = pseudorandom_element(RevosVault.mod_categories.with_voucher)
	end

	for k, v in pairs(SMODS.Mods) do
		if v.id == RevosVault.other_mod then
			RevosVault.other_mod_display = v.name
		end
	end

	RevosVault.other_card = get_eligable_cards(RevosVault.other_mod, RevosVault.other_type)
end
end


-- hotpot be like
function RevosVault.show_shop()
    if G.shop and G.shop.alignment.offset.py then
        G.shop.alignment.offset.y = G.shop.alignment.offset.py
        G.shop.alignment.offset.py = nil
    end
end

function RevosVault.hide_shop()
    if G.shop and not G.shop.alignment.offset.py then
        G.shop.alignment.offset.py = G.shop.alignment.offset.y
        G.shop.alignment.offset.y = G.ROOM.T.y + 29
    end
end

function RevosVault.move_card(card, _area) 
    local area = card.area
    if area == G.jokers and _area ~= G.jokers then
        card:remove_from_deck()
    elseif _area == G.jokers and area ~= G.jokers then
        card:add_to_deck()
    end
	if not card.getting_sliced then	
		area:remove_card(card)
		_area:emplace(card)
    end
end

  function RevosVault.create_gem_timer(card)
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.43,
        blocking = false,
        blockable = false,
        func = (function()
          if card.opening then return true end
          local t1 = {
              n=G.UIT.ROOT, config = {minw = 0.6, align = 'tm', colour = darken(G.C.BLACK, 0.2), shadow = true, r = 0.05, padding = 0.05, minh = 1}, nodes={
                  {n=G.UIT.R, config={align = "cm", colour = lighten(G.C.BLACK, 0.1), r = 0.1, minw = 1, minh = 0.55, emboss = 0.05, padding = 0.03}, nodes={
                    {n=G.UIT.O, config={object = DynaText({string = {card.ability.extra.destroy_time .. "/" .. card.ability.extra.destroy_time_max+1}, colours = {G.C.MONEY},shadow = true, silent = true, bump = true, pop_in = 0, scale = 0.5})}},
                  }}
              }}
            

          card.children.gem_time = UIBox{
            definition = t1,
            config = {
              align="tm",
              offset = {x=0,y=1.5},
              major = card,
              bond = 'Weak',
              parent = card
            }
          }

          card.children.gem_time.alignment.offset.y = 0.38

            return true
        end)
      }))
  end

function RevosVault.c_message(card, message, type)
	if not type then type = "extra" end
	card_eval_status_text(card, type, nil, nil, nil, { message = message })
end

function RevosVault.revive(card, area, from_sticker)
	local acard = copy_card(card)
	acard:add_to_deck()
	area:emplace(acard)
	SMODS.calculate_effect({ message = localize("crv_revive") }, acard)
	if from_sticker then
		acard:remove_sticker(from_sticker)
	end
end