SMODS.Rarity({
	key = "WIP",
	badge_colour = SMODS.Gradients["crv_wip"],
})


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