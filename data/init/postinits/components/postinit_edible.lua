AddComponentPostInit("edible", function(self, inst)

    -- If a component is edible and perishable, then it can be salted. For now.
    inst:AddComponent("saltable")
end)
