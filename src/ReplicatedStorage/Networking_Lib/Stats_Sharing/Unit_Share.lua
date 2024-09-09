local Unit_Share = {}

--// Assets:

local Units_Assets = script.Parent.Parent.Parent.Assets_Lib.Units_Assets

--// Variables:

Unit_Share.Stats = {
	["Test"] = {
		["Stats"] = {
			["Damage"] = 1
		}
	}
}

--// Functions:

function Unit_Share.Get_Unit_Stat(Unit_Name)
	if not Unit_Name then
		return
	end
	
	for Stat_Unit_Name, v in pairs(Unit_Share.Stats) do
		if Stat_Unit_Name and string.lower(Stat_Unit_Name) == string.lower(Unit_Name) then
			return v
		end
	end
end

function Unit_Share.Return_All_Units()
	return Unit_Share.Stats
end

function Unit_Share.Refresh_Stats()
	if not Units_Assets then
		return
	end
	
	for _, unit in ipairs(Units_Assets:GetDescendants()) do
		if unit:IsA("Model") and unit.Parent:IsA("Folder") then
			local Stats_Module = unit.Parent:FindFirstChild("Team_Stats") or unit:FindFirstChild("Stats")
			local Template = {
				["Stats"] = {
					["Damage"] = 1, 
					["Range"] = 1, 
					["Accuracy"] = 1,
					["Attack Speed"] = 1
				}
			}
			
			local Result_Stats_Module = Stats_Module and require(Stats_Module)
			Unit_Share.Stats[unit.Name] = Result_Stats_Module and Result_Stats_Module.Stats or Template
		end
	end
	
	print(Unit_Share.Stats)
end

function Unit_Share.On_Server()
	spawn(function()
		Unit_Share.Refresh_Stats()
	end)
end

return Unit_Share
