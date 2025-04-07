--// Module
local Instancer = {}

function Instancer.from(
	tree: { [string]: number | boolean | string | { [string]: number | boolean | string } },
	name: string,
	parent: Instance
): Instance
	local root = Instance.new("Folder")
	root.Name = name or "Instancer"
	root.Parent = parent

	for key, value in pairs(tree) do
		local instance: Instance

		if type(value) == "table" then
			instance = Instancer.from(value, key, root)
		else
			if type(value) == "string" then
				instance = Instance.new("StringValue")
				instance.Name = key
				instance.Value = value
			elseif type(value) == "number" then
				instance = Instance.new("NumberValue")
				instance.Name = key
				instance.Value = value
			elseif type(value) == "boolean" then
				instance = Instance.new("BoolValue")
				instance.Name = key
				instance.Value = value
			else
				warn("Unsupported type for key:", key, "value:", value)
			end
		end

		if instance then
			instance.Parent = root
		end
	end

	return root
end

function Instancer.to(path: Instance)
	local tree = {}

	for _, child in path:GetDescendants() do
		if child:IsA("Folder") then
			tree[child.Name] = Instancer.to(child)
		else
			tree[child.Name] = child.Value
		end
	end

	return tree
end

return Instancer
