function AddLevelFixed(level_type, data)
	if GetModConfigBoolean("UseDefaultLocations") then
		data.location = "forest"
	end
	AddLevel(level_type, data)
end

function AddTaskSetFixed(task_set, data)
	if GetModConfigBoolean("UseMigrationPortals") then
		data.set_pieces["MigrationGrass"] = data.set_pieces["CaveEntrance"]
		data.set_pieces["CaveEntrance"] = nil
	end
	if GetModConfigBoolean("UseDefaultLocations") then
		data.location = "forest"
	end
	AddTaskSet(task_set, data)
end
