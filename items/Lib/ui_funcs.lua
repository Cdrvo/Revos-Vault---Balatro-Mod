
-- D6

G.FUNCS.can_reroll_cards = function(e)
	local card = e.config.ref_table
	if card.ability.extra.can_roll == true then
		e.config.colour = G.C.RED
		e.config.button = "reroll_cards"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.reroll_cards = function(e)
	local card = e.config.ref_table
	Card:reroll_cards()
end

function Card:reroll_cards()
	SMODS.calculate_context({ reroll_cards = true })
end

-- The Vault (shop)

G.FUNCS.crv_can_emplace_to_vault = function(e)
	local card = e.config.ref_table
	if G.vault_card and G.vault_card.cards and (#G.vault_card.cards==0) then
		e.config.colour = G.C.RED
		e.config.button = "crv_emplace_to_vault"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.crv_emplace_to_vault = function(e)
	local card = e.config.ref_table
	RevosVault.move_card(card, G.vault_card)
	G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
end

G.FUNCS.crv_remove_from_vault = function(e)
	local card = e.config.ref_table
	if (G.jokers and G.jokers.cards and #G.jokers.cards < G.jokers.config.card_limit and card) or (card and card.edition and card.edition.negative) then
        RevosVault.move_card(card, G.jokers)
		G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
    elseif card and G.jokers then
        alert_no_space(card, G.jokers)
    end
end

-- Holo face

G.FUNCS.crv_can_change = function(e)
	local card = e.config.ref_table
	if not RevosVault.scoring then
		e.config.colour = G.C.RED
		e.config.button = "crv_change"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.crv_change = function(e)
	local card = e.config.ref_table
	if card:is_face() then
		local face = pseudorandom_element(RevosVault.facepool(card.base.value)).key
		card:flip()
		G.E_MANAGER:add_event(Event({
			trigger = "before",
			delay = 0.5,
			func = function()
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.5,
			func = function()
				SMODS.change_base(card, nil, face)
				card:flip()
				return true
			end,
		}))
	end
end

-- The Dealer

G.FUNCS.can_change_mode = function(e)
	local card = e.config.ref_table
	if card.ability.extra["turn"] == "Player" then
		e.config.colour = G.C.RED
		e.config.button = "crv_modee"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.crv_modee = function(e)
	local card = e.config.ref_table
	if card.ability.extra["turn"] == "Player" then
		if card.ability.extra["mode"] == "Joker" then
			card.ability.extra["mode"] = "Self"
			RevosVault.c_message(card, "Self!")
		elseif card.ability.extra["mode"] == "Self" then
			card.ability.extra["mode"] = "Joker"
			RevosVault.c_message(card, "Joker!")
		end
	end
end

-- Jimbo's Apple

G.FUNCS.crv_eaten = function(e)
	local card = e.config.ref_table
	card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
	if #SMODS.find_card("j_crv_oldjimbo") > 0 then
		for i = 1, #SMODS.find_card("j_crv_oldjimbo") do
			SMODS.find_card("j_crv_oldjimbo")[1]:start_dissolve()
		end
	end
	if G.STATE ~= G.STATES.SELECTING_HAND then
		return
	end
	G.GAME.chips = G.GAME.blind.chips
	G.STATE = G.STATES.HAND_PLAYED
	G.STATE_COMPLETE = true
	end_round()
end

-- Invesment


G.FUNCS.crv_invest = function(e) -- i am way to lazy to fix this right now. I will fix it later.................................................................
	local card = e.config.ref_table
	if card.ability.extra["check"] == false then
		card.ability.extra["check"] = true
		if G.GAME.talisman == 1 then
			card.ability.extra["invested"] = to_number(G.GAME.dollars / 4)
			ease_dollars(-(to_number(G.GAME.dollars / 4)))
		else
			card.ability.extra["invested"] = G.GAME.dollars / 4
			ease_dollars(-(G.GAME.dollars / 4))
		end
	end
end

G.FUNCS.crv_can_invest = function(e)
	local card = e.config.ref_table
	if card.ability.extra["check"] == false then
		e.config.colour = G.C.RED
		e.config.button = "crv_invest"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

-- Roulette

G.FUNCS.crv_changebet = function(e)
	local card = e.config.ref_table
	if card.ability.extra["bet"] == "Black" then
		card.ability.extra["bet"] = "Red"
		RevosVault.c_message(card, "Red!")
	elseif card.ability.extra["bet"] == "Red" then
		card.ability.extra["bet"] = "Green"
		RevosVault.c_message(card, "Green!")
	elseif card.ability.extra["bet"] == "Green" then
		card.ability.extra["bet"] = "Black"
		RevosVault.c_message(card, "Black!")
	end
end

-- Deal Breaker

G.FUNCS.crv_half = function(e)
	local card = e.config.ref_table
	card.ability.extra["uses"] = card.ability.extra["uses"] - 1
	G.GAME.blind.chips = G.GAME.blind.chips / 2
	G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
	RevosVault.c_message(card, "Halved!")
end