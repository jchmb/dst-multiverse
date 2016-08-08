local offsetX = 0
local offsetY = 0


return {
	-- Choose layout type
							type = LAYOUT.STATIC,

							layout_position = LAYOUT_POSITION.CENTER,
							
							-- Add any arguments for the layout function
							args = nil,							
							-- Lay the objects in whatever pattern

							ground_types = {GROUND.CARPET},

							--layout_position = LAYOUT_POSITION.CENTER,

							ground = {
								{0, 1, 1, 1, 0},
								{1, 1, 1, 1, 1},
								{1, 1, 1, 1, 1},
								{1, 1, 1, 1, 1},
								{0, 1, 1, 1, 0},
							},

							layout = 
								{
									icebox = {
										{
											x = 0.5,
											y = 1,
											properties = {
												scenario = "icebox_carrots",
											},
										}
									},
									cookpot = {
										{
											x = -0.5,
											y = 1,
										},
									},
									firepit = {
										{
											x = 0,
											y = 0,
										},
									},
									hatrabbithouse = {
										{
											x = 0,
											y = -1,
											properties = {
												data = {
													startinghat = "tophat"
												}
											},
										},
									},
								},
								
							-- Either choose to specify the objects positions or a number of objects
							count = nil,
								
							-- Choose a scale on which to place everything
							scale = 1,
}