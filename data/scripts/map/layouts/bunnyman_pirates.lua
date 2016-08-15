local offsetX = 0
local offsetY = 0

local houses = {}
for i=0,2,2 do
	for j=0,2,2 do
		table.insert(
			houses,
			{
				x=offsetX + i * 1,
				y=offsetY + j * 1,
				properties={
					data = {
						startinghat = "piratehat",
						colorfname = "default",
					}
				}	
			}
		)
	end
end

return {
	-- Choose layout type
							type = LAYOUT.STATIC,
							
							layout_position = LAYOUT_POSITION.CENTER,
							
							-- Add any arguments for the layout function
							args = nil,							
							-- Lay the objects in whatever pattern
							layout = 
								{

									hatrabbithouse = houses,
									treasurechest = {
										x = 1,
										y = 1,
									}
								},
								
							-- Either choose to specify the objects positions or a number of objects
							count = nil,
								
							-- Choose a scale on which to place everything
							scale = 1,
}