local assets =
{
    Asset("ANIM", "anim/snook_statue.zip"),
	Asset("MINIMAP_IMAGE", "statue"),
}

local prefabs =
{
    -- "marble",
    -- "rock_break_fx",
    -- "chesspiece_formal_sketch",
}

local FRABBIT_RANGE = 30

SetSharedLootTable('snook_statue',
{
    { 'chesspiece_formal_sketch', 1.00},
    { 'marble', 1.00 },
    { 'marble', 1.00 },
    { 'marble', 1.00 },
    { 'marble', 1.00 },
    { 'marble', 1.00 },
    { 'marble', 1.00 },
    { 'marble', 0.33 },
})

local function OnWork(inst, worker, workleft)
    if inst.prefab == "statue_snook" then
        local frabbit = FindEntity(inst, FRABBIT_RANGE, function(ent) return ent.prefab == "bunnyman_frabbit" end)
        if frabbit ~= nil and worker ~= nil and worker.components.combat then
            frabbit.components.combat:SuggestTarget(worker)
        end
    end
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
        inst.AnimState:PlayAnimation("idle_low")
    elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
        inst.AnimState:PlayAnimation("idle_med")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst:AddTag("maxwell")
    inst.entity:AddTag("statue")

    MakeObstaclePhysics(inst, 0.66)

    inst.MiniMapEntity:SetIcon("statue.png")

    inst.AnimState:SetBank("snook_statue")
    inst.AnimState:SetBuild("snook_statue")
    inst.AnimState:PlayAnimation("idle_full")
    inst.AnimState:SetScale(3,3,3)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('snook_statue')

    inst:AddComponent("inspectable")
    inst:AddComponent("workable")
    --TODO: Custom variables for mining speed/cost
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE * 5)
    inst.components.workable:SetOnWorkCallback(OnWork)

    MakeHauntableWork(inst)

    return inst
end

return Prefab("statue_snook", fn, assets, prefabs)
