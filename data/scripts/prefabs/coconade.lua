local assets=
{
	Asset("ANIM", "anim/coconade.zip"),
	Asset("ANIM", "anim/swap_coconade.zip"),

	Asset("ANIM", "anim/coconade_obsidian.zip"),
	Asset("ANIM", "anim/swap_coconade_obsidian.zip"),
}

local prefabs =
{
	"explode_large",
	"explodering_fx",
}

local function addfirefx(inst, owner)
    if not inst.fire then
		-- inst.SoundEmitter:KillSound("hiss")
    	-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/cocnade_fuse_loop", "hiss")
        inst.fire = SpawnPrefab( "torchfire" )
        local follower = inst.fire.entity:AddFollower()
        if owner then
        	follower:FollowSymbol( owner.GUID, "swap_object", 40, -140, 1 )
        else
        	follower:FollowSymbol( inst.GUID, "swap_flame", 0, 0, 0.1 )
        end
    end
end

local function removefirefx(inst)
    if inst.fire then
        inst.fire:Remove()
        inst.fire = nil
    end
end

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", inst.swapsymbol, inst.swapbuild)
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")

	if inst.components.burnable:IsBurning() then
		addfirefx(inst, owner)
	end
end

local function onunequip(inst, owner)
	owner.AnimState:ClearOverrideSymbol("swap_object")
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	removefirefx(inst)
end

local function ondropped(inst)
	if inst.components.burnable:IsBurning() then
		addfirefx(inst)
	end
end

local function onputininventory(inst)
    inst.Physics:SetFriction(.1)
	removefirefx(inst)
	if inst.components.burnable:IsBurning() then
    	-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/cocnade_fuse_loop", "hiss")
	end
end

local function onthrown(inst, thrower, pt)

    inst.Physics:SetFriction(.2)
	inst.Transform:SetFourFaced()
	inst:FacePoint(pt:Get())
	inst.components.floatable:UpdateAnimations("idle_water", "throw")
    inst.AnimState:PlayAnimation("throw", true)
    -- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/coconade_throw")

	inst.LightTask = inst:DoPeriodicTask(FRAMES, function()
		local pos = inst:GetPosition()

		if pos.y <= 0.1 then
			inst.components.floatable:UpdateAnimations("idle_water", "idle")
		inst:DoTaskInTime(2, function()
				if inst and inst.LightTask then
					inst.LightTask:Cancel()
				end
			end)
		end

		if inst.fire then
    		local rad = math.clamp(Lerp(2, 0, pos.y/6), 0, 2)
    		local intensity = math.clamp(Lerp(0.8, 0.5, pos.y/7), 0.5, 0.8)
    		inst.fire.Light:SetRadius(rad)
    		inst.fire.Light:SetIntensity(intensity)
	    end
	end)
end

local function onexplode(inst, scale)
	scale = scale or 1
	local pos = Vector3(inst.Transform:GetWorldPosition())
	-- inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")

	local explode = SpawnPrefab("explode_large")
	local ring = SpawnPrefab("explodering_fx")
	local pos = inst:GetPosition()

	ring.Transform:SetPosition(pos.x, pos.y, pos.z)
	ring.Transform:SetScale(scale, scale, scale)

    -- TODO: where is explode_large defined anyway?
	-- explode.Transform:SetPosition(pos.x, pos.y, pos.z)
	-- explode.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
	-- explode.AnimState:SetLightOverride(1)
	-- explode.Transform:SetScale(scale, scale, scale)
end

local function onexplode_obsid(inst)
	-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/coconade_obsidian_explode")
	onexplode(inst, 1.3)
end

local function onignite(inst)
	inst.components.fuse:StartFuse()
    if inst.components.equippable:IsEquipped() then
    	local owner = inst.components.inventoryitem.owner
    	addfirefx(inst, owner)
    elseif not inst.components.inventoryitem:IsHeld() then
    	addfirefx(inst)
    end
end

local function ondepleted(inst)
	inst.components.explosive:OnBurnt()
end

local function getstatus(inst)
    if inst.components.burnable:IsBurning() then
        return "BURNING"
    end
end

local function onremove(inst)
	inst.SoundEmitter:KillSound("hiss")
	removefirefx(inst)
	if inst.LightTask then
		inst.LightTask:Cancel()
	end
end

local function commonfn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	-- MakeInventoryFloatable(inst, "idle_water", "idle")

	inst:AddTag("thrown")
	inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus

	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(onputininventory)

    inst:AddComponent("fuse")
    inst.components.fuse:SetFuseTime(TUNING.COCONADE_FUSE)
    inst.components.fuse.onfusedone = ondepleted

	inst:AddComponent("burnable")
	inst.components.burnable.onignite = onignite
	inst.components.burnable.nofx = true

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)

	inst:AddComponent("throwable")
	inst.components.throwable.onthrown = onthrown

	inst:AddComponent("explosive")

	-- inst:AddComponent("appeasement")
    -- inst.components.appeasement.appeasementvalue = TUNING.WRATH_LARGE

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = function()
        return inst.components.throwable:GetThrowPoint()
    end
    inst.components.reticule.ease = true


    inst.OnRemoveEntity = onremove

	return inst
end

local function firefn(Sim)
	local inst = commonfn(Sim)

	inst.AnimState:SetBank("coconade")
	inst.AnimState:SetBuild("coconade")
	inst.AnimState:PlayAnimation("idle")

	inst.swapsymbol = "swap_coconade"
	inst.swapbuild = "swap_coconade"

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.inventoryitem.atlasname = "images/inventoryimages/coconade.xml"

	inst.components.explosive:SetOnExplodeFn(onexplode)
	inst.components.explosive.explosivedamage = TUNING.COCONADE_DAMAGE
	inst.components.explosive.explosiverange = TUNING.COCONADE_EXPLOSIONRANGE
	inst.components.explosive.buildingdamage = TUNING.COCONADE_BUILDINGDAMAGE

	return inst
end

local function obsidianfn()
	local inst = commonfn()

	inst.AnimState:SetBank("coconade_obsidian")
	inst.AnimState:SetBuild("coconade_obsidian")
	inst.AnimState:PlayAnimation("idle")

	inst.swapsymbol = "swap_coconade_obsidian"
	inst.swapbuild = "swap_coconade_obsidian"

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.inventoryitem.atlasname = "images/inventoryimages/obsidiancoconade.xml"

	inst.components.explosive:SetOnExplodeFn(onexplode_obsid)
	inst.components.explosive.explosivedamage = TUNING.COCONADE_OBSIDIAN_DAMAGE
	inst.components.explosive.explosiverange = TUNING.COCONADE_OBSIDIAN_EXPLOSIONRANGE
	inst.components.explosive.buildingdamage = TUNING.COCONADE_OBSIDIAN_BUILDINGDAMAGE

	return inst
end

return Prefab("coconade", firefn, assets, prefabs),
   Prefab("obsidiancoconade", obsidianfn, assets, prefabs)
