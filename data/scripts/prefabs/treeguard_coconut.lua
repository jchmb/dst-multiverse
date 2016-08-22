local assets=
{
	Asset("ANIM", "anim/coconut_cannon.zip"),
}

local prefabs = 
{
	"small_puff_light",
	"coconut_chunks",
	"bombsplash",
}

local function onthrown(inst, thrower, pt, time_to_target)
    inst.Physics:SetFriction(.2)
	inst.Transform:SetFourFaced()
	inst:FacePoint(pt:Get())
    inst.AnimState:PlayAnimation("throw", true)

    local shadow = SpawnPrefab("warningshadow")
    shadow.Transform:SetPosition(pt:Get())
    shadow:shrink(time_to_target, 1.75, 0.5)

	inst.TrackHeight = inst:DoPeriodicTask(FRAMES, function()
		local pos = inst:GetPosition()

		if pos.y <= 0.3 then

		    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 1.5)

		    for k,v in pairs(ents) do
	            if v.components.combat and v ~= inst and v.prefab ~= "treeguard" then
	                v.components.combat:GetAttacked(thrower, 50)
	            end
		    end

			local pt = inst:GetPosition()
			if inst:GetIsOnWater() then
				local splash = SpawnPrefab("bombsplash")
				splash.Transform:SetPosition(pos.x, pos.y, pos.z)

				inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/cannonball_impact")
				inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/seacreature_movement/splash_large")

			else
				local smoke = SpawnPrefab("small_puff_light")

				local other = nil

				if math.random() < 0.01 then
					other = SpawnPrefab("coconut")
				else
					other = SpawnPrefab("coconut_chunks")
				end
				smoke.Transform:SetPosition(pt:Get())
				other.Transform:SetPosition(pt:Get())
			end

			inst:Remove()
		end
	end)
end

local function onremove(inst)
	if inst.TrackHeight then
		inst.TrackHeight:Cancel()
		inst.TrackHeight = nil
	end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("coconut_cannon")
	inst.AnimState:SetBuild("coconut_cannon")
	inst.AnimState:PlayAnimation("throw", true)

	inst:AddTag("thrown")
	inst:AddTag("projectile")

	inst:AddComponent("throwable")
	inst.components.throwable.onthrown = onthrown
	inst.components.throwable.random_angle = 0
	inst.components.throwable.max_y = 50
	inst.components.throwable.yOffset = 3

	inst.OnRemoveEntity = onremove

	return inst
end

return Prefab("common/inventory/treeguard_coconut", fn, assets, prefabs)