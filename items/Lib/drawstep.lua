SMODS.DrawStep {
	key = 'new_use',
	order = -30,
	func = function(self)
		if self.children.crv_use then
            if self.highlighted then
                self.children.crv_use:draw() 
            else
                self.children.crv_use:remove() 
                self.children.crv_use = nil
            end
        end
       if self.children.crv_use_alt then
            if self.highlighted then
                self.children.crv_use_alt:draw() 
            else
                self.children.crv_use_alt:remove() 
                self.children.crv_use_alt = nil
            end
        end
	end,
}

SMODS.DrawStep({
	key = "joker_shine",
	order = 11,
	func = function(self)
		if
			self.config.center.soul_set == "Spectral"
			and self.ability.set == "Superior"
			and self:should_draw_base_shader()
		then
			self.children.center:draw_shader("booster", nil, self.ARGS.send_to_shader)
		end
	end,
	conditions = { vortex = false, facing = "front" },
})