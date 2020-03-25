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
		--FIX
		line.prv = ln
		line.nxt = line
	end
	return ln
end

function text.insert(str)
	local pbyte = {}
	local left = false
	local pos2 = 0
	for i = 1, #str do
		local c = str:sub(i, i)
		if c == '\n' then
			if pos2 > 0 then
				line.dta = sinsert(line.dta, table.concat(pbyte), pos - 1)
				pbyte = {}
				pos = pos + pos2
			end
			pos2 = 0
			--insert on a new line
			line = text.line()
		else
			pos2 = pos2 + 1
			table.insert(pbyte, c)
		end
	end
	--if we didnt leave on a newline
	--we still have more chars
	if pos2 == 0 then
	return end
	line.dta = sinsert(line.dta, table.concat(pbyte), pos - 1)
	pos = pos + pos2
end

function text.delete()
	local npos = pos - 1
	if npos == 0 then
		if line.prv then
			local prv = line.prv
			if line.nxt then
				prv.nxt = line.nxt
				line.nxt.prv = line.prv
			end
			prv = sinsert(prv.dta, line.dta:sub(1, #line.dta - 1), #prv.dta - 1)
		end
	return end
	local ln = {
		line.dta:sub(1, pos - 2),
		line.dta:sub(pos, #line.dta)
	}
	line.dta = table.concat(ln)
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
