local assets =
{
    Asset("ANIM", "anim/firepit.zip"),
	Asset("ANIM", "anim/firepit_obsidian.zip"),
}

local prefabs =
{
    "campfirefire",
    "collapse_small",
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	local ash = SpawnPrefab("ash")
	ash.Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle")
end

local function onignite(inst)
    if not inst.components.cooker then
        inst:AddComponent("cooker")
    end
end

local function onextinguish(inst)
    if inst.components.cooker then
        inst:RemoveComponent("cooker")
    end
    if inst.components.fueled then
        inst.components.fueled:InitializeFuelLevel(0)
    end
end

local function fn()

	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local network = inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "firepit.png" )
	minimap:SetPriority( 1 )

    anim:SetBank("firepit_obsidian")
    anim:SetBuild("firepit_obsidian")
    anim:PlayAnimation("idle",false)
    inst:AddTag("campfire")
    inst:AddTag("structure")

    MakeObstaclePhysics(inst, .3)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -----------------------
    inst:AddComponent("burnable")
    --inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:AddBurnFX("obsidianfirefire", Vector3(0,.4,0) )
    -- inst.components.burnable:MakeNotWildfireStarter()
    inst:ListenForEvent("onextinguish", onextinguish)
    inst:ListenForEvent("onignite", onignite)

    -------------------------
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

    -------------------------
    inst:AddComponent("fueled")
    inst.components.fueled.maxfuel = TUNING.OBSIDIANFIREPIT_FUEL_MAX
    inst.components.fueled.accepting = true

    inst.components.fueled:SetSections(4)
    inst.components.fueled.bonusmult = TUNING.OBSIDIANFIREPIT_BONUS_MULT
    inst.components.fueled.ontakefuelfn = function() inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel") end

    inst.components.fueled:SetUpdateFn( function()
        local rate = 1
        -- if TheWorld.state.israining then
        --     rate = 1 + TUNING.OBSIDIANFIREPIT_RAIN_RATE * TheWorld.state.precipitationrate
        -- end
        -- if inst:GetIsFlooded() then
        --     rate = rate + TUNING.OBSIDIANFIREPIT_FLOOD_RATE
        -- end
        inst.components.fueled.rate = rate

        if inst.components.burnable and inst.components.fueled then
            inst.components.burnable:SetFXLevel(inst.components.fueled:GetCurrentSection(), inst.components.fueled:GetSectionPercent())
        end
    end)

    inst.components.fueled:SetSectionCallback( function(section)
        if section == 0 then
            inst.components.burnable:Extinguish()
        else
            if not inst.components.burnable:IsBurning() then
                inst.components.burnable:Ignite()
            end

            inst.components.burnable:SetFXLevel(section, inst.components.fueled:GetSectionPercent())

        end
    end)

    inst.components.fueled:InitializeFuelLevel(TUNING.OBSIDIANFIREPIT_FUEL_START)

    -----------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = function(inst)
        local sec = inst.components.fueled:GetCurrentSection()
        if sec == 0 then
            return "OUT"
        elseif sec <= 4 then
            local t = {"EMBERS","LOW","NORMAL","HIGH"}
            return t[sec]
        end
    end

    inst:ListenForEvent( "onbuilt", function()
        anim:PlayAnimation("place")
        anim:PushAnimation("idle",false)
        inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
    end)

    -- inst:AddComponent("blowinwindgust")
    -- inst.components.blowinwindgust:SetWindSpeedThreshold(TUNING.OBSIDIANFIRE_WINDBLOWN_SPEED)
    -- inst.components.blowinwindgust:SetGustStartFn(function(inst, windspeed)
    --     if inst and inst.components.burnable and inst.components.burnable:IsBurning() and math.random() < TUNING.OBSIDIANFIRE_BLOWOUT_CHANCE then
    --         inst.components.burnable:Extinguish()
    --     end
    -- end)
    -- inst.components.blowinwindgust:Start()

    return inst
end

return Prefab( "firepit_obsidian", fn, assets, prefabs),
		MakePlacer( "firepit_obsidian_placer", "firepit_obsidian", "firepit_obsidian", "preview" )
