SMODS.Consumable({
	key = "brush",
	set = "Spectral",
	config = { extra = { cards = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	pos = { x = 0, y = 0 },
	atlas = "spec",
	cost = 3,
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		if G and G.hand then
			if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then 
				return true
			end
		end
		return false
	end,
	use = function(self, card)
		for i, card in pairs(G.hand.highlighted) do
			card:set_seal("crv_ps")
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
	end,
})

SMODS.Consumable({
	key = "pruification",
	set = "Spectral",
	config = { extra = { cards = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	pos = { x = 0, y = 1 },
	atlas = "spec",
	cost = 5,
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		if G and G.jokers then
			if #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.extra.cards then 
                for k, v in pairs(G.jokers.highlighted) do
                    if v.config.center.rarity == "crv_curse" then
                        return true
                    end
                end
			end
		end
		return false
	end,
	use = function(self, card)
        RevosVault.purified_curse = true
		for i, card in pairs(G.jokers.highlighted) do
			if card.config.center.rarity == "crv_curse" then
                SMODS.destroy_cards(card, true)
            end
		end
	end,
    after_use = function()
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.5,
            func = function()
                RevosVault.purified_curse = false
                return true
            end
        }))
    end,
    in_pool = function(self)
        return (RevosVault.rarity_in("crv_curse") and (RevosVault.rarity_in("crv_curse")>0))
    end
})