SMODS.Joker({
	key = "letterprinter",
	atlas = "aiko",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	pos = {
		x = 0,
		y = 0,
	},
	dependencies = "aikoyorisshenanigans",
	loc_vars = function(self, info_queue, center) end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.setting_blind and not context.blueprint then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				SMODS.add_card({
					set = "Alphabet",
					editon = "e_negative",
				})
			else
				if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then
					SMODS.add_card({
						set = "Alphabet",
					})
				end
			end
		end
	end,
	in_pool = function(self, args)
		return G.GAME.akyrs_character_stickers_enabled
	end,
})

SMODS.Joker({
	key = "umbralprinter",
	atlas = "aiko",
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
	dependencies = "aikoyorisshenanigans",
	loc_vars = function(self, info_queue, center) end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.setting_blind and not context.blueprint then
			if
				G.GAME.used_vouchers["v_crv_printerup"] == true
					and pseudorandom("ALLPRINTER") < G.GAME.probabilities.normal / 4
				or G.GAME.used_vouchers["v_crv_printeruptier"] == true
			then
				SMODS.add_card({
					set = "Umbral",
					editon = "e_negative",
				})
			else
				if #G.consumeables.cards < G.consumeables.config.card_limit or self.area == G.consumeables then
					SMODS.add_card({
						set = "Umbral",
					})
				end
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})

random_phrase = function()
	local car
	local wtab = {}
	G.E_MANAGER:add_event(Event({
		func = function()

			for k, v in pairs(AKYRS.words) do
				if v and #k <= 6 then wtab[#wtab+1] = k
				end
			end	

			local random_phrase = pseudorandom_element(wtab, pseudoseed("AikoShenCrossMod"))
			local stab = {}
			for i = 1, #random_phrase do
				stab[#stab + 1] = random_phrase.sub(random_phrase, i, i)
			end

			for i = 1, #stab do

				local front = pseudorandom_element(G.P_CARDS, pseudoseed("aikoyori:akyrs_letter_randomer"))
				car = Card(
					G.deck.T.x,
					G.deck.T.y,
					G.CARD_W,
					G.CARD_H,
					front,
					G.P_CENTERS["c_base"],
					{ playing_card = G.playing_card }
				)
				car.is_null = true

				car:set_letters(stab[i])

				G.hand:emplace(car)
				G.playing_card = (G.playing_card and G.playing_card + 1) or 1

				table.insert(G.playing_cards, car)
			end
			return true
		end,
	}))
end

SMODS.Joker({
	key = "phraseprinter",
	atlas = "aiko",
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
	dependencies = "aikoyorisshenanigans",
	loc_vars = function(self, info_queue, center) end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.setting_blind and not context.blueprint then
			random_phrase()
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
