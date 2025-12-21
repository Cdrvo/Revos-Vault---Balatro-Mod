--[[SMODS.Joker({
	key = "rr_joker",
	atlas = "finity_atlas",
    rarity = "finity_showdown",
	pos = { x = 1, y = 0 },
	soul_pos = { x = 0, y = 0 },
	config = { extra = { retrigger_joker = nil } },
	dependencies = "finity",
	calculate = function(self, card, context)
		local crv = card.ability.extra

		if context.setting_blind and not crv.retrigger_joker and not context.blueprint then
            print("set joker")
            local tab = {}
            for k, v in pairs(G.jokers.cards) do
                if v.config.center.blueprint_compat then
                    tab[#tab+1] = v
                end
            end
			crv.retrigger_joker = RevosVault.random_joker(tab, card)
		end

		if not G.jokers then
			return nil
		end

		local copy = nil
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] == card then
				if crv.retrigger_joker and crv.retrigger_joker ~= card and crv.retrigger_joker.config.center.blueprint_compat then
					copy = SMODS.blueprint_effect(card, crv.retrigger_joker, context)
				end
				break
			end
		end
		if copy then
			return copy
		else
			return nil
		end

		if context.end_of_round and not context.blueprint then
			crv.retrigger_joker = nil
		end
	end,
})

SMODS.Joker({
	key = "swarm_joker",
	atlas = "finity_atlas",
	pos = { x = 1, y = 1 },
	soul_pos = { x = 0, y = 1 },
	dependencies = "finity",
})
]]



--This is a patch and is on hold


--[[patches]]
--[patches.pattern]
--target = '=[SMODS finity "Finity.lua"]'
--pattern = 'FinisherBossBlindStringMap = {'
--position = "after"
--payload ='''
--["bl_crv_rrp"] = {"j_crv_rr_joker","Russian Roulette+"},
--["bl_crv_no"] = {"j_crv_swarm_joker","The Swarm"},
--'''
--match_indent = true
