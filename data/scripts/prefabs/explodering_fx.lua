local assets =
{
	Asset("ANIM", "anim/explode_ring_fx.zip"),
}

local function fn()
	local inst = CreateEntity()
    local network = inst.entity:AddNetwork()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

    anim:SetBank("explode_ring_fx")
    anim:SetBuild("explode_ring_fx")
    anim:PlayAnimation("idle")
    anim:SetFinalOffset(-1)

    anim:SetOrientation( ANIM_ORIENTATION.OnGround )
    anim:SetLayer( LAYER_BACKGROUND )
    anim:SetSortOrder( 3 )

    inst.persists = false
    inst:AddTag("fx")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", function() inst:Remove() end)

    return inst
end

return Prefab("explodering_fx", fn, assets)
