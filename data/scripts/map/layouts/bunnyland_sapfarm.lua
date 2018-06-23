local offsetX = 0
local offsetY = 0


return {
	-- Choose layout type
							type = LAYOUT.STATIC,

							-- layout_position = LAYOUT_POSITION.CENTER,

							-- Add any arguments for the layout function
							args = nil,
							-- Lay the objects in whatever pattern

							ground_types = {GROUND.QUAGMIRE_PARKSTONE},

							--layout_position = LAYOUT_POSITION.CENTER,

							ground = {
								{1, 1, 1, 1},
								{1, 1, 1, 1},
								{1, 1, 1, 1},
								{1, 1, 1, 1},
							},

							layout =
								{
									firepit = {
										{
											x = 1,
											y = 1,
										},
									},
									treasurechest = {
										{
											x = -1,
											y = -1,
											properties = {
												scenario = "bunnyland_sapfarm_chest",
											},
										},
									},
								},

							-- Either choose to specify the objects positions or a number of objects
							count = nil,

							-- Choose a scale on which to place everything
							scale = 1,
}
