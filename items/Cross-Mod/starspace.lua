if RevoConfig["experimental_enabled"] then
  
STAR_UTIL.Patch {
  key = "blessed_patch",
  badge_colour = HEX("00b300"),
  atlas = "starspace",
  pos = { x = 0, y = 0 },
  patch_sticker = "crv_vamp",
  config = { extra = {
  } },

  loc_vars = function(self, info_queue, card)
    return { vars = {
    } }
  end,

  calculate = function(self, card, context)
    if context.crv_joker_destroyed and context.crv_destroyedj == card then
        RevosVault.revive(card, context.crv_destroy_area, "crv_blessed_patch")
    end
  end
}

STAR_UTIL.Patch {
  key = "stable_patch",
  badge_colour = HEX("eeb025"),
  atlas = "starspace",
  pos = { x = 1, y = 0 },
  patch_sticker = "crv_radioactive",
  config = { extra = {
  } },

  loc_vars = function(self, info_queue, card)
    return { vars = {
    } }
  end,
}

STAR_UTIL.Patch {
  key = "purified_patch",
  badge_colour = G.C.DARK_EDITION,
  atlas = "starspace",
  pos = { x = 2, y = 0 },
  patch_sticker = "crv_cursed",
  config = { extra = {
  } },

  loc_vars = function(self, info_queue, card)
    return { vars = {
    } }
  end,

  calculate = function(self, card, context)
    if context.setting_blind then
      if card:crv_random_sticker("crv_purified_patch") then
        card:remove_sticker(card:crv_random_sticker("crv_purified_patch"), true)
      end
    end
  end
}

end