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

function love.update()
	if love.keyboard.isDown("d") then
		rx = rx + 1
	end
	if love.keyboard.isDown("a") then
		rx = rx - 1
		if rx < 0 then
			rx = 0
		end
	end
end

function love.draw()
	local fh = font:getHeight()
	--first visible line
	local lno = math.floor(ry / fh) + 1
	--screen line coordinate
	local ly = lno * fh - (fh + ry)
	for i = lno, #lineinfo do
		if ly > wndh then
			break end
		local ox = 0
		local lx
		local first = false
		for j = 1, #lineinfo[i] do
			local c = lineinfo[i]:sub(j, j)
			local w = font:getWidth(c)
			if not first then
				ox = ox + w
				if ox > rx then
					first = true
					lx = ox - rx
					--lx is the next char position
					--lx - w is the last
					love.graphics.print(c, lx - w, ly)
				end
			elseif lx < wndw then
				love.graphics.print(c, lx, ly)
				lx = lx + w			
			else break end
		end
		ly = ly + fh
	end
end
