SMODS.Tag({
	key = "pst",

	atlas = "tags",
	pos = { x = 0, y = 0 },
	apply = function(self, tag, context)
		if context.type == "store_joker_create" then
			local prs_in_posession = { 0 }
			for k, v in ipairs(G.jokers.cards) do
				if v.config.center.rarity == "crv_p" and not prs_in_posession[v.config.center.key] then
					prs_in_posession[1] = prs_in_posession[1] + 1
					prs_in_posession[v.config.center.key] = true
				end
			end
			local card
			if #G.P_JOKER_RARITY_POOLS.crv_p > prs_in_posession[1] then
				card = create_card("Joker", context.area, nil, "crv_p", nil, nil, nil, "crv_pst")
				create_shop_card_ui(card, "Joker", context.area)
				card.states.visible = false
				tag:yep("+", G.C.RARITY.crv_p, function()
					card:start_materialize()
					card.ability.couponed = true
					card:set_cost()
					return true
				end)
			else
				tag:nope()
			end
			tag.triggered = true
			return card
		end
	end,
})

SMODS.Tag({
	key = "reintag",
	atlas = "tags",
	pos = { x = 1, y = 0 },
	apply = function(self, tag, context)
		if context.type == "store_joker_create" then
			local prs_in_posession = { 0 }
			local card
			if #G.P_JOKER_RARITY_POOLS.crv_p > prs_in_posession[1] then
				card = create_card("Joker", context.area, nil, nil, nil, nil, "j_crv_rein")
				create_shop_card_ui(card, "Joker", context.area)
				card.states.visible = false
				tag:yep("+", G.C.RARITY.crv_p, function()
					card:start_materialize()
					card.ability.couponed = true
					card:set_cost()
					return true
				end)
			else
				tag:nope()
			end
			tag.triggered = true
			return card
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})

SMODS.Tag({
	key = "packtag",
	atlas = "tags",
	pos = { x = 2, y = 0 },
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			tag:yep("+", G.C.SECONDARY_SET.Spectral, function()
				local key = "p_crv_cbst3"
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
				card.from_tag = true
				G.FUNCS.use_card({ config = { ref_table = card } })
				card:start_materialize()
				return true
			end)
			tag.triggered = true
			return true
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})
