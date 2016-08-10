local prefabs = 
{
    "piratebunnyman",
}

local MAX_SIZE = 20

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    --[[Non-networked entity]]

    inst:AddTag("herd")
    --V2C: Don't use CLASSIFIED because herds use FindEntities on "herd" tag
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    inst:AddComponent("herd")
    inst.components.herd:SetMemberTag("piratebunnyman")
    inst.components.herd:SetGatherRange(40)
    inst.components.herd:SetUpdateRange(20)
    inst.components.herd:SetMaxSize(MAX_SIZE)
    inst.components.herd:SetOnEmptyFn(inst.Remove)
    
    inst.settlelocation = nil

    return inst
end

return Prefab("piratebunnymanherd", fn, nil, prefabs)
