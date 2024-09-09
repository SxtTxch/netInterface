local ClientShare = {}

--// Services:

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--// Remotes:

local Demand_Client_Share = ReplicatedStorage.Networking_Lib.Data_Sharing.Demand_Client_Share

--// Functions:

ClientShare.Share = {
	--// Add shared data.
}

function ClientShare.getShare()
	return ClientShare.Share
end

if RunService:IsClient() then
	Demand_Client_Share.OnClientInvoke = ClientShare.getShare
end

return ClientShare