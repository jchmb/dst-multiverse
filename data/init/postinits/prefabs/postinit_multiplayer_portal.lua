AddPrefabPostInit("multiplayer_portal", function(inst)
    if GLOBAL.TheWorld.ismastersim then
        local x, y, z = inst.Transform:GetWorldPosition()
        local pt = GLOBAL.Vector3(x + 2, y, z)
        local sign = GLOBAL.SpawnPrefab("homesign_welcome")
        sign.Transform:SetPosition(pt:Get())
    end
end)
