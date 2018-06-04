local mushassets =
{
    Asset("ANIM", "anim/new_mushrooms.zip"),
}

local cookedassets =
{
    Asset("ANIM", "anim/new_mushrooms.zip"),
}

local capassets =
{
    Asset("ANIM", "anim/new_mushrooms.zip"),
}

local function open(inst)
    if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
        if inst.growtask then
            inst.growtask:Cancel()
        end
        inst.growtask = inst:DoTaskInTime(3 + math.random() * 6, inst.opentaskfn)
        inst.openstate = "open"
    end
end

local function close(inst)
    if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
        if inst.growtask then
            inst.growtask:Cancel()
        end
        inst.growtask = inst:DoTaskInTime(3 + math.random() * 6, inst.closetaskfn)
        inst.openstate = "closed"
    end
end

local function OnIsOpenPhase(inst, isopen)
    local notstate = isopen and "open" or "closed"
    if isopen and inst.openstate ~= notstate then
        open(inst)
    elseif not isopen and inst.openstate ~= notstate then
        close(inst)
    end
end

local MUSHROOM_CHECK_DISTANCE = 5
local MIN_WETNESS_REQUIRED = 0.1
local WET_ITEMS = {"phlegm", "wetgoop", "mucus"}

local function IsSlimeyItem(item)
	return jchmb.IsOneOf(item, WET_ITEMS)
end

local function AppearsSlimey(guy)
	return guy.components.inventory ~= nil
		and guy.components.inventory:FindItem(IsSlimeyItem)
end

local function IsSlimey(guy)
    return (guy:HasTag("player") and AppearsSlimey(guy)) or
        guy.prefab == "yellow_pigman"
end

local function IsSlimeyGuyNearby(inst)
    local target = FindEntity(inst, MUSHROOM_CHECK_DISTANCE, IsSlimey)
    return target ~= nil
end

local regen_conditions =
{
    brown_mushroom = function(inst)
        return TheWorld.state.israining
    end,
    gray_mushroom = function(inst)
        return TheWorld.state.nightmarephase ~= "calm"
    end,
    yellow_mushroom = function(inst)
        return IsSlimeyGuyNearby(inst)
    end,
}

local function IsCrazyGuyNearby(inst)
    local crazyguy = FindEntity(inst, MUSHROOM_CHECK_DISTANCE, function(guy)
        return guy:HasTag("player") and guy.components.sanity:IsCrazy()
    end)
    return crazyguy ~= nil
end

local function OnUpdateGrayMushroomState(inst)
    if TheWorld.state.nightmarephase == "wild" or IsCrazyGuyNearby(inst) then
        OnIsOpenPhase(inst, true)
    else
        OnIsOpenPhase(inst, false)
    end
end

local function OnUpdateYellowMushroomState(inst)
    if IsSlimeyGuyNearby(inst) then
        OnIsOpenPhase(inst, true)
    else
        OnIsOpenPhase(inst, false)
    end
end

local function OnUpdateBrownMushroomState(inst)
    if TheWorld.state.israining then
        OnIsOpenPhase(inst, true)
    else
        OnIsOpenPhase(inst, false)
    end
end

local function OnNightmarePhaseChanged(inst, phase, instant)
    OnUpdateGrayMushroomState(inst)
end

local function onsave(inst, data)
    data.rain = inst.rain
end

local function onload(inst, data)
    if data.rain or inst.rain then
        inst.rain = data.rain or inst.rain
    end
end

local function onpickedfn(inst)
    if inst.growtask ~= nil then
        inst.growtask:Cancel()
        inst.growtask = nil
    end
    inst.AnimState:PlayAnimation("picked")
    inst.rain = 10 + math.random(10)
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("picked")
end

local function checkregrow(inst)
    if inst.components.pickable ~= nil and not inst.components.pickable.canbepicked and TheWorld.state.israining then
        inst.rain = inst.rain - 1
        if inst.rain <= 0 then
            inst.components.pickable:Regen()
        end
    end
end

local function GetStatus(inst)
    return (not (inst.components.pickable ~= nil and inst.components.pickable.canbepicked) and "PICKED")
        or (inst.components.pickable.caninteractwith and "GENERIC")
        or "INGROUND"
end

local function onregenfn(inst)
    local fn = regen_conditions[inst.prefab]
    if fn ~= nil and fn(inst) then
        open(inst)
    end
end

local function testfortransformonload(inst)
    return TheWorld.state.isfullmoon
end

local function OnSpawnedFromHaunt(inst, data)
    Launch(inst, data.haunter, TUNING.LAUNCH_SPEED_SMALL)
end

--V2C: basically, each colour and type can switch to another colour of the same type
local switchtable = {}
local switchcolours = { "gray", "brown", "yellow" }
local switchtypes = { "_cap", "_cap_cooked", "_mushroom" }
for i, v in ipairs(switchcolours) do
    for i2, v2 in ipairs(switchtypes) do
        local t = {}
        switchtable[v..v2] = t
        for i3, v3 in ipairs(switchcolours) do
            if v ~= v3 then
                table.insert(t, v3..v2)
            end
        end
    end
end
local function pickswitchprefab(inst)
    local t = switchtable[inst.prefab]
    return t ~= nil and t[math.random(#t)] or nil
end

local function OnHauntMush(inst, haunter)
    local ret = false
    if math.random() <= TUNING.HAUNT_CHANCE_OCCASIONAL then
        local x, y, z = inst.Transform:GetWorldPosition()
        SpawnPrefab("small_puff").Transform:SetPosition(x, y, z)
        local prefab = pickswitchprefab(inst)
        local new = prefab ~= nil and SpawnPrefab(prefab) or nil
        if new ~= nil then
            new.Transform:SetPosition(x, y, z)
            -- Make it the right state
            if inst.components.pickable ~= nil and not inst.components.pickable.canbepicked then
                if new.components.pickable ~= nil then
                    new.components.pickable:MakeEmpty()
                end
            elseif inst.components.pickable ~= nil and not inst.components.pickable.caninteractwith then
                new.AnimState:PlayAnimation("inground")
                if new.components.pickable ~= nil then
                    new.components.pickable.caninteractwith = false
                end
            else
                new.AnimState:PlayAnimation(new.data.animname.."_90s")
                if new.components.pickable ~= nil then
                    new.components.pickable.caninteractwith = true
                end
            end
        end
        new:PushEvent("spawnedfromhaunt", { haunter = haunter, oldPrefab = inst })
        inst:PushEvent("despawnedfromhaunt", { haunter = haunter, newPrefab = new })
        inst.persists = false
        inst.entity:Hide()
        inst:DoTaskInTime(0, inst.Remove)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
        ret = true
    elseif inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() and inst.components.pickable.caninteractwith then
        inst:closetaskfn()
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
        ret = true
    end
    --#HAUNTFIX
    --if math.random() <= TUNING.HAUNT_CHANCE_VERYRARE then
        --if inst.components.burnable ~= nil and not inst.components.burnable:IsBurning() and
            --inst.components.pickable ~= nil and inst.components.pickable.canbepicked then
            --inst.components.burnable:Ignite()
            --inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
            --inst.components.hauntable.cooldown_on_successful_haunt = false
            --ret = true
        --end
    --end
    return ret
end

local function mushcommonfn(data)
    local inst = CreateEntity()

    inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("new_mushrooms")
    inst.AnimState:SetBuild("new_mushrooms")
    inst.AnimState:PlayAnimation(data.animname)
    inst.AnimState:SetRayTestOnBB(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.data = data
    inst.openstate = "unknown"

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst.opentaskfn = function()
        inst.AnimState:PlayAnimation("open_inground")
        inst.AnimState:PushAnimation("open_"..data.animname)
        inst.AnimState:PushAnimation(data.animname)
        inst.SoundEmitter:PlaySound("dontstarve/common/mushroom_up")
        inst.growtask = nil
        if inst.components.pickable ~= nil then
            inst.components.pickable.caninteractwith = true
        end
    end

    inst.closetaskfn = function()
        inst.AnimState:PlayAnimation("close_"..data.animname)
        inst.AnimState:PushAnimation("inground")
        inst:DoTaskInTime(.25, function() inst.SoundEmitter:PlaySound("dontstarve/common/mushroom_down") end )
        inst.growtask = nil
        if inst.components.pickable then
            inst.components.pickable.caninteractwith = false
        end
    end

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp(data.pickloot, nil)
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.makeemptyfn = makeemptyfn
    --inst.components.pickable.quickpick = true

    inst.rain = 0

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(function(inst, chopper)
        if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
            inst.components.lootdropper:SpawnLootPrefab(data.pickloot)
        end

        inst.components.lootdropper:SpawnLootPrefab(data.pickloot)
        inst:Remove()
    end)
    inst.components.workable:SetWorkLeft(1)

    --inst:AddComponent("transformer")
    --inst.components.transformer:SetTransformWorldEvent("isfullmoon", true)
    --inst.components.transformer:SetRevertWorldEvent("isfullmoon", false)
    --inst.components.transformer:SetOnLoadCheck(testfortransformonload)
    --inst.components.transformer.transformPrefab = data.transform_prefab

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeNoGrowInWinter(inst)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetOnHauntFn(OnHauntMush)

    inst:DoPeriodicTask(TUNING.SEG_TIME, checkregrow, TUNING.SEG_TIME + math.random()*TUNING.SEG_TIME)

    if regen_conditions[data.name] then
        inst.AnimState:PlayAnimation(data.animname)
        inst.components.pickable.caninteractwith = true
    else
        inst.AnimState:PlayAnimation("inground")
        inst.components.pickable.caninteractwith = false
    end

    data.initfn(inst)

    return inst
end

local function OnHauntCapOrCooked(inst, haunter)
    if math.random() <= TUNING.HAUNT_CHANCE_RARE then
        local x, y, z = inst.Transform:GetWorldPosition()
        SpawnPrefab("small_puff").Transform:SetPosition(x, y, z)
        local prefab = pickswitchprefab(inst)
        local new = prefab ~= nil and SpawnPrefab(prefab) or nil
        if new ~= nil then
            new.Transform:SetPosition(x, y, z)
            if new.components.stackable ~= nil and inst.components.stackable ~= nil and inst.components.stackable:IsStack() then
                new.components.stackable:SetStackSize(inst.components.stackable:StackSize())
            end
            if new.components.inventoryitem ~= nil and inst.components.inventoryitem ~= nil then
                new.components.inventoryitem:InheritMoisture(inst.components.inventoryitem:GetMoisture(), inst.components.inventoryitem:IsWet())
            end
            if new.components.perishable ~= nil and inst.components.perishable ~= nil then
                new.components.perishable:SetPercent(inst.components.perishable:GetPercent())
            end
            new:PushEvent("spawnedfromhaunt", { haunter = haunter, oldPrefab = inst })
            inst:PushEvent("despawnedfromhaunt", { haunter = haunter, newPrefab = new })
            inst.persists = false
            inst.entity:Hide()
            inst:DoTaskInTime(0, inst.Remove)
        end
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
        return true
    end
    return false
end

local function capcommonfn(data)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("new_mushrooms")
    inst.AnimState:SetBuild("new_mushrooms")
    inst.AnimState:PlayAnimation(data.animname.."_cap")

    MakeDragonflyBait(inst, 3)

    --cookable (from cookable component) added to pristine state for optimization
    inst:AddTag("cookable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
    MakeSmallPropagator(inst)
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..data.pickloot..".xml"

    --this is where it gets interesting
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = data.health
    inst.components.edible.hungervalue = data.hunger
    inst.components.edible.sanityvalue = data.sanity
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)
    AddHauntableCustomReaction(inst, OnHauntCapOrCooked, true, false, true)
    inst:ListenForEvent("spawnedfromhaunt", OnSpawnedFromHaunt)

    inst:AddComponent("cookable")
    inst.components.cookable.product = data.pickloot.."_cooked"

    return inst
end

local function cookedcommonfn(data)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("new_mushrooms")
    inst.AnimState:SetBuild("new_mushrooms")
    inst.AnimState:PlayAnimation(data.pickloot.."_cooked")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.TINY_FUEL
    MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
    MakeSmallPropagator(inst)
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..data.pickloot.."_cooked.xml"

    MakeHauntableLaunchAndPerish(inst)
    AddHauntableCustomReaction(inst, OnHauntCapOrCooked, true, false, true)
    inst:ListenForEvent("spawnedfromhaunt", OnSpawnedFromHaunt)

    --this is where it gets interesting
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = data.cookedhealth
    inst.components.edible.hungervalue = data.cookedhunger
    inst.components.edible.sanityvalue = data.cookedsanity
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    return inst
end

local function MakeMushroom(data)
    local prefabs =
    {
        data.pickloot,
        data.pickloot.."_cooked",
        "small_puff",
    }

    local prefabs2 =
    {
        "small_puff",
    }

    local function mushfn()
        return mushcommonfn(data)
    end

    local function capfn()
        return capcommonfn(data)
    end

    local function cookedfn()
        return cookedcommonfn(data)
    end

    return Prefab(data.name, mushfn, mushassets, prefabs),
           Prefab(data.pickloot, capfn, capassets, prefabs2),
           Prefab(data.pickloot.."_cooked", cookedfn, cookedassets, prefabs2)
end

local data =
{
    {
        name = "brown_mushroom",
        animname="brown",
        pickloot="brown_cap",
        initfn = function(inst)
            inst.updatetask = inst:DoPeriodicTask(2, OnUpdateBrownMushroomState)
            OnUpdateBrownMushroomState(inst)
        end,
        sanity = 0,
        health = -8,
        hunger = 5,
        cookedsanity = -3,
        cookedhealth = 3,
        cookedhunger = 10,
        transform_prefab = "mushtree_medium",
    },
    {
        name = "gray_mushroom",
        animname="gray",
        pickloot="gray_cap",
        initfn = function(inst)
            inst:WatchWorldState("nightmarephase", OnNightmarePhaseChanged)
            inst.updatetask = inst:DoPeriodicTask(2, OnUpdateGrayMushroomState)
            OnUpdateGrayMushroomState(inst)
        end,
        sanity = -5,
        health = -5,
        hunger = 5,
        cookedsanity = -8,
        cookedhealth = 5,
        cookedhunger = 2,
        transform_prefab = "mushtree_medium",
    },
    {
        name = "yellow_mushroom",
        animname="yellow",
        pickloot="yellow_cap",
        initfn = function(inst)
            inst.updatetask = inst:DoPeriodicTask(2, OnUpdateYellowMushroomState)
        end,
        sanity = -8,
        health = -10,
        hunger = 10,
        cookedsanity = -3,
        cookedhealth = -3,
        cookedhunger = 15,
        transform_prefab = "mushtree_medium",
    },
}

local prefabs = {}

for k,v in pairs(data) do
    local shroom, cap, cooked = MakeMushroom(v)
    table.insert(prefabs, shroom)
    table.insert(prefabs, cap)
    table.insert(prefabs, cooked)
end

return unpack(prefabs)
