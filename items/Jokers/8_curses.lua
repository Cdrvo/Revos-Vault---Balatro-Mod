SMODS.Joker({
	key = "black_clover",
	atlas = "Jokers2",
	pos = {
		x = 8,
		y = 13,
	},
	rarity = "crv_curse",
	blueprint_compat = false,
	cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "crv_curse_desc"}
	end,
	add_to_deck = function(self,card,from_debuff)
		for k, v in pairs(G.playing_cards) do
			if v:is_enhanced() then
				v:set_ability("c_base")
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff) 
		if not RevosVault.purified_curse then
			local ccard = copy_card(card)
			ccard:add_to_deck()
			G.jokers:emplace(ccard)
		end
  end,
	calculate = function(self,card,context)
		if context.card_enhanced and context.area then
			context.card:set_ability("c_base")
			RevosVault.c_message(card, "Not Allowed!")
		end
  end
})

if RevoConfig["experimental_enabled"] then
SMODS.Joker({
	key = "limited_stock",
	atlas = "Jokers2",
	pos = {
		x = 8,
		y = 13,
	},
	rarity = "crv_curse",
	blueprint_compat = false,
	cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "crv_curse_desc"}
	end,
	add_to_deck = function(self,card,from_debuff)
		change_shop_size(-1)
	end,
	remove_from_deck = function(self, card, from_debuff) 
		if not RevosVault.purified_curse then
			local ccard = copy_card(card)
			ccard:add_to_deck()
			G.jokers:emplace(ccard)
		else
			change_shop_size(1)
		end
  	end,
	calculate = function(self,card,context)
		if context.starting_shop and not context.blueprint then
			RevosVault.change_shop_size(-1, "shop_booster")
		end
		if context.ending_shop and not context.blueprint then
			RevosVault.change_shop_size(1, "shop_booster")
		end
	end
})

SMODS.Joker({
	key = "inflation",
	atlas = "Jokers2",
	pos = {
		x = 8,
		y = 13,
	},
	rarity = "crv_curse",
	blueprint_compat = false,
	cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "crv_curse_desc"}
	end,
	add_to_deck = function(self,card,from_debuff)
		G.GAME.xinflation = G.GAME.xinflation + 1
	end,
	remove_from_deck = function(self, card, from_debuff) 
		if not RevosVault.purified_curse then
			local ccard = copy_card(card)
			ccard:add_to_deck()
			G.jokers:emplace(ccard)
		else
			G.GAME.xinflation = G.GAME.xinflation - 1
		end
  end,
})

SMODS.Joker({
	key = "greed",
	atlas = "Jokers2",
	pos = {
		x = 8,
		y = 13,
	},
	rarity = "crv_curse",
	blueprint_compat = false,
	cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "crv_curse_desc"}
	end,
	add_to_deck = function(self,card,from_debuff)
		G.GAME.curse_cashout = G.GAME.curse_cashout + 1
	end,
	remove_from_deck = function(self, card, from_debuff) 
		if not RevosVault.purified_curse then
			local ccard = copy_card(card)
			ccard:add_to_deck()
			G.jokers:emplace(ccard)
		else
			G.GAME.curse_cashout = G.GAME.curse_cashout - 1
		end
  end,
})

SMODS.Joker({
	key = "demotion",
	atlas = "Jokers2",
	pos = {
		x = 8,
		y = 13,
	},
	config = {
		extra = {
			def = nil
		}
	},
	rarity = "crv_curse",
	blueprint_compat = false,
	cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "crv_curse_desc"}
	end,
	add_to_deck = function(self,card,from_debuff)
		card.ability.extra.def = G.GAME.rare_mod
		G.GAME.rare_mod = 0
	end,
	remove_from_deck = function(self, card, from_debuff) 
		if not RevosVault.purified_curse then
			local ccard = copy_card(card)
			ccard:add_to_deck()
			G.jokers:emplace(ccard)
		else
			G.GAME.rare_mod = G.GAME.rare_mod + card.ability.extra.def
		end
  end,
})

SMODS.Joker({
	key = "cursed_printer",
	atlas = "Jokers2",
	pos = {
		x = 8,
		y = 13,
	},
	config = {
		extra = {
		}
	},
	rarity = "crv_curse",
	blueprint_compat = false,
	cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "crv_curse_desc"}
	end,
	add_to_deck = function(self,card,from_debuff)
	end,
	remove_from_deck = function(self, card, from_debuff) 
		if not RevosVault.purified_curse then
			local ccard = copy_card(card)
			ccard:add_to_deck()
			G.jokers:emplace(ccard)
		else
			--
		end
  	end,
	calculate = function(self,card,context)
		if context.setting_blind and not context.blueprint and pseudorandom("cursed_printer") < 1/4 then
			local acard = SMODS.add_card{
				rarity = "crv_curse",
				blueprint_compat = false,
				area = G.jokers,
				set = "Joker",
			}
			acard:add_sticker("eternal", true)
		end
 	end
})

SMODS.Joker({
	key = "soulless",
	atlas = "Jokers2",
	pos = {
		x = 8,
		y = 13,
	},
	config = {
		extra = {
		}
	},
	rarity = "crv_curse",
	blueprint_compat = false,
	cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "crv_curse_desc"}
	end,
	add_to_deck = function(self,card,from_debuff)
	end,
	remove_from_deck = function(self, card, from_debuff) 
		if not RevosVault.purified_curse then
			local ccard = copy_card(card)
			ccard:add_to_deck()
			G.jokers:emplace(ccard)
		else
			--
		end
  	end,
	calculate = function(self,card,context)
		if context.individual and context.cardarea == G.play and pseudorandom("soulless") < 1/2 and not context.blueprint then
			context.other_card:set_ability("m_crv_soulcard")		
		end
 	end
})

SMODS.Joker({
	key = "clumsy",
	atlas = "Jokers2",
	pos = {
		x = 8,
		y = 13,
	},
	config = {
		extra = {
		}
	},
	rarity = "crv_curse",
	blueprint_compat = false,
	cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "crv_curse_desc"}
	end,
	add_to_deck = function(self,card,from_debuff)
	end,
	remove_from_deck = function(self, card, from_debuff) 
		if not RevosVault.purified_curse then
			local ccard = copy_card(card)
			ccard:add_to_deck()
			G.jokers:emplace(ccard)
		else
			--
		end
  	end,
	calculate = function(self,card,context)
		if context.buying_card and not context.blueprint and pseudorandom("clumsy") < 1/4 then
			SMODS.destroy_cards(context.card, true)
		end
 	end
})

SMODS.Joker({
	key = "hardcore",
	atlas = "Jokers2",
	pos = {
		x = 8,
		y = 13,
	},
	config = {
		extra = {
			def = nil
		}
	},
	rarity = "crv_curse",
	blueprint_compat = false,
	cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "crv_curse_desc"}
	end,
	add_to_deck = function(self,card,from_debuff)
		card.ability.extra.def = G.GAME.starting_params.ante_scaling
		G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 3
		card.ability.extra.def = G.GAME.starting_params.ante_scaling - card.ability.extra.def
	end,
	remove_from_deck = function(self, card, from_debuff) 
		if not RevosVault.purified_curse then
			local ccard = copy_card(card)
			ccard:add_to_deck()
			G.jokers:emplace(ccard)
		else
			G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling - card.ability.extra.def
		end
  	end,
	calculate = function(self,card,context)
 	end
})

SMODS.Joker({
	key = "sneak_attack",
	atlas = "Jokers2",
	pos = {
		x = 8,
		y = 13,
	},
	config = {
		extra = {

		}
	},
	rarity = "crv_curse",
	blueprint_compat = false,
	cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "crv_curse_desc"}
	end,
	add_to_deck = function(self,card,from_debuff)
	end,
	remove_from_deck = function(self, card, from_debuff) 
		if not RevosVault.purified_curse then
			local ccard = copy_card(card)
			ccard:add_to_deck()
			G.jokers:emplace(ccard)
		else
			--
		end
  	end,
	calculate = function(self,card,context)
		if context.setting_blind and not context.blueprint and pseudorandom("sneak_attack") < 1/10 then
			G.GAME.blind.chips = G.GAME.blind.chips * 10
			G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
			card:juice_up(0.3, 0.4)
			return{
				message = "Cursed!"
			}
		end
 	end
})

SMODS.Joker({
	key = "hardstuck",
	atlas = "Jokers2",
	pos = {
		x = 8,
		y = 13,
	},
	config = {
		extra = {
			def = nil
		}
	},
	rarity = "crv_curse",
	blueprint_compat = false,
	cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "crv_curse_desc"}
	end,
	add_to_deck = function(self,card,from_debuff)
		--
	end,
	remove_from_deck = function(self, card, from_debuff) 
		if not RevosVault.purified_curse then
			local ccard = copy_card(card)
			ccard:add_to_deck()
			G.jokers:emplace(ccard)
		else
			--
		end
  	end,
	calculate = function(self,card,context)
		if context.starting_shop and not context.blueprint then
			RevosVault.change_shop_size(-1, "shop_vouchers")
		end
		if context.ending_shop and not context.blueprint then
			RevosVault.change_shop_size(1, "shop_vouchers")
		end
	end
})

SMODS.Joker({
	key = "small_hands",
	atlas = "Jokers2",
	pos = {
		x = 8,
		y = 13,
	},
	config = {
		extra = {
			def = nil
		}
	},
	rarity = "crv_curse",
	blueprint_compat = false,
	cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "crv_curse_desc"}
	end,
	add_to_deck = function(self,card,from_debuff)
		RevosVault.total_limit(-1)
	end,
	remove_from_deck = function(self, card, from_debuff) 
		if not RevosVault.purified_curse then
			local ccard = copy_card(card)
			ccard:add_to_deck()
			G.jokers:emplace(ccard)
		else
			RevosVault.total_limit(1)
		end
  	end,
	calculate = function(self,card,context)
 	end
})

SMODS.Joker({
	key = "royal_assasin",
	atlas = "Jokers2",
	pos = {
		x = 8,
		y = 13,
	},
	config = {
		extra = {
			def = nil
		}
	},
	rarity = "crv_curse",
	blueprint_compat = false,
	cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = "Other", key = "crv_curse_desc"}
	end,
	add_to_deck = function(self,card,from_debuff)
	end,
	remove_from_deck = function(self, card, from_debuff) 
		if not RevosVault.purified_curse then
			local ccard = copy_card(card)
			ccard:add_to_deck()
			G.jokers:emplace(ccard)
		else
			--
		end
  	end,
	calculate = function(self,card,context)
		if context.individual and not context.blueprint and context.cardarea == G.play then
			if context.other_card:is_face() then
				SMODS.destroy_cards(context.other_card, true)
			end
		end
 	end
})

end