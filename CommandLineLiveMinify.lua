
--
-- CommandLineLiveMinify.lua
--
-- For testing: Lets you enter lines of text to be minified to verify the 
-- correctness of their implementation.
--

package.path = package.path..';'..string.gsub(arg[0], "(.*[/\\]).*", "%1")..'?.lua'

local util = require'Util'
local Parser = require'ParseLua'
local Format_Mini = require'FormatMini'
local ParseLua = Parser.ParseLua
local PrintTable = util.PrintTable

while true do
	io.write('> ')
	local line = io.read('*line')
	local fileFrom, fileTo = line:match("^file (.*) (.*)")
	if fileFrom and fileTo then
		local file = io.open(fileFrom, 'r')
		local fileTo = io.open(fileTo, 'w')
		if file and fileTo then
			local st, ast = ParseLua(file:read('*all'))
			if st then
				fileTo:write(Format_Mini(ast)..'\n')
				io.write("Minification Complete\n")
			else
				io.write(""..tostring(ast).."\n")
			end
			file:close()
			fileTo:close()
		else
			io.write("File does not exist\n")
		end
	else
		local st, ast = ParseLua(line)
		if st then
			io.write("====== AST =======\n")
			io.write(PrintTable(ast)..'\n')
			io.write("==== MINIFIED ====\n")
			io.write(Format_Mini(ast)..'\n')
			io.write("==================\n")
		else
			io.write(""..tostring(ast).."\n")
		end
	end
end
