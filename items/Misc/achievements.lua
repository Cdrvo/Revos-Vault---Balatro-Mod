SMODS.Achievement({
    key = "get_all_stickers",
    unlock_condition = function(self, args)
        if args.type == "howdidwegethere" then
            return true
        end
    end
})