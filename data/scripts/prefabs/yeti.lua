local brain = require "brains/yetibrain"

local assets =
{
    Asset("ANIM", "anim/deerclops_basic.zip"),
    Asset("ANIM", "anim/deerclops_actions.zip"),
    Asset("ANIM", "anim/deerclops_build.zip"),
    Asset("ANIM", "anim/yeti_build.zip"),
    Asset("SOUND", "sound/deerclops.fsb"),
}

local prefabs =
{
    "meat",
    "deerclops_eyeball",
    "icespike_fx_1",
    "icespike_fx_2",
    "icespike_fx_3",
    "icespike_fx_4",
}

local TARGET_DIST = 16
local YETI_HELP_DISTANCE = 40
local YETI_MAX_HELPERS = 6

local function CalcSanityAura(inst)
    return -TUNING.SANITYAURA_SMALL
end

local function RetargetFn(inst)
    --print("Deerclops retarget", debugstack())
    return FindEntity(inst, TARGET_DIST, function(guy)
        return inst.components.combat:CanTarget(guy)
               and (guy.components.combat.target == inst
                or (inst:GetPosition():Dist(guy:GetPosition()) <= (inst.Physics:GetRadius() + 8)))
    end, nil, {"yeti"})
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

local function OnEntitySleep(inst)

end

local function OnSave(inst, data)

end

local function OnLoad(inst, data)

end

local function OnAttacked(inst, data)
    if data.attacker == nil then
        return
    end
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(
        data.attacker,
        YETI_HELP_DISTANCE,
        function(dude)
            return dude:HasTag("yeti")
        end,
        YETI_MAX_HELPERS
    )
end

local loot = {"meat", "meat"}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 50, .5) -- TODO: fix

    local s  = 0.8
    inst.Transform:SetScale(s, s, s)
    inst.DynamicShadow:SetSize(2, 1.5)
    inst.Transform:SetFourFaced()

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("yeti")
    inst:AddTag("scarytoprey")
    inst:AddTag("herdmember")

    inst.AnimState:SetBank("deerclops")
    inst.AnimState:SetBuild("yeti_build")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    ------------------------------------------

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 3

    ------------------------------------------
    inst:SetStateGraph("SGyeti")

    ------------------------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    MakeLargeBurnableCharacter(inst, "deerclops_body")
    MakeHugeFreezableCharacter(inst, "deerclops_body")

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(1000)

    ------------------

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(30)
    --inst.components.combat:SetRange(5)
    inst.components.combat.hiteffectsymbol = "deerclops_body"
    inst.components.combat:SetAttackPeriod(TUNING.DEERCLOPS_ATTACK_PERIOD / 3)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    ------------------------------------------

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)

    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    inst.components.lootdropper:AddChanceLoot("bluegem", 0.2)

    --

    inst:AddComponent("herdmember")
    inst.components.herdmember:SetHerdPrefab("yetiherd")
    inst.components.herdmember:Enable(true)

    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()
    ------------------------------------------
    inst:AddComponent("knownlocations")
    inst:SetBrain(brain)

    inst:ListenForEvent("entitysleep", OnEntitySleep)
    inst:ListenForEvent("attacked", OnAttacked)
    --inst:ListenForEvent("death", OnDead)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("yeti", fn, assets, prefabs)
