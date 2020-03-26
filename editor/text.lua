--[[


	
]]
local text = {}
--head of double linked list
--used for traversal
local head
--marker for storing buffer position
local mark = {}
--cursor line
local line
--cursor column position
local pos = 1

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
	ln.dta = table.concat({s, '\n'})
	if not head then
		head = ln
		line = ln
	else
		if line.nxt then
			line.nxt.prv = ln
		end	
		ln.prv = line
		ln.nxt = line.nxt
		line.nxt = ln
	end
	return ln
end

function text.insert(s)
	local pbyte = {}
	local pos2 = 0
	for i = 1, #s do
		local c = s:sub(i, i)
		if c == '\n' then
			local split = table.concat({line.dta:sub(1, pos - 1), table.concat(pbyte), '\n'})
			local new = line.dta:sub(pos, #line.dta)
			line.dta = split
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
	line.dta = sinsert(line.dta, table.concat(pbyte), pos - 1)
	pos = pos + pos2
end

function text.delete()
	if pos > 1 then
		line.dta = table.concat({
			line.dta:sub(1, pos - 2),
			line.dta:sub(pos, #line.dta)	
		})	
	return end
	local prv = line.prv
	if not prv then
	return end
	if line.nxt then
		prv.nxt = line.nxt
		line.nxt.prv = prv
	end
	local s = line.dta:sub(1, #line.dta - 1)
	line = prv
	pos = #prv.dta
	text.insert(s)
end

function text.advline()
	if not line.nxt then
	return false end
	line = line.nxt
	pos = 1
	return true
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