TheVault = {
	vault_cost = 75,
	vault_cost_default = 75,

	enhance_cost = 15,
	enhance_cost_default = 15,

	upgrade_cost = 40,
	upgrade_cost_default = 40,

	harvest_cost = 0,
	harvest_cost_default = 0,
	harvest_cost_extra = 0,
	harvest_cost_extra_default = 0,

	in_vault = false,

    current_vault_text = "Vault",
    changed = false -- idk
}

if not RevoConfig["6_vault_enabled"] then
    TheVault.current_vault_text = "Reroll"
    TheVault.changed = true
    TheVault.vault_cost = 30
    TheVault.vault_cost_default = 30
end

local can_reroll_old = G.FUNCS.can_reroll
function G.FUNCS.can_reroll(e)
	if TheVault.in_vault then
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	else
		can_reroll_old(e)
	end
end

G.FUNCS.can_enter_vault = function(e)
	e.config.colour = G.C.PURPLE
	e.config.button = "enter_vault"
end

G.FUNCS.enter_vault = function(e)
	if G.vault then
		G.vault:remove()
		G.vault = nil
	end
	G.vault = UIBox({
		definition = G.UIDEF.vault(),
		config = { align = "tmi", offset = { x = 0, y = G.ROOM.T.y + 11 }, major = G.hand, bond = "Weak" },
	})

	if G.load_vault_card then
		nosave_vault = true
		G.vault_card:load(G.load_vault_card)
		G.load_vault_card = nil
	end

	RevosVault.s_to_v()

	G.E_MANAGER:add_event(Event({
		func = function()
			save_run()
			return true
		end,
	}))
end

local toggle_shop_old = G.FUNCS.toggle_shop
function G.FUNCS.toggle_shop(e)
	toggle_shop_old(e)
	if G.vault then
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.5,
			func = function()
				G.vault:remove()
				G.vault = nil
				return true
			end,
		}))
	end
end

function Card:is_vaultable()
	for k, v in pairs(G.P_JOKER_RARITY_POOLS["crv_va"]) do
		if type(v.from) == "table" then
			for kk, vv in pairs(v.from) do
				if self.config.center.key == vv then
					return true
				end
			end
		else
			if self.config.center.key == v.from then
				return true
			end
		end
	end
	return false
end

function Card:crv_is_upgradeable()
	local tab = RevosVault.modify_rarity()
	local match = nil

	for k, v in pairs(tab) do
		if v == self.config.center.rarity then
			match = true
		end
	end

	if self.config.center.rarity == tab[#tab] then
		return false
	end
	
	if match then
		return true
	end
end

function RevosVault.vaultify(card, no_juice, ret)
	for k, v in pairs(G.P_JOKER_RARITY_POOLS["crv_va"]) do
		if type(v.from) == "table" then
			for kk, vv in pairs(v.from) do
				if card.config.center.key == vv then
					if ret then
						return v.key
					end
					card:set_ability(v.key)
					if not no_juice then
						card:juice_up()
					end
					return true
				end
			end
		else
			if card.config.center.key == v.from then
				if ret then
					return v.key
				end
				card:set_ability(v.key)
				if not no_juice then
					card:juice_up()
				end
				return true
			end
		end
	end
end

G.FUNCS.take_me_back = function(e)
	if G.vault_card and G.vault_card.cards then
		local vcard = nil
		local turn_back = true

		if G.vault_card.cards[1] then
			vcard = G.vault_card.cards[1]
		end

		if
			(G.jokers and G.jokers.cards and #G.jokers.cards < G.jokers.config.card_limit and vcard)
			or (vcard and vcard.edition and vcard.edition.negative)
		then
			RevosVault.move_card(vcard, G.jokers)
		elseif vcard and G.jokers then
			alert_no_space(vcard, G.jokers)
			turn_back = false
		end

		if turn_back then
			RevosVault.v_to_s()
			G.E_MANAGER:add_event(Event({
				func = function()
					save_run()
					return true
				end,
			}))
		else
			turn_back = true
		end
	end
end

G.FUNCS.crv_vault_help = function(e)
	if TheVault.changed then
		G.FUNCS.RevosVault_info{menu_type = "crv_thevault_alt", no_first_time = true}
	else
		G.FUNCS.RevosVault_info{menu_type = "crv_thevault", no_first_time = true}
	end
end

G.FUNCS.crv_vault_help_can = function(e)
	if not (not TheVault.vault_lock) then
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	else
		e.config.colour = G.C.L_BLACK
		e.config.button = "crv_vault_help"
	end
end

G.FUNCS.crv_vault_vault_can = function(e)
    if not TheVault.changed then
        if
            not (
                G.vault_card
                and G.vault_card.cards
                and G.vault_card.cards[1]
                and G.vault_card.cards[1]:is_vaultable()
                and G.GAME.souls
                and (G.GAME.souls >= TheVault.vault_cost)
    			and not TheVault.vault_lock
				and not G.CONTROLLER.locked
				and not G.vault_card.cards[1].crv_harvested
            )
        then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.PURPLE
            e.config.button = "crv_vault_vault"
        end
    else
        if
            not (
                G.vault_card
                and G.vault_card.cards
                and G.vault_card.cards[1]
                and G.GAME.souls
                and (G.GAME.souls >= TheVault.vault_cost)
            )
        then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.PURPLE
            e.config.button = "crv_vault_vault"
        end
    end
end

G.FUNCS.crv_vault_vault = function(e)

	G.E_MANAGER:add_event(Event({
		trigger = "before",
		delay = 0,
		func = function()
			TheVault.vault_lock = true
			return true
		end
	}))

    if not TheVault.changed then
		
        G.GAME.souls = G.GAME.souls - TheVault.vault_cost

        local vault_ver = RevosVault.vaultify(G.vault_card.cards[1], true, true)
		RevosVault.set_ability({card = G.vault_card.cards[1], sound = "gong", effect_table = {center = vault_ver}})
        play_sound("coin1")
    else
		G.E_MANAGER:add_event(Event({
			trigger = "before",
			delay = 0,
			func = function()
				TheVault.vault_lock = true
				return true
			end
		}))
        G.GAME.souls = G.GAME.souls - TheVault.vault_cost
        play_sound("coin1")

        RevosVault.replacecards(G.vault_card.cards, nil, true, true)
    end

	    G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0,
            func = function()
				TheVault.vault_lock = false
                save_run()
                return true
            end,
        }))
end

G.FUNCS.crv_vault_enhance_can = function(e)
	if
		not (
			G.vault_card
			and G.vault_card.cards
			and G.vault_card.cards[1]
			and G.GAME.souls
			and (G.GAME.souls >= TheVault.enhance_cost)
			and not TheVault.vault_lock
			and not G.CONTROLLER.locked
			and not G.vault_card.cards[1].crv_harvested
		)
	then
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	else
		e.config.colour = G.C.DARK_EDITION
		e.config.button = "crv_vault_enhance"
	end
end

G.FUNCS.crv_vault_enhance = function(e)
	G.E_MANAGER:add_event(Event({
		trigger = "before",
		delay = 0,
		func = function()
			TheVault.vault_lock = true
			return true
		end
	}))
	G.GAME.souls = G.GAME.souls - TheVault.enhance_cost

	local edition = poll_edition(nil, nil, true, true)
	G.vault_card.cards[1]:set_edition(edition)
	play_sound("coin1")
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0,
		func = function()
			TheVault.vault_lock = false
			save_run()
			return true
		end,
	}))
end

G.FUNCS.crv_vault_upgrade_can = function(e)
	if
		not (
			G.vault_card
			and G.vault_card.cards
			and G.vault_card.cards[1]
			and G.vault_card.cards[1]:crv_is_upgradeable()
			and G.GAME.souls
			and (G.GAME.souls >= TheVault.upgrade_cost)
			and not TheVault.vault_lock
			and not G.CONTROLLER.locked
			and not G.vault_card.cards[1].crv_harvested
		)
	then
		TheVault.upgrade_cost = TheVault.upgrade_cost_default
		if G.vault_card.cards[1] then
			if G.vault_card.cards[1].config.center.rarity == 4 then
				TheVault.upgrade_cost = TheVault.upgrade_cost+((RevosVault.modify_rarity(G.vault_card.cards[1], 1, true)/4)+15) -- FUCK EXOTICS, LEGENDARIES 'TILL THE END!
			else
				TheVault.upgrade_cost = TheVault.upgrade_cost+((RevosVault.modify_rarity(G.vault_card.cards[1], 1, true)/4)-5)
			end
		end
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	else

		TheVault.upgrade_cost = TheVault.upgrade_cost_default
		if G.vault_card.cards[1].config.center.rarity == 4 then
			TheVault.upgrade_cost = TheVault.upgrade_cost+((RevosVault.modify_rarity(G.vault_card.cards[1], 1, true)/4)+15) -- lazy 
		else
			TheVault.upgrade_cost = TheVault.upgrade_cost+((RevosVault.modify_rarity(G.vault_card.cards[1], 1, true)/4)-5)	
		end

		e.config.colour = G.C.RED
		e.config.button = "crv_vault_upgrade"
	end
end

G.FUNCS.crv_vault_upgrade = function(e)
	G.E_MANAGER:add_event(Event({
		trigger = "before",
		delay = 0,
		func = function()
			TheVault.vault_lock = true
			return true
		end
	}))
	G.GAME.souls = G.GAME.souls - TheVault.upgrade_cost

	local new_key = RevosVault.modify_rarity(G.vault_card.cards[1], 1, nil, nil, true)
	RevosVault.set_ability({card = G.vault_card.cards[1], sound = nil, effect_table = {center = new_key}})
	play_sound("coin1")

	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0,
		func = function()
			TheVault.vault_lock = false
			save_run()
			return true
		end,
	}))
end

G.FUNCS.crv_vault_harvest_can = function(e)
	if
		not (
			G.vault_card
			and G.vault_card.cards
			and G.vault_card.cards[1]
			and G.GAME.souls
			and G.vault_card.cards[1].sell_cost
			and not SMODS.is_eternal(G.vault_card.cards[1])
			and not TheVault.vault_lock
			and not G.CONTROLLER.locked
			and not G.vault_card.cards[1].crv_harvested
		)
	then
		TheVault.harvest_cost = TheVault.harvest_cost_default
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	else
		if G.GAME.modifiers.fifty_soul_increase then
			TheVault.harvest_cost_extra = TheVault.harvest_cost_extra_default
			TheVault.harvest_cost_extra = TheVault.harvest_cost_extra + RevosVault.perc(G.vault_card.cards[1].sell_cost, 50)
		end
		TheVault.harvest_cost = (G.vault_card.cards[1].sell_cost + TheVault.harvest_cost_extra )
		e.config.colour = G.C.BLUE
		e.config.button = "crv_vault_harvest"
	end
end

G.FUNCS.crv_vault_harvest = function(e)
	G.E_MANAGER:add_event(Event({
		trigger = "before",
		delay = 0,
		func = function()
			TheVault.vault_lock = true
			return true
		end
	}))
	G.GAME.souls = G.GAME.souls + (G.vault_card.cards[1].sell_cost + TheVault.harvest_cost_extra )
	play_sound("coin1")

	G.vault_card.cards[1].crv_harvested = true
	SMODS.destroy_cards(G.vault_card.cards[1])

	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0,
		func = function()
			TheVault.vault_lock = false
			save_run()
			return true
		end,
	}))
end

function RevosVault.v_to_s(no_shop)
    ease_background_colour_blind(G.STATES.SHOP)
	if not no_shop then
		TheVault.in_vault = false
	end

	if G.shop and G.shop.alignment.offset.py and not no_shop then
		G.shop.alignment.offset.y = G.shop.alignment.offset.py
		G.shop.alignment.offset.py = nil
	end
	if G.vault then
		G.vault.alignment.offset.y = G.ROOM.T.y + 29
	end
end

function RevosVault.s_to_v(no_shop)
    ease_background_colour({new_colour = darken(G.C.PURPLE, 0.3), special_colour = G.C.BLACK})
	if not no_shop then
		TheVault.in_vault = true
	end

	if G.shop and not G.shop.alignment.offset.py then
		G.shop.alignment.offset.py = G.shop.alignment.offset.y
		if not no_shop then
			G.shop.alignment.offset.y = G.ROOM.T.y + 29
		end
	end
	if G.vault and G.shop.alignment.offset.py then
		G.vault.alignment.offset.y = G.shop.alignment.offset.py
	end
end

function RevosVault.resetv()
	G.vault:remove()
	G.vault = nil
	G.vault = G.vault
		or UIBox({
			definition = G.UIDEF.vault(),
			config = { align = "tmi", offset = { x = 0, y = G.ROOM.T.y + 11 }, major = G.hand, bond = "Weak" },
		})
end
