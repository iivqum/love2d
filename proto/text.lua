--[[
	
	
]]

local text = {}
--root of double linked list
--local head
--cursor line
local line
--cursor column position
local pos = 1

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
		line.dta:sub(1, pos)
		line.dta:sub(pos + 1, #line.dta)	
	})
	text.movecur(-1, 0)
end

function text.movecur(dx, dy)

end

return text
