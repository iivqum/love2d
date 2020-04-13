--[[


	
]]

local function insert_immutable(dst, src, x)
	return table.concat({dst:sub(1, x), src, dst:sub(x + 1, #dst)})
end

local function sign(n)
	if n >= 0 then
	return 1
	return -1
end

local text = {}

setfenv(1, text)

local head = nil
local line = nil
local pos = 1

local mark_row = nil
local mark_col = nil

--[[
	basic linked list traversal
	should optimize this somehow
]]

function mark()
	mark_row = 1
	local ptr = head
	while ptr do
		if ptr == line then
		break end
		mark_row = mark_row + 1
		ptr = ptr.next
	end
	mark_col = pos
end

function go_to_mark()
	local ptr = head
	local i = 1
	while ptr do
		if i == mark_row then
			if mark_col >= #ptr.data then
			return false end
			line = ptr
			pos = mark_col
		return true end
		i = i + 1
		ptr = ptr.next
	end
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
	local bytes = {}
	local pos2 = 0
	for i = 1, #s do
		local c = s:sub(i, i)
		if c == '\n' then
			local split = table.concat({line.data:sub(1, pos - 1), table.concat(bytes), '\n'})
			local new = line.data:sub(pos, #line.data)
			line.data = split
			if pos2 > 0 then
				bytes = {}
				pos = 1
				pos2 = 0
			end
			line = insert_line(new)
			move(1)
		else
			pos2 = pos2 + 1
			table.insert(bytes, c)
		end
	end
	if pos2 == 0 then
	return end
	--remaining chars
	line.data = insert_immutable(line.data, table.concat(bytes), pos - 1)
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
	op = sign(op)
	if op == -1 and pos == 1 and line.prev then
		line = line.prev
	elseif op == 1 and pos == #line.data and line.next then
		line = line.next
	else return end
	pos = pos + op
end

function read()
	return line.data:sub(pos, pos)
end

return text
