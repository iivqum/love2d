--[[


	
]]

local text = {}

setfenv(1, text)

local head = nil
local line = nil
local mark = {}
local pos = 1

local function sinsert(dst, src, x)
	return table.concat({
		dst:sub(1, x),
		src,
		dst:sub(x + 1, #dst)	
	})
end

function insert_line(s)
	local ln = {}
	s = s or ''
	ln.data = table.concat({s, '\n'})
	if not head then
		head = ln
		line = ln
	return ln
	if line.next then
		line.next.prev = ln
	end	
	ln.prev = line
	ln.next = line.next
	line.next = ln
	return ln
end

function insert(s)
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
			line = insert_line(new)
			adv()
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

function delete()
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
	insert(s)
end

return text
