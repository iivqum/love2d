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
	local pchars = {}
	for i = 1, #str do
		local c = str:sub(i, i)
		if c == "\n" then
			if #pchars > 0 then
				line.dta = sinsert(line.dta, table.concat(pchars), pos)
				pchars = {}
			end
			pos = 1
			--inserting on a new line
			line = text.line()
		else
			table.insert(pchars, c)
		end
	end
	--add remaining chars to last line
	if #pchars > 0 then
		line.dta = sinsert(line.dta, table.concat(pchars), pos)
	end
	--text.adv()
end

function text.delete()
	line.dta = table.concat({
		line.dta:sub(1, pos - 1)
		line.dta:sub(pos + 1, #line.dta)	
	})
	text.ret()
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

function text.get()
	return line.dta:sub(pos, pos)
end

function text.eol()
	return pos == #line.dta
end

return text
