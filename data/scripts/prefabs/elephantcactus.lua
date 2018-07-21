local brain = require "brains/elephantcactusbrain"

local assets =
{
	Asset("ANIM", "anim/cactus_volcano.zip"),
	-- Asset("MINIMAP_IMAGE", "cactus_volcano"),
}

local prefabs =
{
	"needle_dart",
	"blowdart_pipe",
	"dug_elephantcactus",
	"needlespear",
	"twigs",
}

local function ontransplantfn(inst)
	inst.components.pickable:MakeBarren()
end

local function makeemptyfn(inst)
	local active = SpawnPrefab("elephantcactus_active")
	active.Physics:Teleport(inst.Transform:GetWorldPosition())

	if inst.components.pickable and inst.components.pickable.withered then
		active.sg:GoToState("grow_spike")
	end

	inst:Remove()
end

local function makebarrenfn(inst)
	if inst.components.pickable and inst.components.pickable.withered then
		if not inst.components.pickable.hasbeenpicked then
			inst.AnimState:PlayAnimation("full_to_dead")
			-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/volcano_cactus/full_to_dead")
		else
			inst.AnimState:PlayAnimation("empty_to_dead")
			-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/volcano_cactus/empty_to_dead")
		end
		inst.AnimState:PushAnimation("idle_dead")
	else
		inst.AnimState:PlayAnimation("idle_dead")
	end
end

local function pickanim(inst)
	if inst.components.pickable then
		if inst.components.pickable:CanBePicked() then
			return "idle_spike"
		else
			if inst.components.pickable:IsBarren() then
				return "idle_dead"
			else
				return "idle"
			end
		end
	end

	return "idle"
end

local function shake(inst)
	if inst.components.pickable and inst.components.pickable:CanBePicked() then
		inst.AnimState:PlayAnimation("shake")
	else
		inst.AnimState:PlayAnimation("shake_empty")
	end
	inst.AnimState:PushAnimation(pickanim(inst), false)
end

local function onpickedfn(inst, picker)
	if inst.components.pickable then
		inst.AnimState:PlayAnimation("chopped")

		if inst.components.pickable:IsBarren() then
			inst.AnimState:PushAnimation("idle_dead")
		else
			inst.AnimState:PushAnimation("idle")
		end
	end
	if picker.components.combat then
		picker.components.combat:GetAttacked(inst, TUNING.MARSHBUSH_DAMAGE)
		picker:PushEvent("thorns")
	end
end

local function makefullfn(inst)
	local anim = pickanim(inst)
	inst.AnimState:PlayAnimation(anim)
    -- TODO: again with this?
	-- local task_time = inst.AnimState:GetTotalTime(anim)
    local task_time = 100

	if task_time ~= nil then
		inst:DoTaskInTime(task_time, function(inst)
			local active = SpawnPrefab("elephantcactus_active")
			if active then
				active.Physics:Teleport(inst.Transform:GetWorldPosition())
				inst:Remove()
			end
		end)
	end
end


local function dig_up(inst, chopper)
	if inst.components.pickable then
		if inst.components.pickable:CanBePicked() then
			inst.components.lootdropper:SpawnLootPrefab("needlespear")
		else
			inst.components.lootdropper:SpawnLootPrefab("twigs")
			inst.components.lootdropper:SpawnLootPrefab("twigs")
		end
	else
		inst.components.lootdropper:SpawnLootPrefab("dug_elephantcactus")
	end

	inst:Remove()
end

local function getregentimefn(inst)
	if inst.components.pickable then
		local num_cycles_passed = math.min(inst.components.pickable.max_cycles - inst.components.pickable.cycles_left, 0)
		return TUNING.BERRY_REGROW_TIME + TUNING.BERRY_REGROW_INCREASE*num_cycles_passed+ math.random()*TUNING.BERRY_REGROW_VARIANCE
	else
		return TUNING.BERRY_REGROW_TIME
	end

end

local function retargetfn(inst)
	local newtarget = FindEntity(inst, TUNING.ELEPHANTCACTUS_RANGE, function(guy)
			return guy.components.health and not guy.components.health:IsDead()
			-- return guy.components.combat and inst.components.combat:CanTarget(guy)
					--and (guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
	end, nil, {"elephantcactus", "FX", "NOCLICK"})

	return newtarget
end

local function shouldKeepTarget(inst, target)
	if target and target:IsValid() and
		(target.components.health and not target.components.health:IsDead()) then
		local distsq = target:GetDistanceSqToInst(inst)
		return distsq < TUNING.ELEPHANTCACTUS_RANGE*TUNING.ELEPHANTCACTUS_RANGE
	else
		return false
	end
end

local function onseasonchange(inst)
    if TheWorld.state.issummer then
	-- if GetSeasonManager():IsDrySeason() then
		local active = SpawnPrefab("elephantcactus_active")
		if active then
			active.Physics:Teleport(inst.Transform:GetWorldPosition())
			inst:Remove()
		end
	end
end

local function onload(inst, data)
	onseasonchange(inst)
end

local function onseasonchange_active(inst)
	if not inst.prevseason then
		inst.prevseason = TheWorld.state.season
		return
	end

    -- TODO: depend on summer?
	if TheWorld.state.isspring and inst.prevseason == "summer" then
		local dormant = SpawnPrefab("elephantcactus")
		if dormant then
			dormant.Physics:Teleport(inst.Transform:GetWorldPosition())
			inst:Remove()
		end
	end

	inst.prevseason = TheWorld.state.season
end

local function onload_active(inst, data)
	onseasonchange_active(inst)
	inst.has_spike = data.has_spike
end

local function onsave_active(inst, data)
	data.has_spike = inst.has_spike
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local network = inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("minimap_elephant_cactus.tex")

	anim:SetBuild("cactus_volcano")
	anim:SetBank("cactus_volcano")
	anim:PlayAnimation("idle_spike", true)
	anim:SetTime(math.random()*2)

	inst:AddTag("thorny")
	inst:AddTag("elephantcactus")
	inst:AddTag("scarytoprey")

    MakeObstaclePhysics(inst, 1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnLoad = onload

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"

	inst.components.pickable:SetUp("needlespear", TUNING.BERRY_REGROW_TIME)
	inst.components.pickable.getregentimefn = getregentimefn
	inst.components.pickable.onpickedfn = onpickedfn
	inst.components.pickable.makebarrenfn = makebarrenfn
	inst.components.pickable.makefullfn = makefullfn
	inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.pickable.ontransplantfn = ontransplantfn
	-- inst.components.pickable:SetReverseSeasons(true)
	-- inst.components.pickable:MakeWitherable()
	inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
	inst.components.pickable.cycles_left = inst.components.pickable.max_cycles

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")

	inst.entity:AddSoundEmitter()

	inst:DoTaskInTime(0, onseasonchange)

	return inst
end

local function ontimerdone(inst, data)
	if data.name == "SPIKE" then
		inst.has_spike = true
		inst:PushEvent("growspike")
	end
end

local function OnBlocked(owner, data)
	if      (data.weapon == nil or (not data.weapon:HasTag("projectile") and not data.weapon.projectile))
		and data.attacker and data.attacker.components.combat and data.stimuli ~= "thorns" and not data.attacker:HasTag("thorny")
		and ((data.damage and data.damage > 0) or (data.attacker.components.combat and data.attacker.components.combat.defaultdamage > 0)) then
		data.attacker.components.combat:GetAttacked(owner, TUNING.ELEPHANTCACTUS_DAMAGE/2, nil, "thorns")
		-- owner.SoundEmitter:PlaySound("dontstarve_DLC002/common/armour/cactus")
	end
end

local function activefn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local network = inst.entity:AddNetwork()
	local minimap = inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
	MakeObstaclePhysics(inst, 1)

	minimap:SetIcon("cactus_volcano.png")

	anim:SetBuild("cactus_volcano")
	anim:SetBank("cactus_volcano")
	anim:PlayAnimation("idle_spike")
	anim:SetTime(math.random()*2)

	inst:AddTag("thorny")
	inst:AddTag("elephantcactus")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")

	MakeLargeFreezableCharacter(inst)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"needlespear"})


	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.ELEPHANTCACTUS_HEALTH)

	inst:AddComponent("combat")
	inst.components.combat:SetRange(TUNING.ELEPHANTCACTUS_RANGE)
	inst.components.combat:SetDefaultDamage(TUNING.ELEPHANTCACTUS_DAMAGE)
	inst.components.combat:SetAreaDamage(TUNING.ELEPHANTCACTUS_RANGE, 1.0)
	inst.components.combat:SetAttackPeriod(1)
	inst.components.combat:SetRetargetFunction(1, retargetfn)
	inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)
	inst.components.combat.notags = {"elephantcactus", "armorcactus"}
	-- inst.components.combat:SetHurtSound("dontstarve_DLC002/creatures/volcano_cactus/hit")

	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", ontimerdone)

	inst:ListenForEvent("blocked", OnBlocked)
	inst:ListenForEvent("attacked", OnBlocked)

	inst.has_spike = true

	inst:SetBrain(brain)
	inst:SetStateGraph("SGelephantcactus")
	inst.sg:GoToState("grow_spike")

	inst:ListenForEvent("seasonchange", function() onseasonchange_active(inst) end )

	inst.OnLoad = onload_active
	inst.OnSave = onsave_active

	return inst
end

local function stumpfn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

	inst.OnLoad = onload

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cactus_volcano.png")

	anim:SetBuild("cactus_volcano")
	anim:SetBank("cactus_volcano")
	anim:PlayAnimation("idle_underground")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")

	inst:ListenForEvent("seasonChange", function() onseasonchange(inst) end, GetWorld() )

	return inst
end

-- you can find dug_elephantcactus in plantables.lua
return Prefab("elephantcactus", fn, assets, prefabs),
	   Prefab("elephantcactus_active", activefn, assets, prefabs),
	   Prefab("elephantcactus_stump", stumpfn, assets, prefabs)
