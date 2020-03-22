local path = "sample.c"
local wndw = 512
local wndh = 512
local font = love.graphics.newFont("arial.ttf", 16)
--visible region offsets
local rx = 0
local ry = 0
--array of strings
local lineinfo = {}

for str in love.filesystem.lines(path) do
	table.insert(lineinfo, str)
end

love.window.setMode(wndw, wndh)
love.graphics.setFont(font)

function love.wheelmoved(dx, dy)
	--down scroll is given as a negative number
	--the opposite is desired
	dy = -dy
	ry = ry + dy * 50
	if ry < 0 then
		ry = 0
	end
end

function love.update(dt)

	
end

function love.draw()
	local lno = math.floor(ry / fh) + 1
	if lno > #lineinfo then
	return end
	--screen line coordinate
	local ly = lno * fh - (fh + ry)
	for i = lno, #lineinfo do
		if ly > wndh then
		break end
		local lx
		local j = 1
		local ox = 0
		local first = false	
		
		if #lineinfo[i] == 0 then
			if i == cy and cx == 1 then
				love.graphics.rectangle("fill", 0, ly, font:getWidth(" "), fh)
			end
		end
		
		while j <= #lineinfo[i] do
			local c = lineinfo[i]:sub(j, j)
			local w = font:getWidth(c)
			if not first then
				ox = ox + w
				if ox > rx then
					first = true
					lx = ox - (rx + w)
					--repeat last character
					--this time drawing it
					j = j - 1
				end
			elseif lx < wndw then
				--draw cursor
				if i == cy and j == cx then
					love.graphics.rectangle("fill", lx, ly, w, fh)
				end
				love.graphics.print(c, lx, ly)
				lx = lx + w			
			else break end
			j = j + 1
		end
		ly = ly + fh
	end
end
