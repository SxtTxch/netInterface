local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Networking_Lib = ReplicatedStorage.Networking_Lib

local Share = nil
if RunService:IsServer() then
	Share = require(ServerScriptService.Modules.Data_Sharing.Server_Share)
else
	Share = require(ReplicatedStorage.Networking_Lib.Data_Sharing.ClientShare)
end

local Demand_Server_Share = Networking_Lib.Data_Sharing.Demand_Server_Share
local Demand_Client_Share = Networking_Lib.Data_Sharing.Demand_Client_Share

local DataSharer = {}

function DataSharer.getClientData(client : Player)
	if RunService:IsClient() then warn("DataSharer.IsClient() should be used only on the client! Please use DataSharer.getClientData()") return end
	local ClientShare = Demand_Client_Share:InvokeClient(client)
	return ClientShare
end

function DataSharer.getServerData()
	if RunService:IsServer() then warn("DataSharer.getServerData() should be used only on the server! Please use DataSharer.getClientData()") return end
	local Server_Share = Demand_Server_Share:InvokeServer()
	return Server_Share
end

function DataSharer.setClientData(key, value)
	if RunService:IsServer() then warn("DataSharer.setClientData() should be used only on the client! Please use DataSharer.setServerData()") return end
	Share.Share[key] = value
end

function DataSharer.setServerData(key, value)
	if RunService:IsClient() then warn("DataSharer.setServerData() should be used only on the server! Pleasee use DataSharer.getClientData()") return end
	Share.Share[key] = value
end

return DataSharer
