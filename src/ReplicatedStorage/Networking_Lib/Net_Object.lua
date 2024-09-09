--!strict
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Networking_Lib = script.Parent
local Remotes = require(Networking_Lib.Remotes)

local Connector = Networking_Lib.Connector

-- Define the type for netInterfaceType
export type netInterfaceType = {
	__index: netInterfaceType,
	new: (name: string) -> netInterfaceType,
	get: (name: string) -> netInterfaceType?,
	fireServer: (self: netInterfaceType, ... any) -> nil,
	fireClient: (self: netInterfaceType, client : Player, ... any) -> nil,
	fireAllClients: (self: netInterfaceType, ... any) -> nil,
	onServer: (self: netInterfaceType, () -> any?) -> any?,
	onClient: (self: netInterfaceType, () -> any?) -> any?,
	Destroy: (self: netInterfaceType) -> nil,
	name: string,
	remote : RemoteEvent,
}

local netContent: {[string]: netInterfaceType} = {}

local netInterface: netInterfaceType = {} :: netInterfaceType
netInterface.__index = netInterface

function netInterface.new(name: string): netInterfaceType
	
	for existingName ,_ in netContent do
		if existingName == name then
			return netContent[name]
		end
	end
	
	local netInterfaceObject = setmetatable({}, netInterface) :: any

	netInterfaceObject.name = name

	netContent[name] = netInterfaceObject
	
	if RunService:IsClient() then
		local object = Connector:InvokeServer(name)
		netInterfaceObject = setmetatable(object, netInterface) :: netInterfaceType
	end
	
	netInterfaceObject.remote = Remotes.newRemote(name)
	
	return netInterfaceObject
end

if RunService:IsServer() then
	Connector.OnServerInvoke = function(_, name : string)
		local newInterface = netInterface.new(name)
		return newInterface
	end
end

function netInterface.get(name: string): netInterfaceType?
	return netInterface.new(name) or nil
end

function netInterface:fireServer(...)
	self.remote:FireServer(...)
	return nil
end

function netInterface:fireClient(client, ...)
	self.remote:FireClient(client, ...)
	return nil
end

function netInterface:fireAllClients(...)
	self.remote:FireAllClients(...)
	return nil
end

function netInterface:Destroy()
	self.remote:Destroy()
	netContent[self.name] = nil
	return nil
end

function netInterface:onServer(callback)
	if RunService:IsClient() then warn("netInterface.onServer() should be used only on the server! Please use netInterface.onClient()") return end
	self.remote.OnServerEvent:Connect(callback)
	return nil
end

function netInterface:onClient(callback)
	if RunService:IsServer() then warn("netInterface.onClient() should be used only on the client! Please use netInterface.onServer()") return end
	self.remote.OnClientEvent:Connect(callback)
	return nil
end
return netInterface
