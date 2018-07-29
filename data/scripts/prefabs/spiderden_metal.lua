local prefabs =
{
    "spider",
    "spider_metal",
    "silk",
    -- "spidereggsack_poisonous",
    -- "spiderqueen",
}

local assets =
{
    Asset("ANIM", "anim/spider_cocoon.zip"),
    Asset("ANIM", "anim/spider_cocoon_metal.zip"),
    Asset("SOUND", "sound/spider.fsb"),
	Asset("MINIMAP_IMAGE", "spiderden"), --shared with spiderden2 and 3
}

local ANIM_DATA =
{
    SMALL =
    {
        hit = "cocoon_small_hit",
        idle = "cocoon_small",
        init = "grow_sac_to_small",
    },
}

SetSharedLootTable("spiderden_metal", {
        {"rocks", 1.00},
        {"rocks", 1.00},
        {"rocks", 1.00},
        {"ironnugget", 0.80},
        {"ironnugget", 0.80},
        {"goldnugget", 0.20},
})

local QUEEN_LOOT =
{
    "monstermeat",
    "monstermeat",
    "monstermeat",
    "venom_gland",
    "silk",
    "silk",
    "silk",
    "spidereggsack_poisonous",
    "spiderhat",
}

local function SetStage(inst, stage)
    if stage <= 3 and inst.components.childspawner ~= nil then -- if childspawner doesn't exist, then this den is burning down
        inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_grow")
        inst.components.childspawner:SetMaxChildren(math.floor(SpringCombatMod(TUNING.SPIDERDEN_SPIDERS[stage] * 2)))
        inst.components.childspawner:SetMaxEmergencyChildren(TUNING.SPIDERDEN_EMERGENCY_WARRIORS[stage])
        inst.components.childspawner:SetEmergencyRadius(TUNING.SPIDERDEN_EMERGENCY_RADIUS[stage] * 1.5)
        inst.components.health:SetMaxHealth(TUNING.SPIDERDEN_HEALTH[stage] * 2)

        inst.AnimState:PlayAnimation(inst.anims.init)
        inst.AnimState:PushAnimation(inst.anims.idle, true)
    end

    inst.components.upgradeable:SetStage(stage)
    inst.data.stage = stage -- track here, as growable component may go away
end

local function onspawnspider(inst, spider)
    spider.sg:GoToState("taunt")
end

local function SetSmall(inst)
    inst.anims = ANIM_DATA.SMALL
    SetStage(inst, 1)
    inst.components.lootdropper:SetChanceLootTable("spiderden_metal")

    if inst.components.burnable ~= nil then
        inst.components.burnable:SetFXLevel(3)
        inst.components.burnable:SetBurnTime(20)
    end

    if inst.components.freezable ~= nil then
        inst.components.freezable:SetShatterFXLevel(3)
        inst.components.freezable:SetResistance(4)
    end

    -- inst.GroundCreepEntity:SetRadius(0)
end

local function OnThaw(inst)
    --print(inst, "OnThaw")
    inst.AnimState:PlayAnimation(inst.anims.thaw, true)
    inst.SoundEmitter:PlaySound("dontstarve/common/freezethaw", "thawing")
    inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
end

local function OnUnFreeze(inst)
    --print(inst, "OnUnFreeze")
    inst.AnimState:PlayAnimation(inst.anims.idle, true)
    inst.SoundEmitter:KillSound("thawing")
    inst.AnimState:ClearOverrideSymbol("swap_frozen")

    StartSpawning(inst)

    if inst.components.growable ~= nil then
        inst.components.growable:Resume()
    end
end

local function GetSmallGrowTime(inst)
    return TUNING.SPIDERDEN_GROW_TIME[1] * (1 + math.random())
end

local function OnKilled(inst)
    inst.AnimState:PlayAnimation("cocoon_dead")
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren()
    end
    RemovePhysicsColliders(inst)

    inst.SoundEmitter:KillSound("loop")

    inst.SoundEmitter:PlaySound("dontstarve/creatures/knight/death")
    inst.components.lootdropper:DropLoot(inst:GetPosition())
end

local function IsDefender(child)
    return child.prefab == "spider_metal"
end

local function SpawnDefenders(inst, attacker)
    if not inst.components.health:IsDead() then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/knight/hurt")
        inst.AnimState:PlayAnimation(inst.anims.hit)
        inst.AnimState:PushAnimation(inst.anims.idle)
        if inst.components.childspawner ~= nil then
            local max_release_per_stage = { 2, 4, 6 }
            local num_to_release = math.min(max_release_per_stage[inst.data.stage] or 1, inst.components.childspawner.childreninside)
            local num_warriors = math.min(num_to_release, TUNING.SPIDERDEN_WARRIORS[inst.data.stage])
            num_to_release = math.floor(SpringCombatMod(num_to_release))
            num_warriors = math.floor(SpringCombatMod(num_warriors))
            num_warriors = num_warriors - inst.components.childspawner:CountChildrenOutside(IsDefender)
            for k = 1, num_to_release do
                inst.components.childspawner.childname = k <= num_warriors and "spider_metal" or "spider_metal"
                local spider = inst.components.childspawner:SpawnChild()
                if spider ~= nil and attacker ~= nil and spider.components.combat ~= nil then
                    spider.components.combat:SetTarget(attacker)
                    spider.components.combat:BlankOutAttacks(1.5 + math.random() * 2)
                end
            end
            inst.components.childspawner.childname = "spider_metal"

            local emergencyspider = inst.components.childspawner:TrySpawnEmergencyChild()
            if emergencyspider ~= nil then
                emergencyspider.components.combat:SetTarget(attacker)
                emergencyspider.components.combat:BlankOutAttacks(1.5 + math.random() * 2)
            end
        end
    end
end

local function IsInvestigator(child)
    return child.components.knownlocations:GetLocation("investigate") ~= nil
end

local function SpawnInvestigators(inst, data)
    if not inst.components.health:IsDead() then
        inst.AnimState:PlayAnimation(inst.anims.hit)
        inst.AnimState:PushAnimation(inst.anims.idle)
        if inst.components.childspawner ~= nil then
            local max_release_per_stage = { 1, 2, 3 }
            local num_to_release = math.min(max_release_per_stage[inst.data.stage] or 1, inst.components.childspawner.childreninside)
            num_to_release = math.floor(SpringCombatMod(num_to_release))
            local num_investigators = inst.components.childspawner:CountChildrenOutside(IsInvestigator)
            num_to_release = num_to_release - num_investigators
            local targetpos = data ~= nil and data.target ~= nil and data.target:GetPosition() or nil
            for k = 1, num_to_release do
                local spider = inst.components.childspawner:SpawnChild()
                if spider ~= nil and targetpos ~= nil then
                    spider.components.knownlocations:RememberLocation("investigate", targetpos)
                end
            end
        end
    end
end

local function StartSpawning(inst)
    if inst.components.childspawner ~= nil and
        not TheWorld.state.iscaveday then
        inst.components.childspawner:StartSpawning()
    end
end

local function StopSpawning(inst)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:StopSpawning()
    end
end

local function OnEntityWake(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spidernest_LP", "loop")
end

local function OnEntitySleep(inst)
    inst.SoundEmitter:KillSound("loop")
end

local function OnIsCaveDay(inst, iscaveday)
    if iscaveday then
        StopSpawning(inst)
    else
        StartSpawning(inst)
    end
end

local function OnInit(inst)
    inst:WatchWorldState("iscaveday", OnIsCaveDay)
    OnIsCaveDay(inst, TheWorld.state.iscaveday)
end

local function OnStageAdvance(inst)
   inst.components.growable:DoGrowth()
   return true
end

local function OnUpgrade(inst)
   inst.AnimState:PlayAnimation(inst.anims.hit)
   inst.AnimState:PushAnimation(inst.anims.idle)
end

local growth_stages =
{
    { name = "small",   time = GetSmallGrowTime,    fn = SetSmall           },
}

local function CanTarget(guy)
    return not guy.components.health:IsDead()
end

local function OnHaunt(inst)
    if math.random() <= TUNING.HAUNT_CHANCE_HALF then
        local target = FindEntity(
            inst,
            25,
            CanTarget,
            { "_combat", "_health" }, --see entityreplica.lua
            { "playerghost", "spider", "INLIMBO" }
        )
        if target ~= nil then
            SpawnDefenders(inst, target)
            inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
            return true
        end
    end

    return false
end

local function MakeSpiderDenFn(den_level)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        -- inst.entity:AddGroundCreepEntity()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, .5)

        inst.MiniMapEntity:SetIcon("spiderden.png")

        inst.AnimState:SetBank("spider_cocoon")
        inst.AnimState:SetBuild("spider_cocoon_metal")
        inst.AnimState:PlayAnimation("cocoon_small", true)

        inst:AddTag("cavedweller")
        inst:AddTag("structure")
        inst:AddTag("chewable") -- by werebeaver
        inst:AddTag("hostile")
        inst:AddTag("spiderden")
        inst:AddTag("hive")

        MakeSnowCoveredPristine(inst)

        -- inst:SetPrefabName("spiderden")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.data = {}

        -------------------
        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(500)

        -------------------
        inst:AddComponent("childspawner")
        inst.components.childspawner.childname = "spider_metal"
        inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
        inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)

        inst.components.childspawner.emergencychildname = "spider_metal"
        inst.components.childspawner.emergencychildrenperplayer = 1

        inst.components.childspawner:SetSpawnedFn(onspawnspider)
        --inst.components.childspawner:SetMaxChildren(TUNING.SPIDERDEN_SPIDERS[stage])
        --inst.components.childspawner:ScheduleNextSpawn(0)
        inst:ListenForEvent("creepactivate", SpawnInvestigators)

        ---------------------
        inst:AddComponent("lootdropper")
        ---------------------
        -------------------

        ---------------------
        -- MakeMediumFreezableCharacter(inst)
        -- inst:ListenForEvent("freeze", OnFreeze)
        inst:ListenForEvent("onthaw", OnThaw)
        -- inst:ListenForEvent("unfreeze", OnUnFreeze)
        -------------------

        inst:DoTaskInTime(0, OnInit)

        -------------------

        inst:AddComponent("combat")
        inst.components.combat:SetOnHit(SpawnDefenders)
        inst:ListenForEvent("death", OnKilled)

        inst:AddComponent("upgradeable")
        inst.components.upgradeable.upgradetype = UPGRADETYPES.SPIDER
        inst.components.upgradeable.onupgradefn = OnUpgrade
        inst.components.upgradeable.onstageadvancefn = OnStageAdvance

        inst:AddComponent("growable")
        inst.components.growable.springgrowth = true
        inst.components.growable.stages = growth_stages
        inst.components.growable:SetStage(den_level)
        inst.components.growable:StartGrowing()

        ---------------------

        --inst:AddComponent( "spawner" )
        --inst.components.spawner:Configure( "resident", max, initial, rate )
        --inst.spawn_weight = global_spawn_weight

        inst:AddComponent("inspectable")

        MakeSnowCovered(inst)

        inst.OnEntitySleep = OnEntitySleep
        inst.OnEntityWake = OnEntityWake
        return inst
    end
end

return Prefab("spiderden_metal", MakeSpiderDenFn(1), assets, prefabs)
