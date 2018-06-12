if GetModConfigBoolean("UseMultiShards") and (GLOBAL.TheNet:GetIsServer() or GLOBAL.TheNet:IsDedicated()) then
	modimport("init/hooks/portal/hook_migration_portal")
	AddPrefabPostInitAny(function(prefab)
		-- Migration portals share the wormhole icon. This is confusing. Use teleportato icon instead.
		--prefab.MiniMapEntity:SetIcon("teleportato.png")
		if prefab.components and prefab.components.worldmigrator then
			prefab:DoTaskInTime(1, HookInitConnect)
		end
	end)
end
