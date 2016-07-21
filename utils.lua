function AddLevelFixed(level_type, data)
    AddLevel(level_type, data)
    data_copy = deepcopy(data)
    data_copy.id = data.id .. "_NORMAL"
    data_copy.location = "forest"
    data_copy.overrides.taskset = data.overrides.taskset .. "_normal"
    AddLevel(level_type, data_copy)
end

function AddTaskSetFixed(task_set, data)
    AddTaskSet(task_set, data)
    data_copy = deepcopy(data)
    task_set_normal = task_set .. "_normal"
    data_copy.location = "forest"
    AddTaskset(task_set_normal, data_copy)
end
