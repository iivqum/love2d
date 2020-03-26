--[[


	
]]
local text = {
	--head of double linked list
	head = nil,
	--marker for storing buffer position
	mark = nil,
	--cursor line
	line = nil
	--cursor column position
	pos = 1
}

local function sinsert(dst, src, x)
	return table.concat({
		dst:sub(1, x),
		src,
		dst:sub(x + 1, #dst)	
	})
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

function text.gotop()
	pos = 1
	line = head
end

function text.line(s)
	local ln = {}
	s = s or ''
	ln.data = table.concat({s, '\n'})
	if not head then
		head = ln
		line = ln
	else
		if line.next then
			line.next.prev = ln
		end	
		ln.prev = line
		ln.next = line.next
		line.next = ln
	end
	return ln
end

function text.insert(s)
	local pbyte = {}
	local pos2 = 0
	for i = 1, #s do
		local c = s:sub(i, i)
		if c == '\n' then
			local split = table.concat({line.data:sub(1, pos - 1), table.concat(pbyte), '\n'})
			local new = line.data:sub(pos, #line.data)
			line.data = split
			if pos2 > 0 then
				pbyte = {}
				pos = 1
				pos2 = 0
			end
			line = text.line(new)
			text.advline()
		else
			pos2 = pos2 + 1
			table.insert(pbyte, c)
		end
	end
	if pos2 == 0 then
	return end
	--remaining chars
	line.data = sinsert(line.data, table.concat(pbyte), pos - 1)
	pos = pos + pos2
end

function text.delete()
	if pos > 1 then
		line.data = table.concat({
			line.data:sub(1, pos - 2),
			line.data:sub(pos, #line.data)	
		})	
	return end
	local prev = line.prev
	if not prev then
	return end
	if line.next then
		prev.next = line.next
		line.next.prev = prev
	end
	local s = line.data:sub(1, #line.data - 1)
	line = prev
	pos = #prev.data
	text.insert(s)
end

function text.advline()
	if not line.next then
	return false end
	line = line.next
	pos = 1
	return true
end

function text.adv()
	if pos == #line.data then
		if line.next then
			line = line.next
			pos = 1
		end 
	return true end
	pos = pos + 1
	return false
end

function text.ret()
	if pos == 1 then
		if line.prev then
			line = line.prev
			pos = #line.data
		end 
	return true end
	pos = pos - 1
	return false
end

function text.get()
	return line.data:sub(pos, pos)
end

function text.eol()
	return pos == #line.data
end

return text
