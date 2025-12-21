local c_def = JokerDisplay.Definitions  

c_def["j_crv_revoo_"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp" }
            }
        }
    },
}
c_def["j_crv_adam_"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { ref_table = "card.ability.extra", ref_value = "scrapc", },
    },
    extra = {
        {
            { text = "(" },
            { text = "1 in 3"},
            { text = ")" },
        }
},
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
}
c_def["j_crv_chainsawm"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp" }
            }
        }
    },
}
c_def["j_crv_snayn3"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { ref_table = "card.ability.extra", ref_value = "timer", },
    },
}
c_def["j_crv_snayn32"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp" }
            }
        }
    },
}
c_def["j_crv__pease"] = { 
    text = {
        {
        border_nodes = {
        { text = "X"},
        { ref_table = "card.joker_display_values", ref_value = "xmult",retrigger_type = "mult" }
        }
    }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "localized_text" }
    },
    calc_function = function(card)
        local xmult = 1
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() == 13 then
                    local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    xmult = xmult * card.ability.extra.xmult * retriggers
                end
            end
        end
        card.joker_display_values.xmult = xmult
        card.joker_display_values.localized_text = "[" .. localize("k_crv_king") .. "]"
    end
}
c_def["j_crv_holybanana"] = {
text = {
    { text = "+",colour = G.C.CHIPS },
    { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS},
    { text= " " },
    {
        border_nodes = {
            { text = "X" },
            { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp" }
        },
        
    }
},
extra = {
    {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "odds" },
        { text = ")" },
    },
    
},
extra_config = { colour = G.C.GREEN, scale = 0.3 },
calc_function = function(card)
    card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
end

}
c_def["j_crv_pprwork"] = { 
        text = {
            { text = "+",                              colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS, retrigger_type = "mult" },
            { text = " +",                             colour = G.C.MULT },
            { ref_table = "card.joker_display_values", ref_value = "mult",  colour = G.C.MULT,  retrigger_type = "mult" }
        },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "localized_text" }
        },
        calc_function = function(card)
            local chips, mult = 0, 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    if scoring_card:get_id() >= 2 and scoring_card:get_id() <= 9 then
                        local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        chips = chips + card.ability.extra.chips * retriggers
                        mult = mult + card.ability.extra.mult * retriggers
                    end
                end
            end
            card.joker_display_values.mult = mult
            card.joker_display_values.chips = chips
            card.joker_display_values.localized_text = "[" .. localize("k_crv_92") .. "]"
        end
    }
    c_def["j_crv_lpm"] = {
        text = {
            
                    { text = "+" ,colour = G.C.MULT},
                    { ref_table = "card.ability.extra", ref_value = "mult",colour = G.C.MULT,retrigger_type = "mult" }
            
        },
        extra = {
            {
                { text = "(" },
                { text = "1 in 4"},
                { text = ")" },
            }
    },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
    }
    c_def["j_crv_head"] = {
        text = {
             
                    { text = "+",colour = G.C.MULT },
                    { ref_table = "card.ability.extra", ref_value = "mult",colour = G.C.MULT,retrigger_type = "mult" }
            
        },
    }
    c_def["j_crv_body"] = {
        text = {
    
                    { text = "+",colour = G.C.MULT },
                    { ref_table = "card.ability.extra", ref_value = "mult",colour = G.C.MULT,retrigger_type = "mult" }
            
        },
    }
    c_def["j_crv_back"] = {
        text = {
      
                    { text = "+",colour = G.C.MULT },
                    { ref_table = "card.ability.extra", ref_value = "mult",colour = G.C.MULT,retrigger_type = "mult" }
            
        },
    }
    c_def["j_crv_pcp"] = {
        text = {
        {
            border_nodes = {
            
                    { text = "X",},
                    { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp" }
            
            }
        }
        },
    }
    c_def["j_crv_fcp"] = {
        text = {
      
                    { text = "+",colour = G.C.CHIPS },
                    { ref_table = "card.ability.extra", ref_value = "chips",colour = G.C.CHIPS,retrigger_type = "mult" }
            
        },
    }
    c_def["j_crv_hcp"] = {
        text = {
      
                    { text = "+",colour = G.C.MULT },
                    { ref_table = "card.ability.extra", ref_value = "mult",colour = G.C.MULT},retrigger_type = "mult" 
            
        },
    }
    c_def["j_crv_ghostbanana"] = {
        text = {
      
                    { text = "+",colour = G.C.CHIPS },
                    { ref_table = "card.ability.extra", ref_value = "chips",colour = G.C.CHIPS,retrigger_type = "mult" }
            
        },
    }
    c_def["j_crv_ghostslices"] = {
        text = {
      
                    { text = "+",colour = G.C.CHIPS },
                    { ref_table = "card.ability.extra", ref_value = "chips",colour = G.C.CHIPS,retrigger_type = "mult" }
            
        },
    }
    c_def["j_crv_plantain"] = {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp"  }
                    }
                }
            },
            reminder_text = {
                { ref_table = "card.ability.extra", ref_value = "timer", },
                {text = "/3"}
            },
            extra = {
                {
                    { text = "(" },
                    { ref_table = "card.joker_display_values", ref_value = "odds" },
                    { text = ")" },
                },
                
            },
            extra_config = { colour = G.C.GREEN, scale = 0.3 },
            calc_function = function(card)
                card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
            end
    }
    c_def["j_crv_reban"] = {
        text = {
            
                    { text = "+",colour = G.C.MULT },
                    { ref_table = "card.ability.extra", ref_value = "mult",colour = G.C.MULT,retrigger_type = "mult"  }
            
            
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            },
            
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
        end
}
c_def["j_crv_tundan"] = {
    text = {
        
                { text = "+",colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "chips",colour = G.C.CHIPS,retrigger_type = "mult"   }
        
        
    },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        },
        
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end
}
c_def["j_crv_bluj"] = {
    text = {
        
                { text = "+",colour = G.C.MULT },
                { ref_table = "card.ability.extra", ref_value = "mult",colour = G.C.MULT,retrigger_type = "mult"  }
        
        
    },
}
c_def["j_crv_plainb"] = {
    reminder_text = {
        { text = "(" },
        { text = "$",         colour = G.C.GOLD },
        { ref_table = "card", ref_value = "sell_cost", colour = G.C.GOLD },
        { text = ")" },
    },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        },
        
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    reminder_text_config = { scale = 0.35 },
    calc_function = function(card)
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end
}
c_def["j_crv_tickingb"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp"  }
            }
        }
    },
    reminder_text = {
        { ref_table = "card.ability.extra", ref_value = "timer", },
        {text = "/3"}
    },
}
c_def["j_crv_uneasyb"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp"  }
            }
        }
    },
    extra = {
        {
            { text = "(" },
            { text = "1 in 10"},
            { text = ")" },
        },
        
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
}
c_def["j_crv_bpj"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_gain", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
       card.joker_display_values.x_gain = card.ability.extra.x_gain * bfps() + 1
    end
}
c_def["j_crv_dcj"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_gain", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
       card.joker_display_values.x_gain = card.ability.extra.x_gain * dcs() + 1
    end
}
c_def["j_crv_mgj"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_gain", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
       card.joker_display_values.x_gain = card.ability.extra.x_gain * mgc() + 1
    end
}
c_def["j_crv_amj"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_gain", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
       card.joker_display_values.x_gain = card.ability.extra.x_gain * flm() + 1
    end
}
c_def["j_crv_mj"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_gain", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
       card.joker_display_values.x_gain = card.ability.extra.x_gain * mg() + 1
    end
}
c_def["j_crv_bj"] = {
    text = {
        { text = "+",colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips",retrigger_type = "mult" ,colour = G.C.CHIPS  },
        { text = " " },
        { text = "+",colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "exp",colour = G.C.MULT },
        { text = " " },
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_gain", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
       card.joker_display_values.x_gain = card.ability.extra.x_gain * bls() + 1
       card.joker_display_values.chips = card.ability.extra.chips * bls() 
       card.joker_display_values.mult = card.ability.extra.mult * bls() 
    end
}
c_def["j_crv_t1j"] = {
    text = {
        
                { text = "+",colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips",retrigger_type = "mult" ,colour = G.C.CHIPS }
            
    
    },
    calc_function = function(card)
       card.joker_display_values.chips = card.ability.extra.chips * t1() 
    end
}
c_def["j_crv_t2j"] = {
    text = {
        
                { text = "+",colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips",retrigger_type = "mult" ,colour = G.C.CHIPS },
                { text = " "},
                { text = "+",colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult",retrigger_type = "mult" ,colour = G.C.MULT },
            
    
    },
    calc_function = function(card)
       card.joker_display_values.chips = card.ability.extra.chips * t2() 
       card.joker_display_values.mult = card.ability.extra.mult * t2() 
    end
}
c_def["j_crv_t3j"] = {
    text = {
        
                { text = "+",colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips",retrigger_type = "mult" ,colour = G.C.CHIPS },
                { text = " " },
            {
                border_nodes = {
                    { text = "X", },
                    { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp",},
                }
            }
    
    },
    calc_function = function(card)
       card.joker_display_values.chips = card.ability.extra.chips * t3() 
       card.joker_display_values.xmult = card.ability.extra.xmult * t3() + 1
    end
}
c_def["j_crv_flytrap"] = {
    text = {
        
                { text = "+"},
                { ref_table = "card.ability.extra", ref_value = "chip",retrigger_type = "mult" },
    
    },
    text_config = { colour = G.C.CHIPS },
}
c_def["j_crv_news"] = {
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        },
        
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end
}

c_def["j_crv_mtm"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp"  }
            }
        }
    },
}
c_def["j_crv_ut"] = { 
text = {
    {
        border_nodes = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
        }
    }
},
calc_function = function(card)
    local playing_hand = next(G.play.cards)
    local numbers, all_cards = 0, 0
    local is_two_and_six = false
    for _, playing_card in ipairs(G.hand.cards) do
        if playing_hand or not playing_card.highlighted then
            all_cards = all_cards + 1
            if playing_card.facing and not (playing_card.facing == 'back') and (playing_card:get_id() >= 2 and playing_card:get_id() <= 6) then
                numbers = numbers + 1
            end
        end
    end
    is_two_and_six = numbers == all_cards
    card.joker_display_values.xmult = is_two_and_six and card.ability.extra.xmult or 1
end
}
c_def["j_crv_mtm"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp"  }
            }
        }
    },
}
c_def["j_crv_smbj"] = { 
text = {
    {
        border_nodes = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
        }
    }
},
reminder_text = {
    { text = "(" },
    { ref_table = "card.ability.extra", ref_value = "setsuit"},
    { text = ")" }
},
calc_function = function(card)
    local playing_hand = next(G.play.cards)
    local all_cards = 0
    local cards = 0
    local multgive = false  
    for _, playing_card in ipairs(G.hand.cards) do
        if playing_hand or not playing_card.highlighted then
            all_cards = all_cards + 1
            if card.ability.extra.randomsuit == 1 and playing_card.facing and not (playing_card.facing == 'back') and (playing_card:is_suit('Clubs', nil, true)) then
                cards = cards + 1
            end
            if card.ability.extra.randomsuit == 2 and playing_card.facing and not (playing_card.facing == 'back') and (playing_card:is_suit('Spades', nil, true)) then
                cards = cards + 1
            end
            if card.ability.extra.randomsuit == 3 and playing_card.facing and not (playing_card.facing == 'back') and (playing_card:is_suit('Diamonds', nil, true)) then
                cards = cards + 1
            end
            if card.ability.extra.randomsuit == 4 and playing_card.facing and not (playing_card.facing == 'back') and (playing_card:is_suit('Hearts', nil, true)) then
                cards = cards + 1
            end
        end
    end
    multgive = cards == all_cards
    card.joker_display_values.xmult = multgive and card.ability.extra.xmult or 1
end
}
c_def["j_crv_goldenshark"] = {
    reminder_text = {
        { ref_table = "card.ability.extra", ref_value = "timer", },
        {text = "/3"}
    },
}
c_def["j_crv_sfj"] = {
    text = {
        { text = "+"},
        { ref_table = "card.ability.extra", ref_value = "one",retrigger_type = "mult"  },
    },
    text_config = { colour = G.C.CHIPS },
}
c_def["j_crv_news"] = {
    extra = {
        {
            { text = "(" },
            { text = "1 in 8" },
            { text = ")" },
        },
        
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
}
c_def["j_crv_psy"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp"  }
            }
        }
    },
}
c_def["j_crv_mj4"] = { 
        text = {
            {
            border_nodes = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "xmult",retrigger_type = "exp"  }
            }
        }
        },
        reminder_text = {
            { text = "(" },
            { text = "4 of a Kind",colour = G.C.ORANGE },
            { text = ")" },
        },
        calc_function = function(card)
            local xmult = 1
            local _, poker_hands, _ = JokerDisplay.evaluate_hand()
            if poker_hands["Four of a Kind"] and next(poker_hands["Four of a Kind"]) then
                xmult = card.ability.extra.xmult
            end
            card.joker_display_values.xmult = xmult
        end
    }
    c_def["j_crv_tp3"] = { 
        text = {
            {
            border_nodes = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "xmult",retrigger_type = "exp"  }
            }
        }
        },
        reminder_text = {
            { text = "(" },
            { text = "3 of a Kind",colour = G.C.ORANGE },
            { text = ")" },
        },
        calc_function = function(card)
            local xmult = 1
            local _, poker_hands, _ = JokerDisplay.evaluate_hand()
            if poker_hands["Three of a Kind"] and next(poker_hands["Three of a Kind"]) then
                xmult = card.ability.extra.xmult
            end
            card.joker_display_values.xmult = xmult
        end
    }
    c_def["j_crv_ml"] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp"  }
                }
            }
        },
    }
    c_def["j_crv_vji"] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp"  }
                }
            }
        },
        reminder_text = {
            {ref_table = "card.ability.extra", ref_value = "limit"},
            {text = "/10"}
        }
    }
    c_def["j_crv_tgm"] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp"  }
                }
            }
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            },
            
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
        end
    }
    c_def["j_crv_hteg"] = {
        reminder_text = {
            { ref_table = "card.ability.extra", ref_value = "stages", },
            {text = "/3"}
        },
    }
    c_def["j_crv_jhv"] = {
        text = {
            { text = "+",colour = G.C.CHIPS },
            { ref_table = "card.ability.extra", ref_value = "stg1b",retrigger_type = "mult", colour = G.C.CHIPS},
        },
        text_config = { colour = G.C.CHIPS },
        reminder_text = {
            { ref_table = "card.ability.extra", ref_value = "stages", },
            {text = "/3"}
        },
    }
    c_def["j_crv_jbe"] = {
        text = {
            { text = "+",colour = G.C.CHIPS },
            { ref_table = "card.ability.extra", ref_value = "stg2b",retrigger_type = "mult",  colour = G.C.CHIPS},
            { text = " "},
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "stg2b2",retrigger_type = "exp" },
                }
            }
        },
        reminder_text = {
            { ref_table = "card.ability.extra", ref_value = "stages", },
            {text = "/3"}
        },
    }
    c_def["j_crv_jma"] = {
        text = {
            { text = "+",colour = G.C.CHIPS },
            { ref_table = "card.ability.extra", ref_value = "stg3b",retrigger_type = "mult", colour = G.C.CHIPS},
            { text = " "},
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "stg3b2",retrigger_type = "exp" },
                }
            }
        },
        reminder_text = {
            { ref_table = "card.ability.extra", ref_value = "stages", },
            {text = "/3"}
        },
    }
    c_def["j_crv_jad"] = {
        text = {
        {
            border_nodes = {
                { text = "X"},
                { ref_table = "card.ability.extra", ref_value = "stg4b",retrigger_type = "exp" },
            },
            border_colour = G.C.CHIPS
        },

            { text = " "},
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "stg4b2",retrigger_type = "exp"},
                }
            }
        },
        reminder_text = {
            { ref_table = "card.ability.extra", ref_value = "stages", },
            {text = "/3"}
        },
    }
    c_def["j_crv_jcbt"] = {
        text = {
            {
            border_nodes = {
                { text = "X"},
                { ref_table = "card.ability.extra", ref_value = "stg5b",retrigger_type = "exp"},
            },
            border_colour = G.C.CHIPS
        },
            { text = " "},
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "stg5b2",retrigger_type = "exp"},
                }
            }
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            },
            
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
        end
    }
    c_def["j_crv_jimp"] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "xmult",retrigger_type = "exp"  }
                }
            }
        },
        calc_function = function(card)
            local xmult = 1.5
            local rr = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    rr = i;
                    break
                end
            end
            if G.jokers.cards[rr + 1] == nil or G.jokers.cards[rr - 1] == nil then
                xmult = card.ability.extra.xmult
            end
            card.joker_display_values.xmult = xmult
        end
    }
    c_def["j_crv_jarden"] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp" }
                }
            }
        },
    }
    c_def["j_crv_onj"] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp" }
                }
            }
        },
    }
    c_def["j_crv_rab"] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp" }
                }
            }
        },
    }
    c_def["j_crv_rabf"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp" }
            }
        },
        {text = " "},
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x",                              scale = 0.35 },
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmultf",retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.MONEY},
        { text = ")" }
    },
    calc_function = function(card)
        local count = 0
        if G.play then
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    if scoring_card:is_face() then
                        count = count + 
                            JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    end
                end
            end
        else
            count = 3
        end
        card.joker_display_values.count = count
        card.joker_display_values.localized_text = localize("k_crv_face")
    end
}
c_def["j_crv_rabflush"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "xmultex",retrigger_type = "exp"}
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.RED},
        { text = ")" }
    },
    calc_function = function(card)
        local xmult = 4
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()
        if poker_hands["Flush"] and next(poker_hands["Flush"]) then
            xmult = card.ability.extra.xmultex
        end
        card.joker_display_values.xmultex = xmult
        card.joker_display_values.localized_text = localize("crv_flush")
    end
}
c_def["j_crv_rabhigh"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "xmultex",retrigger_type = "exp"}
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.RED},
        { text = ")" }
    },
    calc_function = function(card)
        local xmult = 4
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()
        if poker_hands["Full House"] and next(poker_hands["Full House"]) then
            xmult = card.ability.extra.xmultex
        end
        card.joker_display_values.xmultex = xmult
        card.joker_display_values.localized_text = localize("crv_full")
    end
}

c_def["j_crv_vjim"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "exp" }
            }
        }
    },
    extra = {
        {
        { ref_table = "card.ability.extra", ref_value = "discards"},
        { text = "/"},
        { ref_table = "card.ability.extra", ref_value = "odds"},
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
}

c_def["j_crv_vsix"] = {
    extra = {
        {
        { ref_table = "card.ability.extra", ref_value = "multip2"}, 
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
}
c_def["j_crv_vface"] = { 
    text = {
        { text = "+",                              colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "pmult", colour = G.C.MULT, retrigger_type = "mult" },
        { text = " "},
        { ref_table = "card.joker_display_values", ref_value = "mmult",  colour = G.C.MULT,  retrigger_type = "mult" }
    },
    reminder_text = {
        {ref_table = "card.ability.extra", ref_value = "timer"},
        {text = "/15"}
    },
    calc_function = function(card)
        local pmult, mmult = 0, 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() >= 2 and scoring_card:get_id() <= 10 then
                    local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    mmult = mmult + card.ability.extra.mmult * retriggers
                end
            end
        end
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:is_face() then
                    local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    pmult = pmult + card.ability.extra.pmult * retriggers
                end
            end
        end
        card.joker_display_values.mmult = mmult
        card.joker_display_values.pmult = pmult
    end
}
c_def["j_crv_vmichel"]= { 
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" }
                }
            }
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
        end
    }
    c_def["j_crv_chaoticprintermachine"]= { 
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
        end
    }
    c_def["j_crv_promotion"] = { 
        text = {
            {
                border_nodes = {
                    { text = " X",},
                    { ref_table = "card.joker_display_values", ref_value = "xmult",retrigger_type = "mult" }
                }
            },
            {text = " "},
            { text = "+",                              colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS, retrigger_type = "mult" },
        },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "localized_text" }
        },
        calc_function = function(card)
            local chips, xmult = 0, 1
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    if scoring_card:is_face() or scoring_card:get_id() == 14 then
                        local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        chips = chips + card.ability.extra.chips * retriggers
                        xmult = xmult + card.ability.extra.xmult * retriggers
                    end
                end
            end
            card.joker_display_values.xmult = xmult
            card.joker_display_values.chips = chips
            card.joker_display_values.localized_text = "(" .. localize("k_crv_fa") .. ")"
        end
    }
    c_def["j_crv_hfj"] = {
        text = {
            {
                border_nodes = {
            { text = "X"},
            { ref_table = "card.ability.extra", ref_value = "one",retrigger_type = "mult"  },
                }
            }
        },
    }
    c_def["j_crv_loveletter"] = {
        text = {
            
                    { text = "+"},
                    { ref_table = "card.ability.extra", ref_value = "mult",retrigger_type = "mult" },
        
        },
        text_config = { colour = G.C.MULT },
    }
    c_def["j_crv_clicker"] = {
        text = {
            
                    { text = "+"},
                    { ref_table = "card.ability.extra", ref_value = "chips",retrigger_type = "mult" },
        
        },
        text_config = { colour = G.C.CHIPS },
    }
    c_def["j_crv_jjoker"] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "mult",retrigger_type = "mult" }
                }
            }
        },
        calc_function = function(card)
            if card.ability.extra.mult * G.GAME.henchmans == 0 then
            card.joker_display_values.mult = 1
            else 
            card.joker_display_values.mult = card.ability.extra.mult * G.GAME.henchmans
            end
        end
    }
    c_def["j_crv_henchman"] = {
        text = {
            
                    { text = "+" },
                    { ref_table = "card.ability.extra", ref_value = "mult",retrigger_type = "mult" }
                
            
        },
        text_config = { colour = G.C.MULT },
    }
    c_def["j_crv_jnx"] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "xchips",retrigger_type = "mult" }
                },
                border_colour = G.C.CHIPS
            }
        },
    }
    c_def["j_crv_jimshow"] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "xmult",retrigger_type = "mult" }
                },
            }
        },
    }
    c_def["j_crv_jimbojam"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "chips",retrigger_type = "mult" }
            },
        }
    },
}
    c_def["j_crv_rekoj"] = {
        text = {
            
                    { text = "+" },
                    { ref_table = "card.ability.extra", ref_value = "chips",retrigger_type = "mult" }
                
            
        },
        text_config = { colour = G.C.CHIPS },
    }
    c_def["j_crv_collector"] = {
        text = {
            
                    { text = "+" },
                    { ref_table = "card.ability.extra", ref_value = "mult",retrigger_type = "mult" }
                
            
        },
        text_config = { colour = G.C.MULT },
    }
    c_def["j_crv_kq"] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
                }
            }
        },
        calc_function = function(card)
           card.joker_display_values.xmult = card.ability.extra.xmult * stickercheck() + 1
        end
    }
    c_def["j_crv_giftbox"] = {
        reminder_text = {
            { ref_table = "card.ability.extra", ref_value = "timer", },
            {text = "/3"}
        },
    }




