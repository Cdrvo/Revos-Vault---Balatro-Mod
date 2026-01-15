if FLACE and FLACE.Flace then

    FLACE.Flace({
        key = "aop",
        atlas = "flace",
        subset = "Tuning",
        no_buttons = true,
        pos = { x = 0, y = 0 },
        config = { extra = { } },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    
                },
            }
        end,
    
        calculate = function(self, card, context)
           if context.first_hand_drawn then
                local acecard = RevosVault.random_playing_card("Ace", nil, G.hand)
                return{
                    message = "Aced!",
                }
           end
        end,
    })

end