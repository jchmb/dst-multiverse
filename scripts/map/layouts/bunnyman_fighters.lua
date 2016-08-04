local walls = {}
local n = 7
local ds = 0.25

for i=0,n do
	table.insert(walls, {x=i*ds,y=0})
	if i ~= 3 and i ~= 4 then
		table.insert(walls, {x=0,y=i*ds})
		table.insert(walls, {x=n*ds,y=i*ds})
	end
	table.insert(walls, {x=i*ds,y=n*ds})
end

return {
	-- Choose layout type
							type = LAYOUT.STATIC,
							
							-- Add any arguments for the layout function
							args = nil,							
							-- Lay the objects in whatever pattern
							layout = 
								{

									wall_hay = walls,
									hatrabbithouse = {
										{
											x = 2 * ds,
											y = 3 * ds,
											properties = {
												startinghat = "footballhat",
												colorfname = "colored",
											},
										},
										{
											x = 5 * ds,
											y = 3 * ds,
											properties = {
												startinghat = "footballhat",
												colorfname = "colored",
											},
										},
									},
								},
								
							-- Either choose to specify the objects positions or a number of objects
							count = nil,
								
							-- Choose a scale on which to place everything
							scale = 1,
}