
require'ParseLua'

--
-- FormatIdentity.lua
--
-- Returns the exact source code that was used to create an AST, preserving all
-- comments and whitespace.
-- This can be used to get back a Lua source after renaming some variables in
-- an AST.
--

local function Format_Identity(ast)
	local formatStatlist, formatExpr;

	formatExpr = function(expr)
		if expr.AstType == 'VarExpr' then


		elseif expr.AstType == 'NumberExpr' then


		elseif expr.AstType == 'StringExpr' then


		elseif expr.AstType == 'BooleanExpr' then


		elseif expr.AstType == 'NilExpr' then


		elseif expr.AstType == 'BinopExpr' then


		elseif expr.AstType == 'UnopExpr' then


		elseif expr.AstType == 'DotsExpr' then


		elseif expr.AstType == 'CallExpr' then


		elseif expr.AstType == 'TableCallExpr' then


		elseif expr.AstType == 'StringCallExpr' then


		elseif expr.AstType == 'IndexExpr' then


		elseif expr.AstType == 'MemberExpr' then


		elseif expr.AstType == 'Function' then


		elseif expr.AstType == 'ConstructorExpr' then


		end
	end

	local formatStatement = function(statement)
		if statement.AstType == 'AssignmentStatement' then


		elseif statement.AstType == 'CallStatement' then


		elseif statement.AstType == 'LocalStatement' then


		elseif statement.AstType == 'IfStatement' then


		elseif statement.AstType == 'WhileStatement' then


		elseif statement.AstType == 'DoStatement' then


		elseif statement.AstType == 'ReturnStatement' then


		elseif statement.AstType == 'BreakStatement' then


		elseif statement.AstType == 'RepeatStatement' then


		elseif statement.AstType == 'Function' then


		elseif statement.AstType == 'GenericForStatement' then


		elseif statement.AstType == 'NumericForStatement' then


		end
	end

	formatStatlist = function(statList)

	end

	return formatStatlist(ast)
end

return Format_Identity
