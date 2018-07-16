local MAXHITS = 10  -- make this an even number

local TechTree = require("techtree")
local OBSIDIAN_TWO = TechTree.Create({OBSIDIAN = 2})

local function turnlightoff(inst, light)
    if light then
        light:Enable(false)
    end
end

-- light, rad, intensity, falloff, colour, time, callback
local function OnTurnOn(inst)
    inst.components.prototyper.on = true  -- prototyper doesn't set this until after this function is called!!
    inst.AnimState:PlayAnimation("proximity_pre")
    inst.AnimState:PushAnimation("proximity_loop", true)
    -- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/obsidian_workbench_LP", "loop")
    inst.Light:Enable(true)
    inst.components.lighttweener:StartTween(nil, 0, nil, nil, nil, 0.2)
end

local function OnTurnOff(inst)
    inst.components.prototyper.on = false  -- prototyper doesn't set this until after this function is called
    inst.AnimState:PlayAnimation("proximity_pst")
    inst.AnimState:PushAnimation("idle", true)
    -- inst.SoundEmitter:KillSound("loop")
    inst.components.lighttweener:StartTween(nil, 0, nil, nil, nil, 0.2, turnlightoff)
end

local assets =
{
	Asset("ANIM", "anim/workbench_obsidian.zip"),
    Asset("MINIMAP_IMAGE", "workbench_obsidian")
}


local function InitFn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local network = inst.entity:AddNetwork()


	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetPriority( 5 )
	minimap:SetIcon( "minimap_obsidian_workbench.tex" )
    inst.Transform:SetScale(1,1,1)

	MakeObstaclePhysics(inst, 2, 1.2)

	inst.entity:AddSoundEmitter()

	anim:SetBank("workbench_obsidian")
	anim:SetBuild("workbench_obsidian")
	anim:PlayAnimation("idle")

	inst:AddTag("prototyper")
	inst:AddTag("altar")
    inst:AddTag("structure")
    inst:AddTag("stone")

	inst:AddComponent("inspectable")


	inst:AddComponent("prototyper")
	inst.components.prototyper.onturnon = OnTurnOn
	inst.components.prototyper.onturnoff = OnTurnOff

	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.OBSIDIAN_THREE

	inst.components.prototyper.onactivate = function()
        inst.AnimState:PlayAnimation("use")
        --inst.AnimState:PushAnimation("idle_full")
        inst.AnimState:PushAnimation("proximity_loop", true)
       -- inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_craft","sound")
	end

    inst:AddComponent("lighttweener")
    local light = inst.entity:AddLight()

    inst.Light:Enable(false)
    inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(.5)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(1,1,1)
    inst.components.lighttweener:StartTween(light, 1, .9, 0.9, {255/255,177/255,164/255}, 0, turnlightoff)


	return inst
end

return Prefab( "obsidian_workbench", InitFn, assets, prefabs)
