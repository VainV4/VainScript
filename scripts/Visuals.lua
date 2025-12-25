-- visuals.lua
-- FULLY FIXED ESP SYSTEM (Metal / Tree / Bee / Star)

local Visuals = {}
_G.Vain.Visuals = Visuals

local Config = _G.Vain.Config

--// SERVICES
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer

--// ENSURE TABLES
Config.ActiveObjects = Config.ActiveObjects or {
	metal = {},
	tree = {},
	bee = {},
	star = {}
}

--// GET SETTINGS
local function getSettings(category)
	return Config.Settings[string.upper(category) .. "_ESP"]
end

--// GET ROOT PART (VERY IMPORTANT)
local function getRoot(obj)
	if not obj then return end

	if obj:IsA("BasePart") then
		return obj
	end

	if obj:IsA("Model") then
		return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
	end
end

--// CLEAN ESP
local function cleanup(category, target)
	local data = Config.ActiveObjects[category][target]
	if not data then return end

	for _, inst in pairs(data) do
		if typeof(inst) == "Instance" then
			inst:Destroy()
		end
	end

	Config.ActiveObjects[category][target] = nil
end

--// CREATE ESP
function Visuals.CreateESP(target, category)
	if not target then return end
	if Config.ActiveObjects[category][target] then return end

	local settings = getSettings(category)
	if not settings or not settings.ENABLED then return end
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

	local root = getRoot(target)
	if not root then return end

	--// COLOR
	local color = settings.COLOR
	if category == "star" then
		local n = target.Name:lower()
		if n:find("green") then
			color = Color3.fromRGB(80,255,80)
		elseif n:find("yellow") then
			color = Color3.fromRGB(255,230,50)
		end
	end

	--// HIGHLIGHT
	local highlight = Instance.new("Highlight")
	highlight.FillColor = color
	highlight.OutlineColor = Color3.new(1,1,1)
	highlight.FillTransparency = 0.55
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Adornee = root.Parent:IsA("Model") and root.Parent or root
	highlight.Parent = workspace

	--// BEAM
	local a0 = Instance.new("Attachment")
	a0.Parent = player.Character.HumanoidRootPart

	local a1 = Instance.new("Attachment")
	a1.Parent = root

	local beam = Instance.new("Beam")
	beam.Attachment0 = a0
	beam.Attachment1 = a1
	beam.Width0 = 0.15
	beam.Width1 = 0.15
	beam.FaceCamera = true
	beam.Color = ColorSequence.new(color)
	beam.Parent = workspace

	Config.ActiveObjects[category][target] = {
		Highlight = highlight,
		Beam = beam,
		A0 = a0,
		A1 = a1
	}
end

--// TOGGLE CATEGORY
function Visuals.Toggle(category, state)
	local settings = getSettings(category)
	if not settings then return end

	settings.ENABLED = state

	if not state then
		for target in pairs(Config.ActiveObjects[category]) do
			cleanup(category, target)
		end
	else
		Visuals.Refresh(category)
	end

	if _G.Vain.Notify then
		_G.Vain.Notify((state and "Enabled " or "Disabled ") .. category)
	end
end

--// REFRESH EXISTING OBJECTS
function Visuals.Refresh(category)
	if not category or category == "metal" then
		for _, obj in ipairs(CollectionService:GetTagged("hidden-metal")) do
			Visuals.CreateESP(obj, "metal")
		end
	end

	if not category or category == "tree" then
		for _, obj in ipairs(CollectionService:GetTagged("treeOrb")) do
			Visuals.CreateESP(obj, "tree")
		end
	end

	if not category or category == "bee" then
		for _, obj in ipairs(CollectionService:GetTagged("bee")) do
			if obj.Name ~= "TamedBee" then
				Visuals.CreateESP(obj, "bee")
			end
		end
	end

	if not category or category == "star" then
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("Model") and obj.Name:lower():find("star") then
				Visuals.CreateESP(obj, "star")
			end
		end
	end
end

--// NEW OBJECT LISTENERS
CollectionService:GetInstanceAddedSignal("hidden-metal"):Connect(function(o)
	Visuals.CreateESP(o, "metal")
end)

CollectionService:GetInstanceAddedSignal("treeOrb"):Connect(function(o)
	Visuals.CreateESP(o, "tree")
end)

CollectionService:GetInstanceAddedSignal("bee"):Connect(function(o)
	if o.Name ~= "TamedBee" then
		Visuals.CreateESP(o, "bee")
	end
end)

workspace.DescendantAdded:Connect(function(o)
	if o:IsA("Model") and o.Name:lower():find("star") then
		task.wait(0.1)
		Visuals.CreateESP(o, "star")
	end
end)

--// CHARACTER RESPAWN
player.CharacterAdded:Connect(function()
	task.wait(1)
	for cat in pairs(Config.ActiveObjects) do
		for target in pairs(Config.ActiveObjects[cat]) do
			cleanup(cat, target)
		end
	end
	Visuals.Refresh()
end)
