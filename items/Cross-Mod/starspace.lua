if RevoConfig["experimental_enabled"] then
  
STAR_UTIL.Patch {
  key = "blessed_patch",
  badge_colour = HEX("4F5DA1"),
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

end