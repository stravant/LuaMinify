-- Adapted from Yueliang

local source = [=[
;                                       -- FAIL
local                                   -- FAIL
local;                                  -- FAIL
local =                                 -- FAIL
local end                               -- FAIL
local a
local a;
local a, b, c
local a; local b local c;
local a = 1
local a local b = a
local a, b = 1, 2
local a, b, c = 1, 2, 3
local a, b, c = 1
local a = 1, 2, 3
local a, local                          -- FAIL
local 1                                 -- FAIL
local "foo"                             -- FAIL
local a = local                         -- FAIL
local a, b, =                           -- FAIL
local a, b = 1, local                   -- FAIL
local a, b = , local                    -- FAIL
do                                      -- FAIL
end                                     -- FAIL
do end
do ; end                                -- FAIL
do 1 end                                -- FAIL
do "foo" end                            -- FAIL
do local a, b end
do local a local b end
do local a; local b; end
do local a = 1 end
do do end end
do do end; end
do do do end end end
do do do end; end; end
do do do return end end end
do end do                               -- FAIL
do end end                              -- FAIL
do return end
do return return end                    -- FAIL
do break end                            -- FAIL
while                                   -- FAIL
while do                                -- FAIL
while =                                 -- FAIL
while 1 do                              -- FAIL
while 1 do end
while 1 do local a end
while 1 do local a local b end
while 1 do local a; local b; end
while 1 do 2 end                        -- FAIL
while 1 do "foo" end                    -- FAIL
while true do end
while 1 do ; end                        -- FAIL
while 1 do while                        -- FAIL
while 1 end                             -- FAIL
while 1 2 do                            -- FAIL
while 1 = 2 do                          -- FAIL
while 1 do return end
while 1 do return return end            -- FAIL
while 1 do do end end
while 1 do do return end end
while 1 do break end
while 1 do break break end              -- FAIL
while 1 do do break end end
repeat                                  -- FAIL
repeat until                            -- FAIL
repeat until 0
repeat until false
repeat until local                      -- FAIL
repeat end                              -- FAIL
repeat 1                                -- FAIL
repeat =                                -- FAIL
repeat local a until 1
repeat local a local b until 0
repeat local a; local b; until 0
repeat ; until 1                        -- FAIL
repeat 2 until 1                        -- FAIL
repeat "foo" until 1                    -- FAIL
repeat return until 0
repeat return return until 0            -- FAIL
repeat break until 0
repeat break break until 0              -- FAIL
repeat do end until 0
repeat do return end until 0
repeat do break end until 0
for                                     -- FAIL
for do                                  -- FAIL
for end                                 -- FAIL
for 1                                   -- FAIL
for a                                   -- FAIL
for true                                -- FAIL
for a, in                               -- FAIL
for a in                                -- FAIL
for a do                                -- FAIL
for a in do                             -- FAIL
for a in b do                           -- FAIL
for a in b end                          -- FAIL
for a in b, do                          -- FAIL
for a in b do end
for a in b do local a local b end
for a in b do local a; local b; end
for a in b do 1 end                     -- FAIL
for a in b do "foo" end                 -- FAIL
for a b in                              -- FAIL
for a, b, c in p do end
for a, b, c in p, q, r do end
for a in 1 do end
for a in true do end
for a in "foo" do end
for a in b do break end
for a in b do break break end           -- FAIL
for a in b do return end
for a in b do return return end         -- FAIL
for a in b do do end end
for a in b do do break end end
for a in b do do return end end
for =                                   -- FAIL
for a =                                 -- FAIL
for a, b =                              -- FAIL
for a = do                              -- FAIL
for a = 1, do                           -- FAIL
for a = p, q, do                        -- FAIL
for a = p q do                          -- FAIL
for a = b do end                        -- FAIL
for a = 1, 2, 3, 4 do end               -- FAIL
for a = p, q do end
for a = 1, 2 do end
for a = 1, 2 do local a local b end
for a = 1, 2 do local a; local b; end
for a = 1, 2 do 3 end                   -- FAIL
for a = 1, 2 do "foo" end               -- FAIL
for a = p, q, r do end
for a = 1, 2, 3 do end
for a = p, q do break end
for a = p, q do break break end         -- FAIL
for a = 1, 2 do return end
for a = 1, 2 do return return end       -- FAIL
for a = p, q do do end end
for a = p, q do do break end end
for a = p, q do do return end end
break                                   -- FAIL
return
return;
return return                           -- FAIL
return 1
return local                            -- FAIL
return "foo"
return 1,                               -- FAIL
return 1,2,3
return a,b,c,d
return 1,2;
return ...
return 1,a,...
if                                      -- FAIL
elseif                                  -- FAIL
else                                    -- FAIL
then                                    -- FAIL
if then                                 -- FAIL
if 1                                    -- FAIL
if 1 then                               -- FAIL
if 1 else                               -- FAIL
if 1 then else                          -- FAIL
if 1 then elseif                        -- FAIL
if 1 then end
if 1 then local a end
if 1 then local a local b end
if 1 then local a; local b; end
if 1 then else end
if 1 then local a else local b end
if 1 then local a; else local b; end
if 1 then elseif 2                      -- FAIL
if 1 then elseif 2 then                 -- FAIL
if 1 then elseif 2 then end
if 1 then local a elseif 2 then local b end
if 1 then local a; elseif 2 then local b; end
if 1 then elseif 2 then else end
if 1 then else if 2 then end end
if 1 then else if 2 then end            -- FAIL
if 1 then break end                     -- FAIL
if 1 then return end
if 1 then return return end             -- FAIL
if 1 then end; if 1 then end;
function                                -- FAIL
function 1                              -- FAIL
function end                            -- FAIL
function a                              -- FAIL
function a end                          -- FAIL
function a( end                         -- FAIL
function a() end
function a(1                            -- FAIL
function a("foo"                        -- FAIL
function a(p                            -- FAIL
function a(p,)                          -- FAIL
function a(p q                          -- FAIL
function a(p) end
function a(p,q,) end                    -- FAIL
function a(p,q,r) end
function a(p,q,1                        -- FAIL
function a(p) do                        -- FAIL
function a(p) 1 end                     -- FAIL
function a(p) return end
function a(p) break end                 -- FAIL
function a(p) return return end         -- FAIL
function a(p) do end end
function a.(                            -- FAIL
function a.1                            -- FAIL
function a.b() end
function a.b,                           -- FAIL
function a.b.(                          -- FAIL
function a.b.c.d() end
function a:                             -- FAIL
function a:1                            -- FAIL
function a:b() end
function a:b:                           -- FAIL
function a:b.                           -- FAIL
function a.b.c:d() end
function a(...) end
function a(...,                         -- FAIL
function a(p,...) end
function a(p,q,r,...) end
function a() local a local b end
function a() local a; local b; end
function a() end; function a() end;
local function                          -- FAIL
local function 1                        -- FAIL
local function end                      -- FAIL
local function a                        -- FAIL
local function a end                    -- FAIL
local function a( end                   -- FAIL
local function a() end
local function a(1                      -- FAIL
local function a("foo"                  -- FAIL
local function a(p                      -- FAIL
local function a(p,)                    -- FAIL
local function a(p q                    -- FAIL
local function a(p) end
local function a(p,q,) end              -- FAIL
local function a(p,q,r) end
local function a(p,q,1                  -- FAIL
local function a(p) do                  -- FAIL
local function a(p) 1 end               -- FAIL
local function a(p) return end
local function a(p) break end           -- FAIL
local function a(p) return return end   -- FAIL
local function a(p) do end end
local function a.                       -- FAIL
local function a:                       -- FAIL
local function a(...) end
local function a(...,                   -- FAIL
local function a(p,...) end
local function a(p,q,r,...) end
local function a() local a local b end
local function a() local a; local b; end
local function a() end; local function a() end;
a                                       -- FAIL
a,                                      -- FAIL
a,b,c                                   -- FAIL
a,b =                                   -- FAIL
a = 1
a = 1,2,3
a,b,c = 1
a,b,c = 1,2,3
a.b = 1
a.b.c = 1
a[b] = 1
a[b][c] = 1
a.b[c] = 1
a[b].c = 1
0 =                                     -- FAIL
"foo" =                                 -- FAIL
true =                                  -- FAIL
(a) =                                   -- FAIL
{} =                                    -- FAIL
a:b() =                                 -- FAIL
a() =                                   -- FAIL
a.b:c() =                               -- FAIL
a[b]() =                                -- FAIL
a = a b                                 -- FAIL
a = 1 2                                 -- FAIL
a = a = 1                               -- FAIL
a(                                      -- FAIL
a()
a(1)
a(1,)                                   -- FAIL
a(1,2,3)
1()                                     -- FAIL
a()()
a.b()
a[b]()
a.1                                     -- FAIL
a.b                                     -- FAIL
a[b]                                    -- FAIL
a.b.(                                   -- FAIL
a.b.c()
a[b][c]()
a[b].c()
a.b[c]()
a:b()
a:b                                     -- FAIL
a:1                                     -- FAIL
a.b:c()
a[b]:c()
a:b:                                    -- FAIL
a:b():c()
a:b().c[d]:e()
a:b()[c].d:e()
(a)()
()()                                    -- FAIL
(1)()
("foo")()
(true)()
(a)()()
(a.b)()
(a[b])()
(a).b()
(a)[b]()
(a):b()
(a).b[c]:d()
(a)[b].c:d()
(a):b():c()
(a):b().c[d]:e()
(a):b()[c].d:e()
a"foo"
a[[foo]]
a.b"foo"
a[b]"foo"
a:b"foo"
a{}
a.b{}
a[b]{}
a:b{}
a()"foo"
a"foo"()
a"foo".b()
a"foo"[b]()
a"foo":c()
a"foo""bar"
a"foo"{}
(a):b"foo".c[d]:e"bar"
(a):b"foo"[c].d:e"bar"
a(){}
a{}()
a{}.b()
a{}[b]()
a{}:c()
a{}"foo"
a{}{}
(a):b{}.c[d]:e{}
(a):b{}[c].d:e{}
a =                                     -- FAIL
a = a
a = nil
a = false
a = 1
a = "foo"
a = [[foo]]
a = {}
a = (a)
a = (nil)
a = (true)
a = (1)
a = ("foo")
a = ([[foo]])
a = ({})
a = a.b
a = a.b.                                -- FAIL
a = a.b.c
a = a:b                                 -- FAIL
a = a[b]
a = a[1]
a = a["foo"]
a = a[b][c]
a = a.b[c]
a = a[b].c
a = (a)[b]
a = (a).c
a = ()                                  -- FAIL
a = a()
a = a.b()
a = a[b]()
a = a:b()
a = (a)()
a = (a).b()
a = (a)[b]()
a = (a):b()
a = a"foo"
a = a{}
a = function                            -- FAIL
a = function 1                          -- FAIL
a = function a                          -- FAIL
a = function end                        -- FAIL
a = function(                           -- FAIL
a = function() end
a = function(1                          -- FAIL
a = function(p) end
a = function(p,)                        -- FAIL
a = function(p q                        -- FAIL
a = function(p,q,r) end
a = function(p,q,1                      -- FAIL
a = function(...) end
a = function(...,                       -- FAIL
a = function(p,...) end
a = function(p,q,r,...) end
a = ...
a = a, b, ...
a = (...)
a = ..., 1, 2
a = function() return ... end           -- FAIL
a = -10
a = -"foo"
a = -a
a = -nil
a = -true
a = -{}
a = -function() end
a = -a()
a = -(a)
a = -                                   -- FAIL
a = not 10
a = not "foo"
a = not a
a = not nil
a = not true
a = not {}
a = not function() end
a = not a()
a = not (a)
a = not                                 -- FAIL
a = #10
a = #"foo"
a = #a
a = #nil
a = #true
a = #{}
a = #function() end
a = #a()
a = #(a)
a = #                                   -- FAIL
a = 1 + 2; a = 1 - 2
a = 1 * 2; a = 1 / 2
a = 1 ^ 2; a = 1 % 2
a = 1 .. 2
a = 1 +                                 -- FAIL
a = 1 ..                                -- FAIL
a = 1 * /                               -- FAIL
a = 1 + -2; a = 1 - -2
a = 1 * -                               -- FAIL
a = 1 * not 2; a = 1 / not 2
a = 1 / not                             -- FAIL
a = 1 * #"foo"; a = 1 / #"foo"
a = 1 / #                               -- FAIL
a = 1 + 2 - 3 * 4 / 5 % 6 ^ 7
a = ((1 + 2) - 3) * (4 / (5 % 6 ^ 7))
a = (1 + (2 - (3 * (4 / (5 % 6 ^ ((7)))))))
a = ((1                                 -- FAIL
a = ((1 + 2)                            -- FAIL
a = 1)                                  -- FAIL
a = a + b - c
a = "foo" + "bar"
a = "foo".."bar".."baz"
a = true + false - nil
a = {} * {}
a = function() end / function() end
a = a() ^ b()
a = ... % ...
a = 1 == 2; a = 1 ~= 2
a = 1 < 2; a = 1 <= 2
a = 1 > 2; a = 1 >= 2
a = 1 < 2 < 3
a = 1 >= 2 >= 3
a = 1 ==                                -- FAIL
a = ~= 2                                -- FAIL
a = "foo" == "bar"
a = "foo" > "bar"
a = a ~= b
a = true == false
a = 1 and 2; a = 1 or 2
a = 1 and                               -- FAIL
a = or 1                                -- FAIL
a = 1 and 2 and 3
a = 1 or 2 or 3
a = 1 and 2 or 3
a = a and b or c
a = a() and (b)() or c.d
a = "foo" and "bar"
a = true or false
a = {} and {} or {}
a = (1) and ("foo") or (nil)
a = function() end == function() end
a = function() end or function() end
a = {                                   -- FAIL
a = {}
a = {,}                                 -- FAIL
a = {;}                                 -- FAIL
a = {,,}                                -- FAIL
a = {;;}                                -- FAIL
a = {{                                  -- FAIL
a = {{{}}}
a = {{},{},{{}},}
a = { 1 }
a = { 1, }
a = { 1; }
a = { 1, 2 }
a = { a, b, c, }
a = { true; false, nil; }
a = { a.b, a[b]; a:c(), }
a = { 1 + 2, a > b, "a" or "b" }
a = { a=1, }
a = { a=1, b="foo", c=nil }
a = { a                                 -- FAIL
a = { a=                                -- FAIL
a = { a=,                               -- FAIL
a = { a=;                               -- FAIL
a = { 1, a="foo"                        -- FAIL
a = { 1, a="foo"; b={}, d=true; }
a = { [                                 -- FAIL
a = { [1                                -- FAIL
a = { [1]                               -- FAIL
a = { [a]=                              -- FAIL
a = { ["foo"]="bar" }
a = { [1]=a, [2]=b, }
a = { true, a=1; ["foo"]="bar", }
]=]

package.path = "../?.lua;" .. package.path
local util = require'Util'
local Parser = require'ParseLua'
local Format = require'FormatBeautiful'

local f = io.open("tmp", 'wb')
f:write(source)
f:close()
for w in io.lines("tmp") do
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
            success, ast = Format(ast)
            --print(success, ast)
            if not success then
                print("ERROR BEAUTIFYING LINE:")
                print("Message: " .. ast)
                print("Line: " .. w)
            end
            local success_ = success
            success, ast = loadstring(success)
            if not success then
                print("ERROR PARSING BEAUTIFIED LINE:")
                print("Message: " .. ast)
                print("Line: " .. success_)
            end
            --print("Suceeded!")
        end
    end
end
print"Done!"
os.remove("tmp")
