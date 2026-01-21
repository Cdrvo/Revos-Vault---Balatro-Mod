-- Thank you JoyousSpring
SMODS.current_mod.custom_ui = function(modNodes)
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
	local random_rarity = pseudorandom_element(random_random)

	local random_cards2 = {}
	local random_cards = {}

	if random_rarity ~= "crv_p" and random_rarity ~= "crv_va" then
		for k, card in pairs(G.P_CENTER_POOLS[random_rarity]) do
			random_cards2[#random_cards2 + 1] = card.key
		end
	elseif random_rarity == "crv_va" and G.P_JOKER_RARITY_POOLS["crv_va"] then
		for k, card in pairs(G.P_JOKER_RARITY_POOLS[random_rarity]) do
			random_cards2[#random_cards2 + 1] = card.key
		end
	elseif random_rarity == "crv_p" and G.P_JOKER_RARITY_POOLS["crv_p"] then
		for k, card in pairs(G.P_JOKER_RARITY_POOLS["crv_p"]) do
			random_cards2[#random_cards2 + 1] = card.key
		end
	end

	pseudoshuffle(random_cards2, pseudoseed("revo_sucks_at_ui"))
	for i = 1, 5 do
		random_cards[#random_cards + 1] = random_cards2[1]
		table.remove(random_cards2, 1)
	end

	if not random_cards then random_cards = {"j_crv_printer","j_crv_grossprinter","j_crv_rustyprinter","j_crv_jimboprinter","j_crv_obeliskprinter"} end

	for i, key in pairs(random_cards) do
		local card = Card(
			G.printer_info.T.x + G.printer_info.T.w / 2,
			G.printer_info.T.y,
			G.CARD_W,
			G.CARD_H,
			G.P_CARDS.empty,
			G.P_CENTERS[key]
		)

		G.printer_info:emplace(card)
		card.states.visible = true
		card:flip()
		G.E_MANAGER:add_event(Event({
			blocking = false,
			trigger = "after",
			delay = 0.4 * i,
			func = function()
				play_sound("card1")
				card:flip()
				card:juice_up()
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

  for k, v in pairs(G.P_JOKER_RARITY_POOLS["crv_p"]) do
	if (not v.no_collection and not v.no_printer_list) or v.yes_printer_list then 
		printers[#printers+1] = v
	end
  end

  printers[#printers+1] = G.P_CENTERS["j_crv_legendaryprinter"]

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
	elseif self.highlighted and self.config.center.rarity == "crv_curse" and self.area == G.jokers then
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
