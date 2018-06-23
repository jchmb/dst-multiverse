local offsetX = 0
local offsetY = 0


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
                                {0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1},
                                {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1},
                                {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1},
                                {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1},
								{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
								{1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1},
								{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
								{1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
                                {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
                                {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
                                {1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0},
							},

							layout =
								{
                                    colored_rabbithouse = {
                                        {
											x = 0,
											y = 1,
										},
                                        {
											x = -1,
											y = -1,
										},
                                        {
											x = 1,
											y = -1,
										},
									},
								},

							-- Either choose to specify the objects positions or a number of objects
							count = nil,

							-- Choose a scale on which to place everything
							scale = 1,
}
