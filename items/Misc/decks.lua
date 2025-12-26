SMODS.Back {
    key = 'pdeck',
    atlas = 'Decks',
    pos = {
        x = 0,
        y = 0
    },

    apply = function()
        if next(SMODS.find_mod("partner")) and Partner_API.config and Partner_API.config.enable_partner then
            RevosVault.partner_fix = true
        else
            G.FUNCS.get_printer_box()
        end
    end
}

SMODS.Back {
    key = 'thedeal',
    atlas = 'Decks',
    pos = {
        x = 1,
        y = 0
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_brj')

                return true
            end
        }))
    end
}

--[[SMODS.Back {
    name = 'Machinery',
    key = 'mach',
    atlas = 'Decks',
    pos = {
        x = 0,
        y = 0
    },

    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_printer')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = 'Old Scroll',
    key = 'os',
    atlas = 'Decks',
    pos = {
        x = 1,
        y = 0
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_rustyprinter')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = 'Gold Mayhem',
    key = 'gm',
    atlas = 'Decks',
    pos = {
        x = 2,
        y = 1
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_moneyprinter')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = 'Ripped Deck',
    key = 'rpd',
    atlas = 'Decks',
    pos = {
        x = 0,
        y = 2
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_brokenprinter')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = "Jimbo's World",
    key = 'jw',
    atlas = 'Decks',
    pos = {
        x = 2,
        y = 0
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_jimboprinter')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = 'Gross Deck',
    key = 'gd',
    atlas = 'Decks',
    pos = {
        x = 0,
        y = 1
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_grossprinter')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = 'The Suspicious Desert',
    key = 'tsd',
    atlas = 'Decks',
    pos = {
        x = 1,
        y = 1
    },
    apply = function()

        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_obeliskprinter')
                return true
            end
        }))
    end
}

SMODS.Back {
    name = 'Speaking Fax',
    key = 'spx',
    atlas = 'Decks',
    pos = {
        x = 1,
        y = 2
    },
    apply = function()

        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_faxprinter')
                return true
            end
        }))
    end
}

SMODS.Back {
    name = 'Phantom Forge',
    key = 'phf',
    atlas = 'Decks',
    pos = {
        x = 2,
        y = 2
    },
    apply = function()

        G.E_MANAGER:add_event(Event({
            func = function()
                joker_add('j_crv_spectralprinter')
                return true
            end
        }))
    end
}

SMODS.Back {
    name = 'Hollow Gems',
    key = 'hg',
    atlas = 'Decks',
    pos = {
        x = 0,
        y = 3
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_legendaryprinter')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = 'Glassbound',
    key = 'gb',
    atlas = 'Decks',
    pos = {
        x = 1,
        y = 3
    },

    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_glassprinter')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = 'Art Gallery',
    key = 'atg',
    atlas = 'Decks',
    pos = {
        x = 2,
        y = 3
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_smile')
                joker_add('j_joker')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = 'The Company Is Hiring!',
    key = 'tcih',
    atlas = 'Decks',
    pos = {
        x = 0,
        y = 4
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_lpm')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = "Devil's Casino",
    key = 'dc',
    atlas = 'Decks2',
    pos = {
        x = 0,
        y = 0
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_devilishprinter')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = "MDeck HQ",
    key = 'rf',
    atlas = 'Decks2',
    pos = {
        x = 1,
        y = 0
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_full')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = "Steelbound",
    key = 'sb',
    atlas = 'Decks2',
    pos = {
        x = 2,
        y = 0
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_steelprinter')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = "Upgrade!",
    key = 'up',
    atlas = 'Decks2',
    pos = {
        x = 3,
        y = 0
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_tierp')

                return true
            end
        }))
    end
}
SMODS.Back {
    name = "Lucky Pot",
    key = 'lp',
    atlas = 'Decks2',
    pos = {
        x = 0,
        y = 1
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_luckyprinter')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = "Celestial Forge",
    key = 'cf',
    atlas = 'Decks2',
    pos = {
        x = 1,
        y = 1
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_celestialprinter')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = "Polychrome Deck",
    key = 'pd',
    atlas = 'Decks2',
    pos = {
        x = 2,
        y = 2
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_pcp')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = "Foil Deck",
    key = 'fd',
    atlas = 'Decks2',
    pos = {
        x = 0,
        y = 2
    },

    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_fcp')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = "Holographic Deck",
    key = 'hd',
    atlas = 'Decks2',
    pos = {
        x = 1,
        y = 2
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_hcp')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = "Negative Deck",
    key = 'nd',
    atlas = 'Decks2',
    pos = {
        x = 3,
        y = 2
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_ncp')

                return true
            end
        }))
    end
}

SMODS.Back {
    name = "Ultimate Deck",
    key = 'ued',
    atlas = 'Decks2',
    pos = {
        x = 2,
        y = 1
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_ucp')

                return true
            end
        }))
    end
}

SMODS.Back {
    key = 'und',
    atlas = 'Decks2',
    pos = {
        x = 3,
        y = 1
    },
    apply = function()

        G.E_MANAGER:add_event(Event({

            func = function()

                joker_add('j_crv_urp')

                return true
            end
        }))
    end
}
]]