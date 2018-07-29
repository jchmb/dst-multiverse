local assets =
{
    Asset("ANIM", "anim/quagmire_goatmom_basic.zip"),
    Asset("ANIM", "anim/bunsy_build.zip"),
}

local prefabs =
{
    -- "quagmire_crate_pot_hanger",
    -- "quagmire_crate_oven",
    -- "quagmire_crate_grill_small",
    -- "quagmire_plate_silver",
    -- "quagmire_bowl_silver",
    -- "quagmire_goatmilk",
    -- "quagmire_portal_key",
}

local function OnTurnOn(inst)
    inst.components.prototyper.on = true
end

local function OnTurnOff(inst)
    inst.components.prototyper.on = false
end

local function OnTalk(inst)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/idle_med")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    -- MakeObstaclePhysics(inst, .4, 50)
    MakeCharacterPhysics(inst, 50, .4)

    inst.DynamicShadow:SetSize(2, 1)

    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(1.3, 1.3, 1.3)

    inst.AnimState:SetBank("quagmire_goatmom_basic")
    inst.AnimState:SetBuild("bunsy_build")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:Hide("hat")

    inst:AddTag("character")
	inst:AddTag("prototyper")

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -400, 0)
    inst.components.talker:MakeChatter()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.talker.ontalk = OnTalk

    inst:AddComponent("inspectable")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 3
    inst.components.locomotor.runspeed = 5

    -- inst:AddComponent("prototyper")
    -- inst.components.prototyper.onturnon = OnTurnOn
	-- inst.components.prototyper.onturnoff = OnTurnOff
	-- inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.TRADING_GOATMUM_THREE

    inst:AddComponent("knownlocations")

    inst.talked = false

    local brain = require "brains/bunsybrain"
    inst:SetStateGraph("SGbunsy")
    inst:SetBrain(brain)

    -- event_server_data("quagmire", "prefabs/quagmire_goatmum").master_postinit(inst, prefabs)

    return inst
end

return Prefab("bunsy", fn, assets, prefabs)
