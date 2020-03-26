local ed = require("editor")

ed.text.line("myline")
ed.text.mark()
ed.text.insert("abcdefg")

ed.text.rst()

local str = {}
while true do
	if ed.text.eol() then
		if not ed.text.advline() then
		break end
		table.insert(str, '\n')
	end
	table.insert(str, ed.text.get())
	ed.text.adv()
end	

print(table.concat(str))