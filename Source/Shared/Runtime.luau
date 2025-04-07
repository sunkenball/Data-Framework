--// Roblox Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Promise = require(ReplicatedStorage.Packages.Promise)

--// Module
local Runtime = {}

function Runtime.new(path: Instance)
	return Promise.new(function(resolve, reject)
		local success, result = pcall(function()
			for _, module in path:GetChildren() do
				if module:IsA("ModuleScript") then
					task.spawn(require, module)
				end
			end
		end)

		if not success then
			reject(result)
		else
			resolve(path)
		end
	end)
end

return Runtime
