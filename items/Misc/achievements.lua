SMODS.Achievement({
    key = "get_all_stickers",
    unlock_condition = function(self, args)
        if args.type == "howdidwegethere" then
            return true
        end
    end
})

SMODS.Achievement({
    key = "printing_away",
    unlock_condition = function(self, args)
        if args.type == "obtain_printer" then
            return true
        end
    end
})

SMODS.Achievement({
    key = "mega_printer",
    unlock_condition = function(self, args)
        if args.type == "megaify" then
            return true
        end
    end
})

SMODS.Achievement({
    key = "buckshotifying",
    unlock_condition = function(self, args)
        if args.type == "buckshotify" then
            return true
        end
    end
})

SMODS.Achievement({
    key = "vaultingify",
    unlock_condition = function(self, args)
        if args.type == "vaulting_it" then
            return true
        end
    end
})

SMODS.Achievement({
    key = "lame_card",
    unlock_condition = function(self, args)
        if args.type == "revoing_it" then
            return true
        end
    end
})

SMODS.Achievement({
    key = "welcome_mine",
    unlock_condition = function(self, args)
        if args.type == "gemming_it" then
            return true
        end
    end
})


-- last
SMODS.Achievement({
    key = "secret_joker",
    hidden_text = true,
    unlock_condition = function(self, args)
        if args.type == "secretify" then
            return true
        end
    end
})