if RevoConfig["experimental_enabled"] then

    TheVault = {
        vault_cost = 75,
        vault_cost_default = 75,

        enhance_cost = 15,
        enhance_cost_default = 15,

        upgrade_cost = 40,
        upgrade_cost_default = 40,

        harvest_cost = 0,
        harvest_cost_default = 0,

        in_vault = false
    }

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
        e.config.button = 'enter_vault'
    end

    G.FUNCS.enter_vault = function(e)

        if G.vault then
			G.vault:remove()
			G.vault = nil
		end
        G.vault = UIBox{
            definition = G.UIDEF.vault(),
            config = {align='tmi', offset = {x=0,y=G.ROOM.T.y+11},major = G.hand, bond = 'Weak'}
        }

        if G.load_vault_card then 
            nosave_vault = true
            G.vault_card:load(G.load_vault_card)
            G.load_vault_card = nil
        end

        RevosVault.s_to_v()
        
        G.E_MANAGER:add_event(Event({ func = function() save_run() return true end}))

    end

    local toggle_shop_old = G.FUNCS.toggle_shop
    function G.FUNCS.toggle_shop(e)
        toggle_shop_old(e)
        if G.vault then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    G.vault:remove()
                    G.vault = nil
                return true
                end
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

        if self.config.center.rarity == tab[#tab] then
            return false
        end
        return true
    end

    function RevosVault.vaultify(card, no_juice)
        for k, v in pairs(G.P_JOKER_RARITY_POOLS["crv_va"]) do
            if type(v.from) == "table" then
                for kk, vv in pairs(v.from) do
                    if card.config.center.key == vv then
                        card:set_ability(v.key)
                        if not no_juice then
                            card:juice_up()
                        end
                        return true
                    end
                end
            else
                if card.config.center.key == v.from then
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

            if (G.jokers and G.jokers.cards and #G.jokers.cards < G.jokers.config.card_limit and vcard) or (vcard and vcard.edition and vcard.edition.negative) then
                RevosVault.move_card(vcard, G.jokers)
            elseif vcard and G.jokers then
                alert_no_space(vcard, G.jokers)
                turn_back = false
            end

            if turn_back then
                RevosVault.v_to_s()
                G.E_MANAGER:add_event(Event({ func = function() save_run() return true end}))
            else
                turn_back = true
            end
        end
    end

    G.FUNCS.crv_vault_vault_can = function(e)
        if not (G.vault_card and G.vault_card.cards and G.vault_card.cards[1] and G.vault_card.cards[1]:is_vaultable() and G.GAME.souls and (G.GAME.souls >= TheVault.vault_cost)) then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.PURPLE
            e.config.button = "crv_vault_vault"
        end
    end

    G.FUNCS.crv_vault_vault = function(e)
        G.GAME.souls = G.GAME.souls - TheVault.vault_cost

        RevosVault.vaultify(G.vault_card.cards[1])
        play_sound('coin1')

         G.E_MANAGER:add_event(Event({ func = function() save_run()
return true end}))
    end

    G.FUNCS.crv_vault_enhance_can = function(e)
        if not (G.vault_card and G.vault_card.cards and G.vault_card.cards[1] and G.GAME.souls and (G.GAME.souls >= TheVault.enhance_cost) and G.vault_card.cards[1]:crv_is_upgradeable()) then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.DARK_EDITION
            e.config.button = "crv_vault_enhance"
        end
    end

    G.FUNCS.crv_vault_enhance = function(e)
        G.GAME.souls = G.GAME.souls - TheVault.enhance_cost

        local edition = poll_edition(nil, nil, true, true)
        G.vault_card.cards[1]:set_edition(edition)
        play_sound('coin1')
        G.E_MANAGER:add_event(Event({ func = function() save_run()
return true end}))
    end

    G.FUNCS.crv_vault_upgrade_can = function(e)
        if not (G.vault_card and G.vault_card.cards and G.vault_card.cards[1] and G.vault_card.cards[1]:crv_is_upgradeable() and G.GAME.souls and (G.GAME.souls >= TheVault.upgrade_cost)) then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.RED
            e.config.button = "crv_vault_upgrade"
        end
    end

    G.FUNCS.crv_vault_upgrade = function(e)
        G.GAME.souls = G.GAME.souls - TheVault.upgrade_cost

        RevosVault.modify_rarity(G.vault_card.cards[1], 1)
        play_sound('coin1')

        G.E_MANAGER:add_event(Event({ func = function() save_run()
return true end}))
    end

    G.FUNCS.crv_vault_harvest_can = function(e)
        if not (G.vault_card and G.vault_card.cards and G.vault_card.cards[1] and G.GAME.souls and G.vault_card.cards[1].cost) then
            TheVault.harvest_cost = TheVault.harvest_cost_default
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            TheVault.harvest_cost = G.vault_card.cards[1].cost/2
            e.config.colour = G.C.BLUE
            e.config.button = "crv_vault_harvest"
        end
    end

    G.FUNCS.crv_vault_harvest = function(e)

        G.GAME.souls = G.GAME.souls + G.vault_card.cards[1].cost/2
        play_sound('coin1')

        SMODS.destroy_cards(G.vault_card.cards[1])

        G.E_MANAGER:add_event(Event({ func = function() save_run()
return true end}))
    end

    function RevosVault.v_to_s()

        TheVault.in_vault = false

        if G.shop and G.shop.alignment.offset.py then
            G.shop.alignment.offset.y = G.shop.alignment.offset.py
            G.shop.alignment.offset.py = nil
        end
        if G.vault then
            G.vault.alignment.offset.y = G.ROOM.T.y + 29
        end
    end

    function RevosVault.s_to_v()

        TheVault.in_vault = true

        if G.shop and not G.shop.alignment.offset.py then
            G.shop.alignment.offset.py = G.shop.alignment.offset.y
            G.shop.alignment.offset.y = G.ROOM.T.y + 29
        end
        if G.vault and G.shop.alignment.offset.py then
            G.vault.alignment.offset.y = G.shop.alignment.offset.py
        end
    end

    function RevosVault.resetv()
        G.vault:remove()
        G.vault = nil
        G.vault = G.vault or UIBox{
            definition = G.UIDEF.vault(),
            config = {align='tmi', offset = {x=0,y=G.ROOM.T.y+11},major = G.hand, bond = 'Weak'}
        }
    end

    function G.UIDEF.vault()

        G.vault_card = CardArea(
            G.hand.T.x+0,
            G.hand.T.y+G.ROOM.T.y + 9,
            1*1.02*G.CARD_W,
            1.05*G.CARD_H, 
            {card_limit = 1, type = 'shop', highlight_limit = 1}
        )

        
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            G.SHOP_SIGN.alignment.offset.y = 0
            return true
        end)
        }))


        local t = {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={
            {n=G.UIT.R, config={align = "cl", padding = 0, emboss = 0.05, r = 0.1, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.R,config={id = 'crv_take_to_shop', align = "cm", minw = 0.9, minh = 0.9, r=0.15,colour = G.C.RED, button = 'take_me_back', hover = true,shadow = false}, nodes = {
                            {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                                {n=G.UIT.R, config={align = "cm", maxw = 1.5}, nodes={
                                {n=G.UIT.T, config={text = "Return to", scale = 0.4, colour = G.C.WHITE, shadow = false}},
                                }},
                                {n=G.UIT.R, config={align = "cm", maxw = 1.5}, nodes={
                                {n=G.UIT.T, config={text = "Shop", scale = 0.4, colour = G.C.WHITE, shadow = false}},
                                }},
                            }},        
                            }},
            }},
                UIBox_dyn_container({
                    {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={

                            --
                        {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN,shadow = false}, nodes={
                            {n=G.UIT.R,config={id = 'crv_vault_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.PURPLE, button = 'crv_vault_vault', func = "crv_vault_vault_can", hover = true,shadow = false}, nodes = {
                            {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={text = "Vault", scale = 0.4, colour = G.C.WHITE, shadow = false}}
                                }},
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={ref_table = TheVault, ref_value = 'vault_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
                                {n=G.UIT.T, config={text = (" " .. "Souls"), scale = 0.7, colour = G.C.WHITE, shadow = true}},
                                }}   
                            }},        
                            }},

                            {n=G.UIT.R,config={id = 'crv_enhance_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.DARK_EDITION,button = 'crv_vault_enhance',func = "crv_vault_enhance_can", hover = true,shadow = false}, nodes = {
                            {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={text = "Enhance", scale = 0.4, colour = G.C.WHITE, shadow = true}}
                                }},
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={ref_table = TheVault, ref_value = 'enhance_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
                                {n=G.UIT.T, config={text = (" " .. "Souls"), scale = 0.7, colour = G.C.WHITE, shadow = true}},
                                }}   
                            }},        
                            }},
                        }},
                            --


                        {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN,shadow = false}, nodes={

                            {n=G.UIT.R, config={align = "cm", padding = 0.1, emboss = 0, r = 0.2, colour = G.C.CLEAR}, nodes={
                                {n=G.UIT.T, config={text = "PUT JOKER", scale = 0.4, colour = G.C.L_BLACK, shadow = false}}
                            }},
                            {n=G.UIT.R, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
                                {n=G.UIT.O, config={object = G.vault_card}},
                            }},
                            {n=G.UIT.R, config={align = "cm", padding = 0.1, emboss = 0, r = 0.2, colour = G.C.CLEAR}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'souls', prefix = ("Souls:" .. " ")}}, maxw = 1.35, colours = {G.C.BLUE}, font = G.LANGUAGES['en-us'].font, shadow = false,spacing = 2, bump = true, scale = 0.4}), id = 'soul_text_UI'}}
                            }},
                        }},
                            --


                        {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN,shadow = false}, nodes={
                            {n=G.UIT.R,config={id = 'crv_upgrade_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.RED, one_press = false, button = 'crv_vault_upgrade', func = "crv_vault_upgrade_can", hover = true,shadow = false}, nodes = {
                            {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={text = "Upgrade", scale = 0.4, colour = G.C.WHITE, shadow = false}}
                                }},
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={ref_table = TheVault, ref_value = 'upgrade_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
                                {n=G.UIT.T, config={text = (" " .. "Souls"), scale = 0.7, colour = G.C.WHITE, shadow = true}},
                                }}   
                            }},        
                            }},

                            
                            {n=G.UIT.R,config={id = 'crv_harvest_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.BLUE, one_press = false, button = 'crv_vault_harvest', func = "crv_vault_harvest_can", hover = true,shadow = false}, nodes = {
                            {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={text = "Harvest", scale = 0.4, colour = G.C.WHITE, shadow = false}}
                                }},
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={ref_table = TheVault, ref_value = 'harvest_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
                                {n=G.UIT.T, config={text = (" " .. "Souls"), scale = 0.7, colour = G.C.WHITE, shadow = true}},
                                }}   
                            }},        
                            }},
                        }},

                    }
                },
                
                }, false)
            },
        }
        return t
    end













end