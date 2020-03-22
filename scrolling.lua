local path = "sample.c"
local wndw = 512
local wndh = 512
local font = love.graphics.newFont("arial.ttf", 16)
--visible region offsets
local rx = 0
local ry = 0
--cursor offsets
local cx = 1
local cy = 1
--array of strings
local lineinfo = {}

for str in love.filesystem.lines(path) do
	print(#str)
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

local sumdt = 0
function love.update(dt)
	sumdt = sumdt + dt
	if sumdt < 0.01 then
		return
	end
	sumdt = 0
	
	if love.keyboard.isDown("d") then
		cx = cx + 1
		if cx > #lineinfo[cy] then
			if #lineinfo[cy] == 0 then
				cx = 1
			else
				cx = #lineinfo[cy]
			end
		end
	end
	if love.keyboard.isDown("a") then
		cx = cx - 1
		if cx < 1 then
			cx = 1
		end
	end
	if love.keyboard.isDown("w") then
		cy = cy - 1
		if cy < 1 then
			cy = 1
		end		
	end
	if love.keyboard.isDown("s") then
		cy = cy + 1
		if cy > #lineinfo then
			cy = #lineinfo
		end		
	end
end

function love.draw()
	local fh = font:getHeight()
	--correct region position
	local cly = cy * fh
	local cly2 = cly - fh
	local ry2 = ry + wndh
	
	if cly2 < ry then
		ry = ry - (ry - cly2)
	elseif cly > ry2 then
		ry = ry + (cly - ry2)
	end
	
	local rx2 = rx + wndw
	local clx = 0
	local prv = 0
	
	for i = 1, cx do
		prv = font:getWidth(lineinfo[cy]:sub(i, i))
		clx = clx + prv
	end
	
	local clx2 = clx - prv
	
	if clx2 < rx then
		rx = rx - (rx - clx2)
	elseif clx > rx2 then
		rx = rx + (clx - rx2)
	end
	--first visible line
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
		--empty line condition
		if #lineinfo[i] == 0 and cy == i then
			love.graphics.rectangle("fill", 0, ly, font:getWidth(" "), fh)
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
