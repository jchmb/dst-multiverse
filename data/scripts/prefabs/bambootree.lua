local assets=
{
	Asset("ANIM", "anim/bambootree.zip"),
	Asset("ANIM", "anim/bambootree_build.zip"),
}


local prefabs =
{
    "bamboo",
}

local function ontransplantfn(inst)
	if inst.components.pickable then
		inst.components.pickable:MakeBarren()
	end
end

local function dig_up(inst, chopper)
	if inst.components.pickable and inst.components.pickable:CanBePicked() then
		inst.components.lootdropper:SpawnLootPrefab("bamboo")
	end
	if inst.components.pickable and not inst.components.pickable:IsBarren() then
		local bush = inst.components.lootdropper:SpawnLootPrefab("dug_bambootree")
	else
		inst.components.lootdropper:SpawnLootPrefab("bamboo")
	end
	inst:Remove()
end

local function onregenfn(inst)
	inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PushAnimation("idle", true)
	inst.Physics:SetCollides(true)
end

local function makeemptyfn(inst)
	if inst.components.pickable and inst.components.pickable:IsBarren() then
		inst.AnimState:PlayAnimation("dead_to_empty")
		inst.AnimState:PushAnimation("picked")
	else
		inst.AnimState:PlayAnimation("picked")
	end
	inst.Physics:SetCollides(false)
end

local function makebarrenfn(inst)
	if inst.components.pickable and inst.components.pickable:IsBarren() then
		if inst.components.pickable:CanBePicked() then
			inst.AnimState:PlayAnimation("full_to_dead")
		else
			inst.AnimState:PlayAnimation("empty_to_dead")
		end
		inst.AnimState:PushAnimation("idle_dead")
	else
		inst.AnimState:PlayAnimation("idle_dead")
	end
	inst.Physics:SetCollides(true)
end

local function onpickedfn(inst, picker)
	-- local fx = SpawnPrefab("hacking_bamboo_fx")
 --    local x, y, z= inst.Transform:GetWorldPosition()
 --    fx.Transform:SetPosition(x,y + math.random()*2,z)

		inst.AnimState:PlayAnimation("picking")

		-- if inst.components.pickable and inst.components.pickable:IsBarren() then
		-- 	inst.AnimState:PushAnimation("idle_dead")
		-- 	inst.Physics:SetCollides(true)
		-- else
			inst.Physics:SetCollides(false)
			inst.AnimState:PushAnimation("picked")
			-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/bamboo_drop")
		-- end

	-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/bamboo_hack")
end

--[[local function onguststart(inst, windspeed)
	if inst.components.hackable and inst.components.hackable:CanBeHacked() then
		inst.AnimState:PlayAnimation("blown_pre", false)
		inst.AnimState:PushAnimation("blown_loop", true)
		--inst.AnimState:PushAnimation("blown_pst", false)
		--inst.AnimState:PushAnimation("idle", true)
	end
end

local function ongustend(inst, windspeed)
	if inst.components.hackable and inst.components.hackable:CanBeHacked() then
		inst.AnimState:PushAnimation("blown_pst", false)
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function ongusthackfn(inst)
	if inst.components.hackable and inst.components.hackable:CanBeHacked() then
        inst.components.hackable:MakeEmpty()
        inst.components.lootdropper:SpawnLootPrefab(inst.components.hackable.product)
	end
end]]

local function inspect_bambootree(inst)
    if inst:HasTag("burnt") then
        return "BURNT"
    elseif inst:HasTag("stump") then
        return "CHOPPED"
    end
end

local function makefn(stage)
	local function fn()
		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()
	    local sound = inst.entity:AddSoundEmitter()
		local minimap = inst.entity:AddMiniMapEntity()
		inst.entity:AddNetwork()
		
		MakeObstaclePhysics(inst, .35)

		minimap:SetIcon( "minimap_bambootree.tex" )

	    anim:SetBank("bambootree")
	    anim:SetBuild("bambootree_build")
	    anim:PlayAnimation("idle",true)
	    anim:SetTime(math.random()*2)
	    local color = 0.75 + math.random() * 0.25
	    anim:SetMultColour(color, color, color, 1)

	    -- inst:AddTag("gustable")

	    inst.entity:SetPristine()

   		if not TheWorld.ismastersim then
        	return inst
    	end

    	inst:AddComponent("pickable")
    	inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
    	inst.components.pickable:SetUp("bamboo", TUNING.BAMBOO_REGROW_TIME)
        inst.components.pickable.onpickedfn = onpickedfn
        inst.components.pickable.makeemptyfn = makeemptyfn
        inst.components.pickable.makebarrenfn = makebarrenfn
        inst.components.pickable.makefullfn = onregenfn
        inst.components.pickable.ontransplantfn = ontransplantfn

        inst:AddComponent("witherable")

		--inst.components.pickable:SetUp("bamboo", TUNING.BAMBOO_REGROW_TIME)
		-- inst.components.hackable:SetUp("bamboo", TUNING.BAMBOO_REGROW_TIME)
		-- inst.components.hackable.onregenfn = onregenfn
		-- inst.components.hackable.onhackedfn = onhackedfn
		-- inst.components.hackable.makeemptyfn = makeemptyfn
		-- inst.components.hackable.makebarrenfn = makebarrenfn
		-- inst.components.hackable.max_cycles = 20
		-- inst.components.hackable.cycles_left = 20
		-- inst.components.hackable.ontransplantfn = ontransplantfn
		-- inst.components.hackable.hacksleft = TUNING.BAMBOO_HACKS
		-- inst.components.hackable.maxhacks = TUNING.BAMBOO_HACKS

		local variance = math.random() * 4 - 2
		-- inst.makewitherabletask = inst:DoTaskInTime(TUNING.WITHER_BUFFER_TIME + variance, function(inst) inst.components.hackable:MakeWitherable() end)

	    if stage == 1 then
			inst.components.pickable:MakeBarren()
		end

		inst:AddComponent("lootdropper")
	    inst:AddComponent("inspectable")
	    inst.components.inspectable.getstatus = inspect_bambootree

		inst:AddComponent("workable")
	    inst.components.workable:SetWorkAction(ACTIONS.DIG)
	    inst.components.workable:SetOnFinishCallback(dig_up)
	    inst.components.workable:SetWorkLeft(1)

	    -- MakeHackableBlowInWindGust(inst, TUNING.BAMBOO_WINDBLOWN_SPEED, TUNING.BAMBOO_WINDBLOWN_FALL_CHANCE)
	    --[[inst:AddComponent("blowinwindgust")
	    inst.components.blowinwindgust:SetWindSpeedThreshold(TUNING.BAMBOO_WINDBLOWN_SPEED)
	    inst.components.blowinwindgust:SetDestroyChance(TUNING.BAMBOO_WINDBLOWN_FALL_CHANCE)
	    inst.components.blowinwindgust:SetGustStartFn(onguststart)
	    inst.components.blowinwindgust:SetGustEndFn(ongustend)
	    inst.components.blowinwindgust:SetDestroyFn(ongusthackfn)
	    inst.components.blowinwindgust:Start()]]

	    ---------------------

	    MakeMediumBurnable(inst)
	    MakeSmallPropagator(inst)
	    MakeDragonflyBait(inst, 1)
		--MakeNoGrowInWinter(inst)

	    ---------------------

	    return inst
	end

    return fn
end


local function bamboo(name, stage)
    return Prefab(name, makefn(stage), assets, prefabs)
end

return bamboo("bambootree", 0),
		bamboo("depleted_bambootree", 1)
