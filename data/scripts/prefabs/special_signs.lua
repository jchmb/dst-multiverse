require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/sign_home.zip"),
    Asset("ANIM", "anim/ui_board_5x3.zip"),
    Asset("MINIMAP_IMAGE", "sign"),
}

local prefabs =
{
    "collapse_small",
}

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", false)
    end
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function onbuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/sign_craft")
end

local function fn(msg)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .2)

    inst.MiniMapEntity:SetIcon("sign.png")

    inst.AnimState:SetBank("sign_home")
    inst.AnimState:SetBuild("sign_home")
    inst.AnimState:PlayAnimation("idle")

    MakeSnowCoveredPristine(inst)

    inst:AddTag("structure")
    inst:AddTag("sign")

    --Sneak these into pristine state for optimization
    inst:AddTag("_writeable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --Remove these tags so that they can be added properly when replicating components below
    inst:RemoveTag("_writeable")

    inst:AddComponent("inspectable")
    inst:AddComponent("writeable")
    inst:AddComponent("lootdropper")

    -- inst:AddComponent("workable")
    -- inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    -- inst.components.workable:SetWorkLeft(4)
    -- inst.components.workable:SetOnFinishCallback(onhammered)
    -- inst.components.workable:SetOnWorkCallback(onhit)
    MakeSnowCovered(inst)

    -- MakeSmallBurnable(inst, nil, nil, true)
    -- MakeSmallPropagator(inst)
    inst.OnSave = onsave
    inst.OnLoad = onload

    -- MakeHauntableWork(inst)
    inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

local function welcomefn()
    local welcome_msg = "Welcome to Multi-worlds. You are currently in Bunnyland. There are many more worlds to explore which you can find through portals."
    local inst = fn()
    inst.components.writeable:SetText(welcome_msg)
    return inst
end

return Prefab("homesign_welcome", welcomefn, assets, prefabs)