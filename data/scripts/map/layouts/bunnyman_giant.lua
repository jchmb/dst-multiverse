local ds = 0.25
local n = 40

local ground = {}
for i=-4,4 do
    local ground_layer = {}
    for j=-4,4 do
        table.insert(ground_layer, 1)
    end
    table.insert(ground, ground_layer)
end

local walls = {}
for i=-4.5,4.5,0.25 do
	table.insert(walls, {x=-4.5, y=i})
	if i ~= 0 then
		table.insert(walls, {x=i,y=-4.5})
		table.insert(walls, {x=i,y=4.5})
	end
	table.insert(walls, {x=4.5,y=i})
end

return {
	-- Choose layout type
							type = LAYOUT.STATIC,

							-- Add any arguments for the layout function
							args = nil,

                            ground_types = {
                                GROUND.GRASS_ORANGE,          -- #1
                            },

							--layout_position = LAYOUT_POSITION.CENTER,

							ground = ground,

							-- Lay the objects in whatever pattern
							layout =
								{
									giant_bunnyman_spawner = {
										{
											x = 0,
											y = 0,
										},
									},
                                    colored_rabbithouse = {
                                        {
                                            x = 2.5,
                                            y = 2.5,
                                        },
                                        {
                                            x = -2.5,
                                            y = 2.5,
                                        },
                                        {
                                            x = 2.5,
                                            y = -2.5,
                                        },
                                        {
                                            x = -2.5,
                                            y = -2.5,
                                        },
                                    },
                                    wall_hay = walls,
								},

							-- Either choose to specify the objects positions or a number of objects
							count = nil,

							-- Choose a scale on which to place everything
							scale = 1,
}
