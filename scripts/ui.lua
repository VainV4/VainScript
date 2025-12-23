--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")

--// SETTINGS & STATE
local Settings = {
	METAL_ESP = { ENABLED = false, COLOR = Color3.fromRGB(0, 170, 255) },
	STAR_ESP = { ENABLED = false, COLOR = Color3.fromRGB(255, 255, 255) },
	TREE_ESP = { ENABLED = false, COLOR = Color3.fromRGB(255, 100, 0) },
	AIM_ASSIST = { ENABLED = false, SMOOTHNESS = 0.15, MAX_DISTANCE = 94, MAX_ANGLE = 90 },
	UI_COLOR = Color3.fromRGB(12, 12, 14),
	KEY_UI_TOGGLE = Enum.KeyCode.RightShift,
	KEY_AIM_TOGGLE = Enum.KeyCode.Q,
	VISIBLE = true
}

local ActiveObjects = { ["metal"] = {}, ["star"] = {}, ["tree"] = {} }
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// UI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VainDashboard_V4"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 20
blur.Enabled = true

local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Size = UDim2.new(0.7, 0, 0.7, 0)
MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
MainContainer.BackgroundColor3 = Settings.UI_COLOR
Instance.new("UICorner", MainContainer).CornerRadius = UDim.new(0, 10)
Instance.new("UIAspectRatioConstraint", MainContainer).AspectRatio = 1.667
MainContainer.ClipsDescendants = true

local MainStroke = Instance.new("UIStroke", MainContainer)
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(45, 45, 50)

-- Top Bar
local TopBar = Instance.new("Frame", MainContainer)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = " VAIN SYSTEM DASHBOARD v4"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(200, 200, 205)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Sidebar
local Sidebar = Instance.new("ScrollingFrame", MainContainer)
Sidebar.Size = UDim2.new(0, 170, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 0
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 10)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 20)

-- Content Area
local Content = Instance.new("Frame", MainContainer)
Content.Size = UDim2.new(1, -170, 1, -40)
Content.Position = UDim2.new(0, 170, 0, 40)
Content.BackgroundTransparency = 1

--// UI DRAGGING
do
	local dragging, dragInput, dragStart, startPos
	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = MainContainer.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	TopBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

--// UI FACTORY
local Panels = {}
local Buttons = {}

local function CreateCategory(name)
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.new(0, 140, 0, 35)
	btn.Text = name:upper()
	btn.TextSize = 16
	btn.Font = Enum.Font.GothamMedium
	btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
	btn.TextScaled = true
	btn.TextColor3 = Color3.fromRGB(150, 150, 150)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	local s = Instance.new("UIStroke", btn)
	s.Color = Color3.fromRGB(45, 45, 50)

	local panel = Instance.new("Frame", Content)
	panel.Size = UDim2.new(1, -40, 1, -40)
	panel.Position = UDim2.new(0, 20, 0, 20)
	panel.Visible = false
	panel.BackgroundTransparency = 1
	local layout = Instance.new("UIListLayout", panel)
	layout.Padding = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(function()
		for _, p in pairs(Panels) do p.Visible = false end
		for _, b in pairs(Buttons) do
			b.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
			if b:FindFirstChild("UIStroke") then
				b.UIStroke.Color = Color3.fromRGB(45,45,50)
			end
		end
		panel.Visible = true
		btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
		if s then s.Color = Color3.fromRGB(255,255,255) end
	end)

	Panels[name] = panel
	Buttons[name] = btn
	return panel
end

local function CreateToggle(parent, text, default, callback)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

	local label = Instance.new("TextLabel", frame)
	label.Text = " "..text
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(200,200,205)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 14

	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0,35,0,18)
	btn.Position = UDim2.new(1,-45,0.5,-9)
	btn.BackgroundColor3 = default and Color3.fromRGB(0,170,255) or Color3.fromRGB(45,45,50)
	btn.Text = ""
	Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

	local dot = Instance.new("Frame", btn)
	dot.Size = UDim2.new(0,14,0,14)
	dot.Position = default and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
	dot.BackgroundColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

	btn.MouseButton1Click:Connect(function()
		default = not default
		TweenService:Create(btn,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BackgroundColor3 = default and Color3.fromRGB(0,170,255) or Color3.fromRGB(45,45,50)}):Play()
		dot:TweenPosition(default and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7),"Out","Quad",0.25,true)
		TweenService:Create(dot,TweenInfo.new(0.25),{BackgroundColor3=default and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,200)}):Play()
		callback(default)
	end)
end

local function CreateSlider(parent, text, min, max, default, callback)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1,0,0,40)
	frame.BackgroundColor3 = Color3.fromRGB(20,20,24)
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

	local label = Instance.new("TextLabel", frame)
	label.Text = text.." "..tostring(default)
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(200,200,205)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 16
	label.TextScaled = true

	local sliderFrame = Instance.new("Frame", frame)
	sliderFrame.Size = UDim2.new(1,-20,0,10)
	sliderFrame.Position = UDim2.new(0,10,0,25)
	sliderFrame.BackgroundColor3 = Color3.fromRGB(45,45,50)
	Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0,5)

	local bar = Instance.new("Frame", sliderFrame)
	bar.Size = UDim2.new((default-min)/(max-min),0,1,0)
	bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
	Instance.new("UICorner", bar).CornerRadius = UDim.new(0,5)

	local dragging = false
	sliderFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)
	sliderFrame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local relative = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X)/sliderFrame.AbsoluteSize.X,0,1)
			local value = min + (max-min)*relative
			bar.Size = UDim2.new(relative,0,1,0)
			label.Text = text.." "..math.floor(value*100)/100
			callback(value)
		end
	end)
end

local function CreateColorPicker(parent, text, defaultColor, callback)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1,0,0,40)
	frame.BackgroundColor3 = Color3.fromRGB(20,20,24)
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

	local label = Instance.new("TextLabel", frame)
	label.Text = " "..text
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(200,200,205)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 16
	label.TextScaled = true

	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0,30,0,30)
	btn.Position = UDim2.new(1,-35,0.5,-15)
	btn.BackgroundColor3 = defaultColor
	btn.Text = ""
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)

	btn.MouseButton1Click:Connect(function()
		-- Simple RGB cycle for demo
		local r,g,b = math.random(), math.random(), math.random()
		local newColor = Color3.fromRGB(r*255,g*255,b*255)
		btn.BackgroundColor3 = newColor
		callback(newColor)
	end)
end

--// CREATE CATEGORIES
local Combat = CreateCategory("Combat")
local Visuals = CreateCategory("Visuals")
local SettingsPanel = CreateCategory("Settings")

--// Forward declaration
local toggleCategory

--// ESP & Highlight
local function createESP(target, category, color, enabled)
	if not target then return end
	local root = target:IsA("Model") and (target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")) or (target:IsA("BasePart") and target)
	if not root or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

	local finalColor = color
	if category == "star" then
		if target.Name:lower():find("green") then finalColor = Color3.fromRGB(80,255,80)
		elseif target.Name:lower():find("yellow") then finalColor = Color3.fromRGB(255,230,50)
		else finalColor = Color3.fromRGB(255,255,255) end
	end

	local data = ActiveObjects[category][target] or {}

	-- Highlight for the object
	if not data.Highlight then
		local highlight = Instance.new("Highlight")
		highlight.FillColor = finalColor
		highlight.OutlineColor = Color3.new(1,1,1)
		highlight.FillTransparency = 0.6
		highlight.Enabled = enabled
		highlight.Parent = target
		data.Highlight = highlight
	else
		data.Highlight.Enabled = enabled
	end

	-- Beam (for star / normal objects)
	if category == "star" then
		if not data.Beam then
			local a0 = Instance.new("Attachment", player.Character.HumanoidRootPart)
			local a1 = Instance.new("Attachment", root)
			local beam = Instance.new("Beam")
			beam.Attachment0 = a0
			beam.Attachment1 = a1
			beam.Color = ColorSequence.new(finalColor)
			beam.Width0, beam.Width1 = 0.2, 0.2
			beam.Texture = "rbxassetid://4955566540"
			beam.FaceCamera = true
			beam.Enabled = enabled
			beam.Parent = root
			data.Beam = beam
			data.A0 = a0
			data.A1 = a1
		else
			data.Beam.Enabled = enabled
		end
	end

	-- Metal loot extra highlight
	if category == "metal" then
		-- Create a new part
		local newPart = Instance.new("Part")
		newPart.Size = Vector3.new(2, 2, 2) -- Adjust size as needed
		newPart.Position = (target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart") or root).Position
		newPart.Anchored = true
		newPart.CanCollide = false
		newPart.Transparency = 0.5
		newPart.Material = Enum.Material.Neon
		newPart.Color = finalColor
		newPart.Parent = target

		-- Add highlight to the new part
		local lootHighlight = Instance.new("Highlight")
		lootHighlight.FillColor = finalColor
		lootHighlight.OutlineColor = Color3.new(1, 1, 1)
		lootHighlight.FillColor = finalColor
		lootHighlight.FillTransparency = 0.2
		lootHighlight.OutlineTransparency = 0.2
		lootHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		lootHighlight.Enabled = enabled
		lootHighlight.Parent = newPart

		-- Save reference if needed
		data.MetalPartHighlight = lootHighlight
		data.Beacon = newPart
	end


	ActiveObjects[category][target] = data
end

--// Toggle Category
function toggleCategory(category, state)
	local tagName = category == "metal" and "hidden-metal" or category == "tree" and "tree-orb" or nil

	-- Scan existing objects if enabling
	if state and tagName then
		for _, obj in ipairs(CollectionService:GetTagged(tagName)) do
			if not ActiveObjects[category][obj] then
				local color = category == "metal" and Settings.METAL_ESP.COLOR
					or category == "tree" and Settings.TREE_ESP.COLOR
					or Settings.STAR_ESP.COLOR
				createESP(obj, category, color, state)
			end
		end
	end

	-- Enable/Disable existing ESPs
	if ActiveObjects[category] then
		for target, data in pairs(ActiveObjects[category]) do
			if data.Beam then data.Beam.Enabled = state end
			if data.Highlight then data.Highlight.Enabled = state end
			if data.MetalPartHighlight then data.MetalPartHighlight.Enabled = state end
			if data.Beacon
			then data.Beacon.Transparency = state and 0.5 or 1 end
		end
	end
end

--// CREATE UI CONTROLS
-- Visual Toggles
CreateToggle(Visuals,"Metal ESP",false,function(v) Settings.METAL_ESP.ENABLED = v toggleCategory("metal",v) end)
CreateToggle(Visuals,"Star ESP",false,function(v) Settings.STAR_ESP.ENABLED = v toggleCategory("star",v) end)
CreateToggle(Visuals,"Tree Orb ESP",false,function(v) Settings.TREE_ESP.ENABLED = v toggleCategory("tree",v) end)
CreateToggle(Combat,"Aim Assist (Q)",false,function(v) Settings.AIM_ASSIST.ENABLED = v end)

-- Settings Panel
CreateColorPicker(SettingsPanel,"UI Color",Settings.UI_COLOR,function(c)
	Settings.UI_COLOR = c
	MainContainer.BackgroundColor3 = c
end)
CreateSlider(SettingsPanel,"Aim Smoothness",0,1,Settings.AIM_ASSIST.SMOOTHNESS,function(v) Settings.AIM_ASSIST.SMOOTHNESS = v end)
CreateSlider(SettingsPanel,"Aim Max Distance",10,500,Settings.AIM_ASSIST.MAX_DISTANCE,function(v) Settings.AIM_ASSIST.MAX_DISTANCE = v end)
CreateSlider(SettingsPanel,"Aim Max Angle",10,180,Settings.AIM_ASSIST.MAX_ANGLE,function(v) Settings.AIM_ASSIST.MAX_ANGLE = v end)
CreateColorPicker(SettingsPanel,"Metal ESP Color",Settings.METAL_ESP.COLOR,function(c)
	Settings.METAL_ESP.COLOR = c
	toggleCategory("metal",false)
	toggleCategory("metal",Settings.METAL_ESP.ENABLED)
end)
CreateColorPicker(SettingsPanel,"Star ESP Color",Settings.STAR_ESP.COLOR,function(c)
	Settings.STAR_ESP.COLOR = c
	toggleCategory("star",false)
	toggleCategory("star",Settings.STAR_ESP.ENABLED)
end)
CreateColorPicker(SettingsPanel,"Tree ESP Color",Settings.TREE_ESP.COLOR,function(c)
	Settings.TREE_ESP.COLOR = c
	toggleCategory("tree",false)
	toggleCategory("tree",Settings.TREE_ESP.ENABLED)
end)

--// AIM ASSIST
local function getNearestPlayer()
	local closest, minDist = nil, Settings.AIM_ASSIST.MAX_DISTANCE
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
	local camPos = camera.CFrame.Position
	local lookDir = camera.CFrame.LookVector
	for _, p in ipairs(Players:GetPlayers()) do
		if p == player or (p.Team and p.Team==player.Team) then continue end
		if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = p.Character.HumanoidRootPart
			local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
			local dist = (hrp.Position - camPos).Magnitude
			local angle = math.deg(math.acos(lookDir:Dot((hrp.Position-camPos).Unit)))
			if humanoid and humanoid.Health>0 and dist<=Settings.AIM_ASSIST.MAX_DISTANCE and angle<=Settings.AIM_ASSIST.MAX_ANGLE then
				if dist<minDist then minDist = dist closest = p end
			end
		end
	end
	return closest
end

RunService.Heartbeat:Connect(function()
	if Settings.AIM_ASSIST.ENABLED then
		local target = getNearestPlayer()
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local newCFrame = CFrame.new(camera.CFrame.Position,target.Character.HumanoidRootPart.Position)
			camera.CFrame = camera.CFrame:Lerp(newCFrame,Settings.AIM_ASSIST.SMOOTHNESS)
		end
	end
end)

--// Input
UIS.InputBegan:Connect(function(input,gp)
	if gp then return end
	if input.KeyCode == Settings.KEY_UI_TOGGLE then
		Settings.VISIBLE = not Settings.VISIBLE
		blur.Enabled = Settings.VISIBLE
		MainContainer.Visible = Settings.VISIBLE
	elseif input.KeyCode == Settings.KEY_AIM_TOGGLE then
		Settings.AIM_ASSIST.ENABLED = not Settings.AIM_ASSIST.ENABLED
		-- Sync toggle button
		for _, child in pairs(Panels["Combat"]:GetChildren()) do
			if child:IsA("Frame") and child:FindFirstChild("TextLabel") and child.TextLabel.Text:find("Aim Assist") then
				local toggleBtn = child:FindFirstChildWhichIsA("TextButton")
				if toggleBtn then
					toggleBtn.BackgroundColor3 = Settings.AIM_ASSIST.ENABLED and Color3.fromRGB(0,170,255) or Color3.fromRGB(45,45,50)
					local dot = toggleBtn:FindFirstChildWhichIsA("Frame")
					if dot then
						dot:TweenPosition(Settings.AIM_ASSIST.ENABLED and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7),"Out","Quad",0.25,true)
					end
				end
			end
		end
	end
end)

--// DATA REFRESH
local function RefreshESP()
	for _, obj in ipairs(CollectionService:GetTagged("hidden-metal")) do
		createESP(obj,"metal",Settings.METAL_ESP.COLOR,Settings.METAL_ESP.ENABLED)
	end
	for _, obj in ipairs(CollectionService:GetTagged("tree-orb")) do
		createESP(obj,"tree",Settings.TREE_ESP.COLOR,Settings.TREE_ESP.ENABLED)
	end
	for _, child in ipairs(workspace:GetChildren()) do
		if child:IsA("Model") and (child.Name:find("Star") or child.Name:find("star")) then
			createESP(child,"star",Settings.STAR_ESP.COLOR,Settings.STAR_ESP.ENABLED)
		end
	end
end

CollectionService:GetInstanceAddedSignal("hidden-metal"):Connect(function(o)
	createESP(o,"metal",Settings.METAL_ESP.COLOR,Settings.METAL_ESP.ENABLED)
end)
CollectionService:GetInstanceAddedSignal("tree-orb"):Connect(function(o)
	createESP(o,"tree",Settings.TREE_ESP.COLOR,Settings.TREE_ESP.ENABLED)
end)
workspace.ChildAdded:Connect(function(child)
	if child:IsA("Model") and (child.Name:find("Star") or child.Name:find("star")) then
		task.wait(0.2)
		createESP(child,"star",Settings.STAR_ESP.COLOR,Settings.STAR_ESP.ENABLED)
	end
end)

player.CharacterAdded:Connect(function()
	task.wait(1)
	for cat,_ in pairs(ActiveObjects) do toggleCategory(cat,false) end
	RefreshESP()
end)

-- Startup
RefreshESP()
Buttons["Visuals"].BackgroundColor3 = Color3.fromRGB(0,120,255)
Panels["Visuals"].Visible = true
