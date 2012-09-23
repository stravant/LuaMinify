
local plugin = PluginManager():CreatePlugin()
local toolbar = plugin:CreateToolbar("Minify")
local minifyButton = toolbar:CreateButton("", "Minify Selected Script", 'MinifyButtonIcon.png')
local toggleReplaceButton = toolbar:CreateButton("Replace", "If enabled, selected script will be REPLACED "..
                                                            "with a minified version",
                                                            'ReplaceButtonIcon.png')

local replace = false

toggleReplaceButton.Click:connect(function()
	replace = not replace
	toggleReplaceButton:SetActive(replace)
end)

minifyButton.Click:connect(function()
	for _, o in pairs(game.Selection:Get()) do
		if o:IsA('Script') or o:IsA('LocalScript') then
			--can't read linkedsource, bail out
			if o.LinkedSource ~= '' then
				error("Minify Plugin: Cannot Minify a script with a LinkedSource", 0)
			end

			--see if it has been minified
			if o.Name:sub(-4,-1) == '_Min' then
				local original = o:FindFirstChild(o.Name:sub(1,-5))
				if not original then
					error("Minify Plugin: Missing original script `"..o.Name:sub(1,-5).."`", 0)
				end
				--
				local st, min = _G.Minify(original.Source)
				if st then
					o.Source = min
				else
					error("Minify Plugin: "..min, 0)
				end
			else
				local st, min = _G.Minify(o.Source)
				if st then
					local original = o:Clone()
					original.Parent = o
					original.Disabled = true
					o.Name = o.Name.."_Min"
					o.Source = min
				else
					error("Minify Plugin: "..min, 0)
				end 
			end
		end
	end
end)