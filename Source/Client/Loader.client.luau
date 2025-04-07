--// Roblox Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Runtimer = require(ReplicatedStorage.Shared.Runtime)

--// Variables
local Controllers = script.Parent:FindFirstChild("Controllers")

--// Script
if not Controllers then
	warn("❌ Controllers folder not found!")
	return
end

print("🔄 Attempting to load controllers...")

Runtimer.new(Controllers)
	:andThen(function()
		print("✅ Successfully loaded controllers")
	end)
	:catch(function(err)
		warn("❌ Failed to load controllers:", err)
	end)

print("")
