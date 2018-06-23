-- DEPLOY_AI Action [FIX FOR MOBS THAT PLANT TREES]
AddAction(
	"DEPLOY_AI",
	"Deploy AI",
	function(act)
		if act.invobject and act.invobject.components.deployable then
			local obj = (act.doer.components.inventory and act.doer.components.inventory:RemoveItem(act.invobject)) or
			(act.doer.components.container and act.doer.components.container:RemoveItem(act.invobject))
			if obj then
				if obj.components.deployable:ForceDeploy(act.pos, act.doer) then
					return true
				else
					act.doer.components.inventory:GiveItem(obj)
				end
			end
		end
	end
)

AddAction(
	"TAPTREE",
	"Tap tree",
	function(act)
    	if act.target ~= nil and act.target.components.tappable ~= nil then
	        if act.target.components.tappable:IsTapped() then
	            act.target.components.tappable:UninstallTap(act.doer)
	            return true
	        elseif act.invobject ~= nil and act.invobject.components.tapper ~= nil then
	            act.target.components.tappable:InstallTap(act.doer, act.invobject)
	            return true
	        end
		end
	end
)

AddAction(
	"INSTALL",
	"Install",
	function(act)
	    if act.invobject ~= nil and act.target ~= nil then
	        -- if act.invobject.components.installable ~= nil and
	        --     act.invobject.components.installable.installprefab ~= nil and
	        --     act.target.components.installations ~= nil then
	        --     local part = SpawnPrefab(act.invobject.components.installable.installprefab)
	        --     if part ~= nil then
	        --         act.invobject:Remove()
	        --         act.target.components.installations:Install(part)
	        --         return true
	        --     end
	        -- elseif act.invobject.components.saltextractor ~= nil
			if act.invobject.components.saltextractor_installable ~= nil
				and act.target.components.saltpond ~= nil
	            and act.invobject.components.saltextractor_installable:DoInstall(act.target) then
		            act.invobject:Remove()
		            return true
	        end
	    end
	end
)

AddComponentAction(
	"SCENE",
	"tappable",
	function(inst, doer, actions, right)
		if not inst:HasTag("tappable") and not inst:HasTag("fire") then
			if right then
				table.insert(actions, GLOBAL.ACTIONS.TAPTREE) -- this is to untap the tree
			elseif inst:HasTag("tapped_harvestable") then
			 	table.insert(actions, GLOBAL.ACTIONS.HARVEST)
			end
		end
	end
)

AddComponentAction(
	"USEITEM",
	"tapper",
	function(inst, doer, target, actions)
        if target:HasTag("tappable") and not inst:HasTag("fire") and not inst:HasTag("burnt") then
            table.insert(actions, GLOBAL.ACTIONS.TAPTREE)
        end
    end
)

-- AddComponentAction(
-- 	"USEITEM",
-- 	"installable",
-- 	function(inst, doer, target, actions)
--         if target:HasTag("installations") then
--             table.insert(actions, ACTIONS.MW_INSTALL)
--         end
--     end,
-- )

AddComponentAction(
	"USEITEM",
	"saltextractor_installable",
	function(inst, doer, target, actions)
        if target:HasTag("saltpond") then
            table.insert(actions, GLOBAL.ACTIONS.INSTALL)
        end
    end
)

-- HACK ACTION
-- AddAction(
-- 	"HACK",
-- 	"Hack",
-- 	function(act)
-- 		local numworks = 1
-- 		if act.invobject and act.invobject.components.tool then
-- 			numworks = act.invobject.components.tool:GetEffectiveness(GLOBAL.ACTIONS.HACK)
-- 		elseif act.doer and act.doer.components.worker then
-- 			numworks = act.doer.components.worker:GetEffectiveness(GLOBAL.ACTIONS.HACK)
-- 		end
-- 		-- TODO:
-- 		-- if act.invobject and act.invobject.components.obsidiantool then
-- 		-- 	act.invobject.components.obsidiantool:Use(act.doer, act.target)
-- 		-- end
-- 		if act.target and act.target.components.hackable then
-- 			act.target.components.hackable:Hack(act.doer, numworks)
-- 			return true
-- 		end
-- 		if act.target and act.target.components.workable and act.target.components.workable.action == GLOBAL.ACTIONS.HACK then
-- 			act.target.components.workable:WorkedBy(act.doer, numworks)
-- 			return true
-- 		end
-- 	end
-- )
-- GLOBAL.ACTIONS.HACK.distance = 1.75
-- GLOBAL.TOOLACTIONS["HACK"] = true
-- AddComponentAction(
-- 	"SCENE",
-- 	"hackable",
-- 	function(inst, doer, actions)
--         -- if inst.canbehacked and inst.caninteractwith and not (inst.components.burnable and inst.components.burnable:IsBurning()) then
--     		--Check if a hack tool is available
--     		local tool = doer.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
--     		if (tool and tool.components.tool and tool.components.tool:CanDoAction(GLOBAL.ACTIONS.HACK)) then
-- 				table.insert(actions, GLOBAL.ACTIONS.HACK)
-- 			end
--     	-- end CSTRINGS.NAMES.SALT_RACK_ITEM = "Saltrack"oconut"
--     end
-- )
-- AddStategraphActionHandler(
-- 	"SGwilson",
-- 	GLOBAL.ActionHandler(
-- 		GLOBAL.ACTIONS.HACK,
-- 		function(inst)
-- 			if inst:HasTag("beaver") then
-- 				return not inst.sg:HasStateTag("gnawing") and "gnaw" or nil
-- 			end
-- 			return not inst.sg:HasStateTag("prechop")
-- 				and (inst.sg:HasStateTag("chopping") and
-- 					"chop" or
-- 					"chop_start")
-- 				or nil
-- 		end
-- 	)
-- )
