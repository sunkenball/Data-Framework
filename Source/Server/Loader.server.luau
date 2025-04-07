--// Roblox Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Runtimer = require(ReplicatedStorage.Shared.Runtime)

--// Variables
local Services = script.Parent:FindFirstChild("Services")

--// Script
if not Services then
    warn("❌ Services folder not found!")
    return
end

print("🔄 Attempting to load server services...")

Runtimer.new(Services)
    :andThen(function()
        print("✅ Successfully loaded services modules")
    end)
    :catch(function(err)
        warn("❌ Failed to load services modules:", err)
    end)
