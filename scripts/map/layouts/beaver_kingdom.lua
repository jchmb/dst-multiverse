

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
