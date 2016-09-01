local assets =
{
	Asset("ANIM", "anim/sand_castle.zip")
}

local prefabs =
{
	-- "sand",
	-- "sandhill",
	-- "seashell"
}

-- these should match the animation names to the workleft
local anims = {"low", "med", "full"}

local function setanim(inst)
	if inst.components.workable.workleft < 1 then
		inst.AnimState:PlayAnimation(anims[1])
	else
		inst.AnimState:PlayAnimation(anims[inst.components.workable.workleft])
	end
end

local function workcallback(inst, worker, workleft)
	if workleft <= 0 then
		-- figure out which side to drop the loot
		local pt = Vector3(inst.Transform:GetWorldPosition())
		local hispos = Vector3(worker.Transform:GetWorldPosition())

		local he_right = ((hispos - pt):Dot(TheCamera:GetRightVec()) > 0)

		if he_right then
			inst.components.lootdropper:DropLoot(pt - (TheCamera:GetRightVec()*2))
		else
			inst.components.lootdropper:DropLoot(pt + (TheCamera:GetRightVec()*2))
		end

		inst:Remove()
	else
		inst.components.fueled:ChangeSection(-1)
	end
	setanim(inst)
end

local function sectioncallback(newsection, oldsection, inst)
	print("section callback", newsection, oldsection)
	inst.components.workable:SetWorkLeft(newsection)
	setanim(inst)
end

local function onperish(inst)
	inst:Remove()
end

local function onupdate(inst)
	-- local sm = GetSeasonManager()
	local rain = Remap(math.max(TheWorld.state.precipitationrate, 0.5), 0.5, 1.0, 0.0, 1.0)
	-- local wind = sm:GetHurricaneWindSpeed()
	local wind = 1
	inst.components.fueled.rate = 1 + TUNING.SANDCASTLE_RAIN_PERISH_RATE * 
		rain + TUNING.SANDCASTLE_WIND_PERISH_RATE * wind
end

local function onbuilt(inst)
	-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sandcastle")
end

local function getstatus(inst, viewer)
	local x, y, z = inst.Transform:GetWorldPosition()
	if TheWorld.Map:GetTileAtPoint(x, y, z) == GROUND.SAND then
		return "SAND"
	else
		return "GENERIC"
	end
end

local function sandcastlefn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	anim:SetBuild("sand_castle")
	anim:SetBank("sand_castle")
	anim:PlayAnimation(anims[#anims])

	MakeObstaclePhysics(inst, .4)

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = "NONE"
    inst.components.fueled.accepting = false
    inst.components.fueled:InitializeFuelLevel(TUNING.SANDCASTLE_PERISHTIME)
    inst.components.fueled:SetDepletedFn(onperish)
    inst.components.fueled:SetSections(#anims)
    inst.components.fueled:SetSectionCallback(sectioncallback)
    inst.components.fueled:SetUpdateFn(onupdate)
    inst.components.fueled:StartConsuming()

	----------------------
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus
	----------------------
	inst:AddComponent("lootdropper")
	inst.components.lootdropper.lootpercentoverride = function()
		return inst.components.fueled:GetPercent()
	end

	--full, med, low
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(#anims)
	inst.components.workable:SetOnWorkCallback(workcallback)

	inst:ListenForEvent( "onbuilt", onbuilt)

	return inst
end

return Prefab( "sand_castle", sandcastlefn, assets, prefabs),
		MakePlacer( "sand_castle_placer", "sand_castle", "sand_castle", anims[#anims] )