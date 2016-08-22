require "prefabutil"
local assets =
{
	Asset("ANIM", "anim/coconut.zip"),
}

local prefabs = 
{
    "coconut_cooked", 
    "cononut_halved"
}

local function growtree(inst)
	print ("GROWTREE")
    inst.growtask = nil
    inst.growtime = nil
	local tree = SpawnPrefab("palmtree_short") 
    if tree then 
		tree.Transform:SetPosition(inst.Transform:GetWorldPosition() ) 
        tree:growfromseed()--PushEvent("growfromseed")
        inst:Remove()
	end
end

local function plant(inst, growtime)

    --[[if not SaveGameIndex:IsModeShipwrecked() then
        inst.AnimState:PlayAnimation("planted")
        inst.AnimState:PushAnimation("planted")
        inst.AnimState:PushAnimation("planted")
        inst.AnimState:PushAnimation("planted")
        inst.AnimState:PushAnimation("death", false)
        inst:ListenForEvent("animqueueover", function()
            local player = GetPlayer()
            if player and player.components.talker then
                player.components.talker:Say(GetString(player.prefab, "ANNOUNCE_OTHER_WORLD_PLANT"))
            end
            local time_to_erode = 4
            local tick_time = TheSim:GetTickTime()
            inst:StartThread( function()
                local ticks = 0
                while ticks * tick_time < time_to_erode do
                    local erode_amount = ticks * tick_time / time_to_erode
                    inst.AnimState:SetErosionParams( erode_amount, 0.1, 1.0 )
                    ticks = ticks + 1
                    Yield()
                end
                inst:Remove()
            end)
        end)
        return
    end]]

    inst:RemoveComponent("inventoryitem")
    inst:RemoveComponent("locomotor")
    RemovePhysicsColliders(inst)
    -- RemoveBlowInHurricane(inst)
    inst.AnimState:PlayAnimation("planted")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")
    inst.growtime = GetTime() + growtime
    print ("PLANT", growtime)
    inst.growtask = inst:DoTaskInTime(growtime, growtree)

     if inst.components.edible then
        inst:RemoveComponent("edible")
    end
    if inst.components.bait then
        inst:RemoveComponent("bait")
    end
end

local function ondeploy (inst, pt) 
    inst = inst.components.stackable:Get()
    inst.Transform:SetPosition(pt:Get() )
    local timeToGrow = GetRandomWithVariance(TUNING.COCONUT_GROWTIME.base, TUNING.COCONUT_GROWTIME.random)
    plant(inst, timeToGrow)
	
	--tell any nearby leifs to chill out
	local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, TUNING.LEIF_PINECONE_CHILL_RADIUS, {"leif"})
	
	local played_sound = false
	for k,v in pairs(ents) do
		
		local chill_chance = TUNING.LEIF_PINECONE_CHILL_CHANCE_FAR
		if distsq(pt, Vector3(v.Transform:GetWorldPosition())) < TUNING.LEIF_PINECONE_CHILL_CLOSE_RADIUS*TUNING.LEIF_PINECONE_CHILL_CLOSE_RADIUS then
			chill_chance = TUNING.LEIF_PINECONE_CHILL_CHANCE_CLOSE
		end
	
		if math.random() < chill_chance then
			if v.components.sleeper then
				v.components.sleeper:GoToSleep(1000)
			end
		else
			if not played_sound then
				v.SoundEmitter:PlaySound("dontstarve/creatures/leif/taunt_VO")
				played_sound = true
			end
		end
		
	end
	
end

local function stopgrowing(inst)
    if inst.growtask then
        inst.growtask:Cancel()
        inst.growtask = nil
    end
    inst.growtime = nil
end

local function restartgrowing(inst)
    if inst and not inst.growtask then
        local growtime = GetRandomWithVariance(TUNING.COCONUT_GROWTIME.base, TUNING.COCONUT_GROWTIME.random)
        inst.growtime = GetTime() + growtime
        inst.growtask = inst:DoTaskInTime(growtime, growtree)
    end
end


local notags = {'NOBLOCK', 'player', 'FX'}
local function test_ground(inst, pt)
	local tiletype = GetGroundTypeAtPosition(pt)
	local ground_OK = tiletype == GROUND.DIRT or tiletype == GROUND.SAND
                        inst:IsPosSurroundedByLand(pt.x, pt.y, pt.z, 1)
	
	if ground_OK then
	    local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, notags) -- or we could include a flag to the search?
		local min_spacing = inst.components.deployable.min_spacing or 2

	    for k, v in pairs(ents) do
			if v ~= inst and v:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
				if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
					return false
				end
			end
		end
		return true
	end
	return false
end

local function describe(inst)
    if inst.growtime then
        return "PLANTED"
    end
end

local function displaynamefn(inst)
    if inst.growtime then
        return STRINGS.NAMES.COCONUT_SAPLING
    end
    return STRINGS.NAMES.COCONUT
end

local function OnSave(inst, data)
    if inst.growtime then
        data.growtime = inst.growtime - GetTime()
    end
end

local function OnLoad(inst, data)
    if data and data.growtime then
        plant(inst, data.growtime)
    end
end

local function common(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    -- MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.MEDIUM, TUNING.WINDBLOWN_SCALE_MAX.MEDIUM)

    inst.AnimState:SetBank("coconut")
    inst.AnimState:SetBuild("coconut")
    inst.AnimState:PlayAnimation("idle")
    

   -- inst:AddComponent("edible")
    --inst.components.edible.foodtype = "VEGGIE"
    inst:AddTag("coconut")
    inst:AddTag("cattoy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = describe
    
    --inst:AddComponent("fuel")
    --inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
    
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	inst:ListenForEvent("onignite", stopgrowing)
    inst:ListenForEvent("onextinguish", restartgrowing)
    MakeSmallPropagator(inst)
    MakeDragonflyBait(inst, 3)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"
   

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "RAW"

    
    inst:AddComponent("inventoryitem")
    --inst:AddComponent("bait")
    

    return inst
end

local function onhacked(inst)
    local nut = inst 
    if inst.components.inventoryitem then 
        local owner = inst.components.inventoryitem.owner
        if inst.components.stackable and inst.components.stackable.stacksize > 1 then 
            nut = inst.components.stackable:Get()
            inst.components.workable:SetWorkLeft(1)
        end 
        if owner then 
            local hacked = SpawnPrefab("coconut_halved")
            hacked.components.stackable.stacksize = 2
            if owner.components.inventory and not owner.components.inventory:IsFull() then
                owner.components.inventory:GiveItem(hacked)
            elseif owner.components.container and not owner.components.container:IsFull() then
                owner.components.container:GiveItem(hacked)
            else
                inst.components.lootdropper:DropLootPrefab(hacked)
            end
        else 
            inst.components.lootdropper:SpawnLootPrefab("coconut_halved")
            inst.components.lootdropper:SpawnLootPrefab("coconut_halved")
        end 
        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/bamboo_hack")
    end
    nut:Remove()

end 

local function raw()
    local inst = common()
    inst:AddTag("show_spoilage")
    -- inst:AddComponent("workable")
    -- inst.components.workable:SetWorkAction(ACTIONS.HACK)
    -- inst.components.workable:SetWorkLeft(1)
    -- inst.components.workable:SetOnFinishCallback(onhacked)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    
    inst:AddComponent("deployable")
    inst.components.deployable.test = test_ground
    inst.components.deployable.ondeploy = ondeploy

    -- MakeInventoryFloatable(inst, "idle_water", "idle")
    
    inst.displaynamefn = displaynamefn

    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2

    inst.components.inventoryitem.atlasname = "images/inventoryimages/coconut.xml"

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end 

local function cooked()
    local inst = common()

    inst.AnimState:PlayAnimation("cook")
    -- MakeInventoryFloatable(inst, "cooked_water", "cook")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.foodstate = "COOKED"
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.edible.foodtype = "SEEDS"

    inst.components.inventoryitem.atlasname = "images/inventoryimages/coconut_halved.xml"


    return inst
end

local function halved()
    local inst = common()

    inst.AnimState:PlayAnimation("chopped")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("cookable")
    inst.components.cookable.product = "coconut_cooked"
    
    -- MakeInventoryFloatable(inst, "chopped_water", "chopped")
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.edible.foodtype = "SEEDS"

    inst.components.inventoryitem.atlasname = "images/inventoryimages/coconut_cooked.xml"

    return inst
end

return Prefab( "coconut", raw, assets, prefabs),
    Prefab( "coconut_cooked", cooked, assets),
    Prefab( "coconut_halved", halved, assets),
	   MakePlacer( "coconut_placer", "coconut", "coconut", "planted" ) 


