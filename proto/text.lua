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

function sinsert(dst, src, pos)
	local ln = {
		dst:sub(1, pos - 1),
		src,
		dst:sub(pos, #dst)
	}	
	return table.concat(ln)
end

function text.clear()
	head = nil
	line = nil
	pos = 1
end

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
	str = str or ''
	ln.dta = table.concat({str, '\n'})
	if not head then
		head = ln
		line = ln
	else
		line.prv = ln
		line.nxt = line
	end
	return ln
end

function text.insert(str)
	local pchars = {}
	local left = false
	for i = 1, #str do
		local c = str:sub(i, i)
		if c == '\n' then
			if left then
				line.dta = sinsert(line.dta, table.concat(pchars), pos - 1)
				pchars = {}
			end
			pos = 1
			--inserting on a new line
			line = text.line()
		else
			pos = pos + 1
			left = true
			table.insert(pchars, c)
		end
	end
	--add remaining chars to last line
	if left then
		line.dta = sinsert(line.dta, table.concat(pchars), pos - 1)
	end
end

function text.delete()
	line.dta = table.concat({
	line.dta:sub(1, pos - 1),
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
