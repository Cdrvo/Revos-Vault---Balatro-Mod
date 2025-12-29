SMODS.Joker({
	key = "epprinter",
	atlas = "grabbag",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	pos = {
		x = 1,
		y = 0,
	},
	dependencies = "GrabBag",
	loc_vars = function(self, info_queue, center) end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.setting_blind and not context.blueprint then
if G.GAME.used_vouchers["v_crv_printerup"] == true and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4  or G.GAME.used_vouchers["v_crv_printeruptier"] == true then
				SMODS.add_card({
					set = "Ephemeral",
					editon = "e_negative",
				})
			else
				if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then
					SMODS.add_card({
						set = "Ephemeral",
					})
				end
			end
		end
	end,
})

SMODS.Enhancement({
	key = "syrup",
	atlas = "grabbag",
	pos = { x = 0, y = 0 },
	shatters = true,
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,
	dependencies = "GrabBag",
    calculate = function(self, card, context)
        if context.hand_drawn then
            for _, search_card in ipairs(context.hand_drawn) do
                if search_card == card then
                            local honey_cards = {}
                            for _, playing_card in ipairs(G.deck.cards) do
                                if SMODS.has_enhancement(playing_card, 'm_gb_honey') or SMODS.has_enhancement(playing_card, 'm_crv_syrup')
                                and not playing_card.ability.honey_drawn then
                                    honey_cards[#honey_cards + 1] = playing_card
                                end
                            end
                            if honey_cards and #honey_cards > 0 then
                                local chosen_card = pseudorandom_element(honey_cards, pseudoseed('gb_honey'))
                                if chosen_card then
                                    chosen_card.ability.honey_drawn = true
                                    draw_card(G.deck, G.hand, 100, 'up', true, chosen_card)
                                    SMODS.calculate_context({hand_drawn = { chosen_card }})
                                end
                            end
                break
                end
            end
        end
        if context.end_of_round then
            card.ability.already_drawn = nil
        end
    end
})

--[[

SMODS.Consumable({
	key = "honeycontract",
	set = "EnchancedDocuments",
	discovered = true,
	atlas = "grabbag",
	pos = { x = 1, y = 1 },
	config = {
		extra = {
			cards = 1,
			odds = 4,
		},
	},
	dependencies = "GrabBag",
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	can_use = function(self, card)
		if G and G.hand then
			if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then
				return true
			end
		end
		return false
	end,
	use = function(self, card, area, copier)
		if pseudorandom("honeycontract") < G.GAME.probabilities.normal / card.ability.extra.odds then
			for i, card in pairs(G.hand.highlighted) do
				card:set_ability(G.P_CENTERS["m_crv_syrup"])
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.2,
					func = function()
						G.hand:unhighlight_all()
						return true
					end,
				}))
				delay(0.5)
			end
		else
			for i, card in pairs(G.hand.highlighted) do
				card:set_ability(G.P_CENTERS["m_gb_hone"])
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.2,
					func = function()
						G.hand:unhighlight_all()
						return true
					end,
				}))
				delay(0.5)
			end
		end
	end,
})]]

SMODS.Joker({
	key = "honeyprinter",
	atlas = "grabbag",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	pos = {
		x = 0,
		y = 1,
	},
	dependencies = "GrabBag",
	loc_vars = function(self, info_queue, center) 
	return{
	vars = {
		G.GAME.probabilities.normal}}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
			if context.first_hand_drawn then
			RevosVault.printer_apply("m_gb_honey", "m_crv_syrup", nil)
		end
	end,
})
