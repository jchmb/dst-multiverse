local ground = {
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
	{0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
	{0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
	{0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
	{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
}

local statues = {
	{
		x = 0,
		y = 0,
	},
}

local frabbit_spawners = {
	{
		x = 1,
		y = 1,
	},
}

local gravestones = {}
for x=-5,5,1 do
	for y=-5,5,1 do
		local i = x + 6
		local j = y + 6
		if ground[i][j] == 0 then
			table.insert(gravestones, {x = x, y = y,})
		end
	end
end

return {
	-- Choose layout type
	type = LAYOUT.STATIC,

	layout_position = LAYOUT_POSITION.CENTER,

	-- Add any arguments for the layout function
	args = nil,

	ground_types = {
		GROUND.ROAD,
	},

	ground = ground,

	-- Lay the objects in whatever pattern
	layout =
		{
			statue_snook = statues,
			bunnyman_frabbit_spawner = frabbit_spawners,
			gravestone = gravestones,
		},

	-- Either choose to specify the objects positions or a number of objects
	count = nil,

	-- Choose a scale on which to place everything
	scale = 1,
}
