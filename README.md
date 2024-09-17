# 🖧 netInterface

**netInterface** is a powerful, **easy-to-use networking solution** for handling **client-server communication** in Roblox games. This library provides a seamless way to create, manage, and interact with remote events between the client and server, making it **simple and efficient** to pass data between both ends.

## 🚀 Features

- **Readability**: Clean and easy-to-read code for fast development.
- **Simple API**: Provides an intuitive interface to manage remote events.
- **Secure**: Handles communication safely between client and server.
- **Time-saver**: Simplifies complex networking tasks, letting you focus on core gameplay logic.

## 📦 Installation

Simply place the library into your game’s `ReplicatedStorage` and require the `Net_Object` in your scripts.

```lua
local netInterface = require(ReplicatedStorage.Networking_Lib.Net_Object)
```

## 🛠️ Usage

### **Creating a New Network Interface**
```lua
local new_interface = net_interface.new("player_points")
```

### **Firing Events to the Server**
```lua
local points_interface = net_interface.get("player_points")
points_interface:fire_server(player, 100)  -- Sends the player's points to the server
```

### **Firing Events to a Client**
```lua
local points_interface = net_interface.get("player_points")
points_interface:fire_client(player, 100)  -- Sends the points to a specific player
```

### **Firing Events to All Clients**
```lua
local points_interface = net_interface.get("player_points")
points_interface:fire_all_clients(100)  -- Broadcasts points to all clients
```

### **Listening for Server-Side Events**
```lua
local points_interface = net_interface.get("player_points")
points_interface:on_server(function(player, points)
    print(player.Name .. " has " .. points .. " points")
end)
```

### **Listening for Client-Side Events**
```lua
local points_interface = net_interface.get("player_points")
points_interface:on_client(function(points)
    print("You have " .. points .. " points")
end)
```

### **Destroying a Network Interface**
```lua
local points_interface = net_interface.get("player_points")
points_interface:destroy()  -- Cleans up the interface
```

## 🧰 API Reference

- `new(name: string): netInterfaceType` - Creates a new network interface with the given name.
- `get(name: string): netInterfaceType?` - Retrieves an existing network interface.
- `fireServer(...: any) -> nil` - Fires an event from the client to the server.
- `fireClient(client: Player, ...: any) -> nil` - Fires an event from the server to a specific client.
- `fireAllClients(...: any) -> nil` - Fires an event from the server to all clients.
- `onServer(callback: () -> any?) -> any?` - Sets up a listener for server-side events.
- `onClient(callback: () -> any?) -> any?` - Sets up a listener for client-side events.
- `Destroy() -> nil` - Destroys the network interface and cleans up associated resources.

## 📖 Example Scenario

Imagine you're building a **points system** in your game. This library can help you:

1. **Fire a client event** to update the player's points display.
2. **Fire a server event** to update points data securely.
3. **Broadcast a message** to all clients when someone hits a high score.

With this library, you'll **save time** and **write cleaner, more secure code**! 🎉
