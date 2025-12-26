-- Thank you JoyousSpring
SMODS.current_mod.custom_ui = function(modNodes)
	G.printer_info = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
		G.ROOM.T.h,
		4.25 * G.CARD_W,
		0.95 * G.CARD_H,
		{ card_limit = 5, type = "title", highlight_limit = 0, collection = true }
	)
	local random_random = { "crv_p", "BananaPool", "crv_va" }
	local random_rarity = pseudorandom_element(random_random)

	local random_cards2 = {}
	local random_cards = {}

	if random_rarity == "BananaPool" then
		for k, card in pairs(G.P_CENTER_POOLS[random_rarity]) do
			random_cards2[#random_cards2 + 1] = card.key
		end
	elseif random_rarity == "crv_va" and G.P_JOKER_RARITY_POOLS["crv_va"] then
		for k, card in pairs(G.P_JOKER_RARITY_POOLS[random_rarity]) do
			random_cards2[#random_cards2 + 1] = card.key
		end
	else
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

  for k, v in pairs(G.P_JOKER_RARITY_POOLS["crv_p"]) do
	if (not v.no_collection and not v.no_printer_list) or v.yes_printer_list then 
		printers[#printers+1] = v
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
  
  local t =  create_UIBox_generic_options({ back_func = 'your_collection', contents = {
        {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables}, 
        {n=G.UIT.R, config={align = "cm"}, nodes={
          create_option_cycle({options = joker_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_collecion_printer_list', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
        }}
    }})
  return t
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

-- This specific hook exits a lot in my current code. Im not planning to remove them nor move them just yet but the future ones will be implemented here under the same hook

local cardhighold = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and string.find(self.ability.set, "crv_Gems") and self.area == G.consumeables then --this doenst fucking existafjkasyhfasmdlşaslj
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.buttons_edit(self, {
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
	elseif self.highlighted and string.find(self.ability.set, "crv_testing1") and self.area == G.consumeables then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.custom_button_set_1(self, {
				sell = true,
				use = true,
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
		and (string.find(self.ability.set, "Default") or string.find(self.ability.set, "Enhanced") or string.find(
			self.ability.set,
			"Playing Card"
		))
		and self.area == G.hand
		and (#SMODS.find_card("j_crv_holoface") > 0)
		and self:is_face()
	then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.custom_button_set_2(self, {
				use = true,
			}),
			config = {
				align = "cr",
				offset = {
					x = -2.8,
					y = 0,
				},
				parent = self,
			},
		})
	elseif self.highlighted and string.find(self.ability.set, "Gem") and self.area == G.shop_vouchers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.custom_button_set_3(self, {
				sell = true,
				use = true,
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
	else
		cardhighold(self, is_highlighted)
	end
end

RevosVault.buttons_edit = function(card, args)
	local args = args or {}
	local use = nil
	local sell = nil

	local args = args or {}
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
		use = nil
		use = {
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
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_modee",
						func = "can_change_mode",
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
												text = localize("crv_mode"),
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
												text = localize("crv_mode2"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = -0.5,
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

RevosVault.custom_button_set_1 = function(card, args)
	local args = args or {}
	local use = nil
	local sell = nil

	local args = args or {}
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
		use = nil
		use = {
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
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_test",
						func = "can_can_test",
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
												text = "f",
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.4,
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

RevosVault.custom_button_set_2 = function(card, args)
	local args = args or {}
	local use = nil
	local sell = nil

	if args.use then
		use = nil
		use = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "bm",
						maxw = 1.3,
						padding = 0.1,
						r = 0.08,
						minw = 1.1,
						minh = 0.03,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_change",
						func = "crv_can_change",
					},
					nodes = {
						{
							n = G.UIT.B,
							config = {
								w = -0.1,
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
												text = "Swap",
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.5,
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
					padding = -0.30,
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

--[[G.FUNCS.button_templace = function(e)
	local card = e.config.ref_table
	if a then
		e.config.colour = G.C.RED
		e.config.button = "crv_modee"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.button_template2 = function(e)
	local card = e.config.ref_table

end]]

--[[G.FUNCS.can_can_test = function(e)
	local card = e.config.ref_table
	if card.config.center:can_testing() then
		e.config.colour = G.C.RED
		e.config.button = "crv_test"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.crv_test = function(e)
	local card = e.config.ref_table
	card.config.center:testing()
end]]

G.FUNCS.crv_can_change = function(e)
	local card = e.config.ref_table
	if true then
		e.config.colour = G.C.RED
		e.config.button = "crv_change"
	end
end

G.FUNCS.crv_change = function(e)
	local card = e.config.ref_table
	if card:is_face() then
		local face = pseudorandom_element(RevosVault.facepool(card.base.value)).key
		card:flip()
		G.E_MANAGER:add_event(Event({
			trigger = "before",
			delay = 0.5,
			func = function()
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.5,
			func = function()
				SMODS.change_base(card, nil, face)
				card:flip()
				return true
			end,
		}))
	end
end

local card_highlighted_ref12 = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and string.find(self.ability.name, "j_crv_thed6") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.create_sell_and_switch_buttons11(self, {
				sell = true,
				use = true,
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
		card_highlighted_ref12(self, is_highlighted)
	end
end

RevosVault.create_sell_and_switch_buttons11 = function(card, args)
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
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "use_card",
						func = "can_reroll_cards",
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
												text = "Reroll",
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
								},
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

G.FUNCS.can_reroll_cards = function(e)
	local card = e.config.ref_table
	if card.ability.extra.can_roll == true then
		e.config.colour = G.C.RED
		e.config.button = "reroll_cards"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.reroll_cards = function(e)
	local card = e.config.ref_table
	Card:reroll_cards()
end

function Card:reroll_cards()
	SMODS.calculate_context({ reroll_cards = true })
end

-- All gems stuff until "--"

RevosVault.custom_button_set_3 = function(card, args)
	local args = args or {}
	local use = nil

	if args.use then
		use = {
			n = G.UIT.C,
			config = {
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						minw = 1.1,
						maxw = 1.3,
						padding = 0.1,
						align = "cm",
						colour = G.C.GREEN,
						shadow = true,
						r = 0.08,
						minh = 0.94,
						func = "can_redeem_gem",
						one_press = true,
						button = "use_card",
						hover = true,
					},
					nodes = {
						{ n = G.UIT.T, config = { text = "Activate", colour = G.C.WHITE, scale = 0.4 } },
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

if RevosVault.config.gem_enabled then
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






-- OLD UI CODE (but still used!)

-- thanks to bepisfever on discord for helping with this part :D

local card_highlighted_ref = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and string.find(self.ability.name, "j_crv_brj") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.create_sell_and_switch_buttons(self, {
				sell = true,
				use = true,
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
		card_highlighted_ref(self, is_highlighted)
	end
end

RevosVault.create_sell_and_switch_buttons = function(card, args)
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
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_modee",
						func = "can_change_mode",
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
												text = localize("crv_mode"),
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
												text = localize("crv_mode2"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.5,
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

G.FUNCS.can_change_mode = function(e)
	local card = e.config.ref_table
	if card.ability.extra["turn"] == "Player" then
		e.config.colour = G.C.RED
		e.config.button = "crv_modee"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.crv_modee = function(e)
	local card = e.config.ref_table
	if card.ability.extra["turn"] == "Player" then
		if card.ability.extra["mode"] == "Joker" then
			card.ability.extra["mode"] = "Self"
		elseif card.ability.extra["mode"] == "Self" then
			card.ability.extra["mode"] = "Joker"
		end
	end
end

--[[local card_highlighted_ref = Card.highlight  // old clicker function
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and string.find(self.ability.name, "j_crv_clicker") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.clicker(self, {
				sell = true,
				use = true,
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
		card_highlighted_ref(self, is_highlighted)
	end
end

RevosVault.clicker = function(card, args)
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
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_clicked",
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
												text = localize("crv_click"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.8,
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

G.FUNCS.crv_clicked = function(e)
	local card = e.config.ref_table
	card.ability.extra["clicks"] = card.ability.extra["clicks"] + 1
	card.ability.extra["chips"] = card.ability.extra["chips"] + card.ability.extra["chipgain"]
end]]

local card_highlighted_ref = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and string.find(self.ability.name, "j_crv_adamap") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.eat(self, {
				sell = true,
				use = true,
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
		card_highlighted_ref(self, is_highlighted)
	end
end

RevosVault.eat = function(card, args)
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
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_eaten",
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
												text = localize("crv_eat"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.8,
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

G.FUNCS.crv_eaten = function(e)
	local card = e.config.ref_table
	card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
	if #SMODS.find_card("j_crv_oldjimbo") > 0 then
		for i = 1, #SMODS.find_card("j_crv_oldjimbo") do
			SMODS.find_card("j_crv_oldjimbo")[1]:start_dissolve()
		end
	end
	if G.STATE ~= G.STATES.SELECTING_HAND then
		return
	end
	G.GAME.chips = G.GAME.blind.chips
	G.STATE = G.STATES.HAND_PLAYED
	G.STATE_COMPLETE = true
	end_round()
end

local card_highlighted_ref = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and string.find(self.ability.name, "j_crv_invest") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.investment(self, {
				sell = true,
				use = true,
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
		card_highlighted_ref(self, is_highlighted)
	end
end

RevosVault.investment = function(card, args)
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
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_invest",
						func = "crv_can_invest",
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
												text = localize("crv_invest"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.6,
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

G.FUNCS.crv_invest = function(e) -- i am way to lazy to fix this right now. I will fix it later.................................................................
	local card = e.config.ref_table
	if card.ability.extra["check"] == false then
		card.ability.extra["check"] = true
		if G.GAME.talisman == 1 then
			card.ability.extra["invested"] = to_number(G.GAME.dollars / 4)
			ease_dollars(-(to_number(G.GAME.dollars / 4)))
		else
			card.ability.extra["invested"] = G.GAME.dollars / 4
			ease_dollars(-(G.GAME.dollars / 4))
		end
	end
end

G.FUNCS.crv_can_invest = function(e)
	local card = e.config.ref_table
	if card.ability.extra["check"] == false then
		e.config.colour = G.C.RED
		e.config.button = "crv_invest"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

local card_highlighted_ref = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and string.find(self.ability.name, "j_crv_roulj") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.betchange(self, {
				sell = true,
				use = true,
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
		card_highlighted_ref(self, is_highlighted)
	end
end

RevosVault.betchange = function(card, args)
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
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_changebet",
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
												text = localize("crv_change"),
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
												text = localize("crv_bet"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.5,
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

G.FUNCS.crv_changebet = function(e)
	local card = e.config.ref_table
	if card.ability.extra["bet"] == "Black" then
		card.ability.extra["bet"] = "Red"
	elseif card.ability.extra["bet"] == "Red" then
		card.ability.extra["bet"] = "Green"
	elseif card.ability.extra["bet"] == "Green" then
		card.ability.extra["bet"] = "Black"
	end
end

local card_highlighted_ref = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
	if self.highlighted and string.find(self.ability.name, "j_crv_dealb") and self.area == G.jokers then
		if self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end

		self.children.use_button = UIBox({
			definition = RevosVault.create_sell_and_switch_buttonsss(self, {
				sell = true,
				use = true,
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
		card_highlighted_ref(self, is_highlighted)
	end
end

RevosVault.create_sell_and_switch_buttonsss = function(card, args)
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
				align = "cr",
			},
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0,
						hover = true,
						shadow = true,
						colour = G.C.RED,
						button = "crv_half",
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
												text = localize("k_half_crv"),
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
												text = localize("k_hblind_crv"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.5,
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

G.FUNCS.crv_half = function(e)
	local card = e.config.ref_table
	card.ability.extra["uses"] = card.ability.extra["uses"] - 1
	G.GAME.blind.chips = G.GAME.blind.chips / 2
	G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
end
