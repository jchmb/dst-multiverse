local assets =
{
    Asset("ANIM", "anim/manrabbit_basic.zip"),
    Asset("ANIM", "anim/manrabbit_actions.zip"),
    Asset("ANIM", "anim/manrabbit_attacks.zip"),
    Asset("ANIM", "anim/manrabbit_build.zip"),

    Asset("ANIM", "anim/manrabbit_beard_build.zip"),
    Asset("ANIM", "anim/manrabbit_beard_basic.zip"),
    Asset("ANIM", "anim/manrabbit_beard_actions.zip"),
    Asset("SOUND", "sound/bunnyman.fsb"),
}

local prefabs =
{
    "meat",
    "manrabbit_tail",
    "carrot",
    "thulecite_pieces",
}

-- Every bunny citizen pays one carrot every day
local CARROT_TAX = 60 * 8

local MAX_GIANT_BUNNYMAN_MINIONS = 4

local GIANT_BUNNYMAN_LOOT = {
    "carrot",
    "carrot",
    "carrot",
    "manrabbit_tail",
    "manrabbit_tail",
    "meat",
    "meat",
    "thulecite_pieces",
    "rabbit",
    "rabbit",
    "rabbit",
}

local brain = require("brains/giant_bunnymanbrain")

local MAX_TARGET_SHARES = 15
local SHARE_TARGET_DIST = 30

local function IsCrazyGuy(guy)
    return false
end

local function CalcSanityAura(inst, observer)
    return -TUNING.SANITYAURA_MED
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(
        data.attacker,
        SHARE_TARGET_DIST,
        function(dude)
            return dude:HasTag("manrabbit")
        end,
        MAX_TARGET_SHARES
    )
end

local function OnNewTarget(inst, data)
    if data == nil or data.target == nil then
        return
    end
    inst.components.combat:ShareTarget(
        data.target,
        math.floor(SHARE_TARGET_DIST / 2),
        function(dude)
            return dude:HasTag("manrabbit")
        end,
        math.floor(MAX_TARGET_SHARES)
    )
end

local function is_meat(item)
    return item.components.edible ~= nil  and item.components.edible.foodtype == FOODTYPE.MEAT
end

local function NormalRetargetFn(inst)
    return FindEntity(inst, TUNING.PIG_TARGET_DIST,
        function(guy)
            return inst.components.combat:CanTarget(guy)
                and (guy:HasTag("monster")
                    or (guy.components.inventory ~= nil and
                        guy:IsNear(inst, TUNING.BUNNYMAN_SEE_MEAT_DIST) and
                        guy.components.inventory:FindItem(is_meat) ~= nil))
        end,
        { "_combat", "_health" }, -- see entityreplica.lua
        {"bunnyfriend"},
        { "monster", "player" })
end

local function NormalKeepTargetFn(inst, target)
    return not (target.sg ~= nil and target.sg:HasStateTag("hiding")) and inst.components.combat:CanTarget(target)
end

local function LootSetupFunction(lootdropper)
    -- regular loot
    lootdropper:SetLoot(GIANT_BUNNYMAN_LOOT)
    lootdropper.numrandomloot = 0
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("manrabbit_build")

    MakeGiantCharacterPhysics(inst, 1000, .5)

    inst.DynamicShadow:SetSize(6, 3.5)
    inst.Transform:SetFourFaced()
    local s = 4
    inst.Transform:SetScale(s, s, s)

    inst:AddTag("epic")
    inst:AddTag("cavedweller")
    inst:AddTag("character")
    inst:AddTag("pig")
    inst:AddTag("manrabbit")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")

    inst.AnimState:SetBank("manrabbit")
    inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:Hide("hat")

    --inst.AnimState:SetClientsideBuildOverride("insane", "manrabbit_build", "manrabbit_beard_build")

    --Sneak these into pristine state for optimization

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = 1 -- account for them being stopped for part of their anim
    inst.components.locomotor.walkspeed = 1 -- account for them being stopped for part of their anim

    inst:AddComponent("bloomer")

    ------------------------------------------
    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.VEGGIE }, { FOODTYPE.VEGGIE })
    inst.components.eater:SetCanEatRaw()

    ------------------------------------------
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "manrabbit_torso"
    inst.components.combat.panic_thresh = TUNING.BUNNYMAN_PANIC_THRESH

    --inst.components.combat.GetBattleCryString = battlecry
    --inst.components.combat.GetGiveUpString = giveupstring

    MakeMediumBurnableCharacter(inst, "manrabbit_torso")

    ------------------------------------------
    ------------------------------------------
    inst:AddComponent("health")
    inst.components.health:StartRegen(TUNING.BUNNYMAN_HEALTH_REGEN_AMOUNT, TUNING.BUNNYMAN_HEALTH_REGEN_PERIOD)

    ------------------------------------------

    inst:AddComponent("inventory")

    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLootSetupFn(LootSetupFunction)
    LootSetupFunction(inst.components.lootdropper)

    ------------------------------------------

    inst:AddComponent("knownlocations")

    ------------------------------------------

    ------------------------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    ------------------------------------------

    inst:AddComponent("sleeper")

    ------------------------------------------
    --TODO ???? MakeMediumFreezableCharacter(inst, "pig_torso")

    ------------------------------------------

    inst:AddComponent("inspectable")
    ------------------------------------------

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewTarget)

    inst.components.sleeper:SetResistance(6)
    inst.components.sleeper.sleeptestfn = NocturnalSleepTest
    inst.components.sleeper.waketestfn = NocturnalWakeTest

    inst.components.combat:SetDefaultDamage(TUNING.BUNNYMAN_DAMAGE + 30)
    inst.components.combat:SetAttackPeriod(TUNING.BUNNYMAN_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
    inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)

    inst.components.locomotor.runspeed = 1
    inst.components.locomotor.walkspeed = 1

    inst.components.health:SetMaxHealth(5000)

    inst.AnimState:SetMultColour(0.75, 0.35, 0.25, 1)

    --MakeHauntablePanic(inst, 5, nil, 5)

    inst:SetBrain(brain)
    inst:SetStateGraph("SGgiantbunnyman")

    inst.beardlord = false

    inst.taxes = {

    }

    return inst
end

return Prefab("giant_bunnyman", fn, assets, prefabs)
