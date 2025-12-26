--what the FUCK
--ok they work now :thumbs_up: (they fucking dont :^hauydtgqh4na ısd)

local function voucher_ui()
	local gems = {}

	for k, v in pairs(G.P_CENTER_POOLS.Gem) do
		gems[#gems + 1] = v
	end

	return SMODS.card_collection_UIBox(gems, { 5, 5 }, {
		snap_back = true,
		hide_single_page = true,
		collapse_single_page = true,
		h_mod = 1.18,
		back_func = "your_collection_other_gameobjects",
	})
end

G.FUNCS.your_collection_crv_gems = function()
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = voucher_ui(),
	})
end

G.FUNCS.can_redeem_gem = function(e)
	local card = e.config.ref_table
if to_big(card.config.center.cost) > to_big(G.GAME.dollars) - to_big(G.GAME.bankrupt_at) then
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
  else
    e.config.colour = G.C.GREEN
    e.config.button = 'redeem_gem'
  end
end

G.FUNCS.redeem_gem = function(e)

	RevosVault.hide_shop()

	local card = e.config.ref_table

	if card.children.price then card.children.price = nil end
	if card.children.use_button then card.children.use_button = nil end
	RevosVault.move_card(card, G.play)
	
	card.config.center:apply_gem()

	

	SMODS.add_card{
		key = card.config.center.key,
		area = G.vouchers
	}

	check_for_unlock({type = "gemming_it"})


	G.GAME.used_gems[#G.GAME.used_gems + 1] = card.config.center.key

	 if card.ability.set == "Gem" then
        stop_use()
        if not card.config.center.discovered then
            discover_card(card.config.center)
        end

        card.states.hover.can = false
        local top_dynatext = nil	
        local bot_dynatext = nil
        
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                top_dynatext = DynaText({string = localize{type = 'name_text', set = card.config.center.set, key = card.config.center.key}, colours = {G.C.WHITE}, rotate = 1,shadow = true, bump = true,float=true, scale = 0.9, pop_in = 0.6/G.SPEEDFACTOR, pop_in_rate = 1.5*G.SPEEDFACTOR})
                bot_dynatext = DynaText({string = localize('b_gem_act'), colours = {G.C.WHITE}, rotate = 2,shadow = true, bump = true,float=true, scale = 0.9, pop_in = 1.4/G.SPEEDFACTOR, pop_in_rate = 1.5*G.SPEEDFACTOR, pitch_shift = 0.25})
                card:juice_up(0.3, 0.5)
                play_sound('card1')
                play_sound('coin1')
                card.children.top_disp = UIBox{
                    definition =    {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
                                        {n=G.UIT.O, config={object = top_dynatext}}
                                    }},
                    config = {align="tm", offset = {x=0,y=0},parent = card}
                }
                card.children.bot_disp = UIBox{
                        definition =    {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
                                            {n=G.UIT.O, config={object = bot_dynatext}}
                                        }},
                        config = {align="bm", offset = {x=0,y=0},parent = card}
                    }
            return true end }))
        ease_dollars(-card.config.center.cost)

        delay(0.6)


        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 2.6, func = function()
            top_dynatext:pop_out(4)
            bot_dynatext:pop_out(4)
            return true end }))
        
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.5, func = function()
            card.children.top_disp:remove()
            card.children.top_disp = nil
            card.children.bot_disp:remove()
            card.children.bot_disp = nil
			SMODS.destroy_cards(card, true)
			RevosVault.show_shop()
        return true end }))
    end
end

SMODS.ObjectType({ -- Do i need this? 
	key = "Gem",
})

SMODS.UndiscoveredSprite{ --Doesn't seem to work?
	key = "Gem",
	display_size = { w = 50, h = 50 },
	atlas = "gemss",
	pos = {x=0,y=3},
	no_overlay = true
}

RevosVault.Gem =
	SMODS.Voucher:extend({ --Voucher extend cause they work like vouchers + its easier to implement since vouchers already have calc support
		required_params = { "key" },
		display_size = { w = 50, h = 50 },
		set = "Gem",
		unlocked = true,
		discovered = true,
		cost = 6,
		config = {},
		pools = {	
			Gem = true,
		},
		set_card_type_badge = function(self, card, badges)
			badges[#badges + 1] = create_badge(localize("b_gem"), SMODS.Gradients["crv_gem"], G.C.WHITE, 1.2)
		end,
		class_prefix = "gem",
		apply_gem = function(self, card) end,
	})

--The gems
RevosVault.Gem({
	key = "exp",
	atlas = "gemss",
	pos = { x = 0, y = 0 },
	config = {
		extra = {
			destroy_time = 0,
			destroy_time_max = 5,
		},
	},
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			if card.ability.extra.destroy_time >= card.ability.extra.destroy_time_max then
				RevosVault.remove_gem(card.config.center.key)
			else
				card.ability.extra.destroy_time = card.ability.extra.destroy_time + 1
			end
		end
	end,
	update = function(self, card, context)
		if G and G.playing_cards then
			for k, v in pairs(G.playing_cards) do
				if v:is_suit("Spades", true) or v:is_suit("Clubs", true) then
					if v.debuff then
						v:set_debuff(false)
					end
				end
			end
		end
	end,
})

RevosVault.Gem({
	key = "expe",
	atlas = "gemss",
	pos = { x = 1, y = 0 },
	config = {
		extra = {
			destroy_time = 0,
			destroy_time_max = 2,
		},
	},
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.end_of_round and context.main_eval then
			if card.ability.extra.destroy_time >= card.ability.extra.destroy_time_max then
				RevosVault.remove_gem(card.config.center.key)
			else
				card.ability.extra.destroy_time = card.ability.extra.destroy_time + 1
			end
		end
		if context.crv_easedollars and to_big(context.crv_easedollars) > to_big(0) and not crv.activated then
			crv.activated = true
			ease_dollars(context.crv_easedollars)
		end
		if crv.activated == true then
			local event
			event = Event({
				blockable = false,
				blocking = false,
				pause_force = true,
				no_delete = true,
				trigger = "after",
				delay = 1.2,
				timer = "UPTIME",
				func = function()
					event.start_timer = false
					crv.activated = false
				end,
			})
			G.E_MANAGER:add_event(event)
		end
	end,
})

RevosVault.Gem({
	key = "ruby",
	atlas = "gemss",
	pos = { x = 2, y = 0 },
	config = {
		extra = {
			destroy_time = 0,
			destroy_time_max = 0,
		},
	},
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.end_of_round and context.main_eval then
			if card.ability.extra.destroy_time >= card.ability.extra.destroy_time_max then
				RevosVault.remove_gem(card.config.center.key)
			else
				card.ability.extra.destroy_time = card.ability.extra.destroy_time + 1
			end
		end
		if context.final_scoring_step then
			return {
				xmult = #G.jokers.cards,
			}
		end
	end,
})

RevosVault.Gem({
	key = "diamond",
	atlas = "gemss",
	pos = { x = 3, y = 0 },
	config = {
		extra = {
			destroy_time = 0,
			destroy_time_max = 5,
		},
	},
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			if card.ability.extra.destroy_time >= card.ability.extra.destroy_time_max then
				RevosVault.remove_gem(card.config.center.key)
			else
				card.ability.extra.destroy_time = card.ability.extra.destroy_time + 1
			end
		end
	end,
	update = function(self, card, context)
		if G and G.playing_cards then
			for k, v in pairs(G.playing_cards) do
				if v:is_suit("Hearts", true) or v:is_suit("Diamonds", true) then
					if v.debuff then
						v:set_debuff(false)
					end
				end
			end
		end
	end,
})

RevosVault.Gem({
	key = "star_sapphire",
	atlas = "gemss",
	pos = { x = 4, y = 0 },
	config = {
		extra = {
			destroy_time = 0,
			destroy_time_max = 0,
		},
	},
	calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.end_of_round and context.main_eval then
			if card.ability.extra.destroy_time >= card.ability.extra.destroy_time_max then
				RevosVault.remove_gem(card.config.center.key)
			else
				card.ability.extra.destroy_time = card.ability.extra.destroy_time + 1
			end
		end
		if context.joker_main then
			return {
				level_up = 1,
			}
		end
	end,
})

RevosVault.Gem({
	key = "obsidian",
	atlas = "gemss",
	pos = { x = 5, y = 0},
	config = {
		extra = {
			destroy_time = 0,
			destroy_time_max = 2,
            old_odds = 0
		},
	},
    calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.end_of_round and context.main_eval then
			if card.ability.extra.destroy_time >= card.ability.extra.destroy_time_max then
				RevosVault.remove_gem(card.config.center.key)
			else
				card.ability.extra.destroy_time = card.ability.extra.destroy_time + 1
			end
		end
	end,
})


RevosVault.Gem({
	key = "angelite",
		atlas = "gemss",
	pos = { x = 6, y = 0 },
	config = {
		extra = {
			destroy_time = 0,
			destroy_time_max = 2,
            old_odds = 0
		},
	},
    calculate = function(self, card, context)
		local crv = card.ability.extra
		if context.end_of_round and context.main_eval then
			if card.ability.extra.destroy_time >= card.ability.extra.destroy_time_max then
				RevosVault.remove_gem(card.config.center.key)
			else
				card.ability.extra.destroy_time = card.ability.extra.destroy_time + 1
			end
		end
        if context.crv_joker_destroyed and context.crv_destroyedj then
            if pseudorandom("angelite") < 1 / 4 then 
                SMODS.add_card{
                    key = context.crv_destroyedj.config.center.key,
                }
            end
        end
	end,
})

RevosVault.Gem({
	key = "amethyst",
	atlas = "gemss",
	pos = { x = 7, y = 0 },
	config = {
		extra = {
			destroy_time = 0,
			destroy_time_max = 2,
		},
	},
	update = function(self, card, context) 
	if G.shop_jokers and G.shop_jokers.cards and card.area == G.vouchers then
		for _, v in pairs(G.shop_jokers.cards) do
			if not v.edition then
				v:juice_up()
				v:set_edition(poll_edition("gem_amethyst", nil, false, true))
			end
		end
	end
	end,
	calculate = function(self,card,context)
		if context.end_of_round and context.main_eval then
			if card.ability.extra.destroy_time >= card.ability.extra.destroy_time_max then
				RevosVault.remove_gem(card.config.center.key)
			else
				card.ability.extra.destroy_time = card.ability.extra.destroy_time + 1
			end
		end
	end
})


--Ametrine - Played cards change suits 

--Adamite - something something with cards being destroyed

--