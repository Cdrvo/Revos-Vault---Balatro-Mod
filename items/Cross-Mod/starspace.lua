if RevoConfig["experimental_enabled"] then


STAR_UTIL.Patch {
  key = "blessed",
  badge_colour = HEX("4F5DA1"),
  atlas = "card_mods",
  pos = { x = 2, y = 2 },
  patch_sticker = "crv_vamp",
  config = { extra = {
  } },

  loc_vars = function(self, info_queue, card)
    return { vars = {
    } }
  end,

  calculate = function(self, card, context)
    if context.crv_joker_destroyed and context.crv_destroyed == card then
        local _card = copy_card(card)
        _card:add_to_deck()
        G.jokers:emplace(_card)
    end
  end
}

end