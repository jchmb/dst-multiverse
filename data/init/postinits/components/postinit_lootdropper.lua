--[[
	Lootdropper Postinit

	Allows one to add and remove named functions that are called when a 
	loot item is spawned.
--]]
AddComponentPostInit("lootdropper", function(self, inst)
	self.loot_postinits = {}

	self.SetLootPostInit = function(_self, name, fn)
		if type(fn) == "function" then
			self.loot_postinits[name] = fn
		end
	end

	self.RemoveLootPostInit = function(_self, name)
		self.loot_postinits[name] = nil
	end

	self.old_SpawnLootPrefab = self.SpawnLootPrefab
	self.SpawnLootPrefab = function(x, lootprefab, pt)
		local loot = self:old_SpawnLootPrefab(lootprefab, pt)
		if loot ~= nil and self.loot_postinits then
			for i,loot_postinit in ipairs(self.loot_postinits) do
				loot = loot_postinit(x, loot)
			end
		end
		return loot
	end
end)
