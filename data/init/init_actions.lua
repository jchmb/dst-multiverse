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

-- HACK ACTION
-- AddAction(
-- 	"HACK",
-- 	"Hack",
-- 	function(act)
-- 		local numworks = 1
-- 		if act.invobject and act.invobject.components.tool then
-- 			numworks = act.invobject.components.tool:GetEffectiveness(ACTIONS.HACK)
-- 		elseif act.doer and act.doer.components.worker then
-- 			numworks = act.doer.components.worker:GetEffectiveness(ACTIONS.HACK)
-- 		end
-- 		-- TODO: 
-- 		-- if act.invobject and act.invobject.components.obsidiantool then
-- 		-- 	act.invobject.components.obsidiantool:Use(act.doer, act.target)
-- 		-- end
-- 		if act.target and act.target.components.hackable then
-- 			act.target.components.hackable:Hack(act.doer, numworks)
-- 			return true
-- 		end
-- 		if act.target and act.target.components.workable and act.target.components.workable.action == ACTIONS.HACK then
-- 			act.target.components.workable:WorkedBy(act.doer, numworks)
-- 			return true
-- 		end
-- 	end
-- )
-- GLOBAL.ACTIONS.HACK.distance = 1.75