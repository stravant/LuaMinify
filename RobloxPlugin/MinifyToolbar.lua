--
-- MinifyToolbar.lua
--
-- The main script that generates a toolbar for studio that allows minification of selected
-- scripts, calling on the _G.Minify function defined in `Minify.lua`
--

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
		if o:IsA('Script') then
			--can't read linkedsource, bail out
			if o.LinkedSource ~= '' then
				Spawn(function()
					error("Minify Plugin: Cannot Minify a script with a LinkedSource", 0)
				end)
				return
			end

			--see if it has been minified
			if o.Name:sub(-4,-1) == '_Min' then
				local original = o:FindFirstChild(o.Name:sub(1,-5))
				if original then
					local st, min = _G.Minify(original.Source)
					if st then
						game:GetService("ChangeHistoryService"):SetWaypoint("Minify `"..original.Name.."`")
						if replace then
							o.Source = min
							original:Destroy()
						else
							o.Source = min
						end
					else
						Spawn(function()
							error("Minify Plugin: "..min, 0)
						end)
						return
					end
				else
					if replace then
						local st, min = _G.Minify(o.Source)
						if st then
							game:GetService("ChangeHistoryService"):SetWaypoint("Minify `"..original.Name.."`")
							o.Source = min
						else
							Spawn(function()
								error("Minify Plugin: "..min, 0)
							end)
							return
						end						
					else
						Spawn(function()
							error("Minify Plugin: Missing original script `"..o.Name:sub(1,-5).."`", 0)
						end)
					end
				end
			else
				local st, min = _G.Minify(o.Source)
				if st then
					game:GetService("ChangeHistoryService"):SetWaypoint("Minify `"..o.Name.."`")
					if replace then
						o.Source = min
						o.Name = o.Name.."_Min"
					else
						local original = o:Clone()
						original.Parent = o
						original.Disabled = true
						o.Name = o.Name.."_Min"
						o.Source = min
					end
				else
					Spawn(function()
						error("Minify Plugin: "..min, 0)
					end)
					return
				end 
			end
		end
	end
end)
