local Model_Share = {
	Units = {}
}

--// Services:

local PS = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

--// Assets:

local Units_Assets = RS.Assets_Lib.Units_Assets

--// Functions:

function Model_Share.Weld_Unit(Player : Player, Unit_Asset : Model)
	if not Player and typeof(Player) ~= "Instance" then
		return
	end
	
	if not Unit_Asset and typeof(Unit_Asset) ~= "Instance" then
		return
	end
	
	local PrimaryPart = Unit_Asset.PrimaryPart or Unit_Asset:FindFirstChild("HumanoidRootPart")
	if not PrimaryPart then
		return
	end
	
	if not Model_Share.Units[Player] and not Model_Share.Units[Player][Unit_Asset] and type(Model_Share.Units[Player][Unit_Asset]) ~= "table" and not Model_Share.Units[Player][Unit_Asset].Welds then
		return
	end
	
	for i, Unit_Assets in pairs(Unit_Asset:GetDescendants()) do
		if Unit_Assets:IsA("BasePart") then
			local Weld = Instance.new("WeldConstraint")
			Weld.Part0 = Unit_Assets
			Weld.Part1 = PrimaryPart
			Weld.Parent = Unit_Assets
			
			Model_Share.Units[Player][Unit_Asset].Welds[Weld] = Weld
		end
	end
end

function Model_Share.New_Unit(Player : Player, Unit_Name : string, Unit_ID : string)
	if not Player and typeof(Player) ~= "Instance" then
		return
	end
	
	if not Unit_Name or type(Unit_Name) ~= "string" then
		return warn("No unit name found")
	end
	
	if not Unit_ID or type(Unit_ID) ~= "string" then
		return warn("No unit name found")
	end
	
	local Character = Player.Character
	if not Character then
		return
	end
	
	if not Model_Share.Units[Player] then
		Model_Share.Units[Player] = {}
	end
	
	local Unit_Asset = Units_Assets:FindFirstChild(Unit_Name)
	Unit_Asset.Name = Unit_Name
	Unit_Asset.Parent = Character:FindFirstChild("Units") or Character:FindFirstChildWhichIsA("Folder") or Character
	
	Model_Share.Weld_Unit(Player, Unit_Asset)
	Unit_Asset:SetPrimaryPartCFrame(Character.PrimaryPart.CFrame)
	
	Model_Share.Units[Player][Unit_ID] = {Welds = {}, Unit_Asset = Unit_Asset}
end

function Model_Share.Remove_Unit(Player : Player, Unit_ID : string)
	if not Player and typeof(Player) ~= "Instance" then
		return
	end

	if not Unit_ID or type(Unit_ID) ~= "string" then
		return warn("No unit name found")
	end
	
	if not Model_Share.Units[Player] then
		return
	end
	
	for Unit_Info_ID, Unit_Info in pairs(Model_Share.Units[Player]) do
		if Unit_Info_ID == Unit_ID then
			local Unit_Asset = Unit_Info.Unit_Asset
			
			if Unit_Asset then
				Unit_Asset:Destroy()
			end
		end
	end
end

return Model_Share
