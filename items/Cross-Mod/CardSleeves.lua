CardSleeves.Sleeve {
    key = "psleeve",
    atlas = "sleeves",
    unlocked = false,
    config = {},
    unlock_condition = {deck = "b_crv_pdeck", stake = "stake_gold"},
    pos = { x = 0, y = 0 },
    loc_vars = function(self)
        local dkey 
        if not dkey then dkey = self.key end
        local key
        if self.get_current_deck_key() == "b_crv_pdeck" then
            RevosVault.sleeve_applied = true
            key = self.key .. "_alt"
        else
            RevosVault.sleeve_applied = false
            key = dkey
        end
        return { key = key }
    end,
    apply = function(self)
        CardSleeves.Sleeve.apply(self)
        if not RevosVault.sleeve_applied then
            if next(SMODS.find_mod("partner")) and Partner_API.config and Partner_API.config.enable_partner then
                RevosVault.partner_fix = true
            else
                G.FUNCS.get_printer_box()
            end
        end
    end
}

--[[CardSleeves.Sleeve {
    key = "machinerys",
    atlas = "sleeves",
    unlocked = false,
    config = { discards = 0,hands = 0 },
    unlock_condition = {deck = "b_crv_mach", stake = "stake_gold"},
    pos = { x = 0, y = 0 },
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() == "b_crv_os" or self.get_current_deck_key() == "b_crv_mach" then
            key = self.key .. "_alt"
            self.config = { discards = -2,hands = -1 }
            vars = { self.config.discards,self.config.hands }
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        CardSleeves.Sleeve.apply(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_printer')
                return true
            end
        }))
    end
}
CardSleeves.Sleeve {
    key = "oldscrolls",
    atlas = "sleeves",
    unlocked = false,
    config = { discards = 0,hands = 0 },
    unlock_condition = {deck = "b_crv_os", stake = "stake_gold"},
    pos = { x = 1, y = 0 },
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() == "b_crv_os" or self.get_current_deck_key() == "b_crv_mach" then
            key = self.key .. "_alt"
            self.config = { discards = -2,hands = -1 }
            vars = { self.config.discards,self.config.hands }
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        CardSleeves.Sleeve.apply(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_rustyprinter')
                return true
            end
        }))
    end
}
CardSleeves.Sleeve {
    key = "goldms",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_gm", stake = "stake_gold"},
    pos = { x = 2, y = 0 },
    config = { dollars = 0 },
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() ~= "b_yellow" then
            key = self.key
            self.config = { dollars = 0 }
            vars = { self.config.dollars }
        else
            key = self.key .. "_alt"
            self.config = { dollars = 10 }
            vars = { self.config.dollars }
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        CardSleeves.Sleeve.apply(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_moneyprinter')
                return true
            end
        }))
    end
}
CardSleeves.Sleeve {
    key = "rpds",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_rpd", stake = "stake_gold"},
    pos = { x = 3, y = 0 },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_brokenprinter')
                return true
            end
        }))
    end
}
CardSleeves.Sleeve {
    key = "jims",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_jw", stake = "stake_gold"},
    pos = { x = 4, y = 0 },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_jimboprinter')
                return true
            end
        }))
    end
}
CardSleeves.Sleeve {
    key = "grossl",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_gd", stake = "stake_gold"},
    pos = { x = 0, y = 1 },
    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_grossprinter')
                return true
            end
        }))
    end
}
CardSleeves.Sleeve {
    key = "obels",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_tsd", stake = "stake_gold"},
    pos = { x = 1, y = 1 },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_obeliskprinter')
                return true
            end
        }))
    end
}
CardSleeves.Sleeve {
    key = "faxs",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_spx", stake = "stake_gold"},
    pos = { x = 2, y = 1 },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_faxprinter')
                return true
            end
        }))
    end
}
CardSleeves.Sleeve {
    key = "phfs",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_phf", stake = "stake_gold"},
    pos = { x = 3, y = 1 },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_spectralprinter')
                return true
            end
        }))
    end
}
CardSleeves.Sleeve {
    key = "hgs",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_hg", stake = "stake_gold"},
    pos = { x = 4, y = 1 },
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() == "b_crv_hg" then
            key = self.key .. "_alt"
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        CardSleeves.Sleeve.apply(self)
        
        if self.get_current_deck_key() == "b_crv_hg" then
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card({
                        set = 'Spectral',
                        key = 'c_soul'
                    }) 
                    return true
                end
            }))
    else
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_legendaryprinter')
                return true
            end
        }))
    end
    end
}
CardSleeves.Sleeve {
    key = "gbs",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_gb", stake = "stake_gold"},
    pos = { x = 0, y = 2 },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_glassprinter')
                return true
            end
        }))
    end
}
CardSleeves.Sleeve {
    key = "atgs",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_atg", stake = "stake_gold"},
    pos = { x = 1, y = 2 },
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() == "b_crv_atg" then
            key = self.key .. "_alt"
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        if self.get_current_deck_key() == "b_crv_atg" then
            G.E_MANAGER:add_event(Event({
                func = function()
                    joker_add('j_crv_smile')
                    return true
                end
            }))
        else
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_smile')
                joker_add('j_joker')
                return true
            end
        }))
    end
end
} 
CardSleeves.Sleeve {
    key = "tcihs",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_tcih", stake = "stake_gold"},
    pos = { x = 2, y = 2 },
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() == "b_crv_tcih" then
            key = self.key .. "_alt"
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        if self.get_current_deck_key() == "b_crv_tcih" then
            G.E_MANAGER:add_event(Event({
                func = function()   
                    SMODS.add_card({
                        set = G.consumeables,
                        key = 'c_crv_dc'
                    }) 
                    SMODS.add_card({
                        area = G.consumeables,
                        key = 'c_crv_dc'
                    }) 
                    SMODS.add_card({
                        set = G.consumeables,
                        key = 'c_crv_dc'
                    }) 
                    return true
                end
            }))
        else
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_lpm')
                return true
            end
        }))
    end
end
    
}
CardSleeves.Sleeve {
    key = "dcs",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_dc", stake = "stake_gold"},
    pos = { x = 3, y = 2 },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_devilishprinter')
                return true
            end
        }))
    end
}
CardSleeves.Sleeve {
    key = "dcs",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_dc", stake = "stake_gold"},
    pos = { x = 3, y = 2 },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_devilishprinter')
                return true
            end
        }))
    end
}
CardSleeves.Sleeve {
    key = "mqs",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_rf", stake = "stake_gold"},
    pos = { x = 4, y = 2 },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_full')
                return true
            end
        }))
    end
}
CardSleeves.Sleeve {
    key = "sbs",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_sb", stake = "stake_gold"},
    pos = { x = 0, y = 3 },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_steelprinter')
                return true
            end
        }))
    end
}
CardSleeves.Sleeve {
    key = "ups",
    atlas = "sleeves",
    unlocked = false,
    unlock_condition = {deck = "b_crv_up", stake = "stake_gold"},
    pos = { x = 1, y = 3 },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_tierp')
                return true
            end
        }))
    end
}]]