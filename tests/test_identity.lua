package.path = "../?.lua;" .. package.path
local Parser          = require'ParseLua'
local util            = require'Util'
local FormatIdentity  = require'FormatIdentity'
local FormatMini      = require'FormatMini'
local FormatBeautiful = require'FormatBeautiful'
require'strict'

function readAll(file)
	local f = io.open(file, "rb")
	local content = f:read("*all")
	f:close()
	return content
end

local g_lexTime = 0
local g_parseTime = 0
local g_reconstructTime = 0

function reconstructText(text)
	local preLex = os.clock()

	local success, tokens, ast, reconstructed
	success, tokens = Parser.LexLua(text)
	if not success then
		print("ERROR: " .. tokens)
		return
	end

	local preParse = os.clock()
	
	success, ast = Parser.ParseLua(tokens)
	if not success then
		print("ERROR: " .. ast)
		return
	end
	
	local preReconstruct = os.clock()

	local DO_MINI = false
	local DO_CHECK = false

	if DO_MINI then
		success, reconstructed = FormatMini(ast)
	else
		success, reconstructed = FormatIdentity(ast)
	end

	if not success then
		print("ERROR: " .. reconstructed)
		return
	end

	local post = os.clock()
	g_lexTime = g_lexTime + (preParse - preLex)
	g_parseTime = g_parseTime + (preReconstruct - preParse)
	g_reconstructTime = g_reconstructTime + (post - preReconstruct)

	if DO_CHECK then
		--[[
		print()
		print("Reconstructed: ")
		print("--------------------")
		print(reconstructed)
		print("--------------------")
		print("Done. ")
		--]]

		if reconstructed == text then
			--print("Reconstruction succeeded")
		else
			print("Reconstruction failed")

			local inputLines  = util.splitLines(text)
			local outputLines = util.splitLines(reconstructed)
			local n = math.max(#inputLines, #outputLines)
			for i = 1,n do
				if inputLines[i] ~= outputLines[i] then
					util.printf("ERROR on line %i", i)
					util.printf("Input:  %q", inputLines[i])
					util.printf("Output: %q", outputLines[i])
					break
				end
			end
		end
	end
end


--[*[
local files = {
	"../ParseLua.lua",
	"../FormatIdentity.lua",
	"../Scope.lua",
	"../strict.lua",
	"../Type.lua",
	"Test_identity.lua"
}

for _,path in ipairs(files) do
	print(path)
	local text = readAll(path)
	reconstructText(text)
end

--]]

print("test_lines.txt")

local line_nr = 0
for text in io.lines("test_lines.txt") do
	line_nr = line_nr + 1
	if not text:find("FAIL") then
		--util.printf("\nText: %q", text)
		reconstructText(text)
	end
end


reconstructText('function a(p,q,r,...) end')

util.printf("Lex    time: %f s", g_lexTime)
util.printf("Parse  time: %f s", g_parseTime)
util.printf("Format time: %f s", g_reconstructTime)
