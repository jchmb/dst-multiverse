local offsetX = 0
local offsetY = 0

local grass = {}
for i=-4.5,-4,0.5 do
	for j=-4.5,-3.5,0.5 do
		table.insert(grass, {x=i, y=j})
	end
end

for i=-2.5,-2,0.5 do
	for j=-4.5,-3.5,0.5 do
		table.insert(grass, {x=i, y=j})
	end
end

for i=2,2.5,0.5 do
	for j=-4.5,-3.5,0.5 do
		table.insert(grass, {x=i, y=j})
	end
end

for i=4,4.5,0.5 do
	for j=-4.5,-3.5,0.5 do
		table.insert(grass, {x=i, y=j})
	end
end


return {
	-- Choose layout type
							type = LAYOUT.STATIC,

							layout_position = LAYOUT_POSITION.CENTER,

							-- Add any arguments for the layout function
							args = nil,
							-- Lay the objects in whatever pattern

							ground_types = {
                                GROUND.ROAD,          -- #1
                            },

							--layout_position = LAYOUT_POSITION.CENTER,

							ground = {
                                {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                                {1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1},
                                {1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1},
                                {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
								{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
								{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
								{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
								{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
                                {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
                                {0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0},
                                {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
							},

							layout =
								{
                                    colored_rabbithouse = {
                                        {
											x = -3,
											y = -3,
										},
                                        {
											x = 3,
											y = -3,
										},
                                        {
											x = 0,
											y = 4,
										},
									},
									grass = grass,
								},

							-- Either choose to specify the objects positions or a number of objects
							count = nil,

							-- Choose a scale on which to place everything
							scale = 1,
}
