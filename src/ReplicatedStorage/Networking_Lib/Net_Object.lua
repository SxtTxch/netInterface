--!strict
local run_service = game:GetService("RunService")
local server_script_service = game:GetService("ServerScriptService")
local replicated_storage = game:GetService("ReplicatedStorage")

local networking_lib = script.Parent
local remotes = require(networking_lib.Remotes)

local connector = networking_lib.Connector

--[[ define the type for net_interface_type ]]
export type net_interface_type = {
    __index: net_interface_type,

    new: (name: string) -> net_interface_type,
    get: (name: string) -> net_interface_type?,

    fire_server: (self: net_interface_type, ... any) -> (),
    fire_client: (self: net_interface_type, client: Player, ... any) -> (),
    fire_all_clients: (self: net_interface_type, ... any) -> (),

    on_server: (self: net_interface_type, () -> any?) -> (),
    on_client: (self: net_interface_type, () -> any?) -> (),

    destroy: (self: net_interface_type) -> (),
    name: string,
    remote: RemoteEvent,
}

local net_content: {[string]: net_interface_type} = {}

local net_interface: net_interface_type = {} :: net_interface_type
net_interface.__index = net_interface

--[[ create a new net_interface instance or return an existing one ]]
function net_interface.new(name: string): net_interface_type
    for existing_name, _ in net_content do
        if existing_name == name then
            return net_content[name]
        end
    end

    local net_interface_object = setmetatable({}, net_interface) :: any
    net_interface_object.name = name
    net_content[name] = net_interface_object

    if run_service:IsClient() then
        local object = connector:InvokeServer(name)
        net_interface_object = setmetatable(object, net_interface) :: net_interface_type
    end

    net_interface_object.remote = remotes.new_remote(name)

    return net_interface_object
end

if run_service:IsServer() then
    connector.OnServerInvoke = function(_, name: string)
        local new_interface = net_interface.new(name)
        return new_interface
    end
end

--[[ retrieve an existing net_interface instance by name ]]
function net_interface.get(name: string): net_interface_type?
    return net_interface.new(name) or nil
end

--[[ fire an event to the server ]]
function net_interface:fire_server(...)
    self.remote:FireServer(...)
end

--[[ fire an event to a specific client ]]
function net_interface:fire_client(client, ...)
    self.remote:FireClient(client, ...)
end

--[[ fire an event to all clients ]]
function net_interface:fire_all_clients(...)
    self.remote:FireAllClients(...)
end

--[[ destroy the net_interface instance and clean up resources ]]
function net_interface:destroy()
    self.remote:Destroy()
    net_content[self.name] = nil
end

--[[ connect a callback to handle server-side events ]]
function net_interface:on_server(callback)
    if run_service:IsClient() then
        warn("net_interface:on_server() should be used only on the server! Please use net_interface:on_client()")
        return
    end
    self.remote.OnServerEvent:Connect(callback)
end

--[[ connect a callback to handle client-side events ]]
function net_interface:on_client(callback)
    if run_service:IsServer() then
        warn("net_interface:on_client() should be used only on the client! Please use net_interface:on_server()")
        return
    end
    self.remote.OnClientEvent:Connect(callback)
end

return net_interface
