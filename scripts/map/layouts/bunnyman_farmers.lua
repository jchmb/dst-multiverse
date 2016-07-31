local farmplots = {}
local offsetX = 0
local offsetY = 0

for i=1,3 do
	for j=1,1 do
		table.insert(
			farmplots,
			{
				x=offsetX + i * 1,
				y=offsetY + j * 1,
			}
		)
	end
end

local houses = {}
for i=1,3,2 do
	table.insert(
		houses,
		{
			x=offsetX + i * 1,
			y=offsetY,
			properties={
				data = {
					startinghat = "strawhat",
					colorfname = "colored",
				}
			}	
		}
	)
end

return {
	-- Choose layout type
							type = LAYOUT.STATIC,
							
							-- Add any arguments for the layout function
							args = nil,							
							-- Lay the objects in whatever pattern
							layout = 
								{

									hatrabbithouse = houses,
									slow_farmplot = farmplots,
								},
								
							-- Either choose to specify the objects positions or a number of objects
							count = nil,
								
							-- Choose a scale on which to place everything
							scale = 1,
}