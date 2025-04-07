--// Roblox Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Data = require(ReplicatedStorage.Shared.Utils.Data)

--// Module Constants
local LEADERSTATS = require(ReplicatedStorage.Shared.Constants.Leaderstats)

--// Main
local LeaderstatsController = {}

function LeaderstatsController.playerAdded(player: Player)
	local data = Data.waitFor(player)

	local leaderstats = Instance.new("Folder")

	leaderstats.Name = "leaderstats"

	for key, name in LEADERSTATS do
		local instance = Instance.new("StringValue")

		instance.Name = name
		instance.Value = data[key].Value

		Data.changed(key, player):Connect(function()
			instance.Value = data[key].Value
		end)

		instance.Parent = leaderstats
	end

	leaderstats.Parent = player
end

--// Connections
do
	Players.PlayerAdded:Connect(LeaderstatsController.playerAdded)

	for _, player in Players:GetPlayers() do
		task.spawn(LeaderstatsController.playerAdded, player)
	end
end

return LeaderstatsController
