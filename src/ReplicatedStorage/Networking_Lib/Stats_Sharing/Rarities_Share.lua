local Rarities_Share = {}

--// Assets:

local Units_Assets = script.Parent.Parent.Parent.Assets_Lib.Units_Assets

--// Variables:

Rarities_Share.Stats = {
	["Bronze"] = {
		Color = Color3.new(0.8, 0.5, 0.2)
	},
	["Silver"] = {
		Color = Color3.new(0.75, 0.75, 0.75)
	},
	["Gold"] = {
		Color = Color3.new(1, 0.84, 0)
	},
	["Elite"] = {
		Color = Color3.new(0.13, 0.55, 0.13)
	},
	["Iconic"] = {
		Color = Color3.new(1, 0.08, 0.58)
	},
	["Champion"] = {
		Color = Color3.new(1, 0.39, 0.28)
	},
	["World-Class"] = {
		Color = Color3.new(0.53, 0.81, 0.92) -- Sky Blue
	},
	["Ultimate"] = {
		Color = Color3.new(1, 0.27, 0) -- Orange Red
	},
	["Hall of Fame"] = {
		Color = Color3.new(0.54, 0.17, 0.89) -- Blue Violet
	},
	["Immortal"] = {
		Color = Color3.new(0, 0.75, 1) -- Deep Sky Blue
	}
}

--// Functions:

function Rarities_Share.Get_Unit_Stat(Rarity_Name)
	if not Rarity_Name then
		return
	end

	for Stat_Unit_Name, v in pairs(Rarity_Name.Stats) do
		if Stat_Unit_Name and string.lower(Stat_Unit_Name) == string.lower(Rarity_Name) then
			return v
		end
	end
end

function Rarities_Share.Return_All_Units()
	return Rarities_Share.Stats
end

return Unit_Share
