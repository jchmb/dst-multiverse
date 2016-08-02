HookInitMimi = function(player)
	print(player.userid)
	print(GetModConfigData("Mimi"))
	if player.userid == GetModConfigData("Mimi") then
		local mimi = SpawnPrefab("mimi")
		mimi.Transform:SetPosition(player.Transform:GetWorldPosition())
		mimi.follower:SetLeader(player)
	end
end