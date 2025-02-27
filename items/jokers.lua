SMODS.Rarity {
    key = "p",
    badge_colour = G.C.RARITY[3],
    pools = {
        ["Joker"] = {
            rate = 0.01
        }
    },
    default_weight = 0.01
}

SMODS.Rarity {
    key = "holy",
    badge_colour = G.C.RARITY[2],
    pools = {}
}

SMODS.Rarity {
    key = "pedro",
    badge_colour = G.C.RARITY[3],
    pools = {}
}

SMODS.Rarity {
    key = "tit",
    badge_colour = G.C.RARITY[4],

    pools = {}
}

SMODS.Joker {
    key = 'revoo_',
    config = {
        extra = {
            xmult = 1,
            xmultg = 2
        }
    },
    rarity = 4,
    atlas = 'rev',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 1,
        y = 0
    },
    soul_pos = {
        x = 0,
        y = 0
    },
    cost = 20,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.xmultg}
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 14 and not context.blueprint and not context.repetition then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultg
                return {
                    message = localize('k_upgrade_ex')
                }

            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'spuzzypp',
    config = {
        extra = {
            chips = 50
        }
    },
    rarity = 4,
    atlas = 'rev',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 1,
        y = 1
    },
    soul_pos = {
        x = 0,
        y = 1
    },
    cost = 20,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.chips}
        }
    end,
    calculate = function(self, card, context)
        if context.individual then
            if context.cardarea == G.play then
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus +
                                                             card.ability.extra.chips
                for k, v in ipairs(context.scoring_hand) do
                    if context.other_card.ability.effect == "Base" then
                        context.other_card:set_ability(G.P_CENTERS[SMODS.poll_enhancement({
                            guaranteed = true
                        })], true, false)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                return true
                            end
                        }))
                    end

                    return {
                        extra = {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.CHIPS
                        },
                        colour = G.C.CHIPS
                    }
                end
            end
        end
        if context.end_of_round and context.main_eval then
            card.ability.extra.chips = card.ability.extra.chips + 10
            return {
                message = '+10!',
                colour = G.C.CHIPS

            }
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}
local scraps = {"c_crv_horn", "c_crv_mp", "c_crv_pickles", "c_crv_ap", "c_crv_dc"}
local adamc = {1, 2, 3}
local lpmc = {1, 2, 3, 4}

SMODS.Joker {
    key = 'adam_',
    config = {
        extra = {
            xmult = 1,
            xmultg = 0.5,
            scrapc = 0
        }
    },
    rarity = 4,
    atlas = 'rev',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 1,
        y = 2
    },
    soul_pos = {
        x = 0,
        y = 2
    },
    cost = 20,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.xmultg, card.ability.extra.scrapc}
        }
    end,
    calculate = function(self, card, context)
        if context.reroll_shop then
            local adamcc = pseudorandom_element(adamc, pseudoseed('adam_'))
            if adamcc == 1 then
                local scrap = pseudorandom_element(scraps, pseudoseed('adam_'))
                SMODS.add_card({
                    area = G.consumeables,
                    key = scrap
                })
            end
        end
        if context.using_consumeable and context.consumeable.config.center.key == 'c_crv_mp' and not context.blueprint or
            context.using_consumeable and context.consumeable.config.center.key == 'c_crv_pickles' and
            not context.blueprint or context.using_consumeable and context.consumeable.config.center.key == 'c_crv_horn' and
            not context.blueprint or context.using_consumeable and context.consumeable.config.center.key == 'c_crv_ap' and
            not context.blueprint or context.using_consumeable and context.consumeable.config.center.key == 'c_crv_dc' and
            not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultg
            card.ability.extra.scrapc = card.ability.extra.scrapc + 1
        end
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
        if (card.ability.extra.scrapc == 5) then
            card.ability.extra.scrapc = 0
            SMODS.add_card({
                set = "Spectral",
                area = G.consumeables,
                edition = "e_negative",
                soulable = true
            })
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'chainsawm',
    config = {
        extra = {
            xmult = 1,
            xmultg = 0.1
        }
    },
    rarity = 4,
    atlas = 'rev',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 1,
        y = 3
    },
    soul_pos = {
        x = 0,
        y = 3
    },
    cost = 20,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.xmultg}
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() >= 2 and context.other_card:get_id() < 11 and not context.blueprint and
                not context.repetition then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultg
                return {
                    message = localize('k_upgrade_ex')
                }

            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'snayn3',
    config = {
        extra = {
            xmult = 3,
            timer = 0
        }
    },
    rarity = 4,
    atlas = 'rev',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 1,
        y = 4
    },
    soul_pos = {
        x = 0,
        y = 4
    },
    cost = 20,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.timer}
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.timer = card.ability.extra.timer + 1
        end
        if (card.ability.extra.timer > 5) then
            card.ability.extra.timer = 5
        end
        if context.joker_main and G.GAME.current_round.hands_left == 1 and card.ability.extra.timer == 5 then
            card.ability.extra.timer = 0
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                    G.jokers:remove_card(card)
                    card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    card = nil
                    return true;
                end
            }))
            local new_card = create_card('Giant', G.jokers, nil, nil, nil, nil, 'j_crv_snayn32')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
        if context.joker_main and not G.GAME.current_round.hands_left == 1 then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end

}

SMODS.Joker {
    key = 'snayn32',
    config = {
        extra = {
            xmult = 20
        }
    },
    rarity = 'crv_tit',
    atlas = 'rev',
    blueprint_compat = true,
    discovered = false,
    no_collection = true,
    pos = {
        x = 1,
        y = 5
    },
    soul_pos = {
        x = 0,
        y = 5
    },
    cost = 25,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
        if context.end_of_round and context.main_eval then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                    G.jokers:remove_card(card)
                    card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    card = nil
                    return true;
                end
            }))
            local new_card = create_card('Eren', G.jokers, nil, nil, nil, nil, 'j_crv_snayn3')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end

}

SMODS.Joker {
    key = '_pease',
    config = {
        extra = {
            xmult = 1.5,
            xmultg = 0.5
        }
    },
    rarity = 4,
    atlas = 'rev',
    blueprint_compat = true,
    discovered = false,
    no_collection = false,
    pos = {
        x = 3,
        y = 0
    },
    soul_pos = {
        x = 2,
        y = 0
    },
    cost = 20,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult,card.ability.extra.xmultg}
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 13 then
                if context.other_card.ability.effect == "Base" then
                context.other_card:set_ability(G.P_CENTERS["m_glass"])
                end
            return {
                x_mult = card.ability.extra.xmult ,
                card = card.other_card
                }
            end
        end
        if context.destroy_card and context.cardarea == G.play then
            if context.destroy_card:get_id() ~= 13 then
                if context.destroy_card:is_face() then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultg
                return {
                    remove = true,
                    message = localize("k_upgrade_ex")
                }
            end
        end
    end
end

}

SMODS.Joker {
    key = 'holybanana',
    config = {
        extra = {
            xmult = 4011,
            chips = 4011,
            odds = 4011
        }
    },
    rarity = 'crv_holy',
    atlas = 'holybanana',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 0,
        y = 0
    },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.chips, (G.GAME.probabilities.normal or 1),
                    card.ability.extra.odds}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult,
                chips = card.ability.extra.chips
            }
        end
        if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
            if pseudorandom('holybanana') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end

                        }))
                        return true
                    end
                }))
                G.GAME.pool_flags.holybanana_extinct = true
                return {
                    message = localize('k_crv_std_ex'),
                    delay(0.6)
                }
            else
                return {
                    message = localize('k_crv_sbg_ex'),
                    delay(0.6)
                }
            end
        end
    end
}
SMODS.Joker {
    key = 'pedro',
    config = {
        extra = {
            xmult = 42831398,
            chips = 42831398
        }
    },
    rarity = 'crv_pedro',
    atlas = 'pedro',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 0,
        y = 0
    },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.chips}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult,
                chips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker {
    key = 'printer',
    atlas = 'Jokers',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 0,
        y = 0
    },
    config = {
        extra = {}
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_blueprint
    end,

    calculate = function(self, card, context)

        if context.setting_blind and not context.blueprint then
            local new_card = create_card('Blueprint', G.jokers, nil, nil, nil, nil, 'j_blueprint')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'rustyprinter',
    atlas = 'Jokers',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 1,
        y = 0
    },
    config = {
        extra = {}
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_brainstorm
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local new_card = create_card('Brainstorm', G.jokers, nil, nil, nil, nil, 'j_brainstorm')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        end
    end,

    in_pool = function(self, wawa, wawa2)

        return true
    end
}

SMODS.Joker {
    key = 'jimboprinter',
    atlas = 'Jokers',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 2,
        y = 0
    },
    config = {
        extra = {}
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_joker
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_joker')
            new_card:set_edition({
                negative = true
            }, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,

    in_pool = function(self, wawa, wawa2)

        return true
    end
}

SMODS.Joker {
    key = 'grossprinter',
    atlas = 'Jokers',
    rarity = 'crv_p',

    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 0,
        y = 1
    },
    config = {
        extra = {
            odds = 100,
            odds2 = 1011

        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_gros_michel
        info_queue[#info_queue + 1] = G.P_CENTERS.j_cavendish
        info_queue[#info_queue + 1] = G.P_CENTERS.j_crv_holybanana
        info_queue[#info_queue + 1] = G.P_CENTERS.j_crv_pedro
        return {
            vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.odds2}
        }
    end,

    calculate = function(self, card, context)

        if context.setting_blind and pseudorandom('grossprinter') < G.GAME.probabilities.normal /
            card.ability.extra.odds then
            local new_card = create_card('Cavendish', G.jokers, nil, nil, nil, nil, 'j_cavendish')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        elseif context.setting_blind then
            local new_card = create_card('Gros Michel', G.jokers, nil, nil, nil, nil, 'j_gros_michel')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
        if context.setting_blind and pseudorandom('grossprinter') < G.GAME.probabilities.normal /
            card.ability.extra.odds2 then
            local new_card = create_card('Holy Banana', G.jokers, nil, nil, nil, nil, 'j_crv_holybanana')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
        if G.GAME.pool_flags.holybanana_extinct == true and context.setting_blind and
            not (#SMODS.find_card('j_crv_pedro') >= 1) then
            local new_card = create_card('Pedro', G.jokers, nil, nil, nil, nil, 'j_crv_pedro')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,

    in_pool = function(self, wawa, wawa2)

        return true
    end
}

SMODS.Joker {
    key = 'obeliskprinter',
    atlas = 'Jokers',
    rarity = 'crv_p',

    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 1,
        y = 1
    },
    config = {
        extra = {}
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_obelisk
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local new_card = create_card('Obelisk', G.jokers, nil, nil, nil, nil, 'j_obelisk')
            new_card:set_edition({
                negative = true
            }, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'moneyprinter',
    atlas = 'Jokers',
    rarity = 'crv_p',

    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 2,
        y = 1
    },
    config = {
        extra = {}
    },

    in_pool = function(self, wawa, wawa2)
        return true
    end,

    calc_dollar_bonus = function(self, card)
        return 35
    end
}

SMODS.Joker {
    key = 'brokenprinter',
    atlas = 'Jokers',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 0,
        y = 2
    },
    config = {
        extra = {}
    },
    calculate = function(self, card, context)
        if context.setting_blind then
            SMODS.add_card({
                set = "Joker",
                area = G.jokers
            })
        end
    end,

    in_pool = function(self, wawa, wawa2)

        return true
    end
}

SMODS.Joker {
    key = 'faxprinter',
    config = {
        extra = {
            odds = 4
        }
    },
    discovered = false,
    unlocked = true,
    rarity = 'crv_p',
    atlas = 'Jokers',
    blueprint_compat = true,
    pos = {
        x = 1,
        y = 2
    },
    cost = 10,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_crv_pprwork
        return {
            vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.odds}
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            if pseudorandom('faxprinter') < G.GAME.probabilities.normal / card.ability.extra.odds then
                local new_card = create_card('Paper Work', G.jokers, nil, nil, nil, nil, 'j_crv_pprwork')
                new_card:add_to_deck()
                G.jokers:emplace(new_card)
            end
        end
    end,

    in_pool = function(self, wawa, wawa2)

        return true
    end

}

SMODS.Joker {
    key = 'pprwork',
    config = {
        extra = {
            chips = 20.4,
            mult = 9.8
        }
    },
    rarity = 2,
    atlas = 'Jokers',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 2,
        y = 2
    },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.chips, card.ability.extra.mult}
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() >= 2 and context.other_card:get_id() <= 9 then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    card = card.other_card
                }
            end
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return false
    end
}

SMODS.Joker {
    key = 'spectralprinter',
    atlas = 'Jokers',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 0,
        y = 3
    },
    config = {
        extra = {}
    },
    calculate = function(self, card, context)
        if context.setting_blind then
            SMODS.add_card({
                set = "Spectral",
                area = G.consumeables,
                edition = "e_negative"
            })
        end
    end,
    in_pool = function(self, wawa, wawa2)

        return true
    end
}

SMODS.Joker {
    key = 'legendaryprinter',
    atlas = 'Jokers',
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 1,
        y = 3
    },
    soul_pos = {
        x = 3,
        y = 3
    },
    config = {
        extra = {
            odds = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.odds}
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            if pseudorandom('legendaryprinter') < G.GAME.probabilities.normal / card.ability.extra.odds then
                SMODS.add_card({
                    set = "Joker",
                    area = G.jokers,
                    legendary = true,
                    edition = "e_negative",
                    stickers = {"perishable"}
                })
            end
        end
    end,
    in_pool = function(self, wawa, wawa2)

        return false
    end
}

SMODS.Joker {
    key = 'glassprinter',
    atlas = 'Jokers',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 2,
        y = 3
    },
    config = {
        extra = {
            odds = 16
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_glassdocument
        return {
            vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.odds}
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            if pseudorandom('glassprinter') < G.GAME.probabilities.normal / card.ability.extra.odds then
                local new_card =
                    create_card('Glass Document', G.consumeables, nil, nil, nil, nil, 'c_crv_glassdocument')
                new_card:add_to_deck()
                G.consumeables:emplace(new_card)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.jokers:remove_card(card)
                                card:shatter()
                                card = nil
                                return true;
                            end
                        }))
                        return true
                    end
                }))
            else
                local new_card =
                    create_card('Glass Document', G.consumeables, nil, nil, nil, nil, 'c_crv_glassdocument')
                new_card:add_to_deck()
                G.consumeables:emplace(new_card)
            end
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'steelprinter',
    atlas = 'Jokers2',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 1,
        y = 0
    },
    config = {
        extra = {
            xmult = 1.5
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_steeldocument
        return {
            vars = {card.ability.extra.xmult}
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local new_card = create_card('Steel Document', G.consumeables, nil, nil, nil, nil, 'c_crv_steeldocument')
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)
        end
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'smile',
    atlas = 'Jokers',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 3,
        y = 0
    },
    config = {
        extra = {
            odds = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_photograph
        return {
            vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.odds}
        }
    end,
    calculate = function(self, card, context)
        if (#SMODS.find_card('j_joker') > 0) and context.setting_blind and pseudorandom('smile') <
            G.GAME.probabilities.normal / card.ability.extra.odds then
            local new_card = create_card('Photograph', G.jokers, nil, nil, nil, nil, 'j_photograph')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'lpm',
    atlas = 'Jokers',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 3,
        y = 1
    },
    config = {
        extra = {
            mult = 0,
            mult_gain = 15
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.mult, card.ability.extra.mult_gain}
        }
    end,
    calculate = function(self, card, context)
        if context.reroll_shop then
            local lpmcc = pseudorandom_element(lpmc, pseudoseed('lpm'))
            if lpmcc == 1 then
                local scrap = pseudorandom_element(scraps, pseudoseed('lpm'))
                SMODS.add_card({
                    area = G.consumeables,
                    key = scrap
                })
            end
        end
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = {card.ability.extra.mult}
                }
            }
        end
        if context.using_consumeable and context.consumeable.config.center.key == 'c_crv_mp' and not context.blueprint or
            context.using_consumeable and context.consumeable.config.center.key == 'c_crv_pickles' and
            not context.blueprint or context.using_consumeable and context.consumeable.config.center.key == 'c_crv_horn' and
            not context.blueprint or context.using_consumeable and context.consumeable.config.center.key == 'c_crv_ap' and
            not context.blueprint or context.using_consumeable and context.consumeable.config.center.key == 'c_crv_dc' and
            not context.blueprint then

            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                message = localize('k_crv_cbm_ex'),
                delay = 1.3
            }
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end

}

SMODS.Joker {
    key = 'devilishprinter',
    atlas = 'Jokers2',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 0,
        y = 0
    },
    config = {
        extra = {
            odds = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_devilscontract
        return {
            vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.odds}
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and pseudorandom('devilishprinter') < G.GAME.probabilities.normal /
            card.ability.extra.odds then
            local new_card = create_card("Devil's Contract", G.consumeables, nil, nil, nil, nil, 'c_crv_devilscontract')
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'head',
    atlas = 'megaprinter',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 0,
        y = 0
    },
    config = {
        extra = {
            mult = 25
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_megadoc
        return {
            vars = {card.ability.extra.mult}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = {card.ability.extra.mult}
                }
            }
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'body',
    atlas = 'megaprinter',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 1,
        y = 0
    },
    config = {
        extra = {
            mult = 30
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_megadoc
        return {
            vars = {card.ability.extra.mult}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = {card.ability.extra.mult}
                }
            }
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'back',
    atlas = 'megaprinter',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 2,
        y = 0
    },
    config = {
        extra = {
            mult = 25
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_megadoc
        return {
            vars = {card.ability.extra.mult}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = {card.ability.extra.mult}
                }
            }
        end
        if (#SMODS.find_card('j_crv_head') > 0) and (#SMODS.find_card('j_crv_body') > 0) and context.setting_blind then
            local new_card = create_card("Mega", G.consumeables, nil, nil, nil, nil, "c_crv_megadoc")
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'tierp',
    atlas = 'Jokers2',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 2,
        y = 0
    },
    config = {
        extra = {
            timer = 0,
            timer2 = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_t1doc
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_t2doc
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_t3doc
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_boostdoc
        return {
            vars = {card.ability.extra.timer, card.ability.extra.timer2}
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and (card.ability.extra.timer == 15) and not (card.ability.extra.timer2 == 5) then
            local new_card = create_card('Tier 3 Document', G.consumeables, nil, nil, nil, nil, 'c_crv_t3doc')
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)
        elseif context.setting_blind and (card.ability.extra.timer >= 5) and not (card.ability.extra.timer == 15) then
            local new_card = create_card('Tier 2 Document', G.consumeables, nil, nil, nil, nil, 'c_crv_t2doc')
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)

        else
            if context.setting_blind and not (card.ability.extra.timer > 4) then
                local new_card = create_card('Tier 1 Document', G.consumeables, nil, nil, nil, nil, 'c_crv_t1doc')
                new_card:add_to_deck()
                G.consumeables:emplace(new_card)
            end
        end
        if context.end_of_round and not context.repetition and not context.individual and
            not (card.ability.extra.timer == 15) and not context.blueprint then
            card.ability.extra.timer = card.ability.extra.timer + 1
        end
        if context.end_of_round and not context.repetition and not context.individual and
            (card.ability.extra.timer == 15) and not (card.ability.extra.timer2 == 5) and not context.blueprint then
            card.ability.extra.timer2 = card.ability.extra.timer2 + 1
        end
        if context.setting_blind and (card.ability.extra.timer2 == 5) then
            local new_card = create_card('Boosted Document', G.consumeables, nil, nil, nil, nil, 'c_crv_boostdoc')
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)
            card.ability.extra.timer2 = 0
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'luckyprinter',
    atlas = 'Jokers2',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 0,
        y = 1
    },
    config = {
        extra = {
            odds = 4
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_luckydocument
        return {
            vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.odds}
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            if pseudorandom('luckyprinter') < G.GAME.probabilities.normal / card.ability.extra.odds then
                local new_card =
                    create_card('Lucky Document', G.consumeables, nil, nil, nil, nil, 'c_crv_luckydocument')
                new_card:add_to_deck()
                G.consumeables:emplace(new_card)
                local new_card2 = create_card('Lucky Document', G.consumeables, nil, nil, nil, nil,
                    'c_crv_luckydocument')
                new_card2:add_to_deck()
                G.consumeables:emplace(new_card2)
            else
                local new_card =
                    create_card('Lucky Document', G.consumeables, nil, nil, nil, nil, 'c_crv_luckydocument')
                new_card:add_to_deck()
                G.consumeables:emplace(new_card)
            end
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'celestialprinter',
    atlas = 'Jokers2',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 1,
        y = 1
    },
    config = {
        extra = {}
    },
    calculate = function(self, card, context)
        if context.setting_blind then
            SMODS.add_card({
                set = "Planet",
                area = G.consumeables,
                edition = "e_negative"
            })

        end
    end,
    in_pool = function(self, wawa, wawa2)

        return true
    end
}

SMODS.Joker {
    key = 'pcp',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_polydoc
        return {
            vars = {card.ability.extra.xmult}
        }
    end,
    atlas = 'Jokers2',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 2,
        y = 4
    },
    config = {
        extra = {
            xmult = 1.5
        }
    },

    calculate = function(self, card, context)

        if context.setting_blind then
            local new_card = create_card('Polychrome Document', G.consumeables, nil, nil, nil, nil, 'c_crv_polydoc')
            new_card:add_to_deck()
            new_card:set_edition({
                polychrome = true
            }, true)
            G.consumeables:emplace(new_card)
        end
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end,
    draw = function(self, card, layer)
        card.children.center:draw_shader('polychrome', nil, card.ARGS.send_to_shader)
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'fcp',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_foildoc
        return {
            vars = {card.ability.extra.chips}
        }
    end,
    atlas = 'Jokers2',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 0,
        y = 4
    },
    config = {
        extra = {
            chips = 50
        }
    },

    calculate = function(self, card, context)

        if context.setting_blind then
            local new_card = create_card('Foil Document', G.consumeables, nil, nil, nil, nil, 'c_crv_foildoc')
            new_card:add_to_deck()
            new_card:set_edition({
                foil = true
            }, true)
            G.consumeables:emplace(new_card)
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
    draw = function(self, card, layer)
        card.children.center:draw_shader('foil', nil, card.ARGS.send_to_shader)
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'hcp',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_holdoc
        return {
            vars = {card.ability.extra.mult}
        }
    end,
    atlas = 'Jokers2',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 1,
        y = 4
    },
    config = {
        extra = {
            mult = 10
        }
    },

    calculate = function(self, card, context)

        if context.setting_blind then
            local new_card = create_card('Holographic Document', G.consumeables, nil, nil, nil, nil, 'c_crv_holdoc')
            new_card:add_to_deck()
            new_card:set_edition({
                holo = true
            }, true)
            G.consumeables:emplace(new_card)
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    draw = function(self, card, layer)
        card.children.center:draw_shader('holo', nil, card.ARGS.send_to_shader)
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'ncp',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_negdoc
        return {
            vars = {}
        }
    end,
    atlas = 'Jokers2',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 3,
        y = 4
    },
    config = {
        extra = {
            counter = 1
        }
    },

    calculate = function(self, card, context)

        if context.setting_blind then
            local new_card = create_card('Negative Document', G.consumeables, nil, nil, nil, nil, 'c_crv_negdoc')
            new_card:add_to_deck()
            new_card:set_edition({
                negative = true
            }, true)
            G.consumeables:emplace(new_card)
        end
    end,
    draw = function(self, card, layer)
        card.children.center:draw_shader('negative', nil, card.ARGS.send_to_shader)
        card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - 1
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'ucp',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_crv_uedoc
        return {
            vars = {}
        }
    end,
    atlas = 'Jokers2',
    rarity = 'crv_p',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 4,
        y = 6
    },
    config = {
        extra = {}
    },

    calculate = function(self, card, context)

        if context.setting_blind then
            SMODS.add_card({
                area = G.consumeables,
                key = 'c_crv_uedoc'
            })
        end
    end,
    draw = function(self, card, layer)
        card.children.center:draw_shader('polychrome', nil, card.ARGS.send_to_shader)
        card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
    end
}

SMODS.Joker {
    key = 'urp',
    config = {
        extra = {
            one = 0
        }
    },
    rarity = 'crv_p',
    atlas = 'Jokers2',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 3,
        y = 1
    },
    cost = 10,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {}
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and #G.jokers.cards > 1 and (card.ability.extra.one == 0) then
            local rr = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    rr = i;
                    break
                end
            end
            if G.jokers.cards[rr + 1] ~= nil then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local card2 = copy_card(G.jokers.cards[rr + 1], nil, nil, G.jokers.cards[i] == card)
                        card2:add_to_deck()
                        G.jokers:emplace(card2)
                        return true
                    end
                }))
            end
            if rr and G.jokers.cards[rr + 1] then
            end
        end

    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'ghostbanana',
    atlas = 'gb',
    rarity = 2,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 0,
        y = 0
    },
    config = {
        extra = {
            chips = 100
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_crv_ghostslices
        return {
            vars = {card.ability.extra.chips}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
        if context.setting_blind and #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
            local new_card = create_card('Ghost Slices', G.jokers, nil, nil, nil, nil, 'j_crv_ghostslices')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'ghostslices',
    atlas = 'gb',
    rarity = 1,
    cost = 1,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 1,
        y = 0
    },
    config = {
        extra = {
            chips = 50
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.chips}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return false
    end
}

SMODS.Joker {
    key = 'plantain',
    atlas = 'gban',
    no_pool_flag = 'pex',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 1,
        y = 0
    },
    config = {
        extra = {
            timer = 0,
            xmult = 2,
            odds = 12
        }

    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.timer, card.ability.extra.xmult, (G.GAME.probabilities.normal or 1),
                    card.ability.extra.odds}
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual and
            not (card.ability.extra.timer == 3) then
            card.ability.extra.timer = card.ability.extra.timer + 1
        end
        if context.joker_main and card.ability.extra.timer == 3 then
            return {
                x_mult = card.ability.extra.xmult
            }

        end
        if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
            if card.ability.extra.timer == 3 then
                if pseudorandom('plantin') < G.GAME.probabilities.normal / card.ability.extra.odds and
                    not context.blueprint then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.3,
                                blockable = false,
                                func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                    return true;
                                end

                            }))
                            return true
                        end
                    }))
                    G.GAME.pool_flags.pex = true
                    return {
                        message = localize('k_extinct_ex'),
                        delay(0.6)
                    }
                else
                    return {
                        message = localize('k_safe_ex'),
                        delay(0.6)
                    }
                end
            end
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'reban',
    atlas = 'gban',
    no_pool_flag = 'rex',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 0,
        y = 0
    },
    config = {
        extra = {
            mult = 30,
            odds = 8
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.mult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
            if pseudorandom('reban') < G.GAME.probabilities.normal / card.ability.extra.odds and not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end

                        }))
                        return true
                    end
                }))
                G.GAME.pool_flags.rex = true
                return {
                    message = localize('k_extinct_ex'),
                    delay(0.6)
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    delay(0.6)
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'tundan',
    atlas = 'gban',
    no_pool_flag = 'lex',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 2,
        y = 0
    },
    config = {
        extra = {
            chips = 0,
            odds = 8,
            chip_gain = 15
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.chips, (G.GAME.probabilities.normal or 1), card.ability.extra.odds,
                    card.ability.extra.chip_gain}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
        if context.end_of_round and not context.repetition and not context.blueprint and not context.individual and
            not (#SMODS.find_card('j_gros_michel') >= 1) then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS,
                card = card
            }
        end
        if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
            if pseudorandom('tundan') < G.GAME.probabilities.normal / card.ability.extra.odds and not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end

                        }))
                        return true
                    end
                }))
                G.GAME.pool_flags.lex = true
                return {
                    message = localize('k_extinct_ex'),
                    delay(0.6)
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    delay(0.6)
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'bluj',
    atlas = 'gban',
    no_pool_flag = 'bex',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 0,
        y = 1
    },
    config = {
        extra = {
            mult = 25,
            mult_r = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.mult, card.ability.extra.mult_r}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
            if not (card.ability.extra.mult == 1) then
                card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_r
                return {
                    message = localize('k_crv_yum'),
                    colour = G.C.MULT,
                    card = card
                }
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        }))
                        return true
                    end
                }))
                G.GAME.pool_flags.bex = true
                return {
                    message = localize('k_crv_eaten_ex')
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'bananavine',
    atlas = 'gban',
    no_pool_flag = 'gex',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 1,
        y = 1
    },
    config = {
        extra = {
            timer = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_gros_michel
        return {
            vars = {card.ability.extra.timer}
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and not context.repetition and not context.individual then
            if card.ability.extra.timer < 3 then
                card.ability.extra.timer = card.ability.extra.timer + 1
                local new_card = create_card('Gros Michel', G.jokers, nil, nil, nil, nil, 'j_gros_michel')
                new_card:add_to_deck()
                G.jokers:emplace(new_card)
            end
            if context.setting_blind and (card.ability.extra.timer == 3) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        }))
                        return true
                    end
                }))
                G.GAME.pool_flags.gex = true
                return {
                    message = localize('k_crv_ofb_ex')
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'plainb',
    atlas = 'gban',
    no_pool_flag = 'pex2',
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 2,
        y = 1
    },
    config = {
        extra = {
            extra_value = 3,
            odds = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.extra_value, (G.GAME.probabilities.normal or 1), card.ability.extra.odds}
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            if pseudorandom('plainb') < G.GAME.probabilities.normal / card.ability.extra.odds and not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end

                        }))
                        return true
                    end
                }))
                G.GAME.pool_flags.pex2 = true
                return {
                    message = localize('k_extinct_ex'),
                    delay(0.6)
                }
            else
                card.ability.extra_value = card.ability.extra_value + 15
                card:set_cost()
                return {
                    message = localize('k_val_up'),
                    delay(0.6)
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'tickingb',
    atlas = 'gban',
    no_pool_flag = 'tex',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 1,
        y = 2
    },
    config = {
        extra = {
            xmult = 15,
            timer = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.timer}
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual and
            not (card.ability.extra.timer == 3) and not context.blueprint then
            card.ability.extra.timer = card.ability.extra.timer + 1
        end
        if context.joker_main then
            if (card.ability.extra.timer == 3) then
                return {
                    x_mult = card.ability.extra.xmult
                }, G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 1.5,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        }))
                        G.GAME.pool_flags.tex = true
                        return true
                    end
                }))

            end
        end
    end

}
local rkeys = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10'}
SMODS.Joker {
    key = 'uneasyb',
    config = {
        extra = {
            xmult = 15
        }
    },
    rarity = 2,
    atlas = 'gban',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 0,
        y = 2
    },
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
        if context.setting_blind then
            local random_key = rkeys[math.random(#rkeys)]
            if (random_key == '5') and not context.repetition and not context.individual then
                G.STATE = G.STATES.GAME_OVER
                G.STATE_COMPLETE = false
            end

        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}

function bfps()
    local bfps2 = 0
    if G.playing_cards then
        for _, v in pairs(G.playing_cards) do
            if SMODS.has_enhancement(v, 'm_crv_bulletproofglass') then
                bfps2 = bfps2 + 1
            end
        end
        return bfps2
    end
    return 0
end

SMODS.Joker {
    key = 'bpj',
    config = {
        extra = {
            x_gain = 0.4,
            bfps()
        }
    },

    rarity = 2,
    atlas = 'Jokers2',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 0,
        y = 2
    },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_bulletproofglass
        return {
            vars = {card.ability.extra.x_gain * bfps() + 1, card.ability.extra.x_gain, bfps()}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if bfps() > 0 then
                return {
                    x_mult = bfps() * card.ability.extra.x_gain + 1
                }
            end
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

function dcs()
    local dcss = 0
    if G.playing_cards then
        for _, v in pairs(G.playing_cards) do
            if SMODS.has_enhancement(v, 'm_crv_diamondcard') then
                dcss = dcss + 1
            end
        end
        return dcss
    end
    return 0
end

SMODS.Joker {
    key = 'dcj',
    config = {
        extra = {
            x_gain = 0.3,
            dcs()
        }
    },
    rarity = 2,
    atlas = 'Jokers2',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 2,
        y = 2
    },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_diamondcard
        return {
            vars = {card.ability.extra.x_gain * dcs() + 1, card.ability.extra.x_gain, dcs()}
        }
    end,
    calculate = function(self, card, context)

        if context.joker_main then
            if dcs() > 0 then
                return {
                    x_mult = dcs() * card.ability.extra.x_gain + 1
                }
            end
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

function mgc()
    local mgcc = 0
    if G.playing_cards then
        for _, v in pairs(G.playing_cards) do
            if SMODS.has_enhancement(v, 'm_crv_mugged') then
                mgcc = mgcc + 1
            end
        end
        return mgcc
    end
    return 0
end

SMODS.Joker {
    key = 'mgj',
    config = {
        extra = {
            x_gain = 0.2,
            mgc()
        }
    },
    rarity = 2,
    atlas = 'Jokers2',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 1,
        y = 3
    },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_mugged
        return {
            vars = {card.ability.extra.x_gain * mgc() + 1, card.ability.extra.x_gain, mgc()}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if mgc() > 0 then
                return {
                    x_mult = mgc() * card.ability.extra.x_gain + 1
                }
            end
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}

function flm()
    local flmm = 0
    if G.playing_cards then
        for _, v in pairs(G.playing_cards) do
            if SMODS.has_enhancement(v, 'm_crv_aflame') then
                flmm = flmm + 1
            end
        end
        return flmm
    end
    return 0
end

SMODS.Joker {
    key = 'amj',
    config = {
        extra = {
            x_gain = 0.2,
            flm()
        }
    },
    rarity = 2,
    atlas = 'Jokers2',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 1,
        y = 2
    },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_aflame
        return {
            vars = {card.ability.extra.x_gain * flm() + 1, card.ability.extra.x_gain, flm()}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if flm() > 0 then
                return {
                    x_mult = flm() * card.ability.extra.x_gain + 1
                }
            end
        end

    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}

function mg()
    local mgg = 0
    if G.playing_cards then
        for _, v in pairs(G.playing_cards) do
            if SMODS.has_enhancement(v, 'm_crv_mega') then
                mgg = mgg + 1
            end
        end
        return mgg
    end
    return 0
end

SMODS.Joker {
    key = 'mj',
    config = {
        extra = {
            x_gain = 0.4,
            mg()
        }
    },
    rarity = 2,
    atlas = 'Jokers2',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 2,
        y = 1
    },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_mega
        return {
            vars = {card.ability.extra.x_gain * mg() + 1, card.ability.extra.x_gain, mg()}
        }
    end,
    calculate = function(self, card, context)

        if context.joker_main then
            if mg() > 0 then
                return {
                    x_mult = mg() * card.ability.extra.x_gain + 1
                }
            end
        end

    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}

function bls()
    local blss = 0
    if G.playing_cards then
        for _, v in pairs(G.playing_cards) do
            if SMODS.has_enhancement(v, 'm_crv_blessedcard') then
                blss = blss + 1
            end
        end
        return blss
    end
    return 0
end

SMODS.Joker {
    key = 'bj',
    config = {
        extra = {
            x_gain = 0.4,
            bls(),
            mult = 5,
            chips = 10
        }
    },
    rarity = 2,
    atlas = 'Jokers2',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 0,
        y = 3
    },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_blessedcard
        return {
            vars = {card.ability.extra.x_gain * bls() + 1, card.ability.extra.x_gain, bls(), card.ability.extra.mult,
                    card.ability.extra.chips, card.ability.extra.chips * bls(), card.ability.extra.mult * bls()}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if bls() > 0 then
                return {
                    chips = bls() * card.ability.extra.chips,
                    mult = bls() * card.ability.extra.mult,
                    x_mult = bls() * card.ability.extra.x_gain + 1
                }
            end
        end

    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}

function t1()
    local t11 = 0
    if G.playing_cards then
        for _, v in pairs(G.playing_cards) do
            if SMODS.has_enhancement(v, 'm_crv_tier1card') then
                t11 = t11 + 1
            end
        end
        return t11
    end
    return 0
end

SMODS.Joker {
    key = 't1j',
    config = {
        extra = {
            chips = 15,
            t1()
        }
    },
    rarity = 2,
    atlas = 't',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 0,
        y = 2
    },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_tier1card
        return {
            vars = {t1(), card.ability.extra.chips, card.ability.extra.chips * t1()}
        }
    end,
    calculate = function(self, card, context)

        if context.joker_main then
            if t1() > 0 then
                return {
                    chips = t1() * card.ability.extra.chips
                }
            end
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}

function t2()
    local t22 = 0
    if G.playing_cards then
        for _, v in pairs(G.playing_cards) do
            if SMODS.has_enhancement(v, 'm_crv_tier2card') then
                t22 = t22 + 1
            end
        end
        return t22
    end
    return 0
end

SMODS.Joker {
    key = 't2j',
    config = {
        extra = {
            chips = 30,
            mult = 5,
            t2()
        }
    },
    rarity = 2,
    atlas = 't',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 1,
        y = 2
    },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_tier2card
        return {
            vars = {t2(), card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.chips * t2(),
                    card.ability.extra.mult * t2()}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if t2() > 0 then
                return {
                    chips = t2() * card.ability.extra.chips,
                    mult = t2() * card.ability.extra.mult
                }
            end
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}

function t3()
    local t33 = 0
    if G.playing_cards then
        for _, v in pairs(G.playing_cards) do
            if SMODS.has_enhancement(v, 'm_crv_tier3card') then
                t33 = t33 + 1
            end
        end
        return t33
    end
    return 0
end

SMODS.Joker {
    key = 't3j',
    config = {
        extra = {
            chips = 50,
            xmult = 0.2,
            t3()
        }
    },
    rarity = 2,
    atlas = 't',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 2,
        y = 2
    },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_crv_tier3card
        return {
            vars = {t3(), card.ability.extra.chips, card.ability.extra.xmult, card.ability.extra.chips * t3(),
                    card.ability.extra.xmult * t3() + 1}
        }
    end,
    calculate = function(self, card, context)

        if context.joker_main then
            if t3() > 0 then
                return {
                    chips = t3() * card.ability.extra.chips,
                    x_mult = t3() * card.ability.extra.xmult + 1
                }
            end
        end

    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

function hc()
    local hcc = 0
    if G.playing_cards then
        for _, v in pairs(G.playing_cards) do
            if SMODS.has_enhancement(v, 'm_crv_target') then
                hcc = hcc + 1
            end
        end
        return hcc
    end
    return 0
end

SMODS.Joker {
    key = 'bh',
    config = {
        extra = {
            hp = 3,
            havecard = 0,
            needs = 0,
            money = 10,
            hand = -1
        }
    },
    rarity = 3,
    atlas = 'Jokers2',
    blueprint_compat = false,
    discovered = false,
    pos = {
        x = 3,
        y = 0
    },
    cost = 10,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.hp, card.ability.extra.havecard, card.ability.extra.needs, hc()}
        }
    end,
    add_to_deck = function(self, card, context)
        card.ability.extra.hp = 3
        card.ability.extra.needs = 0
        card.ability.extra.money = 5
        card.ability.extra.hand = -1
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and not context.repetition and hc() == 0 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local card2 = pseudorandom_element(G.playing_cards, pseudoseed('bh'))
                    card2:set_ability(G.P_CENTERS["m_crv_target"])
                    return true
                end
            }))
            return {
                message = localize('k_crv_tset_ex')
            }
        end
        if context.destroying_card and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if v.config.center == G.P_CENTERS.m_crv_target and not (card.ability.extra.needs == 4) and
                    not context.blueprint then
                    card.ability.extra.needs = card.ability.extra.needs + 1
                    return {
                        dollars = card.ability.extra.money,
                        message = localize('k_crv_telim_ex')
                    }
                end
            end
        end
        if (card.ability.extra.needs == 4) and not context.blueprint and not context.repetition and
            not context.individual then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        func = function()
                            G.jokers:remove_card(card)
                            card:remove()
                            card = nil
                            return true;

                        end

                    }))
                    return true

                end
            }))
            if context.after and not context.repetitive and not context.individual and not context.blueprint then
                local random_key = leg_keys[math.random(#leg_keys)]
                local new_card = create_card(random_key, G.jokers, nil, nil, nil, nil, random_key)
                new_card:set_edition({
                    negative = true
                }, true)
                new_card:add_to_deck()
                G.jokers:emplace(new_card)
            end
        end
        if context.end_of_round and not context.repetition and not context.individual then
            for k, v in pairs(G.playing_cards) do
                if v.config.center == G.P_CENTERS.m_crv_target then
                    card.ability.extra.hp = card.ability.extra.hp - 1
                    return {
                        message = localize('k_crv_failed_ex')
                    }
                end
            end
        end
        if (card.ability.extra.hp == 0) and not context.blueprint and not context.repetition and not context.individual then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        blockable = false,
                        func = function()
                            G.jokers:remove_card(card)
                            card:remove()
                            card = nil
                            return true;
                        end
                    }))
                    return true

                end
            }))
            G.hand:change_size(card.ability.extra.hand)
            return {
                message = localize('k_crv_post_ex')
            }
        end
    end
}

SMODS.Joker {
    key = 'flytrap',
    atlas = 'Jokers2',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 3,
        y = 2
    },
    config = {
        extra = {
            chipg = 10,
            chip = 0

        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.chipg, card.ability.extra.chip}
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit('Clubs', true) and not context.blueprint then
            card.ability.extra.chip = card.ability.extra.chip + card.ability.extra.chipg
        end

        if context.joker_main then
            return {
                chips = card.ability.extra.chip
            }
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'news',
    atlas = 'Jokers2',
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 2,
        y = 3
    },
    config = {
        extra = {
            odds = 4

        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.odds}
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual and pseudorandom('couponist') <
            G.GAME.probabilities.normal / card.ability.extra.odds then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_coupon'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end)
            }))
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'mtm',
    config = {
        extra = {
            xmult = 3.14,
        }
    },
    rarity = 3,
    atlas = 'Jokers2',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 4,
        y = 1
    },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for k, v in ipairs(context.scoring_hand) do
                if v:get_id() == 3 then
                    return {
                        x_mult = card.ability.extra.xmult
                    }
                end
            end
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'vrev',
    atlas = 'Jokers2',
    pos = {
        x = 4,
        y = 2
    },
    rarity = 3,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    config = {
        extra = {
            odds = 6,
            mult = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.mult}
        }
    end,
    calculate = function(self, card, context)
        if (card.ability.extra.odds == 1) then
            card.ability.extra.odds = 6
        end
        if context.setting_blind and not context.blueprint then
            if G.jokers.cards[1] == card or G.jokers.cards[1].ability.eternal then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        G.jokers:remove_card(card)
                        card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        card = nil
                        return true;
                    end
                }))
            end

            if not card.getting_sliced and not G.jokers.cards[1].ability.eternal and
                not G.jokers.cards[1].getting_sliced then
                if G.jokers.cards[1] ~= card then
                    if pseudorandom('vrev') < G.GAME.probabilities.normal / card.ability.extra.odds then
                        local sliced_card = G.jokers.cards[1]
                        sliced_card.getting_sliced = true
                        G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.joker_buffer = 0
                                card.ability.extra.mult = card.ability.extra.mult + sliced_card.sell_cost * 1.5
                                card.ability.extra.odds = 6
                                card:juice_up(0.8, 0.8)
                                sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                                return true
                            end
                        }))
                        return {
                            message = localize('k_crv_hit'),
                            delay(0.6)
                        }
                    else
                        local sliced_card = G.jokers.cards[1]
                        card.ability.extra.mult = card.ability.extra.mult + sliced_card.sell_cost * 1.5
                        card.ability.extra.odds = card.ability.extra.odds - 1
                        return {
                            message = localize('k_crv_miss')
                        }
                    end
                end
            end
        end
        if context.joker_main then
            return {
                x_mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = 'ut',
    atlas = 'Jokers2',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 4,
        y = 0
    },
    config = {
        extra = {
            xmult = 3

        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult}
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local numbers, all_cards = 0, 0
            for k, v in ipairs(G.hand.cards) do
                all_cards = all_cards + 1
                if v:get_id() >= 2 and v:get_id() <= 6 then
                    numbers = numbers + 1
                end
            end
            if numbers == all_cards then
                return {
                    x_mult = card.ability.extra.xmult
                }
            end
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

local suits = {1, 2, 3, 4}
SMODS.Joker {
    key = 'smbj',
    atlas = 'Jokers2',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 5,
        y = 0
    },
    config = {
        extra = {
            xmult = 3,
            randomsuit = 2,
            setsuit = "Spades"

        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.randomsuit, card.ability.extra.xmult, card.ability.extra.setsuit}
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint then
            card.ability.extra.randomsuit = (pseudorandom_element(suits, pseudoseed("ptm")))
            if card.ability.extra.randomsuit == 1 then
                card.ability.extra.setsuit = 'Clubs'
            elseif card.ability.extra.randomsuit == 2 then
                card.ability.extra.setsuit = 'Spades'
            elseif card.ability.extra.randomsuit == 3 then
                card.ability.extra.setsuit = 'Diamonds'
            elseif card.ability.extra.randomsuit == 4 then
                card.ability.extra.setsuit = 'Hearts'
            end
        end
        -- all cards calc
        if context.joker_main then
            local all_cards = 0
            for k, v in ipairs(G.hand.cards) do
                all_cards = all_cards + 1
                card.ability.extra.allcards = all_cards
            end
        end

        -- checks for clubs
        if context.joker_main and card.ability.extra.randomsuit == 1 then
            local blackc_suits = 0
            for k, v in ipairs(G.hand.cards) do
                if v:is_suit('Clubs', nil, true) then
                    blackc_suits = blackc_suits + 1
                end
            end
            if blackc_suits == card.ability.extra.allcards then
                return {
                    x_mult = card.ability.extra.xmult
                }
            end
            -- checks for spades
        elseif context.joker_main and card.ability.extra.randomsuit == 2 then

            local blacks_suits = 0
            for k, v in ipairs(G.hand.cards) do
                if v:is_suit('Spades', nil, true) then
                    blacks_suits = blacks_suits + 1
                end
            end
            if blacks_suits == card.ability.extra.allcards then
                return {
                    x_mult = card.ability.extra.xmult
                }
            end
            -- checks for diamonds
        elseif context.joker_main and card.ability.extra.randomsuit == 3 then
            local redd_suits = 0
            for k, v in ipairs(G.hand.cards) do
                if v:is_suit('Diamonds', nil, true) then
                    redd_suits = redd_suits + 1
                end
            end
            if redd_suits == card.ability.extra.allcards then
                return {
                    x_mult = card.ability.extra.xmult
                }
            end
            -- check for hearts
        elseif context.joker_main and card.ability.extra.randomsuit == 4 then
            local redh_suits = 0
            for k, v in ipairs(G.hand.cards) do
                if v:is_suit('Hearts', nil, true) then
                    redh_suits = redh_suits + 1
                end
            end
            if redh_suits == card.ability.extra.allcards then
                return {
                    x_mult = card.ability.extra.xmult
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'checkpoint',
    atlas = 'Jokers2',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 5,
        y = 1
    },
    config = {
        extra = {}
    },

    calculate = function(self, card, context)

        if context.selling_self then
            G.GAME.chips = G.GAME.chips / 2
            G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + G.GAME.current_round.hands_played
            G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + G.GAME.current_round.discards_used
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'goldenshark',
    atlas = 'Jokers2',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 5,
        y = 2
    },
    config = {
        extra = {
            timer = 0,
            status = 'Not Ready'
        }

    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.timer, card.ability.extra.status}
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual and
            not (card.ability.extra.timer == 3) then
            card.ability.extra.timer = card.ability.extra.timer + 1
        end

        if card.ability.extra.timer == 3 then
            card.ability.extra.status = 'Ready'
            if context.cardarea == G.play then
                for k, v in ipairs(context.scoring_hand) do
                    if context.other_card.ability.effect == "Base" then
                        context.other_card:set_ability(G.P_CENTERS.m_gold)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                return true
                            end
                        }))
                    end
                end
            end
        end
        if card.ability.extra.timer == 3 and context.final_scoring_step then
            card.ability.extra.timer = 0
            card.ability.extra.status = 'Not Ready'
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'sfj',
    atlas = 'Jokers2',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 5,
        y = 3
    },
    config = {
        extra = {
            one = 0,
            chips = 0,
            ok = 0
        }

    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.one, card.ability.extra.chips, card.ability.extra.ok}
        }
    end,

    calculate = function(self, card, context)

        if context.joker_main and next(SMODS.find_mod("Talisman")) and card.ability.extra.one == 0 and
            card.ability.extra.one == 0 and not context.blueprint and not context.repetition then
            card.ability.extra.ok = card.ability.extra.ok + 1
            local chips = hand_chips * mult
            card.ability.extra.chips = chips
            card.ability.extra.one = to_number(card.ability.extra.chips / 2)
            return {
                message = localize('k_crv_stored')
            }
        elseif context.joker_main and card.ability.extra.one == 0 and card.ability.extra.one == 0 and
            card.ability.extra.one == 0 and not context.blueprint and not context.repetition then
            card.ability.extra.ok = card.ability.extra.ok + 1
            local chips = hand_chips * mult
            card.ability.extra.chips = chips
            card.ability.extra.one = card.ability.extra.chips / 2
            return {
                message = localize('k_crv_stored')
            }
        end
        if context.joker_main and next(SMODS.find_mod("Talisman")) and card.ability.extra.ok > 0 then
            if (#SMODS.find_card('j_crv_upgr') == 0) then
                return {
                    chips = to_number(card.ability.extra.one)
                }
            elseif (#SMODS.find_card('j_crv_upgr') > 0) then
                return {
                    mult = card.ability.extra.one
                }
            end
        elseif context.joker_main and card.ability.extra.ok > 0 then
            if (#SMODS.find_card('j_crv_upgr') == 0) then
                return {
                    chips = card.ability.extra.one
                }
            elseif (#SMODS.find_card('j_crv_upgr') > 0) then
                return {
                    mult = card.ability.extra.one
                }
            end
        end
        if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
            card.ability.extra.ok = 0
            card.ability.extra.one = 0
            return {
                message = localize('k_crv_cleaning')
            }
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'upgr',
    atlas = 'Jokers2',
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {
        x = 6,
        y = 4
    },
    config = {
        extra = {}

    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_crv_sfj
        return {
            vars = {}
        }
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

local chances = {1, 2, 3, 4, 5, 6, 7, 8}

SMODS.Joker {
    key = 'btls',
    atlas = 'Jokers2',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 6,
        y = 0
    },
    config = {
        extra = {}
    },

    calculate = function(self, card, context)

        if context.joker_main and next(SMODS.find_mod("Talisman")) and not context.blueprint and not context.repetition then
            local cc = (pseudorandom_element(chances, pseudoseed("btls")))
            if cc == 1 then
                return {
                    chip_mod = to_number(G.GAME.blind.chips * 4),
                    message = localize('k_crv_overscore'),
                    colour = G.C.MULT

                }
            end
        elseif context.joker_main and not context.blueprint and not context.repetition then
            local cc = (pseudorandom_element(chances, pseudoseed("btls")))
            if cc == 1 then
                return {
                    chip_mod = G.GAME.blind.chips * 4,
                    message = localize('k_crv_overscore'),
                    colour = G.C.MULT
                }
            end
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'psy',
    atlas = 'Jokers2',
    rarity = 3,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 6,
        y = 1
    },
    config = {
        extra = {
            xmult = 22

        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult}
        }
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and G.GAME.current_round.hands_left == 2 and
            G.GAME.current_round.discards_left == 2 then
            if #context.full_hand == 2 then
                return {
                    x_mult = card.ability.extra.xmult
                }

            end
        end
    end

}

SMODS.Joker {
    key = 'mj4',
    atlas = 'Jokers2',
    rarity = 3,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 6,
        y = 2
    },
    config = {
        extra = {
            xmult = 4.4

        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult}
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Four of a Kind']) then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end

}

SMODS.Joker {
    key = 'tp3',
    atlas = 'Jokers2',
    rarity = 3,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 6,
        y = 3
    },
    config = {
        extra = {
            xmult = 3.3

        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult}
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Three of a Kind']) then
            return {
                x_mult = card.ability.extra.xmult
            }

        end
    end

}

SMODS.Joker {
    key = 'ml',
    atlas = 'Jokers2',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 1,
        y = 5
    },
    config = {
        extra = {
            xmult = 5,
            dcard = 'N/A'

        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.dcard}
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.repetition and not context.blueprint then
            local jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= self then
                    jokers[#jokers + 1] = G.jokers.cards[i]
                end
            end
            if #jokers > 1 then
                if not context.blueprint then
                    local chosen_joker = pseudorandom_element(jokers, pseudoseed('ml'))
                    chosen_joker:set_debuff(true)
                    if context.end_of_round and context.main_eval then
                        chosen_joker:set_debuff(false)
                    end
                end
            end
        end
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'vji',
    atlas = 'Jokers2',
    rarity = 2,
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 2,
        y = 5
    },
    config = {
        extra = {
            xmult = 1,
            mgain = 0.1,
            limit = 0

        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.mgain, card.ability.extra.limit}
        }
    end,

    calculate = function(self, card, context)
        if context.discard and not context.blueprint and not (card.ability.extra.limit >= 10) then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.mgain
            card.ability.extra.limit = card.ability.extra.limit + 1
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        end
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
        if context.end_of_round and context.main_eval then
            card.ability.extra.limit = 0
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'dont',
    atlas = 'Jokers2',
    rarity = 2,
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 3,
        y = 5
    },
    config = {
        extra = {
            odds = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.odds, (G.GAME.probabilities.normal or 1)}
        }
    end,

    calculate = function(self, card, context)

        if context.joker_main and not context.blueprint and not context.repetition and not context.individual then
            local rr = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    rr = i;
                    break
                end
            end
            if G.jokers.cards[rr + 1] == nil and next(SMODS.find_mod("Talisman")) and pseudorandom('dont') <
                G.GAME.probabilities.normal / card.ability.extra.odds then
                return {
                    chip_mod = to_number(G.GAME.blind.chips * 2),
                    message = localize('k_crv_double')
                }
            elseif G.jokers.cards[rr + 1] == nil and next(SMODS.find_mod("Talisman")) then
                return {
                    x_mult = to_number(G.GAME.blind.chips * 0),
                    message = localize('k_crv_nothing')
                }
            elseif G.jokers.cards[rr + 1] == nil and pseudorandom('dont') < G.GAME.probabilities.normal /
                card.ability.extra.odds then
                return {
                    chip_mod = G.GAME.blind.chips * 2,
                    message = localize('k_crv_double')
                }
            elseif G.jokers.cards[rr + 1] == nil then
                return {
                    x_mult = G.GAME.blind.chips * 0,
                    message = localize('k_crv_nothing')
                }
            end
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}


--find a way to localize this mess (im hopeless send help)
local quests = {"Play a Full House", "Use blueprint or brainstorm to copy this joker once", "Use a strength tarot card",
                "Score a stone card", "Use an uranus card"}
local questsr = {1, 2, 3, 4, 5}

SMODS.Joker {
    key = 'inga',
    atlas = 'Jokers2',
    rarity = 2,
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 4,
        y = 5
    },
    config = {
        extra = {
            one = "Not Active Yet",
            two = "Not Active Yet",
            three = "Not Active Yet",
            four = "Not Active Yet",
            five = "Not Active Yet",
            quest = 0,
            questa = 0,
            questb = 'Not set yet',
            xmult = 2,
            xchips = 4,
            odds = 4,
            counter = 0

        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.one, card.ability.extra.two, card.ability.extra.three, card.ability.extra.four,
                    card.ability.extra.five, card.ability.extra.quest, card.ability.extra.questa,
                    card.ability.extra.questb, card.ability.extra.xmult, card.ability.extra.xchips,
                    card.ability.extra.odds, (G.GAME.probabilities.normal or 1), card.ability.extra.counter}
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and card.ability.extra.questa == 0 then
            card.ability.extra.counter = card.ability.extra.counter + 1
            if card.ability.extra.counter == 1 then
                card.ability.extra.questa = 1
                card.ability.extra.questb = 'Play a Full House'
            elseif card.ability.extra.counter == 2 then
                card.ability.extra.questa = 2
                card.ability.extra.questb = "Use an uranus card"
            elseif card.ability.extra.counter == 3 then
                card.ability.extra.questa = 3
                card.ability.extra.questb = "Use a strength tarot card"
            elseif card.ability.extra.counter == 4 then
                card.ability.extra.questa = 4
                card.ability.extra.questb = "Score a stone card"
            elseif card.ability.extra.counter == 5 then
                card.ability.extra.questa = 5
                card.ability.extra.questb = "Use blueprint or brainstorm to copy this joker once"
            end
        end
        if context.joker_main and next(context.poker_hands['Full House']) then
            if card.ability.extra.questa == 1 then
                card.ability.extra.quest = card.ability.extra.quest + 1
                card.ability.extra.one = "Active"
                card.ability.extra.questa = 0
            end
        end
        if context.joker_main and context.blueprint then
            if card.ability.extra.questa == 5 then
                card.ability.extra.questb = 'No more quests.'
                card.ability.extra.five = "Applied"
                card.ability.extra.questa = 999
                card.ability.extra.xmult = card.ability.extra.xmult * 2
                card.ability.extra.xchips = card.ability.extra.xchips * 2
            end
        end
        if context.using_consumeable and context.consumeable.config.center.key == 'c_strength' then
            if card.ability.extra.questa == 3 then
                card.ability.extra.quest = card.ability.extra.quest + 1
                card.ability.extra.three = "Active"
                card.ability.extra.questa = 0
            end
        end

        if context.individual and card.ability.extra.questa == 4 then
            if context.cardarea == G.play then
                for k, v in ipairs(context.scoring_hand) do
                    if context.other_card.ability.effect == "Stone Card" then
                        card.ability.extra.quest = card.ability.extra.quest + 1
                        card.ability.extra.four = "Active"
                        card.ability.extra.questa = 0
                    end
                end
            end
        end
        if context.using_consumeable and context.consumeable.config.center.key == 'c_uranus' then
            if card.ability.extra.questa == 2 then
                card.ability.extra.quest = card.ability.extra.quest + 1
                card.ability.extra.two = "Active"
                card.ability.extra.questa = 0
            end
        end
        if context.joker_main and card.ability.extra.quest == 1 then
            return {
                x_mult = card.ability.extra.xmult
            }
        elseif context.joker_main and card.ability.extra.quest >= 2 then
            return {
                xchips = card.ability.extra.xchips,
                x_mult = card.ability.extra.xmult
            }
        end
        if context.individual and card.ability.extra.quest >= 3 then
            if context.cardarea == G.play then
                for k, v in ipairs(context.scoring_hand) do
                    if context.other_card.ability.effect == "Base" then
                        context.other_card:set_ability(G.P_CENTERS[SMODS.poll_enhancement({
                            guaranteed = true
                        })], true, false)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                return true
                            end
                        }))
                    end
                end
            end
        end
        if context.individual and card.ability.extra.quest >= 4 then
            if context.cardarea == G.play then
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + 30
            end
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'tgm',
    atlas = 'Jokers2',
    rarity = 2,
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 5,
        y = 5
    },
    config = {
        extra = {
            counter = 0,
            xmult = 1.5,
            xmultlg = 0.5,
            odds = 2

        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.xmultlg, card.ability.extra.odds,
                    (G.GAME.probabilities.normal or 1)}
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
        if context.setting_blind and not context.blueprint and not context.repetition and card.ability.extra.xmult < 5 then
            if pseudorandom('tgm') < G.GAME.probabilities.normal / card.ability.extra.odds then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultlg
            else
                card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmultlg
            end
        end
        if card.ability.extra.xmult <= 0 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        blockable = false,
                        func = function()
                            G.jokers:remove_card(card)
                            card:remove()
                            card = nil
                            return true;
                        end

                    }))
                    return true
                end
            }))
            return {
                message = localize('k_crv_dept'),
                delay(0.6)
            }
        end
    end
}

SMODS.Joker {
    key = 'hteg',
    config = {
        extra = {
            stages = 0
        }
    },

    rarity = 3,
    atlas = 'mm',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 0,
        y = 0
    },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.stages}
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.blueprint and not context.individual and
            not (#SMODS.find_card('j_crv_jhv') >= 1) then
            card.ability.extra.stages = card.ability.extra.stages + 1
        end
        if context.setting_blind and card.ability.extra.stages >= 3 and not context.blueprint and not context.repetition then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                    G.jokers:remove_card(card)
                    card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    card = nil
                    return true;
                end
            }))
            local new_card = create_card('Jhorah,Hatchling', G.jokers, nil, nil, nil, nil, 'j_crv_jhv')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end

        if context.joker_main and not context.blueprint then
            return {
                message = '!'
            }
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return false
    end
}

SMODS.Joker {
    key = 'jhv',
    config = {
        extra = {
            stages = 0,
            stg1b = 30
        }
    },
    rarity = 3,
    atlas = 'mm',
    no_collection = true,
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 1,
        y = 0
    },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.stages, card.ability.extra.stg1b}
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
            card.ability.extra.stages = card.ability.extra.stages + 1
        end
        if context.setting_blind and card.ability.extra.stages >= 3 and not context.repetition and not context.blueprint and
            not context.individual and not (#SMODS.find_card('j_crv_jbe') >= 1) then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                    G.jokers:remove_card(card)
                    card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    card = nil
                    return true;
                end
            }))
            local new_card = create_card('Jhorah,Beasty', G.jokers, nil, nil, nil, nil, 'j_crv_jbe')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end

        if context.joker_main then
            return {
                chips = card.ability.extra.stg1b
            }
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return false
    end
}

SMODS.Joker {
    key = 'jbe',
    config = {
        extra = {
            stages = 0,
            stg2b = 60,
            stg2b2 = 1.5
        }
    },

    rarity = 3,
    atlas = 'mm',
    blueprint_compat = true,
    discovered = false,
    no_collection = true,
    pos = {
        x = 2,
        y = 0
    },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.stages, card.ability.extra.stg2b, card.ability.extra.stg2b2}
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
            card.ability.extra.stages = card.ability.extra.stages + 1
        end
        if context.setting_blind and card.ability.extra.stages >= 3 and not context.repetition and not context.blueprint and
            not context.individual and not (#SMODS.find_card('j_crv_jma') >= 1) then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                    G.jokers:remove_card(card)
                    card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    card = nil
                    return true;
                end
            }))
            local new_card = create_card('Jhorah,Matured', G.jokers, nil, nil, nil, nil, 'j_crv_jma')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end

        if context.joker_main then
            return {
                chips = card.ability.extra.stg2b,
                x_mult = card.ability.extra.stg2b2
            }
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return false
    end
}
SMODS.Joker {
    key = 'jma',
    config = {
        extra = {
            stages = 0,
            stg3b = 90,
            stg3b2 = 2
        }
    },

    rarity = 3,
    atlas = 'mm',
    blueprint_compat = true,
    discovered = false,
    no_collection = true,
    pos = {
        x = 3,
        y = 0
    },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.stages, card.ability.extra.stg3b, card.ability.extra.stg3b2}
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
            card.ability.extra.stages = card.ability.extra.stages + 1
        end
        if context.setting_blind and card.ability.extra.stages >= 3 and not context.repetition and not context.blueprint and
            not context.individual and not (#SMODS.find_card('j_crv_jad') >= 1) then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                    G.jokers:remove_card(card)
                    card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    card = nil
                    return true;
                end
            }))
            local new_card = create_card('Jhorah,Adult', G.jokers, nil, nil, nil, nil, 'j_crv_jad')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end

        if context.joker_main then
            return {
                chips = card.ability.extra.stg3b,
                x_mult = card.ability.extra.stg3b2
            }
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return false
    end
}

SMODS.Joker {
    key = 'jad',
    config = {
        extra = {
            stages = 0,
            stg4b = 2,
            stg4b2 = 2.5
        }
    },

    rarity = 3,
    atlas = 'mm',
    blueprint_compat = true,
    discovered = false,
    no_collection = true,
    pos = {
        x = 4,
        y = 0
    },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.stages, card.ability.extra.stg4b, card.ability.extra.stg4b2}
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
            card.ability.extra.stages = card.ability.extra.stages + 1
        end
        if context.setting_blind and card.ability.extra.stages >= 3 and not context.repetition and not context.blueprint and
            not context.individual and not (#SMODS.find_card('j_crv_jcbt') >= 1) then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                    G.jokers:remove_card(card)
                    card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    card = nil
                    return true;
                end
            }))
            local new_card = create_card('Jhorah,Chained Beast', G.jokers, nil, nil, nil, nil, 'j_crv_jcbt')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end

        if context.joker_main then
            return {
                xchips = card.ability.extra.stg4b,
                x_mult = card.ability.extra.stg4b2
            }
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return false
    end
}

SMODS.Joker {
    key = 'jcbt',
    config = {
        extra = {
            stg5b = 4,
            stg5b2 = 3,
            odds = 4
        }
    },

    rarity = 3,
    atlas = 'mm',
    blueprint_compat = true,
    discovered = false,
    no_collection = true,
    pos = {
        x = 5,
        y = 0
    },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.stages, card.ability.extra.stg5b, card.ability.extra.stg5b2,
                    (G.GAME.probabilities.normal or 1), card.ability.extra.odds}
        }
    end,
    calculate = function(self, card, context)

        if pseudorandom('jcbt') < G.GAME.probabilities.normal / card.ability.extra.odds then
            if context.individual then
                if context.cardarea == G.play then
                    for k, v in ipairs(context.scoring_hand) do
                        if context.other_card.ability.effect == "Base" then
                            context.other_card:set_ability(G.P_CENTERS[SMODS.poll_enhancement({
                                guaranteed = true
                            })], true, false)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    return true
                                end
                            }))
                        end
                    end
                end
            end
        end
        if context.joker_main then
            return {
                xchips = card.ability.extra.stg5b,
                x_mult = card.ability.extra.stg5b2
            }
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return false
    end
}

SMODS.Joker {
    key = 'jimp',
    atlas = 'Jokers2',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 6,
        y = 5
    },
    config = {
        extra = {
            xmult = 3,
            xmult2 = 1.5
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.xmult2}
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local rr = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    rr = i;
                    break
                end
            end
            if G.jokers.cards[rr + 1] == nil or G.jokers.cards[rr - 1] == nil then
                return {
                    x_mult = card.ability.extra.xmult
                }
            else
                return {
                    x_mult = card.ability.extra.xmult2
                }
            end
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'jarden',
    atlas = 'Jokers2',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 7,
        y = 0
    },
    config = {
        extra = {
            xmult = 1,
            xmult2 = 0.5
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.xmult2}
        }
    end,

    calculate = function(self, card, context)
        if context.selling_card and not context.repetition and not context.blueprint then
            card.ability.extra.xmult = 1
            return {
                message = localize('k_reset'),
                colour = G.C.MULT
            }
        end
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult2
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        end
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'kit',
    atlas = 'Jokers2',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 7,
        y = 1
    },
    config = {
        extra = {}
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {}
        }
    end,

    calculate = function(self, card, context)
        if context.final_scoring_step then
            if context.cardarea then
                for k, v in ipairs(context.scoring_hand) do
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.5,
                        func = function()
                            local rank_suffix = v.base.id == 13 and 13 or math.min(v.base.id + 1, 13)
                            if rank_suffix < 10 then
                                rank_suffix = tostring(rank_suffix)
                            elseif rank_suffix == 10 then
                                rank_suffix = '10'
                            elseif rank_suffix == 11 then
                                rank_suffix = 'Jack'
                            elseif rank_suffix == 12 then
                                rank_suffix = 'Queen'
                            elseif rank_suffix == 13 then
                                rank_suffix = 'King'
                            end
                            v:flip();
                            play_sound('card1');
                            v:juice_up(0.3, 0.4);
                            SMODS.change_base(v, nil, rank_suffix);
                            return true
                        end
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 1,
                        func = function()
                            v:flip();
                            v:juice_up(0.3, 0.4);
                            return true
                        end
                    }))
                end
            end
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'kon',
    config = {
        extra = {
            chips = 25
        }
    },
    rarity = 3,
    atlas = 'Jokers2',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 7,
        y = 2
    },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.chips}
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() >= 7 then

            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra.chips
            return {
                message = localize('k_upgrade_ex')
            }
        elseif context.destroy_card and context.cardarea == G.play and context.destroy_card:get_id() < 7 then

            return {
                remove = true
            }
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'onj',
    config = {
        extra = {
            xmult = 1,
            multg = 0.25
        }
    },
    rarity = 3,
    atlas = 'Jokers2',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 7,
        y = 3
    },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.multg}
        }
    end,
    calculate = function(self, card, context)
        if context.before and context.cardarea and not context.blueprint and not context.repetition and
            not context.individual then
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.effect == "Base" then
                    v:set_ability("m_stone")
                    v:juice_up(0.3, 0.4)
                elseif v.ability.effect == "Stone Card" then
                    v:set_ability("c_base")
                    v:juice_up(0.3, 0.4)
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.multg
                end
            end
        end
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

local rabbits = {"j_crv_rabf", "j_crv_rabflush", "j_crv_rabhigh"}

SMODS.Joker {
    key = 'rab',
    config = {
        extra = {
            xmult = 1.50,
            xmultgain = 0.50,
            stage = 0
        }
    },
    rarity = 3,
    atlas = 'Jokers2',
    blueprint_compat = true,
    discovered = false,
    pos = {
        x = 7,
        y = 5
    },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.xmultgain, card.ability.extra.stage}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
        if context.end_of_round and G.GAME.blind.boss and context.main_eval and not context.blueprint then
            local rr = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    rr = i;
                    break
                end
            end
            if G.jokers.cards[rr + 1] == nil or G.jokers.cards[rr - 1] == nil and context.main_eval then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    blockable = false,
                    func = function()
                        G.jokers:remove_card(card)
                        card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        card = nil
                        return true;
                    end
                }))
                return {
                    message = localize('k_crv_rain'),
                    message_card = card
                }

            elseif G.jokers.cards[rr + 1] ~= nil and G.jokers.cards[rr - 1] ~= nil and G.GAME.blind.boss and
                context.main_eval then
                card.ability.extra.stage = card.ability.extra.stage + 1
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultgain
                return {
                    message = localize('k_crv_rain2'),
                    message_card = card
                }
            end
        end
        if card.ability.extra.stage >= 5 and not context.repetition and not context.individual and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 1,
                blockable = false,
                func = function()
                    G.jokers:remove_card(card)
                    card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    card = nil
                    return true;
                end
            }))
            local rabs = pseudorandom_element(rabbits, pseudoseed('rab'))
            SMODS.add_card({
                area = G.jokers,
                key = rabs
            })
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'rabf',
    config = {
        extra = {
            xmult = 4,
            xmultf = 2
        }
    },
    rarity = "crv_tit",
    atlas = 'Jokers2',
    blueprint_compat = true,
    discovered = false,
    no_collection = true,
    pos = {
        x = 2,
        y = 6
    },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.xmultf}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_face() then
                return {
                    x_mult = card.ability.extra.xmultf
                }
            end
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return false
    end
}

SMODS.Joker {
    key = 'rabflush',
    config = {
        extra = {
            xmult = 4,
            xmultex = 6
        }
    },
    rarity = "crv_tit",
    atlas = 'Jokers2',
    blueprint_compat = true,
    discovered = false,
    no_collection = true,
    pos = {
        x = 0,
        y = 6
    },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.xmultex}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Flush']) then
            return {
                x_mult = card.ability.extra.xmultex
            }
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return false
    end
}

SMODS.Joker {
    key = 'rabhigh',
    config = {
        extra = {
            xmult = 4,
            xmultex = 6
        }
    },
    rarity = "crv_tit",
    atlas = 'Jokers2',
    blueprint_compat = true,
    discovered = false,
    no_collection = true,
    pos = {
        x = 1,
        y = 6
    },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.xmultex}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Full House']) then
            return {
                x_mult = card.ability.extra.xmultex
            }
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, wawa, wawa2)
        return false
    end
}


--thanks to bepisfever on discord for helping with this part :D

local card_highlighted_ref = Card.highlight
function Card:highlight(is_highlighted)
    self.highlighted = is_highlighted
    if self.highlighted and string.find(self.ability.name, "j_crv_brj") then

        if self.children.use_button then
            self.children.use_button:remove()
            self.children.use_button = nil
        end

        self.children.use_button = UIBox {
            definition = RevosVault.create_sell_and_switch_buttons(self, {
                sell = true,
                use = true
            }),
            config = {
                align = "cr",
                offset = {
                    x = -0.4,
                    y = 0
                },
                parent = self
            }
        }
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
                align = "cr"
            },
            nodes = {{
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
                    button = 'sell_card',
                    func = 'can_sell_card'
                },
                nodes = {{
                    n = G.UIT.B,
                    config = {
                        w = 0.1,
                        h = 0.6
                    }
                }, {
                    n = G.UIT.C,
                    config = {
                        align = "tm"
                    },
                    nodes = {{
                        n = G.UIT.R,
                        config = {
                            align = "cm",
                            maxw = 1.25
                        },
                        nodes = {{
                            n = G.UIT.T,
                            config = {
                                text = localize('b_sell'),
                                colour = G.C.UI.TEXT_LIGHT,
                                scale = 0.4,
                                shadow = true
                            }
                        }}
                    }, {
                        n = G.UIT.R,
                        config = {
                            align = "cm"
                        },
                        nodes = {{
                            n = G.UIT.T,
                            config = {
                                text = localize('$'),
                                colour = G.C.WHITE,
                                scale = 0.4,
                                shadow = true
                            }
                        }, {
                            n = G.UIT.T,
                            config = {
                                ref_table = card,
                                ref_value = 'sell_cost_label',
                                colour = G.C.WHITE,
                                scale = 0.55,
                                shadow = true
                            }
                        }}
                    }}
                }}
            }}
        }
    end

    if args.use then

        use = {
            n = G.UIT.C,
            config = {
                align = "cr"
            },
            nodes = {{
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
                    button = 'crv_modee'
                },
                nodes = {{
                    n = G.UIT.B,
                    config = {
                        w = 0.1,
                        h = 0.6
                    }
                }, {
                    n = G.UIT.C,
                    config = {
                        align = "tm"
                    },
                    nodes = {{
                        n = G.UIT.R,
                        config = {
                            align = "cm",
                            maxw = 1.25
                        },
                        nodes = {{
                            n = G.UIT.T,
                            config = {
                                text = localize('crv_mode'),
                                colour = G.C.UI.TEXT_LIGHT,
                                scale = 0.4,
                                shadow = true
                            }
                        }}
                    }, {
                        n = G.UIT.R,
                        config = {
                            align = "cm"
                        },
                        nodes = {{
                            n = G.UIT.T,
                            config = {
                                text = localize('crv_mode2'),
                                colour = G.C.UI.TEXT_LIGHT,
                                scale = 0.5,
                                shadow = true
                            }
                        }}
                    }}
                }}
            }}
        }
    end

    return {
        n = G.UIT.ROOT,
        config = {
            align = "cr",
            padding = 0,
            colour = G.C.CLEAR
        },
        nodes = {{
            n = G.UIT.C,
            config = {
                padding = 0.15,
                align = 'cl'
            },
            nodes = {sell and {
                n = G.UIT.R,
                config = {
                    align = 'cl'
                },
                nodes = {sell}
            } or nil, use and {
                n = G.UIT.R,
                config = {
                    align = 'cl'
                },
                nodes = {use}
            } or nil}
        }}
    }
end

G.FUNCS.crv_modee = function(e)
    local card = e.config.ref_table
    if card.ability.extra["turn"] == "Player" then
        if card.ability.extra["mode"] == 'Joker' then
            card.ability.extra["mode"] = 'Self'
        elseif card.ability.extra["mode"] == 'Self' then
            card.ability.extra["mode"] = 'Joker'
        end
    end
end


--find a way to localize this
local brjk2 = {"Self", "Joker"}
SMODS.Joker {
    key = 'brj',
    config = {
        extra = {
            cardhp = 3,
            playerhp = 3,
            mode = 'Joker',
            turn = "Player",
            odds2 = 3
        }
    },
    rarity = 3,
    atlas = 'Jokers2',
    blueprint_compat = false,
    discovered = false,
    no_collection = false,
    pos = {
        x = 5,
        y = 6
    },
    cost = 10,
    loc_vars = function(self, info_queue, card)
        local crv = card.ability.extra
        return {
            vars = {crv.cardhp, crv.playerhp, crv.mode, crv.turn,crv.odds2}
        }
    end,
    calculate = function(self, card, context)
        local crv = card.ability.extra
        if context.first_hand_drawn and not context.repetition and not context.individual and not context.blueprint and
            crv.turn == "Player" then
            if crv.mode == "Self" and pseudorandom('brj') >= 1 / crv.odds2 then
                crv.odds2 = crv.odds2 - 1
                crv.turn = "Player"
                return {
                    message = "Miss, Go again!"
                }
            elseif crv.mode == "Self" and pseudorandom('brj') < 1 / crv.odds2 then 
                crv.odds2 = 3
                crv.turn = "Joker"
                crv.playerhp = crv.playerhp - 1
                return {
                    message = "Ouch!"
                }
            elseif crv.mode == "Joker" and pseudorandom('brj') < 1 / crv.odds2 then 
                crv.odds2 = 3
                crv.turn = "Joker"
                crv.cardhp = crv.cardhp - 1
                return {
                    message = "Hit!"
                }
            elseif crv.mode == "Joker" and pseudorandom('brj') >= 1 / crv.odds2 then
                crv.odds2 = crv.odds2 - 1
                crv.turn = "Joker"
                return {
                    message = "Miss, Changing turns!"
                }
            elseif crv.mode == "Self" then
                crv.turn = "Player"
                crv.odds2 = crv.odds2 - 1
                return {
                    message = "Miss, Go again!"
                }
            elseif crv.mode == "Joker" then
                crv.turn = "Enemy"
                crv.odds2 = crv.odds2 - 1
                crv.turn = "Joker"
                return {
                    message = "Miss, Changing turns!"
                }
            end
        elseif context.first_hand_drawn and not context.repetition and not context.individual and not context.blueprint and
            crv.turn == "Joker" and crv.odds2 > 1 then
            crv.mode = pseudorandom_element(brjk2, pseudoseed('brj'))
            if crv.mode == "Self" and pseudorandom('brj') > 1 / crv.odds2 then
                crv.odds2 = crv.odds2 - 1
                crv.turn = "Player"
                return {
                    message = "Safe, your turn!"
                }
            elseif crv.mode == "Self" and pseudorandom('brj') < 1 / crv.odds2 then
                crv.odds2 = 3
                crv.turn = "Player"
                crv.playerhp = crv.playerhp - 1
                return {
                    message = "Ouch!"
                }
            elseif crv.mode == "Joker" and pseudorandom('brj') < 1 / crv.odds2 then
                crv.odds2 = 3
                crv.turn = "Player"
                crv.cardhp = crv.cardhp - 1
                return {
                    message = "Hit!"
                }
            elseif crv.mode == "Joker" and pseudorandom('brj') > 1 / crv.odds2 then
                crv.odds2 = crv.odds2 - 1
                crv.turn = "Joker"
                return {
                    message = "Miss, waiting!"
                }
            elseif crv.mode == "Self" then
                crv.turn = "Player"
                crv.odds2 = crv.odds2 - 1
                return {
                    message = "Miss, your turn!"
                }
            elseif crv.mode == "Joker" then
                crv.turn = "Enemy"
                crv.odds2 = crv.odds2 - 1
                crv.turn = "Joker"
                return {
                    message = "Miss, waiting!"
                }
            end
        elseif context.first_hand_drawn and not context.repetition and not context.individual and not context.blueprint and
        crv.turn == "Joker" and crv.odds2 == 1 then
            crv.odds2 = 3
            crv.turn = "Player"
            crv.playerhp = crv.playerhp - 1
            return {
                message = "Hit!"
            }
        end
        if crv.playerhp == 0 then
            G.STATE = G.STATES.GAME_OVER
            G.STATE_COMPLETE = false
        end
        if crv.cardhp == 0 and not context.blueprint and not context.repetition and not context.individual then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 1,
                blockable = false,
                func = function()
                    SMODS.add_card({
                        set = "Joker",
                        area = G.jokers,
                        legendary = true,
                        edition = "e_negative",
                    })
                    SMODS.add_card({
                        set = "Joker",
                        area = G.jokers,
                        legendary = true,
                        edition = "e_negative",
                    })
                    G.jokers:remove_card(card)
                    card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    card = nil
                    return true;
                end
            }))
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'jimshow',
    atlas = 'Jokers2',
    rarity = 3,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 6,
        y = 6
    },
    config = {
        extra = {
            xmult = 1,
            xmultg = 0.5

        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.xmultg}
        }
    end,

    calculate = function(self, card, context)
        local crv = card.ability.extra
        if context.joker_main then
            crv.xmult = crv.xmult + crv.xmultg
            return {
                xmult = card.ability.extra.xmult,
            }
        end
        end

}

local igo = Game.init_game_object
Game.init_game_object = function(self)
    local ret = igo(self)
    ret.reincarnation = 1
    return ret
end

SMODS.Joker {
    key = 'rein',
    atlas = 'Jokers2',
    rarity = 3,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 7,
        y = 6
    },
    config = {
        extra = {
            xmult = 2,
            odds = 4

        }
    },
    loc_vars = function(self, info_queue, card)
        local crv = card.ability.extra
        return {
            vars = {crv.xmult*G.GAME.reincarnation,G.GAME.reincarnation,crv.odds,G.GAME.probabilities.normal}
        }
    end,

    calculate = function(self, card, context)
        local crv = card.ability.extra
        if card.getting_sliced and not context.repetition and not context.individual and not context.blueprint then
            G.GAME.reincarnation = G.GAME.reincarnation + 1
            if pseudorandom('rein') < G.GAME.probabilities.normal / crv.odds then
            add_tag(Tag('tag_crv_reintag'))
            end
    end
        if context.joker_main then
            return {
                xmult = crv.xmult * G.GAME.reincarnation
            }
        end
        end

}


local card_highlighted_ref = Card.highlight
function Card:highlight(is_highlighted)
    self.highlighted = is_highlighted
    if self.highlighted and string.find(self.ability.name, "j_crv_clicker") then

        if self.children.use_button then
            self.children.use_button:remove()
            self.children.use_button = nil
        end

        self.children.use_button = UIBox {
            definition = RevosVault.clicker(self, {
                sell = true,
                use = true
            }),
            config = {
                align = "cr",
                offset = {
                    x = -0.4,
                    y = 0
                },
                parent = self
            }
        }
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
                align = "cr"
            },
            nodes = {{
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
                    button = 'sell_card',
                    func = 'can_sell_card'
                },
                nodes = {{
                    n = G.UIT.B,
                    config = {
                        w = 0.1,
                        h = 0.6
                    }
                }, {
                    n = G.UIT.C,
                    config = {
                        align = "tm"
                    },
                    nodes = {{
                        n = G.UIT.R,
                        config = {
                            align = "cm",
                            maxw = 1.25
                        },
                        nodes = {{
                            n = G.UIT.T,
                            config = {
                                text = localize('b_sell'),
                                colour = G.C.UI.TEXT_LIGHT,
                                scale = 0.4,
                                shadow = true
                            }
                        }}
                    }, {
                        n = G.UIT.R,
                        config = {
                            align = "cm"
                        },
                        nodes = {{
                            n = G.UIT.T,
                            config = {
                                text = localize('$'),
                                colour = G.C.WHITE,
                                scale = 0.4,
                                shadow = true
                            }
                        }, {
                            n = G.UIT.T,
                            config = {
                                ref_table = card,
                                ref_value = 'sell_cost_label',
                                colour = G.C.WHITE,
                                scale = 0.55,
                                shadow = true
                            }
                        }}
                    }}
                }}
            }}
        }
    end

    if args.use then

        use = {
            n = G.UIT.C,
            config = {
                align = "cr"
            },
            nodes = {{
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
                    button = 'crv_clicked'
                },
                nodes = {{
                    n = G.UIT.B,
                    config = {
                        w = 0.1,
                        h = 0.6
                    }
                }, {
                    n = G.UIT.C,
                    config = {
                        align = "tm"
                    },
                    nodes = {{
                        n = G.UIT.R,
                        config = {
                            align = "cm",
                            maxw = 1.25
                        },
                        nodes = {{
                            n = G.UIT.T,
                            config = {
                                text = localize('crv_click'),
                                colour = G.C.UI.TEXT_LIGHT,
                                scale = 0.8,
                                shadow = true
                            }
                        }}
                    }}
                }}
            }}
        }
    end

    return {
        n = G.UIT.ROOT,
        config = {
            align = "cr",
            padding = 0,
            colour = G.C.CLEAR
        },
        nodes = {{
            n = G.UIT.C,
            config = {
                padding = 0.15,
                align = 'cl'
            },
            nodes = {sell and {
                n = G.UIT.R,
                config = {
                    align = 'cl'
                },
                nodes = {sell}
            } or nil, use and {
                n = G.UIT.R,
                config = {
                    align = 'cl'
                },
                nodes = {use}
            } or nil}
        }}
    }
end

G.FUNCS.crv_clicked = function(e)
    local card = e.config.ref_table
            card.ability.extra["clicks"] = card.ability.extra["clicks"] + 1
            card.ability.extra["chips"] = card.ability.extra["chips"] + card.ability.extra["chipgain"]
        end


SMODS.Joker {
    key = 'clicker',
    config = {
        extra = {
            clicks = 0,
            chips = 0,
            chipgain = 0.1
        }
    },
    rarity = 3,
    atlas = 'Jokers2',
    blueprint_compat = false,
    discovered = false,
    no_collection = false,
    pos = {
        x = 0,
        y = 7
    },
    cost = 10,
    loc_vars = function(self, info_queue, card)
        local crv = card.ability.extra
        return {
            vars = {crv.clicks,crv.chips,crv.chipgain}
        }
    end,
    calculate = function(self, card, context)
        local crv = card.ability.extra
        if context.joker_main then
            return {
                chips = crv.chips
            }
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end
}

SMODS.Joker {
    key = 'hand',
    atlas = 'Jokers2',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 1,
        y = 7
    },
    config = {
        extra = {
        }
    },
    loc_vars = function(self, info_queue, card)
        local crv = card.ability.extra
        return {
            vars = {}
        }
    end,

    calculate = function(self, card, context)
        local crv = card.ability.extra
            if context.setting_blind then
            local my_pos = nil
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then my_pos = i; break end
                end
                if my_pos and G.jokers.cards[my_pos+1] and not G.jokers.cards[my_pos+1].getting_sliced then 
                    local sliced_card = G.jokers.cards[my_pos+1]
                    sliced_card.getting_sliced = true
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.joker_buffer = 0
                        card:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({HEX("57ecab")}, nil, 0.1)
                    return true end }))
                end
end
        end

}

SMODS.Joker {
    key = 'giftbox',
    atlas = 'Jokers2',
    rarity = 3,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pos = {
        x = 2,
        y = 7
    },
    config = {
        extra = { timer = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        local crv = card.ability.extra
        return {
            vars = {crv.timer}
        }
    end,

    calculate = function(self, card, context)
        local crv = card.ability.extra
        if context.end_of_round and context.main_eval and not context.blueprint then
            crv.timer = crv.timer + 1
        end
            if context.selling_self then
                SMODS.add_card({
                    set = "Joker",
                    area = G.jokers,
                    rarity = 0,
                    stickers = {"eternal"}
                })
                SMODS.add_card({
                    set = "Joker",
                    area = G.jokers,
                    legendary = true,
                    stickers = {"eternal"}
                })
            end
        end

}
