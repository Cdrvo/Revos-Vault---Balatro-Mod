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
