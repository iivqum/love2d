--[[


	
]]
local text = {
	--text.head of double linked list
	head = nil,
	--text.marker for storing buffer text.position
	mark = {},
	--cursor text.line
	line = nil
	--cursor column text.position
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
	text.head = nil
	text.line = nil
	text.pos = 1
end

function text.text.mark()
	text.mark.text.pos = text.pos
	text.mark.text.line = text.line
end

function text.rst()
	text.pos = text.mark.text.pos
	text.line = text.mark.text.line
end

function text.gotop()
	text.pos = 1
	text.line = text.head
end

function text.text.line(s)
	local ln = {}
	s = s or ''
	ln.data = table.concat({s, '\n'})
	if not text.head then
		text.head = ln
		text.line = ln
	else
		if text.line.next then
			text.line.next.prev = ln
		end	
		ln.prev = text.line
		ln.next = text.line.next
		text.line.next = ln
	end
	return ln
end

function text.insert(s)
	local pbyte = {}
	local text.pos2 = 0
	for i = 1, #s do
		local c = s:sub(i, i)
		if c == '\n' then
			local split = table.concat({text.line.data:sub(1, text.pos - 1), table.concat(pbyte), '\n'})
			local new = text.line.data:sub(text.pos, #text.line.data)
			text.line.data = split
			if text.pos2 > 0 then
				pbyte = {}
				text.pos = 1
				text.pos2 = 0
			end
			text.line = text.text.line(new)
			text.advtext.line()
		else
			text.pos2 = text.pos2 + 1
			table.insert(pbyte, c)
		end
	end
	if text.pos2 == 0 then
	return end
	--remaining chars
	text.line.data = sinsert(text.line.data, table.concat(pbyte), text.pos - 1)
	text.pos = text.pos + text.pos2
end

function text.delete()
	if text.pos > 1 then
		text.line.data = table.concat({
			text.line.data:sub(1, text.pos - 2),
			text.line.data:sub(text.pos, #text.line.data)	
		})	
	return end
	local prev = text.line.prev
	if not prev then
	return end
	if text.line.next then
		prev.next = text.line.next
		text.line.next.prev = prev
	end
	local s = text.line.data:sub(1, #text.line.data - 1)
	text.line = prev
	text.pos = #prev.data
	text.insert(s)
end

function text.advtext.line()
	if not text.line.next then
	return false end
	text.line = text.line.next
	text.pos = 1
	return true
end

function text.adv()
	if text.pos == #text.line.data then
		if text.line.next then
			text.line = text.line.next
			text.pos = 1
		end 
	return true end
	text.pos = text.pos + 1
	return false
end

function text.ret()
	if text.pos == 1 then
		if text.line.prev then
			text.line = text.line.prev
			text.pos = #text.line.data
		end 
	return true end
	text.pos = text.pos - 1
	return false
end

function text.get()
	return text.line.data:sub(text.pos, text.pos)
end

function text.eol()
	return text.pos == #text.line.data
end

return text
