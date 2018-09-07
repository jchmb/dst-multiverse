local assets =
{
	Asset("ANIM", "anim/crates.zip"),
}

local prefabs =
{
	-- "collapse_small",
	-- "boards",
	-- "rope",
	-- "tunacan",
	-- "messagebottleempty",
	-- "fabric",
	-- "dubloon"
}

local randomloot =
{
	rope = 10,
	fish = 10,
	smallmeat_dried = 10,
	coconut = 5,
	flint = 5,
	goldnugget = 5,
	ironnugget = 5,
	papyrus = 5,
	cloth = 5,
	salt = 5,
	spotspice_ground = 5,
	honey = 5,
	syrup = 1,
	gears = 1,
	gunpowder = 1,
	pigskin = 1,
	antidote = 1,
}

local function setanim(inst, anim)
	inst.anim = anim
	inst.AnimState:PlayAnimation("idle" .. anim)
end

local function onsave(inst, data)
	data.anim = inst.anim
end

local function onload(inst, data)
	if data and data.anim then
		setanim(inst, data.anim)
	end
end

local function onhammered(inst)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local minimap = inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 0.1)
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	anim:SetBank("crates")
	anim:SetBuild("crates")
	setanim(inst, math.random(1, 10))

	minimap:SetIcon("minimap_crate.tex")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(onhammered)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"boards"})
	-- inst.components.lootdropper:AddRandomLoot("boards", 10)
	-- inst.components.lootdropper:AddRandomLoot("rope", 10)
	-- inst.components.lootdropper:AddRandomLoot("tunacan", 5)
	-- inst.components.lootdropper:AddRandomLoot("messagebottleempty", 10)
	-- inst.components.lootdropper:AddRandomLoot("fabric", 10)
	-- inst.components.lootdropper:AddRandomLoot("dubloon", 1)
	for k,v in pairs(randomloot) do
		inst.components.lootdropper:AddRandomLoot(k, v)
	end
	inst.components.lootdropper.numrandomloot = 1

	inst:AddComponent("inspectable")

	inst.OnSave = onsave
	inst.OnLoad = onload

	return inst
end

return Prefab("crate", fn, assets, prefabs)
