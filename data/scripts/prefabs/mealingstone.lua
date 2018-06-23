local TechTree = require("techtree")

local assets =
{
    Asset("ANIM", "anim/quagmire_mealingstone.zip"),
}

local prefabs =
{
    "collapse_small",
}

local WARES =
{
    -- "quagmire_flour",
    -- "quagmire_salt",
    -- "quagmire_spotspice_ground",
    "salt",
    "spotspice_ground",
}

local MEALING_STONE_ONE = TechTree.Create({MEALING_STONE = 1})

for i, v in ipairs(WARES) do
    table.insert(prefabs, v)
end

local function OnTurnOn(inst)
    inst.components.prototyper.on = true  -- prototyper doesn't set this until after this function is called!!
end

local function OnTurnOff(inst)
    inst.components.prototyper.on = false  -- prototyper doesn't set this until after this function is called
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

    inst.MiniMapEntity:SetPriority(5)
    inst.MiniMapEntity:SetIcon("quagmire_mealingstone.png")

    inst.AnimState:SetBank("quagmire_mealingstone")
    inst.AnimState:SetBuild("quagmire_mealingstone")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")

    --prototyper (from prototyper component) added to pristine state for optimization
    inst:AddTag("prototyper")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("prototyper")
    inst.components.prototyper.trees = MEALING_STONE_ONE
    inst.components.prototyper.onturnon = OnTurnOn
	inst.components.prototyper.onturnoff = OnTurnOff
    inst.components.prototyper.onactivate = function()
        -- inst.AnimState:PlayAnimation("use")
        --inst.AnimState:PushAnimation("idle_full")
        inst.AnimState:PlayAnimation("proximity_loop", true)
       -- inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_craft","sound")
	end

    -- event_server_data("quagmire", "prefabs/quagmire_mealingstone").master_postinit(inst, WARES)

    return inst
end

return Prefab("mealingstone", fn, assets, prefabs),
    MakePlacer( "mealingstone_placer", "mealingstone", "mealingstone", "idle" )
