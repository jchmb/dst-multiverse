local assets=
{
    Asset("ANIM", "anim/sharkitten_basic.zip"),
	Asset("ANIM", "anim/sharkitten_build.zip"),
	Asset("SOUND", "sound/hound.fsb"),
}

local prefabs = 
{
    --"shark_gills",
    --"fish_raw",
}

SetSharedLootTable('sharkitten',
{
    {"fish", 1.00},
    {"fish", 0.50},
    {"shark_gills", 0.50},
})

local function grow(inst, dt)
    if inst.components.scaler.scale < 0.75 then
        local new_scale = math.min(inst.components.scaler.scale + TUNING.ROCKY_GROW_RATE*dt, 0.75)
        inst.components.scaler:SetScale(new_scale)
    else
        if inst.growtask then
            inst.growtask:Cancel()
            inst.growtask = nil
        end
    end
end

local function applyscale(inst, scale)
	inst.DynamicShadow:SetSize(2.5 * scale, 1.5 * scale)
end

local function OnAttacked(inst, data)
    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, 30, {'sharkitten'})
    
    local num_friends = 0
    local maxnum = 5
    for k,v in pairs(ents) do
        v:PushEvent("gohome")
        num_friends = num_friends + 1
        
        if num_friends > maxnum then
            break
        end
    end

    --Try to get help from tigershark
    --check if it's nearby first
    -- local shark = GetClosestInstWithTag("tigershark", inst, 60)

    -- --try to spawn it if it isn't.
    -- if not shark then
    --     local tigersharker = TheWorld.components.tigersharker

    --     shark = tigersharker:SpawnShark()
    --     if shark then
    --         local spawnpt = tigersharker:GetNearbySpawnPoint(inst)
    --         shark.Transform:SetPosition(spawnpt:Get())
    --     end
    -- end

    -- if shark then  
    --     shark.components.combat:SuggestTarget(data.attacker)
    -- end
end

local TARGET_DIST = 15

local function RetargetFn(inst)
    local notags = {"FX", "NOCLICK","INLIMBO"}
    local yestags = {"prey", "smallcreature"}
    return FindEntity(inst, TARGET_DIST, function(guy)
        return inst.components.combat:CanTarget(guy)
    end, nil, notags, yestags)
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function kittenfn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local physics = inst.entity:AddPhysics()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)
    --  MakePoisonableCharacter(inst)
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

	shadow:SetSize( 2.5, 1.5 )
    trans:SetFourFaced()

    inst:AddTag("sharkitten")
    inst:AddTag("scarytoprey")
    inst:AddTag("prey")

    anim:SetBank("sharkitten")
    anim:SetBuild("sharkitten_build")
    anim:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 3 --TUNING.SHARKITTEN_SPEED
    inst.components.locomotor.runspeed = 4 --TUNING.SHARKITTEN_SPEED

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(150)

    inst:AddComponent("combat")
    inst.components.combat:SetRetargetFunction(2, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('sharkitten')

    inst:AddComponent("sleeper")

    inst:AddComponent("follower")

    inst:AddComponent("knownlocations")

    inst:AddComponent("scaler")
    inst.components.scaler.OnApplyScale = applyscale

    inst:AddComponent("eater")

    local min_scale = 0.75
    local max_scale = 1.00

    local scaleRange = max_scale - min_scale
    local start_scale = min_scale + math.random() * scaleRange

    inst.components.scaler:SetScale(start_scale)
    local dt = 60 + math.random()*10
    inst.growtask = inst:DoPeriodicTask(dt, grow, nil, dt)

    local brain = require "brains/sharkittenbrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGsharkitten")

    inst.OnLongUpdate = grow

    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

return Prefab("sharkitten", kittenfn, assets, prefabs)
