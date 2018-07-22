local assets =
{
	Asset("ANIM", "anim/manrabbit_basic.zip"),
	Asset("ANIM", "anim/manrabbit_actions.zip"),
	Asset("ANIM", "anim/manrabbit_attacks.zip"),
	Asset("ANIM", "anim/manrabbit_build.zip"),

	Asset("ANIM", "anim/manrabbit_beard_build.zip"),
	Asset("ANIM", "anim/manrabbit_beard_basic.zip"),
	Asset("ANIM", "anim/manrabbit_beard_actions.zip"),
	Asset("SOUND", "sound/bunnyman.fsb"),
}

local prefabs =
{
	"meat",
	"monstermeat",
	"manrabbit_tail",
	"beardhair",
	"carrot",
}

local DISTANCE_TO_FARM = 30
local PLANT_DISTANCE = 4

local HAT_INITS = {
	["strawhat"] = function(inst)
		local item = inst:GetPlantable()
		if item == nil then
			return
		end
		inst.components.inventory:GiveItem(item)
	end,
	["tophat"] = function(inst)
		return
	end,
}

local HAT_LOOPS = {
	["tophat"] = {
		["test"] = function(inst)
			return inst.stufftarget ~= nil and inst.stufftarget:HasTag("tree") and not inst.stufftarget:HasTag("stump") and
				not inst.components.inventory:FindItem(function(x) return x.components.fuel ~= nil end) and
				not FindEntity(inst, DISTANCE_TO_FARM, function(x) return x.components.fuel ~= nil end)
		end,
		["action"] = function(inst)
			local fuelitem = inst.components.inventory:FindItem(function(x) return x.components.fuel ~= nil end)
			if fuelitem == nil and inst.stufftarget ~= nil and inst.stufftarget:HasTag("tree") and
					not inst.stufftarget:HasTag("stump") then
				return BufferedAction(inst, inst.stufftarget, ACTIONS.CHOP)
			end
		end,
	}
}

local HAT_TARGETS = {
	["strawhat"] = function(inst)
		return FindEntity(
			inst,
			DISTANCE_TO_FARM,
			function(prefab)
				return string.find(prefab.prefab, "farmplot") and
					prefab.components.grower ~= nil and
					prefab.components.grower:IsEmpty() and
					prefab.components.grower:IsFertile()
			end,
			{"structure"}
		)
	end,
	["tophat"] = function(inst)
		local fuelitem = inst.components.inventory:FindItem(
			function(x)
				local firepit = FindEntity(
					inst,
					DISTANCE_TO_FARM,
					function(y)
						return y.prefab == "firepit"
					end
				)
				return firepit ~= nil and x.components.fuel ~= nil and
					firepit.components.fueled:CanAcceptFuelItem(x)
			end
		)
		if fuelitem ~= nil then
			return FindEntity(
				inst,
				DISTANCE_TO_FARM,
				function(e)
					return e.prefab == "firepit" and e.components.fueled:GetPercent() < 0.25
				end
			)
		else
			local fuelitemonfloor = FindEntity(
				inst,
				DISTANCE_TO_FARM,
				function(x)
					local firepit = FindEntity(
						inst,
						DISTANCE_TO_FARM,
						function(y)
							return y.prefab == "firepit"
						end
					)
					return firepit ~= nil and x.components.fuel ~= nil and
						firepit.components.fueled:CanAcceptFuelItem(x)
				end
			)
			if fuelitemonfloor ~= nil then
				return fuelitemonfloor
			end
			return FindEntity(
				inst,
				DISTANCE_TO_FARM,
				function(e)
					return e:HasTag("tree") and not e:HasTag("stump")
				end
			)
		end
	end,
}

local HAT_ACTIONS = {
	["strawhat"] = function(inst, target)
		local item = inst.components.inventory:FindItem(function(x) return x.prefab == "carrot_seeds" end)
		if item == nil then
			return nil
		end
		return BufferedAction(inst, target, ACTIONS.PLANT, item)
	end,
	["tophat"] = function(inst, target)
		local fuelitem = inst.components.inventory:FindItem(
			function(x)
				local firepit = FindEntity(
					inst,
					DISTANCE_TO_FARM * 2,
					function(y)
						return y.prefab == "firepit"
					end
				)
				return firepit ~= nil and x.components.fuel ~= nil and
					firepit.components.fueled:CanAcceptFuelItem(x)
			end
		)
		if fuelitem ~= nil and target ~= nil and target.prefab == "firepit" then
			return BufferedAction(inst, target, ACTIONS.ADDFUEL, fuelitem)
		end
		if fuelitem == nil and target.components.fuel ~= nil then
			return BufferedAction(inst,  target, ACTIONS.PICKUP)
		end
		if fuelitem == nil and target:HasTag("tree") then
			return BufferedAction(inst, target, ACTIONS.CHOP)
		end
	end,
}

local HAT_CHATS = {
	["strawhat"] = STRINGS.HATBUNNYMAN_TALK_FARM,
	["tophat"] = STRINGS.HATBUNNYMAN_TALK_TOPHAT,
}

local HAT_TRADES = {
	["winterhat"] = {
		["test"] = function(inst, item)
			return item.prefab == "log" or item.prefab == "charcoal" or item.prefab == "torch"
		end,
		["trade"] = function(inst, giver, item)
			if giver.components.inventory then
				local reward = SpawnPrefab("mintyberries_cooked")
				giver.components.inventory:GiveItem(reward)
			end
			item:Remove()
		end,
	},
	["strawhat"] = {
		["test"] = function(inst, item)
			return item.prefab == "shovel" or item.prefab == "pitchfork" or item.prefab == "goldenshovel"
		end,
		["trade"] = function(inst, giver, item)
			if giver.components.inventory then
				giver.components.inventory:GiveItem(SpawnPrefab("carrot"))
			end
			item:Remove()
		end,
	},
	["tophat"] = {
		["test"] = function(inst, item)
			return item.prefab == "silk" or item.prefab == "log" or item.prefab == "coffee"
		end,
		["trade"] = function(inst, giver, item)
			if giver.components.inventory and math.random() < 0.5 then
				giver.components.inventory:GiveItem(SpawnPrefab("carrot"))
			end
			item:Remove()
		end,
	},
	["footballhat"] = {
		["test"] = function(inst, item)
			return item.components.armor or item.components.weapon
		end,
		["trade"] = function(inst, giver, item)
			if giver.components.inventory and math.random() < 0.5 then
				giver.components.inventory:GiveItem(SpawnPrefab("manrabbit_tail"))
			end
			item:Remove()
		end,
	},
}

local beardlordloot = { "beardhair", "beardhair", "monstermeat" }
local regularloot = { "carrot", "carrot" }

local brain = require("brains/hatbunnymanbrain")

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30

local function GetPlantable(inst)
	return SpawnPrefab("carrot_seeds")
end

local function IsCrazyGuy(guy)
	local sanity = guy ~= nil and guy.replica.sanity or nil
	return sanity ~= nil and sanity:GetPercentNetworked() <= (guy:HasTag("dappereffects") and TUNING.DAPPER_BEARDLING_SANITY or TUNING.BEARDLING_SANITY)
end

local function ontalk(inst)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/idle_med")
end

local function ClearBeardlord(inst)
	inst.clearbeardlordtask = nil
	inst.beardlord = nil
end

local function SetBeardLord(inst)
	inst.beardlord = true
	if inst.clearbeardlordtask ~= nil then
		inst.clearbeardlordtask:Cancel()
	end
	inst:DoTaskInTime(5.0, ClearBeardlord)
end

local function CalcSanityAura(inst, observer)
	if IsCrazyGuy(observer) then
		SetBeardLord(inst)
	end
	return (IsCrazyGuy(observer) and -TUNING.SANITYAURA_MED)
		or (inst.components.follower ~= nil and
			inst.components.follower.leader == observer and
			TUNING.SANITYAURA_SMALL)
		or 0
end

local function ShouldAcceptItem(inst, item)
	local testtradefn = HAT_TRADES[inst.startinghat] and HAT_TRADES[inst.startinghat]["test"] or nil
	if testtradefn and testtradefn(inst, item) then
		return true
	end
	return
		(   --accept all hats!
			item.components.equippable ~= nil and
			item.components.equippable.equipslot == EQUIPSLOTS.HEAD
		) or
		(   --accept food, but not too many carrots for loyalty!
			item.components.edible ~= nil and
			(   (item.prefab ~= "carrot" and item.prefab ~= "carrot_cooked") or
				inst.components.follower.leader == nil or
				inst.components.follower:GetLoyaltyPercent() <= .9
			)
		)
end

local function OnGetItemFromPlayer(inst, giver, item)
	local testtradefn = HAT_TRADES[inst.startinghat] and HAT_TRADES[inst.startinghat]["test"] or nil
	local tradefn = HAT_TRADES[inst.startinghat] and HAT_TRADES[inst.startinghat]["trade"] or nil
	if testtradefn and tradefn and testtradefn(inst, item) then
		tradefn(inst, giver, item)
		return
	end
	--I eat food
	if item.components.edible ~= nil then
		if item.prefab == "carrot" or item.prefab == "carrot_cooked" then
			if inst.components.combat:TargetIs(giver) then
				inst.components.combat:SetTarget(nil)
			elseif giver.components.leader ~= nil then
				giver:PushEvent("makefriend")
				giver.components.leader:AddFollower(inst)
				inst.components.follower:AddLoyaltyTime(
					giver:HasTag("polite")
					and TUNING.RABBIT_CARROT_LOYALTY + TUNING.RABBIT_POLITENESS_LOYALTY_BONUS
					or TUNING.RABBIT_CARROT_LOYALTY
				)
			end
		end
		if inst.components.sleeper:IsAsleep() then
			inst.components.sleeper:WakeUp()
		end
	end

	--I wear hats
	if item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
		local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		if current ~= nil then
			inst.components.inventory:DropItem(current)
		end
		inst.components.inventory:Equip(item)
		inst.AnimState:Show("hat")
	end
end

local function OnRefuseItem(inst, item)
	inst.sg:GoToState("refuse")
	if inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	end
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST, function(dude) return dude.prefab == inst.prefab end, MAX_TARGET_SHARES)
end

local function OnNewTarget(inst, data)
	inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, function(dude) return dude.prefab == inst.prefab end, MAX_TARGET_SHARES)
end

local function is_meat(item)
	return item.components.edible ~= nil  and item.components.edible.foodtype == FOODTYPE.MEAT
end

local function NormalRetargetFn(inst)
	return FindEntity(inst, TUNING.PIG_TARGET_DIST,
		function(guy)
			return inst.components.combat:CanTarget(guy)
				and not inst.welcomer and (guy:HasTag("monster")
					or (guy.components.inventory ~= nil and
						guy:IsNear(inst, TUNING.BUNNYMAN_SEE_MEAT_DIST) and
						guy.components.inventory:FindItem(is_meat) ~= nil))
		end,
		{ "_combat", "_health" }, -- see entityreplica.lua
		{"bunnyfriend"},
		{ "player" })
end

local function NormalKeepTargetFn(inst, target)
	return not (target.sg ~= nil and target.sg:HasStateTag("hiding")) and inst.components.combat:CanTarget(target)
end

local function giveupstring()
	return "RABBIT_GIVEUP", math.random(#STRINGS["RABBIT_GIVEUP"])
end

local function battlecry(combatcmp, target)
	local strtbl =
		target ~= nil and
		target.components.inventory ~= nil and
		target.components.inventory:FindItem(is_meat) ~= nil and
		"RABBIT_MEAT_BATTLECRY" or
		"RABBIT_BATTLECRY"
	return strtbl, math.random(#STRINGS[strtbl])
end

local function GetStatus(inst)
	return inst.components.follower.leader ~= nil and "FOLLOWER" or nil
end

local function LootSetupFunction(lootdropper)
	local guy = lootdropper.inst.causeofdeath
	if IsCrazyGuy(guy ~= nil and guy.components.follower ~= nil and guy.components.follower.leader or guy) then
		-- beard lord
		lootdropper:SetLoot(beardlordloot)
	else
		-- regular loot
		lootdropper:SetLoot(regularloot)
		lootdropper:AddRandomLoot("meat", 3)
		lootdropper:AddRandomLoot("manrabbit_tail", 1)
		lootdropper.numrandomloot = 1
	end
end

local function GetStuffTargetFn(inst)
	if inst.startinghat == nil or not HAT_TARGETS[inst.startinghat] then
		return nil
	end
	return HAT_TARGETS[inst.startinghat]
end

local function GetStuffActionFn(inst)
	if inst.startinghat == nil or not HAT_ACTIONS[inst.startinghat] then
		return nil
	end
	return HAT_ACTIONS[inst.startinghat]
end

local function GetStuffChatLines(inst)
	if inst.startinghat == nil or not HAT_CHATS[inst.startinghat] then
		return nil
	end
	return HAT_CHATS[inst.startinghat]
end

local function GetStuffInitFn(inst)
	if inst.startinghat == nil or not HAT_INITS[inst.startinghat] then
		return nil
	end
	return HAT_INITS[inst.startinghat]
end

local function GetStuffLoopFns(inst)
	if inst.startinghat == nil or not HAT_LOOPS[inst.startinghat] then
		return nil
	end
	return HAT_LOOPS[inst.startinghat]
end

local function GetStuffLoopAction(inst)
	local loopfns = inst:GetStuffLoopFns()
	if loopfns ~= nil then
		local loopfn = loopfns["action"]
		return loopfn(inst)
	end
end

local function OnTurnOn(inst)
    inst.components.prototyper.on = true  -- prototyper doesn't set this until after this function is called!!
end

local function OnTurnOff(inst)
    inst.components.prototyper.on = false  -- prototyper doesn't set this until after this function is called
end

local function OnSave(inst, data)
	if inst.colorpicked ~= nil then
		data.colorpicked = {
			r = inst.colorpicked.r or 1,
			g = inst.colorpicked.g or 1,
			b = inst.colorpicked.b or 1,
		}
	end
	if inst.welcomer then
		data.welcomer = true
	end
end

local function OnLoad(inst, data)
	if data.colorpicked ~= nil then
		inst.colorpicked = {
			r = data.colorpicked.r or 1,
			g = data.colorpicked.g or 1,
			b = data.colorpicked.b or 1,
		}
		inst.AnimState:SetMultColour(
			inst.colorpicked.r,
			inst.colorpicked.g,
			inst.colorpicked.b,
			1
		)
	end
	if data.welcomer then
		inst.welcomer = true
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	inst.AnimState:SetBuild("manrabbit_build")

	MakeCharacterPhysics(inst, 50, .5)

	inst.DynamicShadow:SetSize(1.5, .75)
	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(1.25, 1.25, 1.25)

	inst:AddTag("cavedweller")
	inst:AddTag("character")
	inst:AddTag("pig")
	inst:AddTag("manrabbit")
	inst:AddTag("scarytoprey")

	inst.AnimState:SetBank("manrabbit")
	inst.AnimState:PlayAnimation("idle_loop")
	inst.AnimState:Hide("hat")

	inst.AnimState:SetClientsideBuildOverride("insane", "manrabbit_build", "manrabbit_beard_build")

	--trader (from trader component) added to pristine state for optimization
	inst:AddTag("trader")

	--Sneak these into pristine state for optimization
	inst:AddTag("_named")

	inst:AddComponent("talker")
	inst.components.talker.fontsize = 24
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.offset = Vector3(0, -500, 0)
	inst.components.talker:MakeChatter()

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	--Remove these tags so that they can be added properly when replicating components below
	inst:RemoveTag("_named")

	inst.components.talker.ontalk = ontalk

	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED * 2.2 -- account for them being stopped for part of their anim
	inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED * 1.9 -- account for them being stopped for part of their anim

	inst:AddComponent("bloomer")

	------------------------------------------
	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.VEGGIE }, { FOODTYPE.VEGGIE })
	inst.components.eater:SetCanEatRaw()

	------------------------------------------
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "manrabbit_torso"
	inst.components.combat.panic_thresh = TUNING.BUNNYMAN_PANIC_THRESH

	inst.components.combat.GetBattleCryString = battlecry
	inst.components.combat.GetGiveUpString = giveupstring

	MakeMediumBurnableCharacter(inst, "manrabbit_torso")

	inst:AddComponent("named")
	inst.components.named.possiblenames = STRINGS.BUNNYMANNAMES
	inst.components.named:PickNewName()

	------------------------------------------
	inst:AddComponent("follower")
	inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME
	------------------------------------------
	inst:AddComponent("health")
	inst.components.health:StartRegen(TUNING.BUNNYMAN_HEALTH_REGEN_AMOUNT, TUNING.BUNNYMAN_HEALTH_REGEN_PERIOD)

	------------------------------------------

	inst:AddComponent("inventory")

	------------------------------------------

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLootSetupFn(LootSetupFunction)
	LootSetupFunction(inst.components.lootdropper)

	------------------------------------------

	inst:AddComponent("knownlocations")

	------------------------------------------

	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
	inst.components.trader.deleteitemonaccept = false

	------------------------------------------

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = CalcSanityAura

	------------------------------------------

	inst:AddComponent("sleeper")

	------------------------------------------
	MakeMediumFreezableCharacter(inst, "pig_torso")

	------------------------------------------

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	------------------------------------------

	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("newcombattarget", OnNewTarget)

	-- if HasGorgePort() then
	-- 	inst:AddComponent("prototyper")
	-- 	inst.components.prototyper.onturnon = OnTurnOn
	-- 	inst.components.prototyper.onturnoff = OnTurnOff
	-- 	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.TRADING_BUNNYMAN_THREE
	-- end

	inst.components.sleeper:SetResistance(2)
	inst.components.sleeper.sleeptestfn = NocturnalSleepTest
	inst.components.sleeper.waketestfn = NocturnalWakeTest

	inst.components.combat:SetDefaultDamage(TUNING.BUNNYMAN_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.BUNNYMAN_ATTACK_PERIOD)
	inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
	inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)

	inst.components.locomotor.runspeed = TUNING.BUNNYMAN_RUN_SPEED
	inst.components.locomotor.walkspeed = TUNING.BUNNYMAN_WALK_SPEED

	inst.components.health:SetMaxHealth(TUNING.BUNNYMAN_HEALTH)

	inst.components.trader:Enable()

	MakeHauntablePanic(inst, 5, nil, 5)

	inst.startinghat = nil

	inst.GetStuffTargetFn = GetStuffTargetFn
	inst.GetStuffActionFn = GetStuffActionFn
	inst.GetStuffChatLines = GetStuffChatLines
	inst.GetPlantable = GetPlantable
	inst.GetStuffInitFn = GetStuffInitFn
	inst.GetStuffLoopFns = GetStuffLoopFns
	inst.GetStuffLoopAction = GetStuffLoopAction

	inst.stufftarget = nil
	inst.colorpicked = nil

	inst.OnLoad = OnLoad
	inst.OnSave = OnSave

	inst:SetBrain(brain)
	inst:SetStateGraph("SGhatbunnyman")

	return inst
end

return Prefab("hatbunnyman", fn, assets, prefabs)
