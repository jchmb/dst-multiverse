local farmplots = {}
local offsetX = 0
local offsetY = 0

for i=1,5 do
	for j=1,2 do
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
for i=1,5,2 do
	table.insert(
		houses,
		{
			x=offsetX + i * 1,
			y=offsetY,
		}
	)
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

			rabbithouse_farmer = houses,
			slow_farmplot = farmplots,
		},

	-- Either choose to specify the objects positions or a number of objects
	count = nil,

	-- Choose a scale on which to place everything
	scale = 1,
}
