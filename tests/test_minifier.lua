-- Adapted from Yueliang

package.path = "../?.lua;" .. package.path
local util = require'Util'
local Parser = require'ParseLua'
local Format_Mini = require'FormatMini'
local line_nr = 0

for w in io.lines("test_lines.txt") do
    line_nr = line_nr + 1
    --print(w)
    local success, ast = Parser.ParseLua(w)
    if w:find("FAIL") then
        --[[if success then
            print("ERROR PARSING LINE:")
            print("Should fail: true. Did fail: " .. tostring(not success))
            print("Line: " .. w)
        else
            --print("Suceeded!")
        end]]
    else
        if not success then
            print("ERROR PARSING LINE:")
            print("Should fail: false. Did fail: " .. tostring(not success))
            print("Line: " .. w)
        else
            success, ast = Format_Mini(ast)
            --print(success, ast)
            if not success then
                print("ERROR MINIFYING LINE:")
                print("Message: " .. ast)
                print("Line: " .. w)
            end
            success, ast = loadstring(success)
            if not success then
                print("ERROR PARSING MINIFIED LINE:")
                print("Message: " .. ast)
                print("Line nr: " .. line_nr)
                print("Line: " .. w)
            end
            --print("Suceeded!")
        end
    end
end
print"Done!"
os.remove("tmp")

--[[
function readAll(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
    return content
end

local text = readAll('../ParseLua.lua')
local success, ast = Parser.ParseLua(text)
local nice
nice = Format_Mini(ast)
print(nice)
--]]
