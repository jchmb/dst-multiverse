local assets =
{
	Asset("ANIM", "anim/pig_king.zip"),
	Asset("ANIM", "anim/beaver_king.zip"),
	Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
	"goldnugget",
	"petals_evil",
}

local tradeTable =
{
	{
		prefab = "livinglog",
		rewards = 
		{
			{
				prefab = "goldnugget",
				count = 1,
			},
		},
	},
}

local function GetRewardsFromTradeTable(item)
	for i, v in ipairs(tradeTable) do
		if v.prefab == item.name or v.prefab == item.prefab then
			return v.rewards
		end
	end
	return nil
end

local function ThrowReward(inst, prefab)
	local nug = SpawnPrefab(prefab)
		local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(0, 4.5, 0)
		
		nug.Transform:SetPosition(pt:Get())
		local down = TheCamera:GetDownVec()
		local angle = math.atan2(down.z, down.x) + (math.random() * 60 - 30) * DEGREES
		--local angle = (math.random() * 60 - 30 - TUNING.CAM_ROT - 90) / 180 * PI
		local sp = math.random() * 4 + 2
		nug.Physics:SetVel(sp * math.cos(angle), math.random() * 2 + 8, sp * math.sin(angle))
end

local function ontradeforgold(inst, item)
	inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingThrowGold")
	local rewards = GetRewardsFromTradeTable(item)
	
	if rewards ~= nil then
	for i, reward in ipairs(rewards) do
		for k = 1, reward.count do
			ThrowReward(inst, reward.prefab)
		end
	end
	end  

	for k = 1, item.components.tradable.goldvalue do
		ThrowReward(inst, "goldnugget")
	end
end

local function onplayhappysound(inst)
	inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingHappy")
end

local function onendhappytask(inst)
	inst.happy = false
	inst.endhappytask = nil
end

local function OnGetItemFromPlayer(inst, giver, item)
	local rewards = GetRewardsFromTradeTable(item)
	if rewards ~= nil or item.components.tradable.goldvalue > 0 then
		inst.AnimState:PlayAnimation("cointoss")
		inst.AnimState:PushAnimation("happy")
		inst.AnimState:PushAnimation("idle", true)
		inst:DoTaskInTime(20/30, ontradeforgold, item)
		inst:DoTaskInTime(1.5, onplayhappysound)
		inst.happy = true
		if inst.endhappytask ~= nil then
			inst.endhappytask:Cancel()
		end
		inst.endhappytask = inst:DoTaskInTime(5, onendhappytask)
	end
end

local function OnRefuseItem(inst, giver, item)
	inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingReject")
	inst.AnimState:PlayAnimation("unimpressed")
	inst.AnimState:PushAnimation("idle", true)
	inst.happy = false
end

local function AcceptTest(inst, item)
	local rewards = GetRewardsFromTradeTable(item)
	return rewards ~= nil or item.components.tradable.goldvalue > 0
end

local function OnIsNight(inst, isnight)
	if isnight then
		inst.components.trader:Disable()
		inst.AnimState:PlayAnimation("sleep_pre")
		inst.AnimState:PushAnimation("sleep_loop", true)
	else
		inst.components.trader:Enable()
		inst.AnimState:PlayAnimation("sleep_pst")
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 2, .5)

	inst.MiniMapEntity:SetPriority(5)
	inst.MiniMapEntity:SetIcon("pigking.png")
	inst.MiniMapEntity:SetPriority(1)

	inst.DynamicShadow:SetSize(10, 5)

	--inst.Transform:SetScale(1.5, 1.5, 1.5)

	inst:AddTag("king")
	inst.AnimState:SetBank("Pig_King")
	inst.AnimState:SetBuild("Beaver_King")
	inst.AnimState:PlayAnimation("idle", true)

	--trader (from trader component) added to pristine state for optimization
	inst:AddTag("trader")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("trader")

	inst.components.trader:SetAcceptTest(AcceptTest)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem

	inst:WatchWorldState("isnight", OnIsNight)
	OnIsNight(inst, TheWorld.state.isnight)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	inst.components.hauntable:SetOnHauntFn(function(inst, haunter)
		if inst.components.trader and inst.components.trader.enabled then
			OnRefuseItem(inst)
			return true
		end
		return false
	end)

	return inst
end

return Prefab("beaver_king", fn, assets, prefabs)
