
require'ParseLua'

--
-- FormatMini.lua
--
-- Returns the minified version of an AST. Operations which are performed:
-- - All comments and whitespace are ignored
-- - All local variables are renamed
--

local LowerChars = lookupify{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 
							 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 
							 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}
local UpperChars = lookupify{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 
							 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 
							 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
local Digits = lookupify{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}

function Format_Mini(ast)
	local formatStatlist, formatExpr;
	local count = 0
	--
	local function joinStatementsSafe(a, b, sep)
		if count > 150 then
			count = 0
			return a.."\n"..b
		end
		sep = sep or ' '
		local aa, bb = a:sub(-1,-1), b:sub(1,1)
		if UpperChars[aa] or LowerChars[aa] or aa == '_' then
			if not (UpperChars[bb] or LowerChars[bb] or bb == '_' or Digits[bb]) then
				--bb is a symbol, can join without sep
				return a..b
			elseif bb == '(' then
				print("==============>>>",aa,bb)
				--prevent ambiguous syntax
				return a..sep..b
			else
				return a..sep..b
			end
		elseif Digits[aa] then
			if bb == '(' then
				--can join statements directly
				return a..b
			else
				return a..sep..b
			end
		elseif aa == '' then
			return a..b
		else
			if bb == '(' then
				--don't want to accidentally call last statement, can't join directly
				return a..sep..b
			else
				return a..b
			end
		end
	end

	formatExpr = function(expr)
		local out = string.rep('(', expr.ParenCount or 0)
		if expr.AstType == 'VarExpr' then
			if expr.Local then
				out = out..expr.Local.Name
			else
				out = out..expr.Name
			end

		elseif expr.AstType == 'NumberExpr' then
			out = out..expr.Value.Data

		elseif expr.AstType == 'StringExpr' then
			out = out..expr.Value.Data

		elseif expr.AstType == 'BooleanExpr' then
			out = out..tostring(expr.Value)

		elseif expr.AstType == 'NilExpr' then
			out = joinStatementsSafe(out, "nil")

		elseif expr.AstType == 'BinopExpr' then
			out = joinStatementsSafe(out, formatExpr(expr.Lhs))
			out = joinStatementsSafe(out, expr.Op)
			out = joinStatementsSafe(out, formatExpr(expr.Rhs))

		elseif expr.AstType == 'UnopExpr' then
			out = joinStatementsSafe(out, expr.Op)
			out = joinStatementsSafe(out, formatExpr(expr.Rhs))

		elseif expr.AstType == 'DotsExpr' then
			out = out.."..."

		elseif expr.AstType == 'CallExpr' then
			out = out..formatExpr(expr.Base)
			out = out.."("
			for i = 1, #expr.Arguments do
				out = out..formatExpr(expr.Arguments[i])
				if i ~= #expr.Arguments then
					out = out..","
				end
			end
			out = out..")"

		elseif expr.AstType == 'TableCallExpr' then
			out = out..formatExpr(expr.Base)
			out = out..formatExpr(expr.Arguments[1])

		elseif expr.AstType == 'StringCallExpr' then
			out = out..formatExpr(expr.Base)
			out = out..expr.Arguments[1].Data

		elseif expr.AstType == 'IndexExpr' then
			out = out..formatExpr(expr.Base).."["..formatExpr(expr.Index).."]"

		elseif expr.AstType == 'MemberExpr' then
			out = out..formatExpr(expr.Base)..expr.Indexer..expr.Ident.Data

		elseif expr.AstType == 'Function' then
			expr.Scope:RenameVars()
			out = out.."function("
			if #expr.Arguments > 0 then
				for i = 1, #expr.Arguments do
					out = out..expr.Arguments[i].Name
					if i ~= #expr.Arguments then
						out = out..","
					elseif expr.VarArg then
						out = out..",..."
					end
				end
			elseif expr.VarArg then
				out = out.."..."
			end
			out = out..")"
			out = joinStatementsSafe(out, formatStatlist(expr.Body))
			out = joinStatementsSafe(out, "end")

		elseif expr.AstType == 'ConstructorExpr' then
			out = out.."{"
			for i = 1, #expr.EntryList do
				local entry = expr.EntryList[i]
				if entry.Type == 'Key' then
					out = out.."["..formatExpr(entry.Key).."]="..formatExpr(entry.Value)
				elseif entry.Type == 'Value' then
					out = out..formatExpr(entry.Value)
				elseif entry.Type == 'KeyString' then
					out = out..entry.Key.."="..formatExpr(entry.Value)
				end
				if i ~= #expr.EntryList then
					out = out..","
				end
			end
			out = out.."}"

		end
		out = out..string.rep(')', expr.ParenCount or 0)
		count = count + #out
		return out
	end

	local formatStatement = function(statement)
		local out = ''
		if statement.AstType == 'AssignmentStatement' then
			for i = 1, #statement.Lhs do
				out = out..formatExpr(statement.Lhs[i])
				if i ~= #statement.Lhs then
					out = out..","
				end
			end
			if #statement.Rhs > 0 then
				out = out.."="
				for i = 1, #statement.Rhs do
					out = out..formatExpr(statement.Rhs[i])
					if i ~= #statement.Rhs then
						out = out..","
					end
				end
			end

		elseif statement.AstType == 'CallStatement' then
			out = formatExpr(statement.Expression)

		elseif statement.AstType == 'LocalStatement' then
			out = out.."local "
			for i = 1, #statement.LocalList do
				out = out..statement.LocalList[i].Name
				if i ~= #statement.LocalList then
					out = out..","
				end
			end
			if #statement.InitList > 0 then
				out = out.."="
				for i = 1, #statement.InitList do
					out = out..formatExpr(statement.InitList[i])
					if i ~= #statement.InitList then
						out = out..","
					end
				end
			end

		elseif statement.AstType == 'IfStatement' then
			out = joinStatementsSafe("if", formatExpr(statement.Clauses[1].Condition))
			out = joinStatementsSafe(out, "then")
			out = joinStatementsSafe(out, formatStatlist(statement.Clauses[1].Body))
			for i = 2, #statement.Clauses do
				local st = statement.Clauses[i]
				if st.Condition then
					out = joinStatementsSafe(out, "elseif")
					out = joinStatementsSafe(out, formatExpr(st.Condition))
					out = joinStatementsSafe(out, "then")
				else
					out = joinStatementsSafe(out, "else")
				end
				out = joinStatementsSafe(out, formatStatlist(st.Body))
			end
			out = joinStatementsSafe(out, "end")

		elseif statement.AstType == 'WhileStatement' then
			out = joinStatementsSafe("while", formatExpr(statement.Condition))
			out = joinStatementsSafe(out, "do")
			out = joinStatementsSafe(out, formatStatlist(statement.Body))
			out = joinStatementsSafe(out, "end")

		elseif statement.AstType == 'DoStatement' then
			out = joinStatementsSafe(out, "do")
			out = joinStatementsSafe(out, formatStatlist(statement.Body))
			out = joinStatementsSafe(out, "end")

		elseif statement.AstType == 'ReturnStatement' then
			out = "return"
			for i = 1, #statement.Arguments do
				out = joinStatementsSafe(out, formatExpr(statement.Arguments[i]))
				if i ~= #statement.Arguments then
					out = out..","
				end
			end

		elseif statement.AstType == 'BreakStatement' then
			out = "break"

		elseif statement.AstType == 'RepeatStatement' then
			out = "repeat"
			out = joinStatementsSafe(out, formatStatlist(statement.Body))
			out = joinStatementsSafe(out, "until")
			out = joinStatementsSafe(out, formatExpr(statement.Condition))

		elseif statement.AstType == 'Function' then
			statement.Scope:RenameVars()
			if statement.IsLocal then
				out = "local"
			end
			out = joinStatementsSafe(out, "function ")
			if statement.IsLocal then
				out = out..statement.Name.Name
			else
				out = out..formatExpr(statement.Name)
			end
			out = out.."("
			if #statement.Arguments > 0 then
				for i = 1, #statement.Arguments do
					out = out..statement.Arguments[i].Name
					if i ~= #statement.Arguments then
						out = out..","
					elseif statement.VarArg then
						print("Apply vararg")
						out = out..",..."
					end
				end
			elseif statement.VarArg then
				out = out.."..."
			end
			out = out..")"
			out = joinStatementsSafe(out, formatStatlist(statement.Body))
			out = joinStatementsSafe(out, "end")

		elseif statement.AstType == 'GenericForStatement' then
			out = "for "
			for i = 1, #statement.VariableList do
				out = out..statement.VariableList[i].Name
				if i ~= #statement.VariableList then
					out = out..","
				end
			end
			out = out.." in"
			out = joinStatementsSafe(out, formatExpr(statement.Generator))
			out = joinStatementsSafe(out, "do")
			out = joinStatementsSafe(out, formatStatlist(statement.Body))
			out = joinStatementsSafe(out, "end")

		elseif statement.AstType == 'NumericForStatement' then
			out = "for "
			out = out..statement.Variable.Name.."="
			out = out..formatExpr(statement.Start)..","..formatExpr(statement.End)
			if statement.Step then
				out = out..","..formatExpr(statement.Step)
			end
			out = joinStatementsSafe(out, "do")
			out = joinStatementsSafe(out, formatStatlist(statement.Body))
			out = joinStatementsSafe(out, "end")

		end
		count = count + #out
		return out
	end

	formatStatlist = function(statList)
		local out = ''
		statList.Scope:RenameVars()
		for _, stat in pairs(statList.Body) do
			out = joinStatementsSafe(out, formatStatement(stat), ';')
		end
		return out
	end

	ast.Scope:RenameVars()
	return formatStatlist(ast)
end

