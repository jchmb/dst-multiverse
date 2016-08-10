local sideLength = 12
local width = 12 + 2 * math.ceil(math.cos((PI * 2) / 8))
local height = width
local ground_types = {GROUND.GRASS_BLUE, GROUND.WOODFLOOR}



local ground = {}
for i=1,width do
	for j=1,height do
		
	end
end

return {
	-- Choose layout type
	type = LAYOUT.STATIC,
							
	layout_position = LAYOUT_POSITION.CENTER,
							
	args = nil,							
	-- Lay the objects in whatever pattern
	layout = {
		hatrabbithouse = houses,
		slow_farmplot = farmplots,
	},
								
	-- Either choose to specify the objects positions or a number of objects
	count = nil,
								
	-- Choose a scale on which to place everything
	scale = 1,
}
