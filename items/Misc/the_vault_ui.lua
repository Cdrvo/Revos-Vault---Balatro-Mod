    local update_shop_old = Game.update_shop
function Game:update_shop(dt)
	if not G.STATE_COMPLETE then
        local vault_exists = not not G.vault
        G.vault = G.vault or UIBox{
            definition = G.UIDEF.vault(),
            config = {align='tmi', offset = {x=0,y=G.ROOM.T.y+11},major = G.hand, bond = 'Weak'}
        }
		G.E_MANAGER:add_event(Event({
                func = function()
                    G.vault.alignment.offset.y = (G.ROOM.T.y or 0.7) + 29
                    G.vault.alignment.offset.x = 0
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        blockable = false,
                        func = function()
                            if math.abs(G.vault.T.y - G.vault.VT.y) < 3 then
                                local nosave_vault = nil
                                if not vault_exists then
                                
                                    if G.load_vault_card then 
                                        nosave_vault = true
                                        G.vault_card:load(G.load_vault_card)
                                        G.load_vault_card = nil
                                    end
                                    
                                    
								end
                                if not nosave_vault then G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end})) end
                                return true
                            end
                        end}))
                    return true
                end
            }))
    end  
	return update_shop_old(self, dt)
end
    
    function G.UIDEF.vault()

        G.vault_card = CardArea(
            G.hand.T.x+0,
            G.hand.T.y+G.ROOM.T.y + 9,
            1*1.02*G.CARD_W,
            1.05*G.CARD_H, 
            {card_limit = 1, type = 'shop', highlight_limit = 1}
        )

        
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            G.SHOP_SIGN.alignment.offset.y = 0
            return true
        end)
        }))


        local t = {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={
            
            {n=G.UIT.R, config={align = "cl", padding = 0, emboss = 0.05, r = 1, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.14, emboss = 0.05, r = 1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
                        {n=G.UIT.C,config={id = 'crv_take_to_shop', align = "cm", minw = 0.9, minh = 0.9, r=0.15,colour = G.C.RED, button = 'take_me_back', hover = true,shadow = false}, nodes = {
                            {n=G.UIT.R, config={align = "cm", padding = 0.1, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                                {n=G.UIT.R, config={align = "cm", maxw = 1.5}, nodes={
                                {n=G.UIT.T, config={text = "Return to", scale = 0.4, colour = G.C.WHITE, shadow = false}},
                                }},
                                {n=G.UIT.R, config={align = "cm", maxw = 1.5}, nodes={
                                {n=G.UIT.T, config={text = "Shop", scale = 0.4, colour = G.C.WHITE, shadow = false}},
                                }},
                            }},        
                            }},
                    
                }},
            }},
                UIBox_dyn_container({
                    {n=G.UIT.R, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={

                            --
                        {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN,shadow = false}, nodes={
                            {n=G.UIT.R,config={id = 'crv_vault_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.PURPLE, button = 'crv_vault_vault', func = "crv_vault_vault_can", hover = true,shadow = false}, nodes = {
                            {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={text = TheVault.current_vault_text, scale = 0.4, colour = G.C.WHITE, shadow = false}}
                                }},
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={ref_table = TheVault, ref_value = 'vault_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
                                {n=G.UIT.T, config={text = (" " .. "Souls"), scale = 0.7, colour = G.C.WHITE, shadow = true}},
                                }}   
                            }},        
                            }},

                            {n=G.UIT.R,config={id = 'crv_enhance_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.DARK_EDITION,button = 'crv_vault_enhance',func = "crv_vault_enhance_can", hover = true,shadow = false}, nodes = {
                            {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={text = "Enhance", scale = 0.4, colour = G.C.WHITE, shadow = true}}
                                }},
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={ref_table = TheVault, ref_value = 'enhance_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
                                {n=G.UIT.T, config={text = (" " .. "Souls"), scale = 0.7, colour = G.C.WHITE, shadow = true}},
                                }}   
                            }},        
                            }},
                        }},
                            --


                        {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN,shadow = false}, nodes={

                            {n=G.UIT.R, config={align = "cm", padding = 0.1, emboss = 0, r = 0.2, colour = G.C.CLEAR}, nodes={
                                {n=G.UIT.T, config={text = "PUT JOKER", scale = 0.4, colour = G.C.L_BLACK, shadow = false}},


                                {n=G.UIT.C,config={id = 'crv_help_button', align = "cm", minw = 0.4, minh = 0.5, r=0.15,colour = G.C.L_BLACK, one_press = false, button = 'crv_vault_help', func = "crv_vault_help_can", hover = true,shadow = false}, nodes = {
                                {n=G.UIT.R, config={align = "cm", padding = 0, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                                    {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                    {n=G.UIT.T, config={text = "?", scale = 0.4, colour = G.C.WHITE, shadow = false}}
                                    }},
                                }},        
                            }},


                            }},
                            {n=G.UIT.R, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
                                {n=G.UIT.O, config={object = G.vault_card}},
                            }},
                            {n=G.UIT.R, config={align = "cm", padding = 0.1, emboss = 0, r = 0.2, colour = G.C.CLEAR}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'souls', prefix = ("Souls:" .. " ")}}, maxw = 1.35, colours = {G.C.BLUE}, font = G.LANGUAGES['en-us'].font, shadow = false,spacing = 2, bump = true, scale = 0.4}), id = 'soul_text_UI'}}
                            }},
                        }},
                            --


                        {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN,shadow = false}, nodes={
                            {n=G.UIT.R,config={id = 'crv_upgrade_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.RED, one_press = false, button = 'crv_vault_upgrade', func = "crv_vault_upgrade_can", hover = true,shadow = false}, nodes = {
                            {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={text = "Upgrade", scale = 0.4, colour = G.C.WHITE, shadow = false}}
                                }},
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={ref_table = TheVault, ref_value = 'upgrade_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
                                {n=G.UIT.T, config={text = (" " .. "Souls"), scale = 0.7, colour = G.C.WHITE, shadow = true}},
                                }}   
                            }},        
                            }},

                            
                            {n=G.UIT.R,config={id = 'crv_harvest_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.BLUE, one_press = false, button = 'crv_vault_harvest', func = "crv_vault_harvest_can", hover = true,shadow = false}, nodes = {
                            {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={text = "Harvest", scale = 0.4, colour = G.C.WHITE, shadow = false}}
                                }},
                                {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={ref_table = TheVault, ref_value = 'harvest_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
                                {n=G.UIT.T, config={text = (" " .. "Souls"), scale = 0.7, colour = G.C.WHITE, shadow = true}},
                                }}   
                            }},   
                                 
                            }},

                        }},

                    },
                    
                },
                
                },
                
                false),
            },

        }
        return t
    end


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
                        {n = G.UIT.R, config = {align = "cm", minh = 0.1}}
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

RevosVault.help_button = function(func)
    G.FUNCS[func] = G.FUNCS[func] or function(e)
        G.FUNCS.RevosVault_info { menu_type = func }
    end
    return
    {n=G.UIT.R, config = {align = 'br', padding = -0.3}, nodes = {
        {n=G.UIT.C, config = {align = 'tm', colour = G.C.RED, r = 0.8, padding = 0.025, minw = 0.5, minh = 0.6, emboss = 0.05, hover = true, button = func, button_dist = 0.1}, nodes = {
            {n=G.UIT.T, config = {text = '?', colour = G.C.WHITE, scale = 0.35}}
        }},
        {n=G.UIT.C, config = {minw = 0.85}}
    }}
end