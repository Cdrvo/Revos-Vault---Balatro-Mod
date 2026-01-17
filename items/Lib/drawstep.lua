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