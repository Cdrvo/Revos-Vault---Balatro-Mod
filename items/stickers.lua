SMODS.Sticker{
    key = "vamp",
    badge_colour = HEX('830000'),
    atlas = "enh",
    pos = {
        x = 2,
        y = 2   
    },
    sets = {
        Joker = true
    },
    rate = 0.3,
    needs_enable_flag = true,
    calculate = function(self,card,context)
        if context.setting_blind then
			local rr = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					rr = i
					break
				end
			end
			if G.jokers.cards[rr + 1] == nil or G.jokers.cards[rr - 1] == nil then
                card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
            end
        end
    end
}
