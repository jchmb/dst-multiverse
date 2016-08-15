AddComponentPostInit("deployable", function(self, inst)
	self.ForceDeploy = function(self, pt, deployer)
			-- if not self:CanDeploy(pt) then
			-- 	return
			-- end
			local prefab = self.inst.prefab
			if self.ondeploy ~= nil then
				self.ondeploy(self.inst, pt, deployer)
			end
			-- self.inst is removed during ondeploy
			deployer:PushEvent("deployitem", { prefab = prefab })
			return true
	end
end)