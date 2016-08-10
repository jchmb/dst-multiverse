local carrots = {}
local offsetX = 0
local offsetY = 0

for i=1,4 do
	for j=1,4 do
		table.insert(
			carrots,
			{
				x=offsetX + i * 0.25,
				y=offsetY + j * 0.25,
			}
		)
	end
end

offsetX = offsetX - 1
offsetY = offsetY - 1

local walls = {}
for i=1,8 do
	table.insert(
		houses,
		{
			x=offsetX + i * 0.25,
			y=offsetY + i * 0.25,
			properties={
				data = {
					startinghat = "strawhat",
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