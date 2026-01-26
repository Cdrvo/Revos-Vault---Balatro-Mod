SMODS.Voucher({
	key = "printerup",
	atlas = "vouch",
	pos = {
		x = 0,
		y = 0,
	},
	cost = 10,
})

SMODS.Voucher({
	key = "printeruptier",
	atlas = "vouch",
	pos = {
		x = 1,
		y = 0,
	},
	cost = 10,
	requires = { "v_crv_printerup" },
})

SMODS.Voucher({
	key = "freedom",
	atlas = "vouch",
	pos = {
		x = 0,
		y = 1,
	},
	config = {
		extra = {
			perc = 10
		}
	},
	cost = 10,
	loc_vars = function(self, info_queue, card)
		local cae = card.ability.extra
		return{vars={cae.perc}}
	end,
	redeem = function(self,card)
		local cae = card.ability.extra
		if TheVault then
			local tv = TheVault
			tv.vault_cost = tv.vault_cost - RevosVault.perc(tv.vault_cost, cae.perc)
			tv.enhance_cost = tv.enhance_cost - RevosVault.perc(tv.enhance_cost, cae.perc)
			tv.upgrade_cost = tv.upgrade_cost - RevosVault.perc(tv.upgrade_cost, cae.perc)
		end
	end
})

SMODS.Voucher({
	key = "vision",
	atlas = "vouch",
	pos = {
		x = 1,
		y = 1,
	},
	cost = 10,
	requires = { "v_crv_freedom" },
	redeem = function(self,card)
		local cae = card.ability.extra
		G.GAME.modifiers.fifty_soul_increase = true
	end
	
})

SMODS.Voucher({
	key = "pink",
	atlas = "vouch",
	pos = {
		x = 2,
		y = 0,
	},
	cost = 10,
})

SMODS.Voucher({
	key = "superior",
	atlas = "vouch",
	pos = {
		x = 3,
		y = 0,
	},
	cost = 10,
	requires = { "v_crv_pink" },
	redeem = function(self,card)
		local cae = card.ability.extra
		G.GAME.superior_mod = G.GAME.superior_mod + 0.5 -- buff?
	end
	
})
