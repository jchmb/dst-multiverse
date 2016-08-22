local assets =
{
	Asset("ANIM", "anim/limpetrock.zip"),
}

local prefabs =
{
	"limpets",
	"rocks",
	"flint",
}   
 

SetSharedLootTable( 'limpetrockempty',
{
	{'rocks', 1.00},
	{'rocks', 1.00},
	{'rocks', 1.00},
	{'flint', 1.00},
	{'flint', 0.60},
})

SetSharedLootTable( 'limpetrockfull',
{
	{'rocks', 1.00},
	{'rocks', 1.00},
	{'rocks', 1.00},
	{'flint', 1.00},
	{'flint', 0.60},
	{'limpets', 1.00},
})

local function makeemptyfn(inst)
	if inst.components.pickable and inst.components.pickable.withered then
		inst.AnimState:PlayAnimation("dead_to_empty")
		inst.AnimState:PushAnimation("empty")
	else
		inst.AnimState:PlayAnimation("empty")
	end
	inst.components.workable:SetWorkable(true)
end

local function makebarrenfn(inst)
	if inst.components.pickable and inst.components.pickable.withered then
		if not inst.components.pickable.hasbeenpicked then
			inst.AnimState:PlayAnimation("full_to_dead")
		else
			inst.AnimState:PlayAnimation("empty_to_dead")
		end
		inst.AnimState:PushAnimation("idle_dead")
	else
		inst.AnimState:PlayAnimation("idle_dead")
	end
end

local function onpickedfn(inst, picker)

	if inst.components.pickable then
		inst.components.workable:SetWorkable(true)

		inst.AnimState:PlayAnimation("limpetmost_picked")
		
		if inst.components.pickable:IsBarren() then
			inst.AnimState:PushAnimation("idle_dead")
		else
			inst.AnimState:PushAnimation("idle")
		end
	end
end

local function getregentimefn(inst)
	return TUNING.LIMPET_REGROW_TIME
end

local function pickanim(inst)
	if inst.components.pickable then
		if inst.components.pickable:CanBePicked() then
			return "limpetmost"
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

local function makefullfn(inst)
	inst.components.workable:SetWorkable(false)
	inst.AnimState:PlayAnimation(pickanim(inst))
end


local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local minimap = inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()


	inst:AddTag("bush")
	minimap:SetIcon( "minimap_limpetrock.tex" )

	MakeObstaclePhysics(inst, 1)
   
	anim:SetBank("limpetrock")
	anim:SetBuild("limpetrock")
	anim:PlayAnimation("limpetmost", false)

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("pickable")
	-- inst.components.pickable.picksound = "dontstarve_DLC002/common/limpet_harvest" TODO
	inst.components.pickable:SetUp("limpets", TUNING.BERRY_REGROW_TIME)--TUNING.LIMPET_REGROW_TIME)
	inst.components.pickable.getregentimefn = getregentimefn
	inst.components.pickable.onpickedfn = onpickedfn
	inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.pickable.makebarrenfn = makebarrenfn
	inst.components.pickable.makefullfn = makefullfn
	inst.components.pickable.oceanic = true

	--inst.components.pickable.ontransplantfn = ontransplantfn

	-- WTF is this below..?

	-- local variance = math.random() * 4 - 2
	-- inst.makewitherabletask = inst:DoTaskInTime(
	-- 	TUNING.WITHER_BUFFER_TIME + variance,
	-- 	function(inst)
	-- 		inst.components.pickable:MakeWitherable()
	-- 	end
	-- )
	
		
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('limpetrockempty')

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft)
		local pt = Point(inst.Transform:GetWorldPosition())
		if workleft <= 0 then
			inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
			inst.components.lootdropper:DropLoot(pt)
			if inst.components.pickable:CanBePicked() and worker and worker.components.groundpounder and worker.components.groundpounder.burner == true then
				inst.components.lootdropper:SpawnLootPrefab("limpets_cooked", pt)
			end
			inst:Remove()
		else
			if workleft < TUNING.ROCKS_MINE*(1/3) then
				inst.AnimState:PlayAnimation("low")
			elseif workleft < TUNING.ROCKS_MINE*(2/3) then
				inst.AnimState:PlayAnimation("med")
			else
				inst.AnimState:PlayAnimation("idle")
			end
		end
	end)

	inst.components.workable:SetWorkable(false)

			
	return inst
end

return Prefab( "rock_limpet", fn, assets, prefabs)	