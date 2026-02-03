SMODS.Joker({
	key = "astralprinter",
	atlas = "giga",
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	pos = {
		x = 0,
		y = 0,
	},
	config = {
		extra = {},
	},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = 'Other', key = 'giga_astral_chance', vars = { (G.GAME.giga and G.GAME.giga_astral_chance and (G.GAME.giga_astral_chance[1] / G.GAME.giga_astral_chance[2]) * 100) or 5, 'Celestial Printer'}}
    end,
    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader('voucher', nil, card.ARGS.send_to_shader)
        end
    end,
	calculate = function(self, card, context)
		if context.setting_blind then
            local a,tab = G.P_CENTER_POOLS["Planet"],{}
            for k, v2 in pairs(a) do
                local v = v2.key
                if string.find(v, "_giga_") and string.find(v, "astral_") and (#SMODS.find_card(v)==0) then
                    tab[#tab + 1] = v
                end
            end
            if #tab>0 then
			    RevosVault.pseudorandom_printer({card = card, area = G.consumeables, key = pseudorandom_element(tab, pseudoseed("CELPRINTER")), seed = "astralprintergobrrr"})
            else
                RevosVault.c_message(card, localize("k_crv_no_more"))
            end
		end
	end,
	in_pool = function(self, wawa, wawa2)
		return false
	end,
})