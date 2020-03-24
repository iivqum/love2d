--[[
	
	
]]

local text = {}
--head of double linked list
--used for traversal
local head
--cursor line
local line
--cursor column position
local pos = 1

local function getline(n)
	local ln = head
	for i = 1, n do
		ln = ln.nxt
		if not ln then
		break end
	end
	return ln
end

function text.mark()
	return {
		pos = pos,
		ln = line
	}
end

function text.goto(mark)
	pos = mark.pos
	line = mark.ln
end

function text.line(str)
	local ln = {}
	ln.dta = str or ""
	if not head then
		head = ln
		line = head
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

function text.adv()
	if text.eol() then
		if not line.nxt then
		return end
		line = line.nxt
		pos = 1
	return end
	pos = pos + 1
end

function text.eol()
	return pos == #line.dta
end

return text
