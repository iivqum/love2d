--[[
	
	
]]
local text = {}
--head of double linked list
--used for traversal
local head
--marker for storing a position
local mark = {}
--cursor line
local line
--cursor column position
local pos = 1

function text.mark()
	mark.pos = pos
	mark.line = line
end

function text.rst()
	pos = mark.pos
	line = mark.line
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

function text.adv()
	if pos == #line.dta then
		if line.nxt then
			line = line.nxt
			pos = 1
		end 
	return true end
	pos = pos + 1
	return false
end

function text.ret()
	if pos == 1 then
		if line.prv then
			line = line.prv
			pos = #line.dta
		end 
	return true end
	pos = pos - 1
	return false
end

return text
