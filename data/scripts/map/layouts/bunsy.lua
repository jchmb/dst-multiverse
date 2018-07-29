local offsetX = 0
local offsetY = 0


local layout = {
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
                                {0, 1, 1, 1, 0},
								{1, 1, 1, 1, 1},
								{1, 1, 1, 1, 1},
								{1, 1, 1, 1, 1},
								{0, 1, 1, 1, 0},
							},

							layout =
								{
                                    bunsy = {
                                        {
											x = -1.5,
											y = 0.5,
										},
									},
									firepit = {
										{
											x = 0,
											y = 0,
										},
									},
									colored_rabbithouse = {
										{
											x = -2,
											y = -2,
										},
										{
											x = 2,
											y = -2,
										},
										{
											x = -2,
											y = 2,
										},
										{
											x = 2,
											y = 2,
										},
									},
								},

							-- Either choose to specify the objects positions or a number of objects
							count = nil,

							-- Choose a scale on which to place everything
							scale = 1,
}

if HasGorgePort() then
	layout.layout['gorge_altar_ivy'] = {
		{
			x = -1,
			y = -1,
		},
		{
			x = 1,
			y = -1,
		},
		{
			x = -1,
			y = 1,
		},
		{
			x = 1,
			y = 1,
		},
	}
end

return layout
