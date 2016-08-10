local assets =
{
	Asset("ANIM", "anim/coffee.zip"),
	Asset("ATLAS", "images/inventoryimages/coffee.xml")
}

local prefabs = 
{
	"spoiled_food",
}

local CAFFEINE_SPEED_MODIFIER = 1.4
local CAFFEINE_DURATION = 6 * 60

local function StartCaffeineFn(inst, eater)
	if eater.components.locomotor ~= nil and eater.components.caffeinated ~= nil then
		eater.components.caffeinated:Caffeinate(CAFFEINE_SPEED_MODIFIER, CAFFEINE_DURATION)
	end
end

local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBuild("coffee")
		inst.AnimState:SetBank("coffee")
		inst.AnimState:PlayAnimation("idle", false)

		inst:AddTag("preparedfood")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = 3
		inst.components.edible.hungervalue = 10
		inst.components.edible.foodtype = FOODTYPE.GENERIC
		inst.components.edible.sanityvalue = -5
		inst.components.edible.temperaturedelta = 5
		inst.components.edible.temperatureduration = 60
		inst.components.edible:SetOnEatenFn(StartCaffeineFn)

		inst:AddComponent("inspectable")
		inst.wet_prefix = "soggy"
		
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/coffee.xml"

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
		MakeHauntableLaunchAndPerish(inst)
		AddHauntableCustomReaction(inst, function(inst, haunter)
			--#HAUNTFIX
			--if math.random() <= TUNING.HAUNT_CHANCE_SUPERRARE then
				--if inst.components.burnable and not inst.components.burnable:IsBurning() then
					--inst.components.burnable:Ignite()
					--inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
					--inst.components.hauntable.cooldown_on_successful_haunt = false
					--return true
				--end
			--end
			return false
		end, true, false, true)
		---------------------        

		inst:AddComponent("bait")

		------------------------------------------------
		inst:AddComponent("tradable")
		
		------------------------------------------------  

		return inst
	end

return Prefab( "coffee", fn, assets, prefabs) 
