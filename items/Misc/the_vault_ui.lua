    local update_shop_old = Game.update_shop
function Game:update_shop(dt)
	if not G.STATE_COMPLETE then
        local vault_exists = not not G.vault
        G.vault = G.vault or UIBox{
            definition = G.UIDEF.vault(),
            config = {align='tmi', offset = {x=0,y=G.ROOM.T.y+11},major = G.hand, bond = 'Weak'}
        }
		G.E_MANAGER:add_event(Event({
                func = function()
                    G.vault.alignment.offset.y = (G.ROOM.T.y or 0.7) + 29
                    G.vault.alignment.offset.x = 0
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        blockable = false,
                        func = function()
                            if math.abs(G.vault.T.y - G.vault.VT.y) < 3 then
                                local nosave_vault = nil
                                if not vault_exists then
                                
                                    if G.load_vault_card then 
                                        nosave_vault = true
                                        G.vault_card:load(G.load_vault_card)
                                        G.load_vault_card = nil
                                    end
                                    
                                    
								end
                                if not nosave_vault then G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end})) end
                                return true
                            end
                        end}))
                    return true
                end
            }))
    end  
	return update_shop_old(self, dt)
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
            {n=G.UIT.R, config={align = "cl", padding = 0, emboss = 0.05, r = 1, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.14, emboss = 0.05, r = 1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
                        {n=G.UIT.C,config={id = 'crv_take_to_shop', align = "cm", minw = 0.9, minh = 0.9, r=0.15,colour = G.C.RED, button = 'take_me_back', hover = true,shadow = false}, nodes = {
                            {n=G.UIT.R, config={align = "cm", padding = 0.1, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                                {n=G.UIT.R, config={align = "cm", maxw = 1.5}, nodes={
                                {n=G.UIT.T, config={text = "Return to", scale = 0.4, colour = G.C.WHITE, shadow = false}},
                                }},
                                {n=G.UIT.R, config={align = "cm", maxw = 1.5}, nodes={
                                {n=G.UIT.T, config={text = "Shop", scale = 0.4, colour = G.C.WHITE, shadow = false}},
                                }},
                            }},        
                            }},
                    
                }},
            }},
                UIBox_dyn_container({
                    {n=G.UIT.R, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={

                            --
                        {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN,shadow = false}, nodes={
                            {n=G.UIT.R,config={id = 'crv_vault_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.PURPLE, button = 'crv_vault_vault', func = "crv_vault_vault_can", hover = true,shadow = false}, nodes = {
                            {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={text = TheVault.current_vault_text, scale = 0.4, colour = G.C.WHITE, shadow = false}}
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

                    },
                    
                },
                
                },
                
                false),
            },

        }
        return t
    end
