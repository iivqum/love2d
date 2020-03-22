local path = "sample.c"
local wndw = 512
local wndh = 512
local font = love.graphics.newFont("arial.ttf", 16)
--visible region offsets
local rx = 0
local ry = 0
--array of draw objects
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
			break
		end
		--find first visible character
		local ox = 0
		for j = 1, #lineinfo[i] do
			local w = font:getWidth(lineinfo[i]:sub(j, j))
			ox = ox + w
			if ox > rx then
				local lx = ox - (rx + w)
				--find subsequent characters
				for k = j, #lineinfo[i] do
					if lx > wndw then
						break
					end
					local c = lineinfo[i]:sub(k, k)
					--draw character
					love.graphics.print(c, lx, ly)
					lx = lx + font:getWidth(c)
				end
				break
			end
		end
		ly = ly + fh
	end
end
