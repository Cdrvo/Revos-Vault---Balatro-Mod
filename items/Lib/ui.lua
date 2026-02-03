-- Thank you JoyousSpring
SMODS.current_mod.custom_ui = function(modNodes)
	modNodes[1].nodes[1].config.colour = G.C.PURPLE
	G.printer_info = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
		G.ROOM.T.h,
		4.25 * G.CARD_W,
		0.95 * G.CARD_H,
		{ card_limit = 5, type = "title", highlight_limit = 0, collection = true }
	)
	local random_random = { "crv_p", "BananaPool"}
	if RevoConfig["superior_enabled"] then
		random_random[#random_random+1] = "Superior"
	end
	if RevoConfig["6_vault_enabled"] then
		random_random[#random_random+1] = "crv_va"
	end
	if RevoConfig["8_curses_enabled"] then
		random_random[#random_random+1] = "crv_curse"
	end
	if RevoConfig["7_chaos_enabled"] then
		random_random[#random_random+1] = "crv_chaos"
	end
	local random_rarity = pseudorandom_element(random_random)

	local random_cards2 = {}
	local random_cards = {}

	if G.P_CENTER_POOLS[random_rarity] then
		for k, card in pairs(G.P_CENTER_POOLS[random_rarity]) do
			random_cards2[#random_cards2 + 1] = card.key
		end
	elseif G.P_JOKER_RARITY_POOLS[random_rarity] then
		for k, card in pairs(G.P_JOKER_RARITY_POOLS[random_rarity]) do
			random_cards2[#random_cards2 + 1] = card.key
		end
	end


	pseudoshuffle(random_cards2, pseudoseed("revo_sucks_at_ui"))
	for i = 1, 5 do
		random_cards[#random_cards + 1] = random_cards2[1]
		table.remove(random_cards2, 1)
	end

	if not random_cards then random_cards = {"j_crv_printer","j_crv_grossprinter","j_crv_rustyprinter","j_crv_jimboprinter","j_crv_obeliskprinter"} end
	local a = 0

	for i, key in pairs(random_cards) do
		local card = Card(
			G.printer_info.T.x + G.printer_info.T.w / 2,
			G.printer_info.T.y,
			G.CARD_W,
			G.CARD_H,
			G.P_CARDS.empty,
			G.P_CENTERS[key]
		)
		card.dissolve = 1
		G.printer_info:emplace(card)
		card:flip()

		G.E_MANAGER:add_event(Event({
			blocking = false,
			trigger = "after",
			delay = 0.2 * i,
			func = function()
				if card and G.printer_info and G.printer_info.cards and #G.printer_info.cards then
					card:start_materialize()
					a = a + 1
					if a >= 3 then
					G.E_MANAGER:add_event(Event({
								trigger = "after",
								delay = 0,
								func = function()
									if G.printer_info and G.printer_info.cards and #G.printer_info.cards then
										for i = 1, #G.printer_info.cards do
											local card = G.printer_info.cards[i]
											G.E_MANAGER:add_event(Event({
												blocking = false,
												trigger = "after",
												delay = 0.1 * i,
												func = function()
													if card and card.facing == "back" then
														play_sound("card1")
														card:flip()
														card:juice_up()
													end
													return true
												end,
											}))
										end
									end
									return true
								end
							}))
					end
				end
				return true
			end,
		}))
	end

	modNodes[#modNodes + 1] = {
		n = G.UIT.R,
		config = { align = "cm", padding = 0.07, no_fill = true },
		nodes = {
			{ n = G.UIT.O, config = { object = G.printer_info } },
		},
	}
end

SMODS.current_mod.ui_config = {
    colour = darken(G.C.PURPLE, 0.6),
    bg_colour = { G.C.PURPLE[1], G.C.BLACK[2], G.C.PURPLE[2], 0.3 },
    back_colour = darken(G.C.PURPLE, 0.3),
    tab_button_colour = darken(HEX("7E7AFF"), 0.2),
    collection_option_cycle_colour = darken(HEX("7E7AFF"), 0.2),
}


-- Curse Card Area 
if RevoConfig["8_curses_enabled"] then
	-- wow i did not add anything here thats crazy
end

-- Printer Deck
function RevosVault.printer_box()
  local deck_tables = {}

  local printers = {}

if G.P_JOKER_RARITY_POOLS["crv_p"] then
  for k, v in pairs(G.P_JOKER_RARITY_POOLS["crv_p"]) do
	if (not v.no_collection and not v.no_printer_list) or v.yes_printer_list then 
		printers[#printers+1] = v
	end
  end
end

  printers[#printers+1] = G.P_CENTERS["j_crv_legendaryprinter"]

  if G.P_CENTERS["j_crv_printorium"] then
	printers[#printers+1] = G.P_CENTERS["j_crv_printorium"]
  end

  G.your_collection = {}
  for j = 1, 3 do
    G.your_collection[j] = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
      5*G.CARD_W,
      0.95*G.CARD_H, 
      {card_limit = 5, type = 'title', highlight_limit = 0, collection = true})
    table.insert(deck_tables, 
    {n=G.UIT.R, config={align = "cm", padding = 0.07, no_fill = true}, nodes={
      {n=G.UIT.O, config={object = G.your_collection[j]}}
    }}
    )
  end

  local joker_options = {}
  for i = 1, math.ceil(#printers/(5*#G.your_collection)) do
    table.insert(joker_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#printers/(5*#G.your_collection))))
  end

  for i = 1, 5 do
    for j = 1, #G.your_collection do
      local center = printers[i+(j-1)*5]
      local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, nil, center)
	  if RevosVault.negative_pdeck then
		-- yes
	  end
      card.sticker = get_joker_win_sticker(center)
      G.your_collection[j]:emplace(card)
	  card:add_sticker("eternal", true)
    end
  end

  INIT_COLLECTION_CARD_ALERTS()
  
  local t =  create_UIBox_generic_options({ back_func = 'leave_deck_menu', contents = {
        {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables}, 
        {n=G.UIT.R, config={align = "cm"}, nodes={
          create_option_cycle({options = joker_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_collecion_printer_list', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
        }},
    }})
  return t
end

G.FUNCS.leave_deck_menu = function(e)
	RevosVault.printer_deck_selection = false
	G.FUNCS:exit_overlay_menu()
end

G.FUNCS.get_printer_box = function(e)
  RevosVault.printer_deck_selection = true
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu{
    definition = RevosVault.printer_box(),
  }
end

G.FUNCS.your_collecion_printer_list = function(args)
  local printers = {}

  for k, v in pairs(G.P_CENTER_POOLS.Joker) do
	if (v.rarity == "crv_p" and (not v.no_collection and not v.no_printer_list)) or v.yes_printer_list then 
		printers[#printers+1] = v
	end
  end


  if not args or not args.cycle_config then return end
  for j = 1, #G.your_collection do
    for i = #G.your_collection[j].cards,1, -1 do
      local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
      c:remove()
      c = nil
    end
  end
  for i = 1, 5 do
    for j = 1, #G.your_collection do
      local center = printers[i+(j-1)*5 + (5*#G.your_collection*(args.cycle_config.current_option - 1))]
      if not center then break end
      local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
      
      G.your_collection[j]:emplace(card)
	  card:add_sticker("eternal", true)
    end
  end
end

-- The Vault

--boom

-- NEW UI(WIP)
RevosVault.button_func = function(card, args) -- idk what im doing

	if args.under then
		if not args.bw then args.bw = -0.1 end
		if not args.bh then args.bh = 0.8 end
		if not args.align_text then args.align_text = "bm" end
	end

	if not args.bw then args.bw = 0.1 end
	if not args.bh then args.bh = 0.6 end
	if not args.align_other then args.align_other = "cm" end
	if not args.align then args.align = "cr" end
	if not args.align_text then args.align_text = "tm" end
	if not args.colour then args.colour = G.C.RED end
	if not args.one_press then args.one_press = false end
	if not args.text_colour then args.text_colour = G.C.UI.TEXT_LIGHT end
	if not args.text_scale then args.text_scale = 0.5 end
	if not args.r then args.r = 0.08 end
	if not args.minw then args.minw = 1.25 end
	if not args.minh then args.minh = 0 end
	if not args.padding_1 then args.padding_1 = 0.1 end
	if not args.align_after_text then args.align_after_text = "cm" end
	if not args.ref_table then args.ref_table = card end
	if not args.hover then args.hover = true end
	if not args.shadow then args.shadow = true end
	if not args.shadow_text then args.shadow_text = true end
	if not args.maxw then args.maxw = 1.25 end
	if not args.maxw_after_text then args.maxw_after_text = 1.25 end

	local args = args or {}
	local sell = nil
	local use = nil

	if args.sell then
		sell = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						hover = true,
						shadow = true,
						colour = G.C.UI.BACKGROUND_INACTIVE,
						one_press = true,
						button = "sell_card",
						func = "can_sell_card",
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = 0.1,
								h = 0.6,
							},
						},
						{
							n = G.UIT.C,
							config = {
								align = "tm",
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										maxw = 1.25,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("b_sell"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.4,
												shadow = true,
											},
										},
									},
								},
								{
									n = G.UIT.R,
									config = {
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("$"),
												colour = G.C.WHITE,
												scale = 0.4,
												shadow = true,
											},
										},
										{
											n = G.UIT.T,
											config = {
												ref_table = card,
												ref_value = "sell_cost_label",
												colour = G.C.WHITE,
												scale = 0.55,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	if args.use then
		use = {
			n = G.UIT.C,
			config = {
				align = args.align,
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = args.ref_table,
						align = args.align_other,
						maxw = args.maxw,
						padding = args.padding_1,
						r = args.r,
						minw = args.minw,
						minh = args.minh,
						hover = args.hover,
						shadow = args.shadow,
						colour = args.colour,
						button = args.button,
						func = args.func,
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = args.bw,
								h = args.bh,
							},
						},
						{
							n = G.UIT.C,
							config = {
								align = args.align_text,
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = args.align_after_text,
										maxw = args.maxw_after_text,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = args.text,
												colour = args.text_colour,
												scale = args.text_scale,
												shadow = args.shadow_text,
											},
										},
									},
								},
								args.second_text
							},
						},
					},
				},
			},
		}
	end

	return {
		n = G.UIT.ROOT,
		config = {
			align = "cr",
			padding = 0,
			colour = G.C.CLEAR,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					padding = 0.15,
					align = "cl",
				},
				nodes = {
					sell and {
						n = G.UIT.R,
						config = {
							align = "cl",
						},
						nodes = { sell },
					} or nil,
					use and {
						n = G.UIT.R,
						config = {
							align = "cl",
						},
						nodes = { use },
					} or nil,
				},
			},
		},
	}
end

-- This specific hook exits a lot in my current code. Im not planning to remove them nor move them just yet but the future ones will be implemented here under the same hook

local cardhighold = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and TheVault and TheVault.in_vault and self.area == G.jokers and self.ability.set == "Joker" then

		if self.children.crv_use then
			self.children.crv_use:remove()
			self.children.crv_use = nil
		end

		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.crv_use = UIBox({
			definition = RevosVault.button_func(self, {
				use = true,
				button = "crv_emplace_to_vault",
				func = "crv_can_emplace_to_vault",
				under = true,
				text = "PLACE"
			}),
			config = {
				align = "cm",
				offset = {
					x = 0,
					y = 1.4,
				},
				parent = self,
			},
		})

		self.children.use_button = UIBox({
			definition = RevosVault.button_func(self, {
				sell = true,
			}),
			config = {
				align = "cr",
				offset = {
					x = -0.4,
					y = 0,
				},
				parent = self,
			},
		})
	elseif self.highlighted and TheVault and TheVault.in_vault and self.area == G.vault_card and self.ability.set == "Joker" then

		if self.children.crv_use then
			self.children.crv_use:remove()
			self.children.crv_use = nil
		end

		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.crv_use = UIBox({
			definition = RevosVault.button_func(self, {
				use = true,
				button = "crv_remove_from_vault",
				under = true,
				text = "REMOVE"
			}),
			config = {
				align = "cm",
				offset = {
					x = 0,
					y = 1.5,
				},
				parent = self,
			},
		})
	end
	
	if self.highlighted and string.find(self.ability.set, "crv_Gems") and self.area == G.consumeables then --this doenst fucking existafjkasyhfasmdlşaslj
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.button_func(self, {
				sell = true,
			}),
			config = {
				align = "cr",
				offset = {
					x = -0.4,
					y = 0,
				},
				parent = self,
			},
		})		
	elseif
		self.highlighted
		and (string.find(self.ability.set, "Default") or string.find(self.ability.set, "Enhanced"))
		and self.area == G.hand
		and self.area ~= G.play
		and (#SMODS.find_card("j_crv_holoface") > 0)
		and self:is_face()
		and not RevosVault.scoring
	then
		if self.children.crv_use then
			self.children.crv_use:remove()
			self.children.crv_use = nil
			self.crv_holofaced = nil
		end

		self.children.crv_use = UIBox({
			definition = RevosVault.button_func(self, {
				use = true,
				button = "crv_change",
				func = "crv_can_change",
				bw = -0.1,
				bh = 0.8,
				text = "SWAP",
				align_text = "bm"
			}),
			config = {
				align = "cm",
				offset = {
					x = 0,
					y = 1.5,
				},
				parent = self,
			},
		})

		self.crv_holofaced = true
		
	elseif self.highlighted and string.find(self.ability.set, "Gem") and self.area == G.shop_vouchers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.button_func(self, {
				use = true,
				button = "use_card",
				func = "can_redeem_gem",
				one_press = true,
				text = "Activate",
				colour = G.C.GREEN,
				bw = -0.1,
				bh = 0.8,
				align_text = "cm"
			}),
			config = {
				align = "cr",
				offset = {
					x = -1.6,
					y = 1.1,
				},
				parent = self,
			},
		})
	elseif self.highlighted and self.config.center.rarity == "crv_curse" and self.area == G.crv_curses then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end
	elseif self.highlighted and string.find(self.ability.name, "j_crv_thed6") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.button_func(self, {
				sell = true,
				use = true,
				button = "use_card",
				func = "can_reroll_cards",
				text = "Reroll",
				text_scale = 0.4,
				second_text = {
									n = G.UIT.R,
									config = {
										align = "cm",
										maxw = 1.25,
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = "Selected",
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.3,
												shadow = true,
											},
										},
									},
								}
				
			}),
			config = {
				align = "cr",
				offset = {
					x = -0.4,
					y = 0,
				},
				parent = self,
			},
		})
	elseif self.highlighted and string.find(self.ability.name, "j_crv_brj") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.button_func(self, {
				sell = true,
				use = true,
				button = "crv_modee",
				func = "can_change_mode",
				text_scale = 0.4,
				text = localize("crv_mode"),
				second_text = {
									n = G.UIT.R,
									config = {
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("crv_mode2"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.5,
												shadow = true,
											},
										},
									},
								},
					
				
			}),
			config = {
				align = "cr",
				offset = {
					x = -0.4,
					y = 0,
				},
				parent = self,
			},
		})
	elseif self.highlighted and string.find(self.ability.name, "j_crv_adamap") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.button_func(self, {
				sell = true,
				use = true,
				text = localize("crv_eat"),
				button = "crv_eaten",
			}),
			config = {
				align = "cr",
				offset = {
					x = -0.4,
					y = 0,
				},
				parent = self,
			},
		})
	elseif self.highlighted and string.find(self.ability.name, "j_crv_invest") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.button_func(self, {
				sell = true,
				use = true,
				text = "INVEST",
				button = "crv_invest",
				func = "crv_can_invest",
				text_align = "cm",
			}),
			config = {
				align = "cr",
				offset = {
					x = -0.4,
					y = 0,
				},
				parent = self,
			},
		})
	elseif self.highlighted and string.find(self.ability.name, "j_crv_roulj") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.button_func(self, {
				sell = true,
				use = true,
				button = "crv_changebet",
				text = localize("crv_change"),
				second_text = {
									n = G.UIT.R,
									config = {
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("crv_bet"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.5,
												shadow = true,
											},
										},
									},
								},
			}),
			config = {
				align = "cr",
				offset = {
					x = -0.4,
					y = 0,
				},
				parent = self,
			},
		})
	elseif self.highlighted and string.find(self.ability.name, "j_crv_dealb") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.button_func(self, {
				sell = true,
				use = true,
				button = "crv_half",
				text = localize("k_half_crv"),
				second_text = {
									n = G.UIT.R,
									config = {
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("k_hblind_crv"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.5,
												shadow = true,
											},
										},
									},
								},
			}),
			config = {
				align = "cr",
				offset = {
					x = -0.4,
					y = 0,
				},
				parent = self,
			},
		})
	else
		cardhighold(self, is_highlighted)	
	end
end


-- All gems stuff until "--"

if RevoConfig["gems_enabled"] then

	--Gem tab function to show the gems in a new tab in run info.
	function G.UIDEF.used_gems()
		local silent = false
		local keys_used = {}
		local area_count = 0
		local voucher_areas = {}
		local voucher_tables = {}
		local voucher_table_rows = {}
		for k, v in ipairs(G.GAME.used_gems or {}) do
			keys_used[#keys_used + 1] = G.P_CENTERS[v]
		end
		for k, v in ipairs(keys_used) do
			if next(v) then
				area_count = area_count + 1
			end
		end
		for k, v in ipairs(keys_used) do
			if next(v) then
				if #voucher_areas == 5 or #voucher_areas == 10 then
					table.insert(
						voucher_table_rows,
						{ n = G.UIT.R, config = { align = "cm", padding = 0, no_fill = true }, nodes = voucher_tables }
					)
					voucher_tables = {}
				end
				voucher_areas[#voucher_areas + 1] = CardArea(
					G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
					G.ROOM.T.h,
					(#v == 1 and 1 or 1.33) * G.CARD_W,
					(area_count >= 10 and 0.75 or 1.07) * G.CARD_H,
					{ card_limit = 2, type = "voucher", highlight_limit = 0 }
				)

				local center = v
				local card = Card(
					voucher_areas[#voucher_areas].T.x + voucher_areas[#voucher_areas].T.w / 2,
					voucher_areas[#voucher_areas].T.y,
					G.CARD_W,
					G.CARD_H,
					nil,
					center,
					{ bypass_discovery_center = true, bypass_discovery_ui = true, bypass_lock = true }
				)
				-- RevosVault.create_gem_timer(card)
				card:start_materialize(nil, silent)
				silent = true
				voucher_areas[#voucher_areas]:emplace(card)

				card.ability.order = v.order

				table.insert(voucher_tables, {
					n = G.UIT.C,
					config = { align = "cm", padding = 0, no_fill = true },
					nodes = {
						{ n = G.UIT.O, config = { object = voucher_areas[#voucher_areas] } },
					},
				})
			end
		end
		table.insert(
			voucher_table_rows,
			{ n = G.UIT.R, config = { align = "cm", padding = 0, no_fill = true }, nodes = voucher_tables }
		)

		local t = silent
				and {
					n = G.UIT.ROOT,
					config = { align = "cm", colour = G.C.CLEAR },
					nodes = {
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{
									n = G.UIT.O,
									config = {
										object = DynaText({
											string = { localize("ph_active_gems") },
											colours = { G.C.UI.TEXT_LIGHT },
											bump = true,
											scale = 0.6,
										}),
									},
								},
							},
						},
						{ n = G.UIT.R, config = { align = "cm", minh = 0.5 }, nodes = {} },
						{
							n = G.UIT.R,
							config = { align = "cm", colour = G.C.BLACK, r = 1, padding = 0.15, emboss = 0.05 },
							nodes = {
								{ n = G.UIT.R, config = { align = "cm" }, nodes = voucher_table_rows },
							},
						},
					},
				}
			or {
				n = G.UIT.ROOT,
				config = { align = "cm", colour = G.C.CLEAR },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = DynaText({
								string = { localize("no_gems") },
								colours = { G.C.UI.TEXT_LIGHT },
								bump = true,
								scale = 0.6,
							}),
						},
					},
				},
			}
		return t
	end

	if RevosVault.config.gems_enabled then
		RevosVault.custom_collection_tabs = function()
			local t = UIBox_button({
				button = "your_collection_crv_gems",
				id = "your_collection_crv_gems",
				label = { localize("b_gems") },
				minw = 5,
				minh = 1,
			})
			--[[local t2 = 
				UIBox_button({
				button = "your_collection_crv_boons",
				id = "your_collection_crv_boons",
				label = { "Boons" },	
				minw = 5,
				minh = 1,
			})]]
			return { t } -- t2}
		end
	end


end

--

-- Taken from the hottest potato around here

    -- Taken from Hot Potato
function RevosVault.manual_parse(text, args)
    if not text then return end
    if type(text) ~= "table" then text = {text} end
    local args = args or {}
    local dir = G.localization
    if args.loc_dir then
        for _,v in ipairs(args.loc_dir) do
            dir[v] = dir[v] or {}
            dir = dir[v]
        end
    else
        dir = G.localization.misc.v_text_parsed
    end
    local key = args.loc_key or "SMODS_stylize_text"
    local function deep_find(t, index)
        if type(index) ~= "table" then index = {index} end
        for _,idv_index in ipairs(index) do
            if t[idv_index] then return true end
            for i,v in pairs(t) do
                if i == idv_index then return true end
                if type(v) == "table" then
                    return deep_find(v, idv_index)
                end
            end
        end
        return false
    end
    if deep_find(text, "control") and not args.refresh then
        if not args.no_loc_save then dir = text end
        return text
    end

    local a = {"text", "name", "unlock"}
    if not args.no_loc_save then
        local loc = dir
        loc[key] = {}
        if deep_find(text, a) then
            for _,v in ipairs(a) do
                text[v] = text[v] or {}
                text[v.."_parsed"] = (args.refresh and {}) or text[v.."_parsed"] or {}
            end
            if text.text then
                for _,v in ipairs(text.text) do
                    if type(v) == "table" then
                        text.text_parsed[#text.text_parsed+1] = {}
                        for _, vv in ipairs(v) do
                            text.text_parsed[#text.text_parsed][#text.text_parsed[#text.text_parsed]+1] = loc_parse_string(vv)
                        end
                    else
                        text.text_parsed[#text.text_parsed+1] = loc_parse_string(v)
                    end
                end
            end
            if text.name then
                for _,v in ipairs((type(text.name) == "string" and {text.name}) or text.name) do
                    text.name_parsed[#text.name_parsed+1] = loc_parse_string(v)
                end
            end
            if text.unlock then
                for _,v in ipairs(text.unlock) do
                    text.unlock_parsed[#text.unlock_parsed+1] = loc_parse_string(v)
                end
            end
            loc[key] = text
        else
            for i,v in ipairs(text) do
                loc[key][i] = loc_parse_string(v)
            end
        end

        return loc[key]
    else
        local loc = {}
        if deep_find(text, a) then
            for _,v in ipairs(a) do
                text[v] = text[v] or {}
                text[v.."_parsed"] = (args.refresh and {}) or text[v.."_parsed"] or {}
            end
            if text.text then
                for _,v in ipairs(text.text) do
                    if type(v) == "table" then
                        text.text_parsed[#text.text_parsed+1] = {}
                        for _, vv in ipairs(v) do
                            text.text_parsed[#text.text_parsed][#text.text_parsed[#text.text_parsed]+1] = loc_parse_string(vv)
                        end
                    else
                        text.text_parsed[#text.text_parsed+1] = loc_parse_string(v)
                    end
                end
            end
            if text.name then
                for _,v in ipairs((type(text.name) == "string" and {text.name}) or text.name) do
                    text.name_parsed[#text.name_parsed+1] = loc_parse_string(v)
                end
            end
            if text.unlock then
                for _,v in ipairs(text.unlock) do
                    text.unlock_parsed[#text.unlock_parsed+1] = loc_parse_string(v)
                end
            end
            loc = text
        else
            for i,v in ipairs(text) do
                loc[i] = loc_parse_string(v)
            end
        end

        return loc
    end
end

function RevosVault.localize(args, misc_cat)
    if args and not (type(args) == 'table') then
        if misc_cat and G.localization.misc[misc_cat] then return G.localization.misc[misc_cat][args] or 'ERROR' end
        return G.localization.misc.dictionary[args] or 'ERROR'
    end
    args = args or {}
    args.nodes = args.nodes or {}

    local loc_target = args.loc_target and copy_table(args.loc_target) or nil
    if args.stylize then loc_target = RevosVault.manual_parse(loc_target) end
    local ret_string = nil
    if args.type == 'other' then
        if not loc_target then loc_target = G.localization.descriptions.Other[args.key] end
    elseif args.type == 'descriptions' or args.type == 'unlocks' then
        if not loc_target then loc_target = G.localization.descriptions[args.set][args.key] end
    elseif args.type == 'tutorial' then
        if not loc_target then loc_target = G.localization.tutorial_parsed[args.key] end
    elseif args.type == 'quips' then
        if not loc_target then loc_target = G.localization.quips_parsed[args.key] end
    elseif args.type == 'raw_descriptions' then
        if not loc_target then loc_target = G.localization.descriptions[args.set][args.key] end
        local multi_line = {}
        if loc_target then
            for _, lines in ipairs(args.type == 'unlocks' and loc_target.unlock_parsed or args.type == 'name' and loc_target.name_parsed or args.type == 'text' and loc_target or loc_target.text_parsed) do
                local final_line = ''
                for _, part in ipairs(lines) do
                    local assembled_string = ''
                    for _, subpart in ipairs(part.strings) do
                        assembled_string = assembled_string..(type(subpart) == 'string' and subpart or format_ui_value(args.vars[tonumber(subpart[1])]) or 'ERROR')
                    end
                    final_line = final_line..assembled_string
                end
                multi_line[#multi_line+1] = final_line
            end
        end
        return multi_line
    elseif args.type == 'text' then
        if not loc_target then loc_target = G.localization.misc.v_text_parsed[args.key] end
    elseif args.type == 'variable' then
        if not loc_target then loc_target = G.localization.misc.v_dictionary_parsed[args.key] end
        if not loc_target then return 'ERROR' end
        if loc_target.multi_line then
            local assembled_strings = {}
            for k, v in ipairs(loc_target) do
                local assembled_string = ''
                for _, subpart in ipairs(v[1].strings) do
                    assembled_string = assembled_string..(type(subpart) == 'string' and subpart or format_ui_value(args.vars[tonumber(subpart[1])]))
                end
                assembled_strings[k] = assembled_string
            end
            return assembled_strings or {'ERROR'}
        else
            local assembled_string = ''
            for _, subpart in ipairs(loc_target[1].strings) do
                assembled_string = assembled_string..(type(subpart) == 'string' and subpart or format_ui_value(args.vars[tonumber(subpart[1])]))
            end
            ret_string = assembled_string or 'ERROR'
        end
    elseif args.type == 'name_text' then
        if pcall(function()
            local name_text = (loc_target and loc_target.name) or G.localization.descriptions[(args.set or args.node.config.center.set)][args.key or args.node.config.center.key].name
            if type(name_text) == "table" then
                ret_string = ""
                for i, line in ipairs(name_text) do
                    ret_string = ret_string.. (i ~= 1 and " " or "")..line
                end
            else
                ret_string = name_text
            end
        end) then
        else ret_string = "ERROR" end
    elseif args.type == 'name' then
        loc_target = loc_target or {}
        if pcall(function()
            local name = loc_target or G.localization.descriptions[(args.set or args.node.config.center.set)][args.key or args.node.config.center.key]
            loc_target.name_parsed = name.name_parsed or {loc_parse_string(name.name)}
        end) then
        else loc_target.name_parsed = {} end
    end

    if ret_string and type(ret_string) == 'string' then ret_string = string.gsub(ret_string, "{.-}", "") end
    if ret_string then return ret_string end

    if loc_target then
        args.AUT = args.AUT or {}
        args.AUT.info = args.AUT.info or {}
        args.AUT.box_colours = {}
        if (args.type == 'descriptions' or args.type == 'other') and type(loc_target.text) == 'table' and type(loc_target.text[1]) == 'table' then
            args.AUT.multi_box = {}
            for i, box in ipairs(loc_target.text_parsed) do
                for j, line in ipairs(box) do
                    local final_line = SMODS.localize_box(line, args)
                    if i == 1 or next(args.AUT.info) then
                        args.nodes[#args.nodes+1] = final_line -- Sends main box to AUT.main
                        if not next(args.AUT.info) then args.nodes.main_box_flag = true end
                    elseif not next(args.AUT.info) then
                        args.AUT.multi_box[i-1] = args.AUT.multi_box[i-1] or {}
                        args.AUT.multi_box[i-1][#args.AUT.multi_box[i-1]+1] = final_line
                    end
                    if not next(args.AUT.info) then args.AUT.box_colours[i] = args.vars.box_colours and args.vars.box_colours[i] or G.C.UI.BACKGROUND_WHITE end
                end
            end
            return
        end
        for _, lines in ipairs(args.type == 'unlocks' and loc_target.unlock_parsed or args.type == 'name' and loc_target.name_parsed or (args.type == 'text' or args.type == 'tutorial' or args.type == 'quips') and loc_target or loc_target.text_parsed) do
            local final_line = {}
            local final_name_assembled_string = ''
            if args.type == 'name' and loc_target.name_parsed then
                for _, part in ipairs(lines) do
                    local assembled_string_part = ''
                    for _, subpart in ipairs(part.strings) do
                        assembled_string_part = assembled_string_part..(type(subpart) == 'string' and subpart or format_ui_value(format_ui_value(args.vars[tonumber(subpart[1])])) or 'ERROR')
                    end
                    final_name_assembled_string = final_name_assembled_string..assembled_string_part
                end
            end
            for _, part in ipairs(lines) do
                local assembled_string = ''
                for _, subpart in ipairs(part.strings) do
                    assembled_string = assembled_string..(type(subpart) == 'string' and subpart or format_ui_value(args.vars[tonumber(subpart[1])]) or 'ERROR')
                end
                local desc_scale = (SMODS.Fonts[part.control.f] or G.FONTS[tonumber(part.control.f)] or G.LANG.font).DESCSCALE
                if G.F_MOBILE_UI then desc_scale = desc_scale*1.5 end
                if args.type == 'name' then
                    final_line[#final_line+1] = {n=G.UIT.C, config={align = "m", colour = part.control.B and args.vars.colours[tonumber(part.control.B)] or part.control.X and loc_colour(part.control.X) or nil, r = 0.05, padding = 0.03, res = 0.15}, nodes={}}
                    final_line[#final_line].nodes[1] = {n=G.UIT.O, config={
                        object = DynaText({string = {assembled_string},
                            colours = {(part.control.V and args.vars.colours[tonumber(part.control.V)]) or (part.control.C and loc_colour(part.control.C)) or args.text_colour or G.C.UI.TEXT_LIGHT},
                            bump = not args.no_bump,
                            silent = not args.no_silent,
                            pop_in = (not args.no_pop_in and (args.pop_in or 0)) or nil,
                            pop_in_rate = (not args.no_pop_in and (args.pop_in_rate or 4)) or nil,
                            maxw = args.maxw or 5,
                            shadow = not args.no_shadow,
                            y_offset = args.y_offset or -0.6,
                            spacing = (not args.no_spacing and (args.spacing or 1) * math.max(0, 0.32*(17 - #(final_name_assembled_string or assembled_string)))) or nil,
                            font = SMODS.Fonts[part.control.f] or G.FONTS[tonumber(part.control.f)] or (SMODS.Fonts[args.font] or G.FONTS[args.font]),
                            scale = (0.55 - 0.004*#(final_name_assembled_string or assembled_string))*(part.control.s and tonumber(part.control.s) or args.scale or 1)*(args.fixed_scale or 1)
                        })
                    }}
                elseif part.control.E then
                    local _float, _silent, _pop_in, _bump, _spacing = nil, true, nil, nil, nil
                    if part.control.E == '1' then
                        _float = true; _silent = true; _pop_in = 0; _spacing = 1
                    elseif part.control.E == '2' then
                        _bump = true; _spacing = 1
                    end
                    final_line[#final_line+1] = {n=G.UIT.C, config={align = "m", colour = part.control.B and args.vars.colours[tonumber(part.control.B)] or part.control.X and loc_colour(part.control.X) or nil, r = 0.05, padding = 0.03, res = 0.15}, nodes={}}
                    final_line[#final_line].nodes[1] = {n=G.UIT.O, config={
                        object = DynaText({string = {assembled_string}, colours = {part.control.V and args.vars.colours[tonumber(part.control.V)] or loc_colour(part.control.C or nil)},
                            float = _float,
                            silent = _silent,
                            pop_in = _pop_in,
                            bump = _bump,
                            spacing = (args.spacing or 1) * _spacing,
                            font = SMODS.Fonts[part.control.f] or G.FONTS[tonumber(part.control.f)] or (SMODS.Fonts[args.font] or G.FONTS[args.font]),
                            scale = 0.32*(part.control.s and tonumber(part.control.s) or args.scale or 1)*desc_scale*(args.fixed_scale or 1)
                        })
                    }}
                elseif part.control.X or part.control.B then
                    final_line[#final_line+1] = {n=G.UIT.C, config={align = "m", colour = part.control.B and args.vars.colours[tonumber(part.control.B)] or loc_colour(part.control.X), r = 0.05, padding = 0.03, res = 0.15}, nodes={
                        {n=G.UIT.T, config={
                            text = assembled_string,
                            font = SMODS.Fonts[part.control.f] or G.FONTS[tonumber(part.control.f)] or (SMODS.Fonts[args.font] or G.FONTS[args.font]),
                            colour = part.control.V and args.vars.colours[tonumber(part.control.V)] or loc_colour(part.control.C or nil),
                            scale = 0.32*(part.control.s and tonumber(part.control.s) or args.scale or 1)*desc_scale*(args.fixed_scale or 1)
                        }},
                    }}
                else
                    final_line[#final_line+1] = {n=G.UIT.T, config={
                        detailed_tooltip = part.control.T and (G.P_CENTERS[part.control.T] or G.P_TAGS[part.control.T] or G.DetailedTooltips[part.control.T]) or nil,
                        text = assembled_string,
                        font = SMODS.Fonts[part.control.f] or G.FONTS[tonumber(part.control.f)] or (SMODS.Fonts[args.font] or G.FONTS[args.font]),
                        shadow = not args.no_shadow or args.shadow,
                        colour = part.control.V and args.vars.colours[tonumber(part.control.V)] or not part.control.C and args.text_colour or loc_colour(part.control.C or nil, args.default_col),
                        scale = 0.32*(part.control.s and tonumber(part.control.s) or args.scale or 1)*desc_scale*(args.fixed_scale or 1)
                    }}
                end
            end
            if args.type == 'text' then return final_line end
            if not args.nodes and args.type == 'name' then args.nodes = {} end
            args.nodes[#args.nodes+1] = final_line
        end
        if args.type == 'name' then
            local final_name = {}

            for _, line in ipairs(args.nodes or {}) do
                final_name[#final_name+1] = {n=G.UIT.R, config={align = "m"}, nodes=line}
            end

            return final_name
        end
    end

    return args.nodes
end

function med_desc_from_rows(desc_nodes, empty, align, maxw, minh)
    local t = {}
    for k, v in ipairs(desc_nodes) do
        t[#t+1] = {n=G.UIT.R, config={align = align or "cm", maxw = maxw}, nodes=v}
    end
    return {n=G.UIT.R, config={align = "cm", colour = empty and G.C.CLEAR or G.C.UI.BACKGROUND_WHITE, r = 0.1, padding = 0.04, minw = 2, minh = minh or 0.8, emboss = not empty and 0.05 or nil, filler = true}, nodes={
        {n=G.UIT.R, config={align = align or "cm", padding = 0.03}, nodes=t}
    }}
end

function G.FUNCS.RevosVault_previous_info_page(e)
    local config = e.config
    local max_page = config.max_page
    local page = config.page
    local menu_type = config.menu_type
	local no_first_time = config.no_first_time
    
    if page <= 1 then
        page = max_page
    else
        page = math.max(page - 1, 1)
    end

    G.FUNCS.RevosVault_info{menu_type = menu_type, page = page}
end

function G.FUNCS.RevosVault_next_info_page(e)
    local config = e.config
    local max_page = config.max_page
    local page = config.page
    local menu_type = config.menu_type
	local no_first_time = config.no_first_time
    
    if page >= max_page then
        page = 1
    else
        page = math.min(page + 1, max_page)
    end

    G.FUNCS.RevosVault_info{menu_type = menu_type, page = page}

end

function RevosVault_create_info_UI(args)
    local args = args or {}
    local back_func = args.back_func or "exit_overlay_menu"
    local menu_type = args.menu_type
    local page = args.page or 1
    local loc = G.localization.Menus[menu_type]
	local no_first_time = args.no_first_time

    local function create_text_box(args)
        local desc_node = {}
        local loc_target = args.loc_target and copy_table(args.loc_target)
        RevosVault.localize{type = 'descriptions', loc_target = {text = loc_target}, nodes = desc_node, scale = 1, text_colour = G.C.UI.TEXT_LIGHT, vars = args.vars or {}, stylize = true, no_shadow = true} 
        desc_node = med_desc_from_rows(desc_node,true,"cm")
        desc_node.config.align = "cm"

        return {n = G.UIT.R, config = {align = "cm", colour = G.C.BLACK, r = 0.2, shadow = true}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.05}, nodes = {
                desc_node
            }},
        }}
    end

    local name_nodes = {n = G.UIT.R, config = {align = "cm", colour = G.C.CLEAR}, nodes = {
        {n = G.UIT.C, config = {align = "cm"}, nodes = {}},
    }}
    local subname_nodes = {n = G.UIT.R, config = {align = "cm", colour = G.C.CLEAR, padding = -0.15}, nodes = {
        {n = G.UIT.C, config = {align = "cm"}, nodes = {}},
    }}
    local info_nodes = {}
    if loc then
        local temp_name_node = {}
        RevosVault.localize{type = 'name', loc_target = {name = loc.name}, nodes = temp_name_node, scale = 1.5, text_colour = G.C.UI.TEXT_LIGHT, vars = args.vars or {}, stylize = true} 
        temp_name_node = med_desc_from_rows(temp_name_node,true,"cm",nil,0)
        temp_name_node.config.align = "cm"
        name_nodes.nodes[1].nodes[#name_nodes.nodes[1].nodes+1] = {n = G.UIT.R, config = {align = "cm", colour = G.C.CLEAR}, nodes = {
            {n = G.UIT.C, config = {align = "cm"}, nodes = {
                temp_name_node
            }},
        }}

        local target = loc.text[page]
        if target then
            local temp_subname_node = {}
            RevosVault.localize{type = 'name', loc_target = {name = target.name}, nodes = temp_subname_node, scale = 0.8, text_colour = G.C.UI.TEXT_LIGHT, vars = args.vars or {}, stylize = true, no_shadow = true, no_pop_in = true, no_bump = true, no_silent = true, no_spacing = true} 
            temp_subname_node = med_desc_from_rows(temp_subname_node,true,"cm",nil,0)
            temp_subname_node.config.align = "cm"
            subname_nodes.nodes[1].nodes[#subname_nodes.nodes[1].nodes+1] = {n = G.UIT.R, config = {align = "cm", colour = G.C.CLEAR}, nodes = {
                {n = G.UIT.C, config = {align = "cm"}, nodes = {
                    temp_subname_node
                }},
            }}
            info_nodes = 
            {n = G.UIT.R, config = {align = "cm", padding = 0, colour = G.C.CLEAR}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.2}, nodes = {}},
            }}
            for _,v in ipairs(target.text) do
                info_nodes.nodes[1].nodes[#info_nodes.nodes[1].nodes+1] = create_text_box({loc_target = v})
            end
        end
    end

    G.PROFILES[G.SETTINGS.profile].first_time_disable = G.PROFILES[G.SETTINGS.profile].first_time_disable or {}

    local ret = {n=G.UIT.ROOT, config = {align = "cm", minw = G.ROOM.T.w*5, minh = G.ROOM.T.h*5,padding = 0.1, r = 0.1, colour = args.bg_colour or {G.C.GREY[1], G.C.GREY[2], G.C.GREY[3],0.7}}, nodes={
        {n=G.UIT.R, config={align = "cm", minh = 1, r = 0.3, padding = 0.07, minw = 1, colour = args.outline_colour or G.C.JOKER_GREY, emboss = 0.1}, nodes={
            {n=G.UIT.C, config={align = "cm", minh = 1, r = 0.2, padding = 0.1, minw = 1, colour = args.colour or G.C.L_BLACK}, nodes={
                {n=G.UIT.R, config={align = "cm", r = 0.2, padding = 0.15, minw = 1, colour = G.C.BLACK}, nodes={
                    {n=G.UIT.C, config={align = "cm", r = 0.2, padding = 0.05, minw = 1, colour = G.C.L_BLACK}, nodes={
                        --i gotta insert here
                        name_nodes,
                        subname_nodes,
                        info_nodes,
                       {n = G.UIT.R, config = {align = "cm", padding = 0.02}, nodes = {
                            {n = G.UIT.C, config = {align = "cr", colour = G.C.CLEAR}, nodes = {
                                not no_first_time and create_toggle({label = localize("crv_not_again"), ref_table = G.PROFILES[G.SETTINGS.profile].first_time_disable, ref_value = menu_type, callback = function() end }) or nil,
                            }},
                        }},
                    }},
                }},
                {n = G.UIT.R, config = {align = "cm", padding = 0}, nodes = {
                    not args.no_back and 
                    {n=G.UIT.C, config={id = args.back_id or 'overlay_menu_back_button', align = "cm", minw = 4, button_delay = args.back_delay, padding =0.1, r = 0.1, hover = true, colour = args.back_colour or G.C.ORANGE, button = back_func, shadow = true, focus_args = {nav = 'wide', button = 'b', snap_to = args.snap_back}}, nodes={
                        {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
                            {n=G.UIT.T, config={id = args.back_id or nil, text = args.back_label or localize('b_back'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, func = not args.no_pip and 'set_button_pip' or nil, focus_args =  not args.no_pip and {button = args.back_button or 'b'} or nil}}
                        }}
                    }} or nil
                }},
            }},
        }},
    }}
    if loc and loc.text and #loc.text > 1 then
        local pages = {
            {n = G.UIT.C, config = {align = "cm", minw = 0.5, minh = 0.5, maxh = 0.5, padding = 0.1, r = 0.1, hover = true, colour = G.C.BLACK, shadow = true, button = "RevosVault_previous_info_page", menu_type = menu_type, page = page, max_page = (#(loc.text or {}) or 1)}, nodes = {
                {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
                    {n = G.UIT.T, config = {text = "<", scale = 0.4, colour = G.C.UI.TEXT_LIGHT}}
                }}
            }},
            {n = G.UIT.C, config = {align = "cm", minw = 0.5, minh = 0.5, maxh = 0.5, padding = 0.1, r = 0.1, hover = true, colour = G.C.BLACK, shadow = true}, nodes = {
                {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
                    {n = G.UIT.T, config = {text = localize("k_page").." "..page.."/"..(#(loc.text or {}) or 1), scale = 0.4, colour = G.C.UI.TEXT_LIGHT}}
                }}
            }}, 
            {n = G.UIT.C, config = {align = "cm", minw = 0.5, minh = 0.5, maxh = 0.5, padding = 0.1, r = 0.1, hover = true, colour = G.C.BLACK, shadow = true, button = "RevosVault_next_info_page", menu_type = menu_type, page = page, max_page = (#(loc.text or {}) or 1)}, nodes = {
                {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
                    {n = G.UIT.T, config = {text = ">", scale = 0.4, colour = G.C.UI.TEXT_LIGHT}}
                }}
            }},
        }
        for _,v in ipairs(pages) do
            ret.nodes[1].nodes[1].nodes[1].nodes[1].nodes[4].nodes[#ret.nodes[1].nodes[1].nodes[1].nodes[1].nodes[4].nodes+1] = v
        end
    end

    return ret
end

function RevosVault_create_info(args)   
    G.E_MANAGER:add_event(Event({
        blockable = false,
        func = function()
            G.REFRESH_ALERTS = true
            return true
        end
    }))
    
    local t = RevosVault_create_info_UI(args or {})
    return t
end

G.FUNCS.RevosVault_info = function(args)   
    if not args or not args.menu_type or not G.localization.Menus[args.menu_type] then return end
    G.FUNCS.overlay_menu{
        definition = RevosVault_create_info(args),
    }
end
--
