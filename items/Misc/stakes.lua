SMODS.Stake{
    key = "blood",
    atlas = "stakes",
    colour = HEX("830000"),
    pos = {x=0,y=0},
    sticker_atlas = "enh",
    sticker_pos = {x=3,y=0},
    applied_stakes = { "gold" },
    shiny = true,
    unlocked = false,
    prefix_config = { applied_stakes = { mod = false } },
    loc_txt = {
        name = "Bloody Stake",
        text = {"{C:attentionAll{} Jokers can become {C:red}Vampiric",
                "{C:inactive,s:0.8}(Card is destroyed if neither sides are empty)"},
                sticker = {
                    name = "Bloody Sticker",
                    text = {"Used this Joker",
                            "to win on {C:attention}Bloody",
                            "{C:attention}Stake{} difficulty"}

                }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_vamp = true
    end
}

SMODS.Stake{
    key = "haunt",
    atlas = "stakes",
    colour = SMODS.Gradients["crv_temp"],
    pos = {x=1,y=0},
    sticker_atlas = "enh",
    sticker_pos = {x=3,y=1},
    applied_stakes = { "crv_blood" },
    shiny = true,
    unlocked = false,
    prefix_config = { applied_stakes = { mod = false} },
    loc_txt = {
        name = "Limited Stake",
        text = {"{C:attentionAll{} Jokers can become {C:crv_temp}Temporary",
                "{C:inactive,s:0.8}(Card is destroyed at the end of the round)"},
                sticker = {
                    name = "Limited Sticker",
                    text = {"Used this Joker",
                            "to win on {C:attention}Limited",
                            "{C:attention}Stake{} difficulty"}

                }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_temp = true
    end
}


SMODS.Stake{
    key = "raido",
    atlas = "stakes",
    colour = HEX("bd9400"),
    pos = {x=2,y=0},
    sticker_atlas = "enh",
    sticker_pos = {x=3,y=1},
    applied_stakes = { "crv_haunt" },
    shiny = true,
    unlocked = false,
    prefix_config = { applied_stakes = { mod = false} },
    loc_txt = {
        name = "Radioactive Stake",
        text = {"{C:attentionAll{} Jokers can become {C:money}Radioactive",
                "{C:inactive,s:0.8}(At the end of a round, randomly destroy the card on the left or right)"},
                sticker = {
                    name = "Radioactive Sticker",
                    text = {"Used this Joker",
                            "to win on {C:attention}Radioactive",
                            "{C:attention}Stake{} difficulty"}

                }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_radioactive = true
    end
}

SMODS.Stake{
    key = "absol",
    atlas = "stakes",
    pos = {x=3,y=0},
    colour = HEX("ffe9b5"),
    sticker_atlas = "enh",
    sticker_pos = {x=4,y=1},
    applied_stakes = { "crv_raido" },
    shiny = true,
    unlocked = false,
    prefix_config = { applied_stakes = { mod = false} },
    loc_txt = {
        name = "Absolute Stake",
        text = {"{C:attentionAll{} Jokers can become {C:attention}Absolute",
                "{C:inactive,s:0.8}(1/4 to create another of self)"},
                sticker = {
                    name = "Absolute Sticker",
                    text = {"Used this Joker",
                            "to win on {C:attention}Absolute",
                            "{C:attention}Stake{} difficulty"}

                }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_absolute = true
    end
}

SMODS.Stake{
    key = "contin",
    atlas = "stakes",
    pos = {x=4,y=0},
    colour = HEX("ffe9b5"),
    sticker_atlas = "enh",
    sticker_pos = {x=5,y=0},
    applied_stakes = { "crv_absol" },
    shiny = true,
    unlocked = false,
    prefix_config = { applied_stakes = { mod = false} },
    loc_txt = {
        name = "Continuity Stake",
        text = {"{C:attentionAll{} Jokers can have {C:crv_continuity}Continuity",
                "{C:inactive,s:0.6}(The card is replaced by another with the same rarity/set)"},
                sticker = {
                    name = "Continuity Sticker",
                    text = {"Used this Joker",
                            "to win on {C:attention}Continuity",
                            "{C:attention}Stake{} difficulty"}

                }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_continuity = true
    end
}

SMODS.Stake{
    key = "overt",
    atlas = "stakes",
    pos = {x=1,y=1},
    colour = HEX("fdffa8"),
    sticker_atlas = "enh",
    sticker_pos = {x=6,y=2},
    applied_stakes = { "crv_contin" },
    shiny = true,
    unlocked = false,
    prefix_config = { applied_stakes = { mod = false} },
    loc_txt = {
        name = "Overtime Stake",
        text = {"{C:attentionAll{} Jokers can have {C:money}Overtime"},
                sticker = {
                    name = "Overtime Sticker",
                    text = {"Used this Joker",
                            "to win on {C:attention}Overtime",
                            "{C:attention}Stake{} difficulty"}

                }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_overtime = true
    end
}

SMODS.Stake{
    key = "myster",
    atlas = "stakes",
    pos = {x=0,y=1},
    colour = HEX("ffe9b5"),
    sticker_atlas = "enh",
    sticker_pos = {x=6,y=0},
    applied_stakes = { "crv_overt" },
    shiny = true,
    unlocked = false,
    prefix_config = { applied_stakes = { mod = false} },
    loc_txt = {
        name = "Mysterious Stake",
        text = {"{C:attentionAll{} Jokers can have {C:crv_mystery}Mystery{} Sticker",
                "{C:inactive,s:0.6}(after 3 rounds gain a turn into a different sticker )"},
                sticker = {
                    name = "Mysterious Sticker",
                    text = {"Used this Joker",
                            "to win on {C:attention}Mysterious",
                            "{C:attention}Stake{} difficulty"}

                }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_mystery = true
    end
}

SMODS.Stake{
    key = "curse",
    atlas = "stakes",
    pos = {x=2,y=1},
    colour = HEX("ffe9b5"),
    sticker_atlas = "enh",
    sticker_pos = {x=6,y=3},
    applied_stakes = { "crv_myster" },
    shiny = true,
    unlocked = false,
    prefix_config = { applied_stakes = { mod = false} },
    loc_txt = {
        name = "Pitch Black Stake",
        text = {"{C:attentionAll{} Jokers can have {C:black}Cursed{} Sticker",
                "{C:inactive,s:0.6}(gain a sticker after each round)"},
                sticker = {
                    name = "Pitch Black Sticker",
                    text = {
                            "Used this Joker",
                            "to win on {C:attention}Mysterious",
                            "{C:attention}Stake{} difficulty"}

                }
    },
    modifiers = function()
        G.GAME.modifiers.enable_crv_mystery = true
    end
}