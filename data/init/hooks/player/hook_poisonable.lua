local onhit = function(inst, attacker, dmg)
    if attacker ~= nil and attacker:HasTag("poisonous") then
        if math.random() <= 0.5 then
            inst.components.poisonable:SetPoison(-1, 5, 60 * 16)
        end
    end
end

HookInitPoisonable = function(player)
    if player.components.poisonable == nil then
		player:AddComponent("poisonable")
        if player.components.combat.onhitfn ~= nil then
            oldonhitfn = player.components.combat.onhitfn
            player.components.combat:SetOnHit(function(inst, attacker, dmg)
                oldonhitfn(inst, attacker, dmg)
                onhit(inst, attacker, dmg)
            end)
        else
            player.components.combat:SetOnHit(onhit)
        end
	end
end