local offsetX = 0
local offsetY = 0

local wheats = {}
for i=-0.75,0.75,0.5 do
	for j=-0.75,0.75,0.5 do
		table.insert(wheats, {x=i,y=j})
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
                                GROUND.QUAGMIRE_SOIL,          -- #1
                            },

							--layout_position = LAYOUT_POSITION.CENTER,

							ground = {
                                {1, 1, 0},
								{1, 1, 0},
								{0, 0, 0},
							},

							layout =
								{
                                    colored_rabbithouse = {
                                        {
											x = 1,
											y = 1,
										},
									},
									wheat_planted = wheats,
								},

							-- Either choose to specify the objects positions or a number of objects
							count = nil,

							-- Choose a scale on which to place everything
							scale = 1,
}
