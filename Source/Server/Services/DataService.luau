--// Roblox Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Sessions = require(ReplicatedStorage.Packages.Sessions)
local Instancer = require(ReplicatedStorage.Shared.Utils.Instancer)

--// Module Constants
local DATA_TEMPLATE = require(ReplicatedStorage.Shared.Constants.Template)
local DATA_VERSION = require(ReplicatedStorage.Shared.Constants.Versions).DATA_VERSION
local MESSAGES = require(ReplicatedStorage.Shared.Constants.Messages)

--// Constants
local SHOULD_SAVE = true

--// Variables
local activeSessions = {}

--// Session Store
local Store = Sessions.New("Game", DATA_TEMPLATE)

--// Types
type Session = typeof(Store:StartSessionAsync(""))

--// Service
local DataService = {}

function DataService.playerAdded(player: Player)
	local session = Store:StartSessionAsync(tostring(player.UserId), {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	if not session then
		return player:Kick(MESSAGES.LOADING_ISSUE)
	end

	session:AddUserId(player.UserId)

	session.OnSessionEnd:Connect(function()
		DataService.onSessionEnd(session, player)

		activeSessions[player] = nil
		player:Kick(MESSAGES.SESSION_ENDED)
	end)

	if player.Parent ~= Players then
		return session:EndSession()
	end

	local shouldReset = not SHOULD_SAVE or session.RobloxMetaData.DATA_VERSION ~= DATA_VERSION

	if shouldReset then
		session.Data = DATA_TEMPLATE
		session.RobloxMetaData.DATA_VERSION = DATA_VERSION

		print("Data reset for", player.Name)
	end

	session:Reconcile()

	activeSessions[player] = session

	print("Session ready for", player.Name)

	DataService.onSessionStart(session, player)
end

function DataService.playerRemoving(player: Player)
	local session = activeSessions[player]

	if not session then
		return warn("No session found for", player.Name)
	end

	print("Session ending for", player.Name)

	session:EndSession()
end

function DataService.onSessionStart(session: Session, player: Player)
	local data = session.Data
	if not data then
		return
	end

	Instancer.from(data, "Data", player)

	print("Session started for", player.Name)
end

function DataService.onSessionEnd(session: Session, player: Player)
	session.Data = Instancer.to(player:FindFirstChild("Data"))

	print("Session saved for", player.Name)
end

--// Connections
do
	Players.PlayerAdded:Connect(DataService.playerAdded)
	Players.PlayerRemoving:Connect(DataService.playerRemoving)

	for _, player in Players:GetPlayers() do
		task.spawn(DataService.playerAdded, player)
	end
end

return DataService
