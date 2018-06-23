local brain = require "brains/packimbrain"
require "stategraphs/SGpackim"

local WAKE_TO_FOLLOW_DISTANCE = 14
local SLEEP_NEAR_LEADER_DISTANCE = 7

local assets =
{
	Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
	Asset("ANIM", "anim/ui_chest_3x3.zip"),

	Asset("ANIM", "anim/packim.zip"),
	Asset("ANIM", "anim/packim_build.zip"),
	Asset("ANIM", "anim/packim_fat_build.zip"),
	Asset("ANIM", "anim/packim_fire_build.zip"),

	-- Asset("MINIMAP_IMAGE", "packim_fat"),
	-- Asset("MINIMAP_IMAGE", "packim_fire"),
}

local prefabs =
{
	"packim_fishbone",
	"die_fx",
	"chesterlight",
	"sparklefx",
	"firestaff",
	-- "feathers_packim",
	-- "feathers_packim_fat",
	-- "feathers_packim_fire",
}

local normalsounds =
{
	close = "dontstarve_DLC002/creatures/packim/close",
	death = "dontstarve_DLC002/creatures/packim/death",
	hurt = "dontstarve_DLC002/creatures/packim/hurt",
	land = "dontstarve_DLC002/creatures/packim/land",
	open = "dontstarve_DLC002/creatures/packim/open",
	swallow = "dontstarve_DLC002/creatures/packim/swallow",
	transform = "dontstarve_DLC002/creatures/packim/transform",
	trasnform_stretch = "dontstarve_DLC002/creatures/packim/trasnform_stretch",
	transform_pop = "dontstarve_DLC002/creatures/packim/trasformation_pop",
	fly = "dontstarve_DLC002/creatures/packim/fly",
	fly_sleep = "dontstarve_DLC002/creatures/packim/fly_sleep",
	sleep = "dontstarve_DLC002/creatures/packim/sleep",
	bounce = "dontstarve_DLC002/creatures/packim/fly_bounce",

	-- only fat packim
	fat_death_spin = "dontstarve_DLC002/creatures/packim/fat_death_spin",
	fat_land_empty = "dontstarve_DLC002/creatures/packim/fat_land_empty",
	fat_land_full = "dontstarve_DLC002/creatures/packim/fat_land_full",
}

local fatsounds =
{
	close = "dontstarve_DLC002/creatures/packim/fat_close",
	death = "dontstarve_DLC002/creatures/packim/fat_death",
	hurt = "dontstarve_DLC002/creatures/packim/fat_hurt",
	land = "dontstarve_DLC002/creatures/packim/land",
	open = "dontstarve_DLC002/creatures/packim/fat_open",
	swallow = "dontstarve_DLC002/creatures/packim/fat_swallow",
	transform = "dontstarve_DLC002/creatures/packim/transform",
	trasnform_stretch = "dontstarve_DLC002/creatures/packim/trasnform_stretch",
	transform_pop = "dontstarve_DLC002/creatures/packim/trasformation_pop",
	fly = "dontstarve_DLC002/creatures/packim/fly",
	fly_sleep = "dontstarve_DLC002/creatures/packim/fly_sleep",
	sleep = "dontstarve_DLC002/creatures/packim/sleep",
	bounce = "dontstarve_DLC002/creatures/packim/fly_bounce",

	-- only fat packim
	fat_death_spin = "dontstarve_DLC002/creatures/packim/fat_death_spin",
	fat_land_empty = "dontstarve_DLC002/creatures/packim/fat_land_empty",
	fat_land_full = "dontstarve_DLC002/creatures/packim/fat_land_full",
}

local function ShouldWakeUp(inst)
	return DefaultWakeTest(inst) or not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE)
end

local function ShouldSleep(inst)
	return DefaultSleepTest(inst) and not inst.sg:HasStateTag("open")
	and inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE)
	and GetWorld().components.clock:GetMoonPhase() ~= "full"
end


local function ShouldKeepTarget(inst, target)
	return false -- packim can't attack, and won't sleep if he has a target
end


local function OnOpen(inst)
	if not inst.components.health:IsDead() then
		inst.sg:GoToState("open")
	end
end

local function OnClose(inst)
	if not inst.components.health:IsDead() then
		inst.sg:GoToState("close")
	end
end

-- eye bone was killed/destroyed
local function OnStopFollowing(inst)
	inst:RemoveTag("companion")
end

local function OnStartFollowing(inst)
	inst:AddTag("companion")
end

local slotpos_3x3 = {}

for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(slotpos_3x3, Vector3(80*x-80*2+80, 80*y-80*2+80,0))
	end
end

local slotpos_3x4 = {}

for y = 2.5, -0.5, -1 do
	for x = 0, 2 do
		table.insert(slotpos_3x4, Vector3(75*x-75*2+75, 75*y-75*2+75,0))
	end
end

local function RetargetFn(inst)
	local notags = {"FX", "NOCLICK","INLIMBO", "abigail"}
	local yestags = {"monster"}
	if not inst.last_fire_time or (inst.fire_interval and (GetTime() - inst.last_fire_time) > inst.fire_interval) then
	    return FindEntity(inst, TUNING.PIG_TARGET_DIST,
	        function(guy)
	            if not guy.LightWatcher or guy.LightWatcher:IsInLight() then
	                return guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy)
	            end
	        end, yestags, notags)
	end
	return false
end
local function KeepTargetFn(inst, target)
	if not inst.last_fire_time or (inst.fire_interval and (GetTime() - inst.last_fire_time) > inst.fire_interval) then
	    --give up on dead guys, or guys in the dark, or werepigs
	    return inst.components.combat:CanTarget(target)
	           and (not target.LightWatcher or target.LightWatcher:IsInLight())
	           and not (target.sg and target.sg:HasStateTag("transform") )
	end
	return false
end

local function MorphFatPackim(inst)
	inst.components.container:SetNumSlots(#slotpos_3x4)
	inst.components.container.widgetslotpos = slotpos_3x4
	inst.components.container.widgetanimbank = "ui_chester_shadow_3x4"
	inst.components.container.widgetanimbuild = "ui_chester_shadow_3x4"
	inst.components.container.widgetpos = Vector3(0,220,0)
	inst.components.container.widgetpos_controller = Vector3(0,220,0)
	inst.components.container.side_align_tip = 160

	-- see state graph for "transform"
	-- inst.AnimState:SetBuild("packim_fat_build")
	inst.PackimState = "FAT"
	inst.firehunger = 0
	inst.MiniMapEntity:SetIcon("packim_fat.png")

    inst:RemoveTag("fireimmune")

	inst.sounds = fatsounds
end


local function WeaponDropped(inst)
    inst:Remove()
end

local function MorphFirePackim(inst)

	--Handle things being in the extra slots!
	local oldnumslots = inst.components.container:GetNumSlots()
	local newnumslots = #slotpos_3x3

	local overflowitems = {}
	local container = inst.components.container

	if oldnumslots >  newnumslots then
		local diff = oldnumslots - newnumslots
		for i = newnumslots + 1, oldnumslots, 1 do
			overflowitems[#overflowitems + 1] = container:RemoveItemBySlot(i)
		end
	end

	inst.components.container:SetNumSlots(#slotpos_3x3, true)
	inst.components.container.widgetslotpos = slotpos_3x3
	inst.components.container.widgetanimbank = "ui_chest_3x3"
	inst.components.container.widgetanimbuild = "ui_chest_3x3"
	inst.components.container.widgetpos = Vector3(0,200,0)
	inst.components.container.side_align_tip = 160

	for i = 1,  #overflowitems, 1  do
		local item = overflowitems[i]
		overflowitems[i] = nil
		container:GiveItem(item, nil, nil, true)
	end
	-- see state graph for "transform"
	-- inst.AnimState:SetBuild("packim_fire_build")

	inst.PackimState = "FIRE"

	inst.MiniMapEntity:SetIcon("minimap_packim_fire.tex")
	local weapon = SpawnPrefab("firestaff")
	inst.components.inventory:Equip(weapon)
	weapon:RemoveComponent("finiteuses")
    weapon.persists = false
    weapon.components.inventoryitem:SetOnDroppedFn(WeaponDropped)

    inst:AddTag("fireimmune")

    inst.sounds = normalsounds
end

local function MorphNormalPackim(inst)

	--Handle things being in the extra slots!
	local oldnumslots = inst.components.container:GetNumSlots()
	local newnumslots = #slotpos_3x3

	local overflowitems = {}
	local container = inst.components.container

	if oldnumslots >  newnumslots then
		local diff = oldnumslots - newnumslots
		for i = newnumslots + 1, oldnumslots, 1 do
			overflowitems[#overflowitems + 1] = container:RemoveItemBySlot(i)
		end
	end

	inst.components.container:SetNumSlots(#slotpos_3x3, true)
	inst.components.container.widgetslotpos = slotpos_3x3
	inst.components.container.widgetanimbank = "ui_chest_3x3"
	inst.components.container.widgetanimbuild = "ui_chest_3x3"
	inst.components.container.widgetpos = Vector3(0,200,0)
	inst.components.container.side_align_tip = 160

	for i = 1,  #overflowitems, 1  do
		local item = overflowitems[i]
		overflowitems[i] = nil
		container:GiveItem(item, nil, nil, true)
	end
	-- see state graph for "transform"
	-- inst.AnimState:SetBuild("packim_build")

	inst.PackimState = "NORMAL"
	inst.firehunger = 0
	inst.components.hunger.current = 0
	inst.MiniMapEntity:SetIcon("packim.png")

    inst:RemoveTag("fireimmune")

	inst.sounds = normalsounds
end

local function checkfiretransform(inst)
	local container = inst.components.container
	local cantransform = true
	for i = 1, container:GetNumSlots() do
        local item = container:GetItemInSlot(i)

        if not item then
            cantransform = false
            break
        end

        if item.prefab ~= "obsidian"  then
            cantransform = false
        end
    end
    if cantransform then
    	container:ConsumeByName("obsidian", container:GetNumSlots())
   	 	MorphFirePackim(inst)
   	end
    return cantransform
end

local function tryeatcontents(inst)

	local dideat = false
	local dideatfire = false
	local container = inst.components.container

	if inst.PackimState == "FIRE" then
		for i = 1, container:GetNumSlots() do
	        local item = container:GetItemInSlot(i)
	     	if item then
	     		local replacement = nil
		     	if item.components.cookable then
		     		replacement = item.components.cookable:GetProduct()
		     	elseif item.components.burnable then
		     		replacement = "ash"
		     	end
		     	if replacement then
	     			local stacksize = 1
	     			if item.components.stackable then
	     				stacksize = item.components.stackable:StackSize()
	     			end
	     			local newprefab = SpawnPrefab(replacement)
	     			if newprefab.components.stackable then
	     				newprefab.components.stackable:SetStackSize(stacksize)
	     			end
	     			container:RemoveItemBySlot(i)
	     			item:Remove()
	     			container:GiveItem(newprefab, i)
	     		end
		     end
		end
		return false
	end

	local loot = {}
	for i = 1, container:GetNumSlots() do
		local item = container:GetItemInSlot(i)
		if item then
			if item:HasTag("packimfood") then
				dideat = true
				item = container:RemoveItemBySlot(i)
				if item.components.edible then
					local cals = item.components.edible:GetHunger()
					if item.components.stackable then
						cals = cals * item.components.stackable:StackSize()
					end
					inst.components.hunger:DoDelta(cals)

				end
				item:Remove()
			elseif item:HasTag("spoiledbypackim") then
				dideat = true
				item = container:RemoveItemBySlot(i)
				if item.components.perishable and item.components.perishable.onperishreplacement then
					local stack = 1
					if item.components.stackable then
	     				stack = item.components.stackable:StackSize()
	     			end
	     			for i = 1, stack do
						table.insert(loot, item.components.perishable.onperishreplacement)
					end
				end
				if item.components.edible then
					local cals = item.components.edible:GetHunger()
					if item.components.stackable then
						cals = cals * item.components.stackable:StackSize()
					end
					inst.components.hunger:DoDelta(cals)
				end
				item:Remove()
			end
		end
	end
	if #loot > 0 then
		inst.components.lootdropper:SetLoot(loot)

		inst:DoTaskInTime(60 * FRAMES, function(inst)
			inst.components.lootdropper:DropLoot()
			inst.components.lootdropper:SetLoot({})
		end)
	end

	if dideat and inst.PackimState == "NORMAL" then
		if inst.components.hunger:GetCurrent() > TUNING.PACKIM_TRANSFORM_HUNGER then
			MorphFatPackim(inst)
		end
	end

	return dideat
end

local function OnStarve(inst)
	if inst.PackimState == "FAT" then
		MorphNormalPackim(inst)
		inst.sg:GoToState("transform")
	end
end

local function OnPoisoned(inst)
	inst:AddTag("spoiler")
end

local function OnPoisonDone(inst)
	inst:RemoveTag("spoiler")
end

local function OnSave(inst, data)
	data.PackimState = inst.PackimState
end

local function OnPreLoad(inst, data)
	if not data then return end
	if data.PackimState == "FAT" then
		MorphFatPackim(inst)
		inst.AnimState:SetBuild("packim_fat_build")
	elseif data.PackimState == "FIRE" then
		MorphFirePackim(inst)
		inst.AnimState:SetBuild("packim_fire_build")
	end
	inst.firehunger = data.firehunger
end


local function create_packim()

	local inst = CreateEntity()

	-- inst:AddTag("companion")
	inst:AddTag("character")
	inst:AddTag("scarytoprey")
	-- inst:AddTag("chester")
	inst:AddTag("packim")
	inst:AddTag("notraptrigger")
	inst:AddTag("cattoy")
    inst:AddTag("amphibious")

	inst.entity:AddTransform()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	-- minimap:SetIcon( "packim.png" )
    minimap:SetIcon("minimap_packim_fire.tex")

    MakeCharacterPhysics(inst, 75, .5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)

	inst.entity:AddAnimState()
	inst.AnimState:SetBank("packim")
	inst.AnimState:SetBuild("packim_build")

	inst.entity:AddSoundEmitter()
	inst.sounds = normalsounds

	inst.entity:AddDynamicShadow()
	inst.DynamicShadow:SetSize( 1.5, .6 )

	-- MakeAmphibiousCharacterPhysics(inst, 75, .5)
	-- MakePoisonableCharacter(inst)
	-- inst.components.poisonable:SetOnPoisonedFn(OnPoisoned)
	-- inst.components.poisonable:SetOnPoisonDoneFn(OnPoisonDone)



	inst.Transform:SetSixFaced()

	------------------------------------------

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "chester_body"
	inst.components.combat:SetDefaultDamage(TUNING.PIG_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.PIG_ATTACK_PERIOD)
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	inst.components.combat:SetRetargetFunction(3, RetargetFn)
	inst.components.combat:SetTarget(nil)

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.CHESTER_HEALTH)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
	inst:AddTag("noauradamage")


	inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()
	--inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 10
	--inst.components.locomotor.runspeed = 7

	inst:AddComponent("follower")
	inst:ListenForEvent("stopfollowing", OnStopFollowing)
	inst:ListenForEvent("startfollowing", OnStartFollowing)
	-- inst.components.follower:SetFollowExitDestinations({EXIT_DESTINATION.LAND,EXIT_DESTINATION.WATER})

	inst:AddComponent("knownlocations")

	MakeSmallBurnableCharacter(inst, "PACKIM_BODY", Vector3(100, 50, 0.5))

	inst:AddComponent("inventory")
	inst.components.inventory.maxslots = 0
	inst.components.inventory.nosteal = true
	inst.components.inventory.acceptitems = false

	inst:AddComponent("container")
	inst.components.container:SetNumSlots(#slotpos_3x3)

	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose

	inst.components.container.widgetslotpos = slotpos_3x3
	inst.components.container.widgetanimbank = "ui_chest_3x3"
	inst.components.container.widgetanimbuild = "ui_chest_3x3"
	inst.components.container.widgetpos = Vector3(0,200,0)
	inst.components.container.side_align_tip = 160

	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(3)
	inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
	inst.components.sleeper:SetSleepTest(ShouldSleep)
	inst.components.sleeper:SetWakeTest(ShouldWakeUp)

	inst:AddComponent("lootdropper")

	inst:AddComponent("hunger")
	inst.components.hunger:SetMax(TUNING.PACKIM_MAX_HUNGER)
	inst.components.hunger:SetKillRate(0)
	inst.components.hunger.current = 0
	inst.components.hunger:SetRate(TUNING.PACKIM_HUNGER_DRAIN)
	-- inst.components.hunger:SetOnStarve(OnStarve)

	inst.OnSave = OnSave
	inst.OnPreLoad = OnPreLoad

	inst:SetStateGraph("SGpackim")
	inst.sg:GoToState("idle")

	inst.PackimState = "NORMAL"

	inst:SetBrain(brain)

	inst.tryeat = tryeatcontents
	inst.checkfiretransform = checkfiretransform

	inst:DoTaskInTime(1.5, function(inst)
		-- We somehow got a packim without an fishbone. Kill it! Kill it with fire!
		if not TheSim:FindFirstEntityWithTag("packim_fishbone") then
			inst:Remove()
		end
	end)

	return inst
end

return Prefab( "packim", create_packim, assets, prefabs)
