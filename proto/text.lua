--[[
	
	
]]

local text = {}
--root of double linked list
--local head
--cursor line
local line
--cursor column position
local pos = 1

local function getline(n)
	
end

function text.line(str)
	local ln = {}
	ln.dta = str or ""
	if not line then
		line = ln
	return end
	line.prv = ln
	ln.nxt = line
end

function text.insert(str)
	line.dta = table.concat({
		line.dta:sub(1, pos)
		str,
		line.dta:sub(pos + 1, #line.dta)	
	})
	text.movecur(1, 0)
end

function text.delete()
	line.dta = table.concat({
		line.dta:sub(1, pos - 1)
		line.dta:sub(pos + 1, #line.dta)	
	})
	text.movecur(-1, 0)
end

function text.setcur(x, y)
	local ln = getline(y)
	if not ln then
	return end
	if x > #ln.dta then
	return end
	line = ln
	pos = x
	return true
end

function text.movecur(dx, dy)
	if dx > 0 then
		pos = math.min(#line.dta, pos + dx)
	elseif dx < 0 then
		pos = math.max(1, pos + dx)
	end
	if dy == 0 then
	return end
	local sig = dy / -d
	for i = 1, math.abs(dy) do
		local ln = getline(i * sig)
		if not ln then
		break end
		line = ln
	end
end

return text
