--[[


	
]]

local function insert_immutable(dst, src, x)
	return table.concat({dst:sub(1, x), src, dst:sub(x + 1, #dst)})
end

local text = {}

setfenv(1, text)

local head = nil
local line = nil
local mark = {}
local pos = 1

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
			move(1)
		else
			pos2 = pos2 + 1
			table.insert(pbyte, c)
		end
	end
	if pos2 == 0 then
	return end
	--remaining chars
	line.data = insert_immutable(line.data, table.concat(pbyte), pos - 1)
	pos = pos + pos2
end

function delete()
	if pos > 1 then
		line.data = table.concat({line.data:sub(1, pos - 2), line.data:sub(pos, #line.data)})	
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

function move(op)
	if op == -1 then
		if pos == 1 then
			if line.prev then line = line.prev end
		return end
		pos = pos - 1
	elseif op == 1 then
		if pos == #line.data then
			if line.next then line = line.next end
		return end
		pos = pos + 1	
	end	
end

function read()
	return line.data:sub(pos, pos)
end

return text
