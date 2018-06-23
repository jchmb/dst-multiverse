local assets =
{
	Asset("ANIM", "anim/volcano_shrub.zip"),
	Asset("MINIMAP_IMAGE", "volcano_shrub")
}

local prefabs =
{
	"ash"
}

local function chopfn(inst)
	RemovePhysicsColliders(inst)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	inst.AnimState:PlayAnimation("break")

	-- TODO: figure out wtf this is
	-- local task_time = inst.AnimState:GetTotalTime("break")
	local task_time = 100
	if task_time ~= nil then
		inst:DoTaskInTime(task_time, function() inst.components.growable:SetStage(1) end)
	end

	inst.components.lootdropper:SpawnLootPrefab("ash")
	inst.components.lootdropper:DropLoot()
end

local function SetEmpty(inst)
	local days = TheWorld.state.springlength + TheWorld.state.autumnlength + TheWorld.state.winterlength + TheWorld.state.summerlength
	inst.components.growable:StartGrowing(days * TUNING.TOTAL_DAY_TIME)
	inst.Physics:SetCollides(false)
	inst:AddTag("NOCLICK")
	inst:Hide()
	inst.MiniMapEntity:SetEnabled(false)
end

local function SetFull(inst)
	inst.components.workable:SetWorkLeft(1)
	inst.components.growable:StopGrowing()
	inst.AnimState:PlayAnimation("idle", true)
	inst.Physics:SetCollides(true)
	inst:RemoveTag("NOCLICK")
	inst:Show()
	inst.MiniMapEntity:SetEnabled(true)
end

local grow_stages =
{
	{name="empty", fn=SetEmpty},
	{name="full", fn=SetFull},
}

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
    local network = inst.entity:AddNetwork()
	local minimap = inst.entity:AddMiniMapEntity()

	inst:AddTag("burnt")
	inst:AddTag("tree")

	MakeObstaclePhysics(inst, .25)

	anim:SetBank("volcano_shrub")
	anim:SetBuild("volcano_shrub")
	anim:PlayAnimation("idle", true)

	minimap:SetIcon("minimap_volcano_shrub.tex")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(chopfn)

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("growable")
	inst.components.growable.stages = grow_stages
	inst.components.growable:SetStage(2)
	inst.components.growable.loopstages = false
	inst.components.growable.growonly = false
	inst.components.growable.springgrowth = false
	inst.components.growable.growoffscreen = true

	return inst
end

return Prefab( "volcano_shrub", fn, assets, prefabs)
