--!strict
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local networking_lib = script.Parent
local remotes = require(networking_lib.Remotes)

export type net_interface_impl = {
    __index: net_interface_impl,

    new: (name: string) -> net_interface_impl,
    get: (name: string) -> net_interface_impl?,

    fire_server: (self: net_interface_impl, ... any) -> (),
    fire_client: (self: net_interface_impl, client: Player, ... any) -> (),
    fire_all_clients: (self: net_interface_impl, ... any) -> (),

    on_server: (self: net_interface_impl, callback: () -> any?) -> (),
    on_client: (self: net_interface_impl, callback: () -> any?) -> (), 

    destroy: (self: net_interface_impl) -> (),
    name: string,
    remote: RemoteEvent,
}

local net_interfaces: {[string]: net_interface_impl} = {}

local net_interface: net_interface_impl = {} :: net_interface_impl
net_interface.__index = net_interface

function net_interface.new(name: string): net_interface_impl
    if net_interfaces[name] then
        return net_interfaces[name]
    end

    local new_interface = setmetatable({}, net_interface) :: net_interface_impl
    new_interface.name = name
    net_interfaces[name] = new_interface

    if RunService:IsClient() then
        local object = Connector:InvokeServer(name)
        new_interface = setmetatable(object, net_interface) :: net_interface_impl
    end

    new_interface.remote = remotes.new_remote(name)

    return new_interface
end

function net_interface.get(name: string): net_interface_impl?
    return net_interfaces[name]
end

function net_interface:fire_server(...)
    self.remote:FireServer(...)
end

function net_interface:fire_client(client: Player, ...)
    self.remote:FireClient(client, ...)
end

function net_interface:fire_all_clients(...)
    self.remote:FireAllClients(...)
end

function net_interface:destroy()
    self.remote:Destroy()
    net_interfaces[self.name] = nil
end

function net_interface:on_server(callback: () -> any?)
    if RunService:IsClient() then
        warn("net_interface:on_server() should be used only on the server! Please use net_interface:on_client()")
        return
    end
    self.remote.OnServerEvent:Connect(callback)
end

function net_interface:on_client(callback: () -> any?)
    if RunService:IsServer() then
        warn("net_interface:on_client() should be used only on the client! Please use net_interface:on_server()")
        return
    end
    self.remote.OnClientEvent:Connect(callback)
end

if RunService:IsServer() then
    Connector.OnServerInvoke = function(_, name: string)
        return net_interface.new(name)
    end
end

return net_interface
