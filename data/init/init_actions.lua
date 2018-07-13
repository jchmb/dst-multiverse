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
