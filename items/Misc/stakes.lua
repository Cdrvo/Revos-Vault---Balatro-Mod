-- will turn these into one stake if i decide to add more stickers

SMODS.Stake {
    key = "water",
    atlas = "stakes",
    pos = {
        x = 0,
        y = 2
    },
    colour = HEX("55c6d9"),
    sticker_atlas = "enh",
    sticker_pos = {
        x = 7,
        y = 1
    },
    applied_stakes = {"gold"},
    shiny = true,
    unlocked = false,
    prefix_config = {
        applied_stakes = {
            mod = false
        }
    },
    loc_txt = {
        name = "Wet Stake",
        text = {"{C:attentionAll{} Jokers can have {C:blue}Wet{} Sticker",
                "{C:inactive,s:0.6}(card cannot be debuffed, 1/4 to remove self)"},
        sticker = {
            name = "Wet Sticker",
            text = {"Used this Joker", "to win on {C:attention}Wet", "{C:attention}Stake{} difficulty"}

        }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_wet = true
    end,
        inject = function(self)
        if not self.injected then
            -- Inject stake in the correct spot
            self.count = #G.P_CENTER_POOLS[self.set] + 1
            self.order = self.count
            if self.above_stake and G.P_STAKES[self.above_stake] then
                self.order = G.P_STAKES[self.above_stake].order + 1
            end
            for _, v in pairs(G.P_STAKES) do
                if v.order >= self.order then
                    v.order = v.order + 1
                end
            end
            G.P_STAKES[self.key] = self
            table.insert(G.P_CENTER_POOLS.Stake, self)
            -- Sticker sprites (stake_ prefix is removed for vanilla compatiblity)
            if self.sticker_pos ~= nil then
                G.shared_stickers[self.key:sub(7)] = Sprite(0, 0, G.CARD_W, G.CARD_H,
                    G.ASSET_ATLAS[self.sticker_atlas] or G.ASSET_ATLAS["stickers"], self.sticker_pos)
                G.sticker_map[self.key] = self.key:sub(7)
            else
                G.sticker_map[self.key] = nil
            end
        else
            G.P_STAKES[self.key] = self
            SMODS.insert_pool(G.P_CENTER_POOLS.Stake, self)
        end
        self.injected = true
        -- should only need to do this once per injection routine

        if next(SMODS.find_mod("HotPotato")) then
            table.remove(self.applied_stakes, 1)
            table.insert(self.applied_stakes, "stake_hpot_missingtext")
        end
    end
}

SMODS.Stake {
    key = "weighted",
    atlas = "stakes",
    pos = {
        x = 4,
        y = 1
    },
    colour = HEX("55c6d9"),
    sticker_atlas = "enh",
    sticker_pos = {
        x = 7,
        y = 1
    },
    applied_stakes = {"crv_water"},
    shiny = true,
    unlocked = false,
    prefix_config = {
        applied_stakes = {
            mod = false
        }
    },
    loc_txt = {
        name = "Weighted Stake",
        text = {"{C:attentionAll{} Jokers can have {C:blue}Heavy{} Sticker",
                "{C:inactive,s:0.6}(-1 Joker Slot)"},
        sticker = {
            name = "Weighted Sticker",
            text = {"Used this Joker", "to win on {C:attention}Weighted", "{C:attention}Stake{} difficulty"}

        }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_heavy = true
    end
}

SMODS.Stake {
    key = "cloudy",
    atlas = "stakes",
    pos = {
        x = 3,
        y = 1
    },
    colour = HEX("55c6d9"),
    sticker_atlas = "enh",
    sticker_pos = {
        x = 7,
        y = 1
    },
    applied_stakes = {"crv_weighted"},
    shiny = true,
    unlocked = false,
    prefix_config = {
        applied_stakes = {
            mod = false
        }
    },
    loc_txt = {
        name = "Cloudy Stake",
        text = {"{C:attentionAll{} Jokers can have {C:blue}Fan{} Sticker",
                "{C:inactive,s:0.6}(slide the joker on the right to right)"},
        sticker = {
            name = "Cloudy Sticker",
            text = {"Used this Joker", "to win on {C:attention}Cloudy", "{C:attention}Stake{} difficulty"}

        }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_fan = true
    end
}

SMODS.Stake {
    key = "absol",
    atlas = "stakes",
    pos = {
        x = 3,
        y = 0
    },
    colour = HEX("ffe9b5"),
    sticker_atlas = "enh",
    sticker_pos = {
        x = 4,
        y = 1
    },
    applied_stakes = {"crv_cloudy"},
    shiny = true,
    unlocked = false,
    prefix_config = {
        applied_stakes = {
            mod = false
        }
    },
    loc_txt = {
        name = "Absolute Stake",
        text = {"{C:attentionAll{} Jokers can become {C:attention}Absolute",
                "{C:inactive,s:0.8}(1/4 to create another of self)"},
        sticker = {
            name = "Absolute Sticker",
            text = {"Used this Joker", "to win on {C:attention}Absolute", "{C:attention}Stake{} difficulty"}

        }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_absolute = true
    end
}

SMODS.Stake {
    key = "haunt",
    atlas = "stakes",
    colour = SMODS.Gradients["crv_temp"],
    pos = {
        x = 1,
        y = 0
    },
    sticker_atlas = "enh",
    sticker_pos = {
        x = 5,
        y = 4
    },
    applied_stakes = {"crv_absol"},
    shiny = true,
    unlocked = false,
    prefix_config = {
        applied_stakes = {
            mod = false
        }
    },
    loc_txt = {
        name = "Limited Stake",
        text = {"{C:attentionAll{} Jokers can become {C:crv_temp}Temporary",
                "{C:inactive,s:0.8}(Card is destroyed at the end of the round)"},
        sticker = {
            name = "Limited Sticker",
            text = {"Used this Joker", "to win on {C:attention}Limited", "{C:attention}Stake{} difficulty"}

        }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_temp = true
    end
}

SMODS.Stake {
    key = "blood",
    atlas = "stakes",
    colour = HEX("830000"),
    pos = {
        x = 0,
        y = 0
    },
    sticker_atlas = "enh",
    sticker_pos = {
        x = 3,
        y = 0
    },
    applied_stakes = {"crv_haunt"},
    shiny = true,
    unlocked = false,
    prefix_config = {
        applied_stakes = {
            mod = false
        }
    },
    loc_txt = {
        name = "Bloody Stake",
        text = {"{C:attentionAll{} Jokers can become {C:red}Vampiric",
                "{C:inactive,s:0.8}(Card is destroyed if neither sides are empty)"},
        sticker = {
            name = "Bloody Sticker",
            text = {"Used this Joker", "to win on {C:attention}Bloody", "{C:attention}Stake{} difficulty"}

        }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_vamp = true
    end,
}

SMODS.Stake {
    key = "raido",
    atlas = "stakes",
    colour = HEX("bd9400"),
    pos = {
        x = 2,
        y = 0
    },
    sticker_atlas = "enh",
    sticker_pos = {
        x = 3,
        y = 1
    },
    applied_stakes = {"crv_blood"},
    shiny = true,
    unlocked = false,
    prefix_config = {
        applied_stakes = {
            mod = false
        }
    },
    loc_txt = {
        name = "Radioactive Stake",
        text = {"{C:attentionAll{} Jokers can become {C:money}Radioactive",
                "{C:inactive,s:0.8}(At the end of a round, randomly destroy the card on the left or right)"},
        sticker = {
            name = "Radioactive Sticker",
            text = {"Used this Joker", "to win on {C:attention}Radioactive", "{C:attention}Stake{} difficulty"}

        }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_radioactive = true
    end
}

SMODS.Stake {
    key = "overt",
    atlas = "stakes",
    pos = {
        x = 1,
        y = 1
    },
    colour = HEX("fdffa8"),
    sticker_atlas = "enh",
    sticker_pos = {
        x = 6,
        y = 2
    },
    applied_stakes = {"crv_raido"},
    shiny = true,
    unlocked = false,
    prefix_config = {
        applied_stakes = {
            mod = false
        }
    },
    loc_txt = {
        name = "Overtime Stake",
        text = {"{C:attentionAll{} Jokers can have {C:money}Overtime"},
        sticker = {
            name = "Overtime Sticker",
            text = {"Used this Joker", "to win on {C:attention}Overtime", "{C:attention}Stake{} difficulty"}

        }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_overtime = true
    end
}

SMODS.Stake {
    key = "contin",
    atlas = "stakes",
    pos = {
        x = 4,
        y = 0
    },
    colour = HEX("ffe9b5"),
    sticker_atlas = "enh",
    sticker_pos = {
        x = 5,
        y = 0
    },
    applied_stakes = {"crv_overt"},
    shiny = true,
    unlocked = false,
    prefix_config = {
        applied_stakes = {
            mod = false
        }
    },
    loc_txt = {
        name = "Continuity Stake",
        text = {"{C:attentionAll{} Jokers can have {C:crv_continuity}Continuity",
                "{C:inactive,s:0.6}(The card is replaced by another with the same rarity/set)"},
        sticker = {
            name = "Continuity Sticker",
            text = {"Used this Joker", "to win on {C:attention}Continuity", "{C:attention}Stake{} difficulty"}

        }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_continuity = true
    end
}

SMODS.Stake {
    key = "myster",
    atlas = "stakes",
    pos = {
        x = 0,
        y = 1
    },
    colour = HEX("ffe9b5"),
    sticker_atlas = "enh",
    sticker_pos = {
        x = 6,
        y = 0
    },
    applied_stakes = {"crv_contin"},
    shiny = true,
    unlocked = false,
    prefix_config = {
        applied_stakes = {
            mod = false
        }
    },
    loc_txt = {
        name = "Mysterious Stake",
        text = {"{C:attentionAll{} Jokers can have {C:crv_mystery}Mystery{} Sticker",
                "{C:inactive,s:0.6}(after 3 rounds gain a turn into a different sticker )"},
        sticker = {
            name = "Mysterious Sticker",
            text = {"Used this Joker", "to win on {C:attention}Mysterious", "{C:attention}Stake{} difficulty"}

        }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_mystery = true
    end
}

SMODS.Stake {
    key = "curse",
    atlas = "stakes",
    pos = {
        x = 2,
        y = 1
    },
    colour = HEX("ffe9b5"),
    sticker_atlas = "enh",
    sticker_pos = {
        x = 6,
        y = 3
    },
    applied_stakes = {"crv_myster"},
    shiny = true,
    unlocked = false,
    prefix_config = {
        applied_stakes = {
            mod = false
        }
    },
    loc_txt = {
        name = "Pitch Black Stake",
        text = {"{C:attentionAll{} Jokers can have {C:black}Cursed{} Sticker",
                "{C:inactive,s:0.6}(gain a sticker after each round)"},
        sticker = {
            name = "Pitch Black Sticker",
            text = {"Used this Joker", "to win on {C:attention}Pitch Black", "{C:attention}Stake{} difficulty"}

        }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_mystery = true
    end
}


