local Remote_Holder = script.Parent.Remote_Holder

type Remotes = {
	newRemote : (name : string) -> nil,
	remoteContent : {[string] : RemoteEvent}
}

local Remotes = {} :: Remotes
Remotes.remoteContent = {} 

function Remotes.newRemote(name : string)
	for _, existingRemote in Remote_Holder:GetChildren() do
		if existingRemote.Name == name then
			return existingRemote
		end
	end
	local newRemote = Instance.new("RemoteEvent")
	newRemote.Name = name
	newRemote.Parent = Remote_Holder
	
	return newRemote
end

return Remotes