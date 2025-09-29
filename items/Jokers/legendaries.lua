--[[SMODS.Joker({
	key = "oldjimbo",
	atlas = "Jokers2",
	rarity = 4,
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 3,
		y = 8,
	},
	soul_pos = {
		x = 4,
		y = 8,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.dollars },
		}
	end,
	calculate = function(self, card, context)
		if card.area then
			SMODS.Stickers["eternal"]:apply(card, true)
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		SMODS.add_card({
			set = "Joker",
			area = G.jokers,
			key = "j_crv_adamap",
		})
		SMODS.Stickers["eternal"]:apply(card, true)
	end,
})

SMODS.Joker({
	key = "adamap",
	atlas = "Jokers2",
	rarity = 4,
	cost = 0,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	no_collection = true,
	pos = {
		x = 5,
		y = 8,
	},
	soul_pos = {
		x = 6,
		y = 8,
	},
	config = {
		extra = {
			xmult = 3,
		},
	},
	pools = {
		Food = true,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})
]]


SMODS.Joker({
	key = "rkn",
	config = {
		extra = {
			xmult = 3,
			discard = 4,
			check = "NXD",
			xmult2 = 3,
			cardc = 3,
		},
	},
	rarity = 4,
	atlas = "Jokers2",
	blueprint_compat = true,
	discovered = false,
	pos = {
		x = 0,
		y = 9,
	},
	soul_pos = {
		x = 1,
		y = 9,
	},
	cost = 20,
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.xmult, crv.discard, crv.xmult2, crv.xmultg, crv.cardc },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main and (#SMODS.find_card("j_chicot") > 0) and G.GAME.blind.boss then
			return {
				x_mult = crv.xmult,
			}
		end
		if context.destroy_card and context.cardarea == G.play then
			if #SMODS.find_card("j_caino") > 0 then
				if context.destroy_card:is_face() then
					card_eval_status_text(card, "extra", nil, nil, nil, { message = "For Canio!" })
					return {
						remove = true
					}
				end
			end
		end
		if context.ending_shop and (#SMODS.find_card("j_perkeo") > 0) then
			if G.consumeables.cards[1] then
				G.E_MANAGER:add_event(Event({
					func = function()
						local card = copy_card(pseudorandom_element(G.consumeables.cards, pseudoseed("rkn")), nil)
						card:set_edition({ negative = true }, true)
						card:add_to_deck()
						G.consumeables:emplace(card)
						return true
					end,
				}))
				card_eval_status_text(card, "extra", nil, nil, nil, { message = "For Perkeo!" })
			end
			return
		end
		if context.setting_blind and (#SMODS.find_card("j_triboulet") > 0) then
			local faces = { "Queen", "King" }
			local suits = pseudorandom_element(SMODS.Suits, pseudoseed("rkn"))
			local suit = tostring(suits)
			local rank = pseudorandom_element(faces, pseudoseed("rkn"))
			for i = 1, crv.cardc do
				local acard = create_playing_card({
					front = G.P_CARDS[suit .. "_" .. rank],
					center = G.P_CENTERS.c_base,
				}, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
				SMODS.change_base(acard, nil, rank)
			end
		end
		if context.setting_blind and (#SMODS.find_card("j_yorick") > 0) then
			ease_discard(card.ability.extra.discard)
			crv.check = "EXD"
		end
		if context.end_of_round and context.main_eval then
			if crv.check == "EXD" then
				crv.check = "NXD"
				G.GAME.round_resets.discards = G.GAME.round_resets.discards
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		if
			(#SMODS.find_card("j_chicot") > 0)
			or (#SMODS.find_card("j_perkeo") > 0)
			or (#SMODS.find_card("j_triboulet") > 0)
			or (#SMODS.find_card("j_yorick") > 0)
			or (#SMODS.find_card("j_caino") > 0)
		then
			return true
		else
			return false
		end
	end,
})


local shopframes = { 0, 1, 2, 3 }
SMODS.Joker({
	key = "shop_sign",
	atlas = "Jokers2",
	rarity = 4,
	pos = { x = 0, y = 13 },
	soul_pos = { x = 1, y = 13 },
	calculate = function(self, card, context) end,
	update = function(self, card, context)
		local timer = (G.TIMERS.REAL * 4) -- Thank you TOGA (i found it in #modding_dev)
		local frame_amount = #shopframes
		local wrapped_value = (math.floor(timer) - 1) % frame_amount + 1
		card.children.floating_sprite:set_sprite_pos({ x = shopframes[wrapped_value], y = 14 })
	end,
})