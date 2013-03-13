--
-- beautify
--
-- A command line utility for beautifying lua source code using the beautifier.
--

require "FormatBeautiful"

local function splitFilename(name)
	--table.foreach(arg, print)
	if name:find(".") then
		local p, ext = name:match("()%.([^%.]*)$")
		if p and ext then
			if #ext == 0 then
				return name, nil
			else
				local filename = name:sub(1,p-1)
				return filename, ext
			end
		else
			return name, nil
		end
	else
		return name, nil
	end
end

if #arg == 1 then
	local name, ext = splitFilename(arg[1])
	local outname = name.."_formatted"
	if ext then outname = outname.."."..ext end
	--
	local inf = io.open(arg[1], 'r')
	if not inf then
		print("Failed to open '"..arg[1].."' for reading")
		return
	end
	--
	local sourceText = inf:read('*all')
	inf:close()
	--
	local st, ast = ParseLua(sourceText)
	if not st then
		--we failed to parse the file, show why
		print(ast)
		return
	end
	--
	local outf = io.open(outname, 'w')
	if not outf then
		print("Failed to open '"..outname.."' for writing")
		return
	end
	--
	outf:write(Format_Beautify(ast))
	outf:close()
	--
	print("Beautification complete")

elseif #arg == 2 then
	--keep the user from accidentally overwriting their non-minified file with 
	if arg[1]:find("_formatted") then
		print("Did you mix up the argument order?\n"..
		      "Current command will beautify '"..arg[1].."' and overwrite '"..arg[2].."' with the results")
		while true do
			io.write("Confirm (yes/no): ")
			local msg = io.read('*line')
			if msg == 'yes' then
				break
			elseif msg == 'no' then
				return
			end
		end
	end
	local inf = io.open(arg[1], 'r')
	if not inf then
		print("Failed to open '"..arg[1].."' for reading")
		return
	end
	--
	local sourceText = inf:read('*all')
	inf:close()
	--
	local st, ast = ParseLua(sourceText)
	if not st then
		--we failed to parse the file, show why
		print(ast)
		return
	end
	--
	if arg[1] == arg[2] then
		print("Are you SURE you want to overwrite the source file with a beautified version?\n"..
		      "You will be UNABLE to get the original source back!")
		while true do
			io.write("Confirm (yes/no): ")
			local msg = io.read('*line')
			if msg == 'yes' then
				break
			elseif msg == 'no' then
				return
			end
		end		
	end
	local outf = io.open(arg[2], 'w')
	if not outf then
		print("Failed to open '"..arg[2].."' for writing")
		return
	end
	--
	outf:write(Format_Beautify(ast))
	outf:close()
	--
	print("Beautification complete")

else
	print("Invalid arguments!\nUsage: lua CommandLineLuaBeautify.lua source_file [destination_file]")
end
