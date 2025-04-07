--// Roblox Services
local Players = game:GetService("Players")

--// Constants
local DEFAULT_TIMEOUT = 15

--// Module
local Data = {}

function Data.get(player: Player?)
	player = player or Players.LocalPlayer

	return player:FindFirstChild("Data")
end

function Data.waitFor(player: Player?, timeout: number?)
	player = player or Players.LocalPlayer
	timeout = timeout or DEFAULT_TIMEOUT

	return player:WaitForChild("Data", timeout)
end

function Data.changed(path: string, player: Player?)
	player = player or Players.LocalPlayer

	local data = Data.get(player)

	if data then
		local tree = string.split(path, ".")
		local instance = data

		for _, branch in tree do
			instance = instance:FindFirstChild(branch)
		end

		if instance then
			return instance:GetPropertyChangedSignal("Value")
		end
	end
end

return Data
