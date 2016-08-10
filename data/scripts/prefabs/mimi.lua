local assets =
{
    Asset("ANIM", "anim/kiki_basic.zip"),
    Asset("ANIM", "anim/kiki_build.zip"),
    Asset("SOUND", "sound/monkey.fsb"),
}

local prefabs =
{
    "poop",
    "monkeyprojectile",
    "smallmeat",
    "cave_banana",
}

local brain = require "brains/mimibrain"

local SLEEP_DIST_FROMHOME = 1
local SLEEP_DIST_FROMTHREAT = 20
local MAX_CHASEAWAY_DIST = 80
local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 40

SetSharedLootTable('monkey',
{
    {'smallmeat',     1.0},
    {'cave_banana',   1.0},
})

local function GetLeader(inst)
    return inst.components.follower.leader
end

local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

local function IsPoop(item)
    return item.prefab == "poop"
end

local function oneat(inst)
    --Monkey ate some food. Give him some poop!
    if inst.components.inventory ~= nil then
        local maxpoop = 3
        local poopstack = inst.components.inventory:FindItem(IsPoop)
        if poopstack == nil or poopstack.components.stackable.stacksize < maxpoop then
            inst.components.inventory:GiveItem(SpawnPrefab("poop"))
        end
    end
end

local function onthrow(weapon, inst)
    if inst.components.inventory ~= nil and inst.components.inventory:FindItem(IsPoop) ~= nil then
        inst.components.inventory:ConsumeByName("poop", 1)
    end
end

local function hasammo(inst)
    return inst.components.inventory ~= nil and inst.components.inventory:FindItem(IsPoop) ~= nil
end

local function EquipWeapons(inst)
    if inst.components.inventory ~= nil and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local thrower = CreateEntity()
        thrower.name = "Thrower"
        thrower.entity:AddTransform()
        thrower:AddComponent("weapon")
        thrower.components.weapon:SetDamage(TUNING.MONKEY_RANGED_DAMAGE)
        thrower.components.weapon:SetRange(TUNING.MONKEY_RANGED_RANGE)
        thrower.components.weapon:SetProjectile("monkeyprojectile")
        thrower.components.weapon:SetOnProjectileLaunch(onthrow)
        thrower:AddComponent("inventoryitem")
        thrower.persists = false
        thrower.components.inventoryitem:SetOnDroppedFn(thrower.Remove)
        thrower:AddComponent("equippable")
        inst.components.inventory:GiveItem(thrower)
        inst.weaponitems.thrower = thrower

        local hitter = CreateEntity()
        hitter.name = "Hitter"
        hitter.entity:AddTransform()
        hitter:AddComponent("weapon")
        hitter.components.weapon:SetDamage(TUNING.MONKEY_MELEE_DAMAGE)
        hitter.components.weapon:SetRange(0)
        hitter:AddComponent("inventoryitem")
        hitter.persists = false
        hitter.components.inventoryitem:SetOnDroppedFn(hitter.Remove)
        hitter:AddComponent("equippable")
        inst.components.inventory:GiveItem(hitter)
        inst.weaponitems.hitter = hitter

    end
end

local function _ForgetTarget(inst)
    inst.components.combat:SetTarget(nil)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    --SetHarassPlayer(inst, nil)
    if inst.task ~= nil then
        inst.task:Cancel()
    end
end

local function IsBanana(item)
    return item.prefab == "cave_banana" or item.prefab == "cave_banana_cooked"
end

local function retargetfn(inst)
    return nil
end

local function shouldKeepTarget(inst)
    --[[if inst:HasTag("nightmare") then
        return true
    end]]
    return true
end

local function OnPickup(inst, data)
    local item = data.item
    if item ~= nil and
        item.components.equippable ~= nil and
        item.components.equippable.equipslot == EQUIPSLOTS.HEAD and
        not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) then
        --Ugly special case for how the PICKUP action works.
        --Need to wait until PICKUP has called "GiveItem" before equipping item.
        inst:DoTaskInTime(0, function()
            if item:IsValid() and
                item.components.inventoryitem ~= nil and
                item.components.inventoryitem.owner == inst then
                inst.components.inventory:Equip(item)
            end
        end)
    end
end

local function DoFx(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")

    local x, y, z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("statue_transition_2")
    if fx ~= nil then
        fx.Transform:SetPosition(x, y, z)
        fx.Transform:SetScale(.8, .8, .8)
    end
    fx = SpawnPrefab("statue_transition")
    if fx ~= nil then
        fx.Transform:SetPosition(x, y, z)
        fx.Transform:SetScale(.8, .8, .8)
    end
end

local function SetNormalMonkey(inst)
    inst:SetBrain(brain)
    inst.AnimState:SetBuild("kiki_basic")
    inst.AnimState:SetMultColour(1, 1, 1, 1)
    inst.curious = true
    inst.soundtype = ""
end

local function OnCustomHaunt(inst)
    inst.components.periodicspawner:TrySpawn()
    return true
end

local function OnSave(inst, data)
    return
end

local function OnLoad(inst, data)
    return
end

local function ShouldAcceptItem(inst, item)
    return false
end

local function OnGetItemFromPlayer(inst, giver, item)
    return
end

local function OnRefuseItem(inst, item)
    return
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()   
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(2, 1.25)

    inst.Transform:SetSixFaced()

    MakeCharacterPhysics(inst, 10, 0.25)

    inst.AnimState:SetBank("kiki")
    inst.AnimState:SetBuild("kiki_basic")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddTag("monkey")
    inst:AddTag("animal")

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -400, 0)
    inst.components.talker:MakeChatter()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.soundtype = ""

    MakeMediumBurnableCharacter(inst)
    MakeMediumFreezableCharacter(inst)

    inst:AddComponent("bloomer")

    inst:AddComponent("inventory")

    inst:AddComponent("inspectable")

    inst:AddComponent("thief")

    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = false }
    inst.components.locomotor.walkspeed = TUNING.MONKEY_MOVE_SPEED

    inst:AddComponent("combat")
    inst.components.combat:SetAttackPeriod(TUNING.MONKEY_ATTACK_PERIOD)
    inst.components.combat:SetRange(TUNING.MONKEY_MELEE_RANGE)
    inst.components.combat:SetRetargetFunction(1, retargetfn)

    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)
    inst.components.combat:SetDefaultDamage(0)  --This doesn't matter, monkey uses weapon damage

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.MONKEY_HEALTH)

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("poop")
    inst.components.periodicspawner:SetRandomTimes(200,400)
    inst.components.periodicspawner:SetDensityInRange(20, 2)
    inst.components.periodicspawner:SetMinimumSpacing(15)
    inst.components.periodicspawner:Start()

    inst:AddComponent("lootdropper")

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.VEGGIE }, { FOODTYPE.VEGGIE })
    inst.components.eater:SetOnEatFn(oneat)

    inst:AddComponent("sleeper")
    --inst.components.sleeper.sleeptestfn = NocturnalSleepTest
    --inst.components.sleeper.waketestfn = NocturnalWakeTest

    inst:AddComponent("areaaware")

    inst:SetBrain(brain)
    inst:SetStateGraph("SGmimi")

    inst.HasAmmo = hasammo
    inst.curious = true

    inst:AddComponent("knownlocations")
    
    inst:AddComponent("follower")

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = false

    inst:ListenForEvent("onpickupitem", OnPickup)
    inst:ListenForEvent("attacked", OnAttacked)

    MakeHauntablePanic(inst)
    AddHauntableCustomReaction(inst, OnCustomHaunt, true, false, true)

    inst.weaponitems = {}
    EquipWeapons(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("mimi", fn, assets, prefabs)
