require "prefabutil"
require "recipes"

local assets =
{
    Asset("ANIM", "anim/rabbit_house.zip"),
    Asset("ANIM", "anim/rabbit_house_blue.zip"),
    Asset("MINIMAP_IMAGE", "rabbit_house"),
}

local prefabs =
{
    "bunnyman",
}

local COLOR_GENERATORS = {
    ["colored"] = function()
        return {
            r = math.random() * 0.5 + 0.5,
            g = math.random() * 0.3 + 0.3,
            b = math.random() * 0.5,
        }
    end,
    ["default"] = function()
        return {
            r = 1, g = 1, b = 1,
        }
    end,
    ["winter"] = function()
        return {
            r = math.random() * 0.5,
            g = math.random() * 0.5 + 0.3,
            b = math.random() * 0.4 + 0.6,
        }
    end,
    ["desert"] = function()
        return {
            r = 1,
            g = 0.6 + math.random() * 0.2,
            b = 0
        }
    end,
}

local TRADE_BEHAVIORS = {

}

local function getstatus(inst)
    return (inst:HasTag("burnt") and "BURNT")
        or (inst.lightson and
            inst.components.spawner ~= nil and
            inst.components.spawner:IsOccupied() and
            "FULL")
        or nil
end

local function onoccupied(inst, child)
    --inst.SoundEmitter:PlaySound("dontstarve/pig/pig_in_hut", "pigsound")
    --inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
    child.stufftarget = nil
end

local function onvacate(inst, child)
    --inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
    --inst.SoundEmitter:KillSound("pigsound")

    if not inst:HasTag("burnt") and
            child ~= nil and
            child.components.health ~= nil then
        child.components.health:SetPercent(1)
        if child.colorpicked == nil then
            local colorfn = COLOR_GENERATORS[inst.colorfname or "default"]
            local colorpicked = colorfn()
            child.AnimState:SetMultColour(colorpicked.r, colorpicked.g, colorpicked.b, 1)
            child.colorpicked = colorpicked
        end
        if inst.welcomer then
            child.welcomer = true
        end
        if inst.startinghat ~= nil then
            local hat = child.components.inventory:FindItem(
                function(x)
                    return x.prefab == inst.startinghat
                end
            )
            local equippedhat = child.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            if hat or equippedhat then --or equippedhat then
                return
            end
            local item = SpawnPrefab(inst.startinghat)
            child.components.inventory:Equip(item)
            if item.components.finiteuses ~= nil then
                item.components.finiteuses:SetPercent(math.random() * 0.05 + 0.05)
            end
            if item.components.armor ~= nil then
                item.components.armor:SetPercent(math.random() * 0.05 + 0.05)
            end
            if item.components.fueled ~= nil then
                item.components.fueled:SetPercent(math.random() * 0.05 + 0.20)
            end
            if item.components.perishable ~= nil then
                local perishable = item.components.perishable
                perishable.perishremainingtime = perishable.perishtime * 0.2
            end
            child.AnimState:Show("hat")
            child.startinghat = inst.startinghat
            local initfn = child.GetStuffInitFn(child)
            if initfn ~= nil then
                initfn(child)
            end
        end
    end
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if inst.doortask ~= nil then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
    if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
        inst.components.spawner:ReleaseChild()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end
end

local function onstopcavedaydoortask(inst)
    inst.doortask = nil
    inst.components.spawner:ReleaseChild()
end

local function OnStopCaveDay(inst)
    --print(inst, "OnStopCaveDay")
    if not inst:HasTag("burnt") and inst.components.spawner:IsOccupied() then
        if inst.doortask ~= nil then
            inst.doortask:Cancel()
        end
        inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, onstopcavedaydoortask)
    end
end

local function SpawnCheckCaveDay(inst)
    inst.inittask = nil
    inst:WatchWorldState("stopcaveday", OnStopCaveDay)
    if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
        if not TheWorld.state.iscaveday or
            (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
            inst.components.spawner:ReleaseChild()
        end
    end
end

local function oninit(inst)
    inst.inittask = inst:DoTaskInTime(math.random(), SpawnCheckCaveDay)
    if inst.components.spawner ~= nil and
        inst.components.spawner.child == nil and
        inst.components.spawner.childname ~= nil and
        not inst.components.spawner:IsSpawnPending() then
        local child = SpawnPrefab(inst.components.spawner.childname)
        if child ~= nil then
            inst.components.spawner:TakeOwnership(child)
            inst.components.spawner:GoHome(child)
        end
    end
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
    if inst.startinghat ~= nil then
        data.startinghat = inst.startinghat
    end
    if inst.colorfname ~= nil and inst.colorfname ~= "default" then
        data.colorfname = inst.colorfname
    end
    if inst.welcomer then
        data.welcomer = inst.welcomer
    end
end

local function InitializeWelcomer(inst)
    inst.components.workable:SetWorkLeft(1000)
    inst:RemoveComponent("burnable")
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
    if data ~= nil and data.startinghat ~= nil then
        inst.startinghat = data.startinghat
    end
    if data ~= nil and data.colorfname ~= nil then
        inst.colorfname = data.colorfname
    end
    if data ~= nil and data.startinghat == "winterhat" then
        inst.AnimState:SetBuild("rabbit_house_blue")
    end
    if data ~= nil and data.welcomer then
        inst.welcomer = true
        InitializeWelcomer(inst)
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve/common/rabbit_hutch_craft")
end

local function onburntup(inst)
    if inst.doortask ~= nil then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
    if inst.inittask ~= nil then
        inst.inittask:Cancel()
        inst.inittask = nil
    end
end

local function onignite(inst)
    if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
        inst.components.spawner:ReleaseChild()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.MiniMapEntity:SetIcon("rabbit_house.png")
--{anim="level1", sound="dontstarve/common/campfire", radius=2, intensity=.75, falloff=.33, colour = {197/255,197/255,170/255}},
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)

    inst.AnimState:SetBank("rabbithouse")
    inst.AnimState:SetBuild("rabbit_house")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("cavedweller")
    inst:AddTag("structure")
    inst:AddTag("rabbithouse")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("spawner")
    inst.components.spawner:Configure("hatbunnyman", TUNING.TOTAL_DAY_TIME)
    inst.components.spawner.onoccupied = onoccupied
    inst.components.spawner.onvacate = onvacate
    inst.components.spawner:CancelSpawning()

    inst:AddComponent("inspectable")

    inst.components.inspectable.getstatus = getstatus

    MakeSnowCovered(inst)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)
    inst:ListenForEvent("burntup", onburntup)
    inst:ListenForEvent("onignite", onignite)

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:ListenForEvent("onbuilt", onbuilt)
    inst.inittask = inst:DoTaskInTime(0, oninit)

    inst.startinghat = nil
    inst.colorfname = "default"

    MakeHauntableWork(inst)

    return inst
end

return Prefab("hatrabbithouse", fn, assets, prefabs),
    MakePlacer("hatrabbithouse_placer", "rabbithouse", "rabbit_house", "idle")
