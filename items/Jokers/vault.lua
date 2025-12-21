SMODS.Rarity({
	key = "va",
	badge_colour = G.C.PURPLE,
	pools = {},
	shop_rate = nil
})

SMODS.Joker({
	key = "vjim",
	atlas = "Jokers2",
	rarity = "crv_va",
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 3,
		y = 3,
	},
	config = {
		extra = {
			odds = 4,
			xmult = 6,
			discards = "N/A",
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.odds, card.ability.extra.discards },
		}
	end,

	calculate = function(self, card, context)
		if G.GAME.current_round.discards_left > 0 then
			card.ability.extra.discards = G.GAME.current_round.discards_left
		end
		if G.GAME.current_round.discards_left == 0 then
			card.ability.extra.discards = 1
		end
		if context.joker_main and pseudorandom("vjim") < card.ability.extra.discards / card.ability.extra.odds then
			return {
				x_mult = -card.ability.extra.xmult,
			}
		elseif context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

local multi = {}

for i = 1, 100 do
	multi[#multi+1] = i
	multi[#multi+1] = -i
end
SMODS.Joker({
	key = "vsix",
	atlas = "Jokers2",
	rarity = "crv_va",
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 4,
		y = 3,
	},
	config = {
		extra = {
			multip2 = "N/A",
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.multip2 },
		}
	end,

	add_to_deck = function(self, card, from_debuff)
		local random2_key = (pseudorandom_element(multi, pseudoseed("vsix")))
		card.ability.extra.multip2 = random2_key
		for k, v in pairs(G.GAME.probabilities) do
			G.GAME.probabilities[k] = v * card.ability.extra.multip2
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		for k, v in pairs(G.GAME.probabilities) do
			G.GAME.probabilities[k] = v / card.ability.extra.multip2
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "vdna",
	atlas = "Jokers2",
	pos = {
		x = 4,
		y = 4,
	},
	rarity = "crv_va",
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	config = {
		extra = {},
	},
	calculate = function(self, card, context)
		if context.first_hand_drawn and not context.blueprint then
			local eval = function()
				return G.GAME.current_round.hands_played == 0
			end
			juice_card_until(card, eval, true)
		end

		if context.cardarea == G.jokers and context.before and G.GAME.current_round.hands_played == 0 then
			if #context.full_hand == 1 then
				G.playing_card = (G.playing_card and G.playing_card + 1) or 1
				local _card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
				_card:add_to_deck()
				if context.full_hand[1].ability.effect == "Base" then
					_card:set_ability(G.P_CENTERS[SMODS.poll_enhancement({ guaranteed = true })], true, false)
				end
				G.deck.config.card_limit = G.deck.config.card_limit + 1
				table.insert(G.playing_cards, _card)
				G.hand:emplace(_card)
				_card.states.visible = nil

				G.E_MANAGER:add_event(Event({
					func = function()
						_card:start_materialize()
						return true
					end,
				}))
				return {
					message = "Mutated!",
					colour = G.C.PURPLE,
					playing_cards_created = { true },
				}
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "vface",
	atlas = "Jokers2",
	rarity = "crv_va",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 0,
		y = 5,
	},
	config = {
		extra = {
			pmult = 20,
			mmult = -15,
			mxmult = -2,
			timer = 0,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.pmult,
				card.ability.extra.mmult,
				card.ability.extra.mxmult,
				card.ability.extra.timer,
			},
		}
	end,

	calculate = function(self, card, context)
		if context.joker_main and (card.ability.extra.timer >= 15) then
			card.ability.extra.timer = 0
			return {
				xmult = card.ability.extra.mxmult,
			}
		end
		if context.individual and context.cardarea == G.play and (card.ability.extra.timer < 15) then
			if context.other_card:is_face() then
				card.ability.extra.timer = card.ability.extra.timer + 1
				return {
					mult = card.ability.extra.pmult,
				}
			end
		end

		if context.individual and context.cardarea == G.play and (card.ability.extra.timer < 15) then
			if context.other_card:get_id() >= 2 and context.other_card:get_id() <= 10 then
				card.ability.extra.timer = 0
				return {
					mult = card.ability.extra.mmult,
				}
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

--this def needs more abilities and downsides but as of now, im leavin it like that

SMODS.Joker({
	key = "vprint",
	atlas = "Jokers2",
	rarity = "crv_va",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 7,
		y = 4,
	},
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.pmult,
				card.ability.extra.mmult,
				card.ability.extra.mxmult,
				card.ability.extra.timer,
			},
		}
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			local jokers = {}
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] ~= card then
					jokers[#jokers + 1] = G.jokers.cards[i]
				end
			end
			--select the joker
			local other_joker = pseudorandom_element(jokers, pseudoseed("vprint"))
			--copy it
			if other_joker and other_joker ~= card then
				context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
				context.blueprint_card = context.blueprint_card or card
				if context.blueprint > #G.jokers.cards + 1 then
					return
				end
				local other_joker_ret = other_joker:calculate_joker(context)
				if other_joker_ret then
					other_joker_ret.card = other_joker_ret.card or card
					other_joker_ret.colour = G.C.PURPLE
					return other_joker_ret
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})
SMODS.Joker({
	key = "vmichel",
	atlas = "Jokers2",
	rarity = "crv_va",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 3,
		y = 6,
	},
	config = {
		extra = { xmult = 30, odds = 12
 },
	},
	pools = {
		Food = true
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.xmult, crv.odds, (G.GAME.probabilities.normal or 1) },
		}
	end,

	calculate = function(self, card, context)
		local crv = card.ability.extra
		if
			context.setting_blind
			and pseudorandom("vmichel") < G.GAME.probabilities.normal / crv.odds
			and not context.repetition
			and not context.individual
			and not context.blueprint
		then
			local _first_dissolve = nil
			for k, v in pairs(G.jokers.cards) do
				if not v.ability.eternal then
					v:start_dissolve(nil, _first_dissolve)
					_first_dissolve = true
				end
			end
		end
		if context.joker_main then
			return {
				x_mult = crv.xmult,
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "vriffraff",
	atlas = "Jokers2",
	rarity = "crv_va",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 7,
		y = 7,
	},
	config = {
		extra = { ammount = 2 },
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.ammount },
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.setting_blind and not context.blueprint then
			local jokers = {}
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] ~= card then
					jokers[#jokers + 1] = G.jokers.cards[i]
				end
			end
			if #jokers >= crv.ammount then
				local chosen_joker = pseudorandom_element(jokers, pseudoseed("ml"))
				local jokers2 = {}
				for i = 1, #G.jokers.cards do
					if G.jokers.cards[i] ~= card and G.jokers.cards[i] ~= chosen_joker then
						jokers2[#jokers2 + 1] = G.jokers.cards[i]
					end
				end
				local chosen_joker2 = pseudorandom_element(jokers2, pseudoseed("ml"))
				chosen_joker:start_dissolve({ HEX("57ecab") }, nil, 1.6)
				chosen_joker = nil
				chosen_joker2:start_dissolve({ HEX("57ecab") }, nil, 1.6)
				chosen_joker2 = nil
				for i = 1, crv.ammount do
					SMODS.add_card({
						set = "Joker",
						legendary = true,
					})
				end
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "vmrbones",
	atlas = "Jokers2",
	rarity = "crv_va",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	pos = {
		x = 8,
		y = 8,
	},
	config = {
		extra = { 
            dollars = 25,
            chances = 3,
            used = 0,
            stone = 10
            
        },
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = { crv.dollars,crv.chances,crv.used,crv.stone},
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.end_of_round and context.game_over then
            for i = 1, crv.stone do
                local acard = create_playing_card({
                    front = G.P_CARDS["Spade" .. "_" .. "King"],
                    center = G.P_CENTERS.c_base,
                }, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
                SMODS.change_base(acard, "Spade", "2")
                acard:set_ability(G.P_CENTERS["m_stone"])
            end
            crv.used = crv.used + 1
            ease_ante(-G.GAME.round_resets.ante)
            ease_dollars(-crv.dollars)
            G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
            return {
                saved = true
            }
        end
        if crv.used >= crv.chances then
            card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
        end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})



SMODS.Joker({
	key = "vsplash",
	atlas = "Jokers2",
	rarity = "crv_va",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 7,
		y = 9,
	},
	config = {
		extra = { 
			xmult = 2,   
			cards = 0  
        },
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = {crv.xmult},
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if	context.before and
			context.cardarea
			and not context.repetition
			and not context.individual
			and not context.blueprint
		then
			for i = 1, #context.scoring_hand do
				G.play.cards[i]:set_debuff(true)
				G.play.cards[1]:set_debuff(false)
			if i ~= 1 then
				crv.cards = i-1
			end
			end
		end
		if context.joker_main and #context.full_hand > 1 then
			return {
				x_mult = crv.cards*crv.xmult+1
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "vacrobat",
	atlas = "Jokers2",
	rarity = "crv_va",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 10,
		y = 2,
	},
	config = {
		extra = { 
			xmult = 6,
			xmult2 = 3   
        },
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = {crv.xmult,crv.xmult2},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.current_round.hands_left == 0 then
			return {
				x_mult = card.ability.extra.xmult
			}
		elseif context.joker_main and G.GAME.current_round.hands_played == 0 then
			return {
				x_mult = -(card.ability.extra.xmult2)
			}
	end
end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})


local yesno = {1,2,3,4}

SMODS.Joker({
	key = "vstencil",
	atlas = "Jokers2",
	rarity = "crv_va",
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 10,
		y = 6,
	},
	config = {
		extra = {
			xmult = 2
		},
	},
	loc_vars = function(self, info_queue, card)
		if G and G.jokers and G.jokers.cards then
		return {
			vars = {#G.jokers.cards*card.ability.extra.xmult, card.ability.extra.xmult},
		}
	else
		return {
			vars = {card.ability.extra.xmult*0, card.ability.extra.xmult},
		}
	end
end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.joker_main then
			return {
				x_mult = crv.xmult*#G.jokers.cards
			}
		end
		if context.end_of_round and context.main_eval and not context.blueprint then
			local yesno = pseudorandom_element(yesno, pseudoseed("rrp"))
			if yesno == 1 then
			local jokers = {}
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] ~= card and G.jokers.cards[i].config.center.key ~= "j_crv_vstencil" then
					jokers[#jokers + 1] = G.jokers.cards[i]
				end
			end
		if #jokers > 0 then
			local _card = pseudorandom_element(jokers, pseudoseed("rrp"))
			if _card then
				_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
			end
		end
	end
end
end,

	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "vredcard",
	atlas = "Jokers2",
	pos = {
		x = 0,
		y = 10,
	},
	rarity = "crv_va",
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	config = {
		extra = {
			xmult = 1,
			xmultp = 5,
			xmultm = -3
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = {crv.xmult,crv.xmultp,crv.xmultm},
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		local c = context
		if c.skipping_booster and not c.blueprint then
			crv.xmult = crv.xmult + crv.xmultp
			return {
				message = "Upgrade!"
			}
		end
		if c.open_booster and not c.blueprint then
			crv.xmult = crv.xmult + crv.xmultm
			return{
				message = "Downgrade!"
			}
		end
		if c.joker_main then
			return{
			xmult = crv.xmult
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "vhalfjoker",
	atlas = "Jokers2",
	pos = {
		x = 6,
		y = 10,
	},
	rarity = "crv_va",
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	config = {
		extra = {
			xmult = 5
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = {crv.xmult},
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		local c = context
		if c.joker_main and #c.full_hand > 3 then
			return{
				xmult = crv.xmult
			}
		elseif c.joker_main then
			return{
				xmult = -crv.xmult
			}
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

SMODS.Joker({
	key = "vball",
	atlas = "Jokers2",
	pos = {
		x = 5,
		y = 13,
	},
	rarity = "crv_va",
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	config = {
		extra = {
			odds = 4
		},
	},
	loc_vars = function(self, info_queue, card)
		local crv = card.ability.extra
		return {
			vars = {(G.GAME.probabilities.normal or 1),crv.odds},
		}
	end,
	calculate = function(self, card, context)
		local crv = card.ability.extra
		local c = context
		if c.individual and c.cardarea == G.play and c.other_card:get_id() == 8 then
			if pseudorandom("vball") < G.GAME.probabilities.normal / crv.odds then
				for i = 1, #G.consumeables.cards do
					SMODS.destroy_cards(G.consumeables.cards[i])
				end
			else
				SMODS.add_card{
					set = "Spectral"
				}
			end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return true
	end,
})

