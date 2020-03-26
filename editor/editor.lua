local text = require("text")

local ed = {}
ed.text = text

local path

function ed.open(path)
	text.clear()
	--no path, default screen
	if not path then
		text.line()
	end
	local info = love.filesystem.getInfo(path)
	if not info then
	return false end
	for str in love.filesystem.lines(path) do
		text.line(str)
	end
	path = path
	return true
end

function ed.save()
	text.gotop()
	while true do
		if ed.text.eol() and not ed.text.advline() then
		break end
		local ln = text.getline()
		
		ed.text.adv()
	end
end

return ed