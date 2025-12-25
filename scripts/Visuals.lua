-- visuals.lua
-- Verantwortlich für ALLES rund um ESP, Highlight, Beams

local Visuals = _G.Vain.Visuals
local Config = _G.Vain.Config

--// SERVICES
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// CREATE ESP
function Visuals.CreateESP(target, category)
	if not target then return end
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

	local root =
		target:IsA("Model")
		and (target.PrimaryPart
			or target:FindFirstChildWhichIsA("BasePart")
			or target:FindFirstChildWhichIsA("MeshPart"))
		or (target:IsA("BasePart") and target)

	if not root then return end

	local settings =
		category == "metal" and Config.Settings.METAL_ESP
		or category == "tree" and Config.Settings.TREE_ESP
		or category == "bee" and Config.Settings.BEE_ESP
		or Config.Settings.STAR_ESP

	local color = settings.COLOR
	local enabled = settings.ENABLED

	-- Star color override
	if category == "star" then
		local name = target.Name:lower()
		if name:find("green") then
			color = Color3.fromRGB(80,255,80)
		elseif name:find("yellow") then
			color = Color3.fromRGB(255,230,50)
		end
	end

	local data = Config.ActiveObjects[category][target]
	if not data then
		data = {}
		Config.ActiveObjects[category][target] = data
	end

	--// HIGHLIGHT
	if not data.Highlight then
		local h = Instance.new("Highlight")
		h.FillColor = color
		h.OutlineColor = Color3.new(1,1,1)
		h.FillTransparency = 0.6
		h.Enabled = enabled
		h.Parent = target
		data.Highlight = h
	else
		data.Highlight.Enabled = enabled
		data.Highlight.FillColor = color
	end

	--// BEAM
	if not data.Beam then
		local a0 = Instance.new("Attachment", player.Character.HumanoidRootPart)
		local a1 = Instance.new("Attachment", root)

		local beam = Instance.new("Beam")
		beam.Attachment0 = a0
		beam.Attachment1 = a1
		beam.Width0 = 0.2
		beam.Width1 = 0.2
		beam.Color = ColorSequence.new(color)
		beam.FaceCamera = true
		beam.Texture = "rbxassetid://4955566540"
		beam.Enabled = enabled
		beam.Parent = root

		data.Beam = beam
		data.A0 = a0
		data.A1 = a1
	else
		data.Beam.Enabled = enabled
		data.Beam.Color = ColorSequence.new(color)
	end

	--// METAL EXTRA BEACON
	if category == "metal" and not data.Beacon then
		local p = Instance.new("Part")
		p.Size = Vector3.new(2,2,2)
		p.Anchored = true
		p.CanCollide = false
		p.Material = Enum.Material.Neon
		p.Transparency = enabled and 0.5 or 1
		p.Color = color
		p.CFrame = root.CFrame
		p.Parent = target

		local h = Instance.new("Highlight")
		h.FillColor = color
		h.OutlineColor = Color3.new(1,1,1)
		h.FillTransparency = 0.2
		h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		h.Enabled = enabled
		h.Parent = p

		data.Beacon = p
		data.MetalHighlight = h
	end
end

--// TOGGLE CATEGORY
function Visuals.Toggle(category, state)
	for target, data in pairs(Config.ActiveObjects[category]) do
		if data.Highlight then
			data.Highlight.Enabled = state
		end
		if data.Beam then
			data.Beam.Enabled = state
		end
		if data.MetalHighlight then
			data.MetalHighlight.Enabled = state
		end
		if data.Beacon then
			data.Beacon.Transparency = state and 0.5 or 1
		end
		if state then
			_G.Vain.Notify("Enabled " +  category)
		else
			_G.Vain.Notify("Disabled " + category)
	end
end

--// REFRESH ALL
function Visuals.Refresh()
	for _, obj in ipairs(CollectionService:GetTagged("hidden-metal")) do
		Visuals.CreateESP(obj,"metal")
	end
	for _, obj in ipairs(CollectionService:GetTagged("treeOrb")) do
		Visuals.CreateESP(obj,"tree")
	end
	for _, obj in ipairs(CollectionService:GetTagged("bee")) do
		if obj.Name ~= "TamedBee" then
			Visuals.CreateESP(obj,"bee")
		end
	end
	for _, child in ipairs(workspace:GetChildren()) do
		if child:IsA("Model") and child.Name:lower():find("star") then
			Visuals.CreateESP(child,"star")
		end
	end
end

--// LISTENERS
CollectionService:GetInstanceAddedSignal("hidden-metal"):Connect(function(o)
	Visuals.CreateESP(o,"metal")
end)

CollectionService:GetInstanceAddedSignal("treeOrb"):Connect(function(o)
	Visuals.CreateESP(o,"tree")
end)

CollectionService:GetInstanceAddedSignal("bee"):Connect(function(o)
	if o.Name ~= "TamedBee" then
		Visuals.CreateESP(o,"bee")
	end
end)

workspace.ChildAdded:Connect(function(c)
	if c:IsA("Model") and c.Name:lower():find("star") then
		task.wait(0.2)
		Visuals.CreateESP(c,"star")
	end
end)

--// CHARACTER RESPAWN
player.CharacterAdded:Connect(function()
	task.wait(1)
	for cat in pairs(Config.ActiveObjects) do
		Visuals.Toggle(cat,false)
	end
	Visuals.Refresh()
end)

--// STARTUP
Visuals.Refresh()
