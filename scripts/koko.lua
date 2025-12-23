-- UI SETUP --

-- Instances:

local Converted = {
	["_VainUI"] = Instance.new("ScreenGui");
	["_Main"] = Instance.new("Frame");
	["_ModuleList"] = Instance.new("Frame");
	["_Container"] = Instance.new("Frame");
	["_UIListLayout"] = Instance.new("UIListLayout");
	["_Visuals"] = Instance.new("Frame");
	["_UICorner"] = Instance.new("UICorner");
	["_VisualsButton"] = Instance.new("TextButton");
	["_UICorner1"] = Instance.new("UICorner");
	["_Modules"] = Instance.new("Folder");
	["_Visuals1"] = Instance.new("Frame");
	["_Main1"] = Instance.new("ScrollingFrame");
	["_UIListLayout1"] = Instance.new("UIListLayout");
	["_MetalESP"] = Instance.new("Frame");
	["_UICorner2"] = Instance.new("UICorner");
	["_Toggle"] = Instance.new("TextButton");
	["_UICorner3"] = Instance.new("UICorner");
	["_Settings"] = Instance.new("Frame");
	["_ToggleModuleSettings"] = Instance.new("ImageButton");
	["_StarESP"] = Instance.new("Frame");
	["_UICorner4"] = Instance.new("UICorner");
	["_Toggle1"] = Instance.new("TextButton");
	["_UICorner5"] = Instance.new("UICorner");
	["_AimAssist"] = Instance.new("Frame");
	["_UICorner6"] = Instance.new("UICorner");
	["_Toggle2"] = Instance.new("TextButton");
	["_UICorner7"] = Instance.new("UICorner");
	["_UICorner8"] = Instance.new("UICorner");
	["_Header"] = Instance.new("Frame");
	["_UICorner9"] = Instance.new("UICorner");
	["_nn"] = Instance.new("TextLabel");
	["_UIListLayout2"] = Instance.new("UIListLayout");
	["_name"] = Instance.new("TextLabel");
}

-- Properties:

Converted["_VainUI"].DisplayOrder = 999999999
Converted["_VainUI"].ResetOnSpawn = false
Converted["_VainUI"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Converted["_VainUI"].Name = "VainUI"
Converted["_VainUI"].Parent = game:GetService("CoreGui")

Converted["_Main"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Main"].BackgroundTransparency = 1
Converted["_Main"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Main"].BorderSizePixel = 0
Converted["_Main"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Main"].Name = "Main"
Converted["_Main"].Parent = Converted["_VainUI"]

Converted["_ModuleList"].BackgroundColor3 = Color3.fromRGB(10.000000353902578, 10.000000353902578, 10.000000353902578)
Converted["_ModuleList"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ModuleList"].BorderSizePixel = 0
Converted["_ModuleList"].Size = UDim2.new(0.0850000009, 0, 1, 0)
Converted["_ModuleList"].Name = "ModuleList"
Converted["_ModuleList"].Parent = Converted["_Main"]

Converted["_Container"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Container"].BackgroundTransparency = 1
Converted["_Container"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Container"].BorderSizePixel = 0
Converted["_Container"].Position = UDim2.new(0.0515163019, 0, 0.00970873795, 0)
Converted["_Container"].Size = UDim2.new(0.879795372, 0, 0.978964388, 0)
Converted["_Container"].Name = "Container"
Converted["_Container"].Parent = Converted["_ModuleList"]

Converted["_UIListLayout"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout"].Parent = Converted["_Container"]

Converted["_Visuals"].BackgroundColor3 = Color3.fromRGB(20.000000707805157, 20.000000707805157, 20.000000707805157)
Converted["_Visuals"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Visuals"].BorderSizePixel = 0
Converted["_Visuals"].Position = UDim2.new(0.463991284, 0, 0.0177993532, 0)
Converted["_Visuals"].Size = UDim2.new(1, 0, 0.0500000007, 0)
Converted["_Visuals"].Name = "Visuals"
Converted["_Visuals"].Parent = Converted["_Container"]

Converted["_UICorner"].Parent = Converted["_Visuals"]

Converted["_VisualsButton"].Font = Enum.Font.Arial
Converted["_VisualsButton"].Text = "VISUALS"
Converted["_VisualsButton"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_VisualsButton"].TextSize = 14
Converted["_VisualsButton"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_VisualsButton"].BackgroundTransparency = 1
Converted["_VisualsButton"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_VisualsButton"].BorderSizePixel = 0
Converted["_VisualsButton"].Size = UDim2.new(1, 0, 1, 0)
Converted["_VisualsButton"].Name = "VisualsButton"
Converted["_VisualsButton"].Parent = Converted["_Visuals"]

Converted["_UICorner1"].Parent = Converted["_ModuleList"]

Converted["_Modules"].Name = "Modules"
Converted["_Modules"].Parent = Converted["_Main"]

Converted["_Visuals1"].BackgroundColor3 = Color3.fromRGB(20.000000707805157, 20.000000707805157, 20.000000707805157)
Converted["_Visuals1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Visuals1"].BorderSizePixel = 0
Converted["_Visuals1"].Position = UDim2.new(0.129449829, 0, 0.0420711972, 0)
Converted["_Visuals1"].Size = UDim2.new(0.100000001, 0, 0.916000009, 0)
Converted["_Visuals1"].Name = "Visuals"
Converted["_Visuals1"].Parent = Converted["_Modules"]

Converted["_Main1"].AutomaticCanvasSize = Enum.AutomaticSize.Y
Converted["_Main1"].CanvasSize = UDim2.new(0, 0, 0, 0)
Converted["_Main1"].ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Main1"].ScrollBarImageTransparency = 1
Converted["_Main1"].Active = true
Converted["_Main1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Main1"].BackgroundTransparency = 1
Converted["_Main1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Main1"].BorderSizePixel = 0
Converted["_Main1"].Position = UDim2.new(0.0588234961, 0, 0.0847951397, 0)
Converted["_Main1"].Size = UDim2.new(0.87843138, 0, 0.894003451, 0)
Converted["_Main1"].Name = "Main"
Converted["_Main1"].Parent = Converted["_Visuals1"]

Converted["_UIListLayout1"].Padding = UDim.new(0, 5)
Converted["_UIListLayout1"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout1"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout1"].Parent = Converted["_Main1"]

Converted["_MetalESP"].AutomaticSize = Enum.AutomaticSize.Y
Converted["_MetalESP"].BackgroundColor3 = Color3.fromRGB(20.000000707805157, 20.000000707805157, 20.000000707805157)
Converted["_MetalESP"].BackgroundTransparency = 1
Converted["_MetalESP"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_MetalESP"].BorderSizePixel = 0
Converted["_MetalESP"].LayoutOrder = 1
Converted["_MetalESP"].Size = UDim2.new(0.899999976, 0, 0.0399999991, 0)
Converted["_MetalESP"].Name = "MetalESP"
Converted["_MetalESP"].Parent = Converted["_Main1"]

Converted["_UICorner2"].Parent = Converted["_MetalESP"]

Converted["_Toggle"].Font = Enum.Font.Arial
Converted["_Toggle"].Text = "Metal ESP"
Converted["_Toggle"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Toggle"].TextSize = 14
Converted["_Toggle"].BackgroundColor3 = Color3.fromRGB(20.000000707805157, 20.000000707805157, 20.000000707805157)
Converted["_Toggle"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Toggle"].BorderSizePixel = 0
Converted["_Toggle"].Size = UDim2.new(0.800000012, 0, 1, 0)
Converted["_Toggle"].Name = "Toggle"
Converted["_Toggle"].Parent = Converted["_MetalESP"]

Converted["_UICorner3"].Parent = Converted["_Toggle"]

Converted["_Settings"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Settings"].BackgroundTransparency = 0.5
Converted["_Settings"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Settings"].BorderSizePixel = 0
Converted["_Settings"].Position = UDim2.new(0, 0, 1, 0)
Converted["_Settings"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Settings"].Visible = false
Converted["_Settings"].Name = "Settings"
Converted["_Settings"].Parent = Converted["_MetalESP"]

Converted["_ToggleModuleSettings"].Image = "http://www.roblox.com/asset/?id=138007024966757"
--Converted["_ToggleModuleSettings"].ImageContent = Content
Converted["_ToggleModuleSettings"].ScaleType = Enum.ScaleType.Fit
Converted["_ToggleModuleSettings"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ToggleModuleSettings"].BackgroundTransparency = 1
Converted["_ToggleModuleSettings"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ToggleModuleSettings"].BorderSizePixel = 0
Converted["_ToggleModuleSettings"].Position = UDim2.new(0.800000012, 0, 0, 0)
Converted["_ToggleModuleSettings"].Size = UDim2.new(0.200000003, 0, 1, 0)
Converted["_ToggleModuleSettings"].Name = "ToggleModuleSettings"
Converted["_ToggleModuleSettings"].Parent = Converted["_MetalESP"]

Converted["_StarESP"].BackgroundColor3 = Color3.fromRGB(20.000000707805157, 20.000000707805157, 20.000000707805157)
Converted["_StarESP"].BackgroundTransparency = 1
Converted["_StarESP"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_StarESP"].BorderSizePixel = 0
Converted["_StarESP"].LayoutOrder = 3
Converted["_StarESP"].Size = UDim2.new(0.899999976, 0, 0.0399999991, 0)
Converted["_StarESP"].Name = "StarESP"
Converted["_StarESP"].Parent = Converted["_Main1"]

Converted["_UICorner4"].Parent = Converted["_StarESP"]

Converted["_Toggle1"].Font = Enum.Font.Arial
Converted["_Toggle1"].Text = "Star ESP"
Converted["_Toggle1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Toggle1"].TextSize = 14
Converted["_Toggle1"].BackgroundColor3 = Color3.fromRGB(20.000000707805157, 20.000000707805157, 20.000000707805157)
Converted["_Toggle1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Toggle1"].BorderSizePixel = 0
Converted["_Toggle1"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Toggle1"].Name = "Toggle"
Converted["_Toggle1"].Parent = Converted["_StarESP"]

Converted["_UICorner5"].Parent = Converted["_Toggle1"]

Converted["_AimAssist"].BackgroundColor3 = Color3.fromRGB(20.000000707805157, 20.000000707805157, 20.000000707805157)
Converted["_AimAssist"].BackgroundTransparency = 1
Converted["_AimAssist"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_AimAssist"].BorderSizePixel = 0
Converted["_AimAssist"].LayoutOrder = 3
Converted["_AimAssist"].Size = UDim2.new(0.899999976, 0, 0.0399999991, 0)
Converted["_AimAssist"].Name = "AimAssist"
Converted["_AimAssist"].Parent = Converted["_Main1"]

Converted["_UICorner6"].Parent = Converted["_AimAssist"]

Converted["_Toggle2"].Font = Enum.Font.Arial
Converted["_Toggle2"].Text = "AimAssist"
Converted["_Toggle2"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Toggle2"].TextSize = 14
Converted["_Toggle2"].BackgroundColor3 = Color3.fromRGB(20.000000707805157, 20.000000707805157, 20.000000707805157)
Converted["_Toggle2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Toggle2"].BorderSizePixel = 0
Converted["_Toggle2"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Toggle2"].Name = "Toggle"
Converted["_Toggle2"].Parent = Converted["_AimAssist"]

Converted["_UICorner7"].Parent = Converted["_Toggle2"]

Converted["_UICorner8"].Parent = Converted["_Visuals1"]

Converted["_Header"].BackgroundColor3 = Color3.fromRGB(10.000000353902578, 10.000000353902578, 10.000000353902578)
Converted["_Header"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Header"].BorderSizePixel = 0
Converted["_Header"].Size = UDim2.new(1.00000012, 0, 0.0584502965, 0)
Converted["_Header"].Name = "Header"
Converted["_Header"].Parent = Converted["_Visuals1"]

Converted["_UICorner9"].Parent = Converted["_Header"]

Converted["_nn"].Font = Enum.Font.SourceSans
Converted["_nn"].Text = ""
Converted["_nn"].TextColor3 = Color3.fromRGB(0, 0, 0)
Converted["_nn"].TextSize = 14
Converted["_nn"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_nn"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_nn"].BorderSizePixel = 0
Converted["_nn"].LayoutOrder = 3
Converted["_nn"].Size = UDim2.new(1, 0, 0.100000001, 0)
Converted["_nn"].Name = "nn"
Converted["_nn"].Parent = Converted["_Header"]

Converted["_UIListLayout2"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout2"].Parent = Converted["_Header"]

Converted["_name"].Font = Enum.Font.SourceSans
Converted["_name"].Text = "VISUALS"
Converted["_name"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_name"].TextSize = 14
Converted["_name"].BackgroundColor3 = Color3.fromRGB(20.000000707805157, 20.000000707805157, 20.000000707805157)
Converted["_name"].BackgroundTransparency = 1
Converted["_name"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_name"].BorderSizePixel = 0
Converted["_name"].LayoutOrder = 1
Converted["_name"].Size = UDim2.new(1, 0, 0.899999976, 0)
Converted["_name"].Name = "name"
Converted["_name"].Parent = Converted["_Header"]





-- VARIABLES --

local CollectionService = game:GetService("CollectionService")
local TeamService = game:GetService("Teams")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Workspace = game.Workspace
local RunService = game:GetService("RunService")

-- UI VARIABLES --

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui") or player:FindFirstChild("PlayerGui")
local MainGUI = Converted["_VainUI"]
MainGUI.Enabled = false

local Main = MainGUI:WaitForChild("Main")

local Modules = Main:WaitForChild("Modules")

local ModuleVisuals = Modules:WaitForChild("Visuals")

local MetalESPFrame = ModuleVisuals:WaitForChild("Main"):WaitForChild("MetalESP")
local MetalESPToggleButton = MetalESPFrame:WaitForChild("Toggle")
local ToggleMetalESPModuleSettingsButton = MetalESPFrame:WaitForChild("ToggleModuleSettings")

local StarESPFrame = ModuleVisuals:WaitForChild("Main"):WaitForChild("StarESP")
local StarESPToggleButton = StarESPFrame:WaitForChild("Toggle")

local AimAssistFrame =  ModuleVisuals:WaitForChild("Main"):WaitForChild("AimAssist")
local AimAssistToggleButton = AimAssistFrame:WaitForChild("Toggle")

local ModuleList = Main:WaitForChild("ModuleList")
local Container = ModuleList:WaitForChild("Container")
local ModuleListVisuals = Container:WaitForChild("Visuals")
local VisualsButton = ModuleListVisuals:WaitForChild("VisualsButton")

local blur = Instance.new("BlurEffect", Lighting)
blur.Enabled = false

-- SETTINGS --

Settings = {

	METAL_ESP = {
		ENABLED = false,
		COLOR = Color3.fromRGB(255,0,0)
	},

	STAR_ESP = {
		ENABLED = false,
	},

	keybinds = {

	},
	
	AIM_ASSIST = {
		ENABLED = false,
	},

}

Beams = {}

-- FUNCTIONS --



local function getAllPlayers()
	return Players:GetPlayers()
end

local function getNearestPlayer()
	local closestPlayer = nil
	local minDistance = 1
	local closestDistance = 35
	local playerLookDirection
	if player and player.Character then
		playerLookDirection = player.Character.HumanoidRootPart.CFrame.LookVector 
	end

	for _, currentPlayer in pairs(game.Players:GetPlayers()) do
		if currentPlayer == player or currentPlayer.Team == player.Team then continue end
		if currentPlayer.Character and currentPlayer.Character:FindFirstChild("HumanoidRootPart") then
			if currentPlayer.Character:FindFirstChild("Humanoid").Health > 0 then
				local distance = (currentPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
				local toPlayerDirection = (currentPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).unit

				local angle = math.acos(playerLookDirection:Dot(toPlayerDirection))

				angle = math.deg(angle)

				if distance < closestDistance and distance > minDistance and angle <= 80 then
					closestDistance = distance
					closestPlayer = currentPlayer
				end
			end
		end
	end
	
	return closestPlayer
end


-- OUTDATED

--[[RunService.Heartbeat:Connect(function()
	if Settings.AIM_ASSIST.ENABLED then
		local nearestPlayer = getNearestPlayer()
		if nearestPlayer then
			local targetPosition = nearestPlayer.Character.HumanoidRootPart.Position
			local camera = workspace.CurrentCamera
			camera.CFrame = CFrame.new(camera.CFrame.Position, targetPosition)
			--local character = player.Character-- The player's character

		end
	end
end)--]]

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local camera = workspace.CurrentCamera
local smoothFactor = 0.1

RunService.Heartbeat:Connect(function()
	if Settings.AIM_ASSIST.ENABLED then
		local nearestPlayer = getNearestPlayer()
		if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local targetPosition = nearestPlayer.Character.HumanoidRootPart.Position

			-- Smoothly transition to the target
			local newCFrame = CFrame.new(camera.CFrame.Position, targetPosition)
			camera.CFrame = camera.CFrame:Lerp(newCFrame, smoothFactor) 
		end
	end
end)



local function toggleMetalESP()
	if Settings.METAL_ESP.ENABLED then
		Settings.METAL_ESP.ENABLED = false
	else
		Settings.METAL_ESP.ENABLED = true
	end
end

local function toggleStarESP()
	if Settings.STAR_ESP.ENABLED then
		Settings.STAR_ESP.ENABLED = false
	else
		Settings.STAR_ESP.ENABLED = true
	end
end


local function toggleBeamType(beamType, visibility)
	if Beams[beamType] then
		for i, v in ipairs(Beams[beamType]) do
			print(i)
			v.Enabled = visibility
		end
	end
end

-- create beam

local function createBeam(target, highlight, beamType, color, visibility)

	if not (target.PrimaryPart and player.Character and player.Character.PrimaryPart) then
		return
	end

	local attachmentLoot = Instance.new("Attachment")
	attachmentLoot.Parent = target.PrimaryPart

	local attachmentPlayer = Instance.new("Attachment")
	attachmentPlayer.Parent = player.Character.PrimaryPart

	-- 
	local beam = Instance.new("Beam", target)
	beam.Attachment1 = attachmentLoot
	beam.Attachment0 = attachmentPlayer
	beam.Parent = target.PrimaryPart

	if visibility ~= nil then
		beam.Enabled = visibility
	end

	if color ~= nil then 
		beam.Color = ColorSequence.new(color)
	else
		beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
	end

	beam.Texture = "http://www.roblox.com/asset/?id=4955566540"
	beam.TextureMode = "Static"
	beam.Width0 = 0.2
	beam.Width1 = 0.2
	beam.Segments = 1
	beam.FaceCamera = true

	if Beams[beamType] then
		table.insert(Beams[beamType], beam)
	else
		Beams[beamType] = {}
		table.insert(Beams[beamType], beam)
	end


	if highlight and (not target:FindFirstChild("highlightPart")) then
		
		local part = Instance.new("Part", target)
		
		for i, v in pairs(part:GetChildren()) do
			if v:IsA("Part") or v:IsA("Mesh") then
				v.Transparency = 1
			end
		end
		part.Name = "highlightPart"
		part.Transparency = 0
		part.CanCollide = false
		part.Anchored = true
		
		if part:IsA("Modell") then
			part.PrimaryPart.Position = target.PrimaryPart.Position
		else
			part.Position = target.PrimaryPart.Position
		end
		
		local highlight = Instance.new("Highlight", part)
		highlight.Enabled = true
		highlight.FillTransparency = 0
		highlight.OutlineColor = Color3.fromRGB(255,0,0)
		highlight.FillColor = Color3.fromRGB(255,0,0)
		
	end
end


-- METAL ESP

CollectionService:GetInstanceAddedSignal("hidden-metal"):Connect(function(loot)
	createBeam(loot, true, "metal-loot", Settings.METAL_ESP.COLOR, Settings.METAL_ESP.ENABLED)
end)


local function GetMetalLoot()
	for _, loot in ipairs(CollectionService:GetTagged("hidden-metal")) do
		task.wait(.5)
		createBeam(loot, true, "metal-loot", Settings.METAL_ESP.COLOR, Settings.METAL_ESP.ENABLED)
	end
end

local function TweenUI(element, length, color)

	local goal = {}
	goal.BackgroundColor3 = color

	local tweenInfo = TweenInfo.new(length, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)

	local tween = TweenService:Create(element, tweenInfo, goal)
	tween:Play()
end

-- Module Toggle Functions

game.Workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") and child.Name:find("Star") then
        task.wait(0.1) -- Wait to ensure it's loaded
        createBeam(child, false, "star", nil, Settings.STAR_ESP)
    end
end)

local function toggleAimAssist()
	if Settings.AIM_ASSIST.ENABLED then
		Settings.AIM_ASSIST.ENABLED = false
		TweenUI(AimAssistToggleButton, .05, Color3.fromRGB(0, 255, 0))
	else
		Settings.AIM_ASSIST.ENABLED = true
		TweenUI(AimAssistToggleButton, .05, Color3.fromRGB(20, 20, 20))
	end
end

local function OnMetalESPToggleButtonClick()
	toggleMetalESP()
	if Settings.METAL_ESP.ENABLED == true then
		toggleBeamType("metal-loot", true)
		TweenUI(MetalESPToggleButton, .05, Color3.fromRGB(0, 255, 0))
	else
		toggleBeamType("metal-loot", false)
		TweenUI(MetalESPToggleButton, .05, Color3.fromRGB(20, 20, 20))
	end
end

local function OnStarESPToggleButtonClick()
	toggleStarESP()

	if Settings.STAR_ESP.ENABLED == true then
		toggleBeamType("star", true)
		TweenUI(StarESPToggleButton, .05, Color3.fromRGB(0, 255, 0))
	else
		toggleBeamType("star", false)
		TweenUI(StarESPToggleButton, .05, Color3.fromRGB(20, 20, 20))
	end
end

local function OnAimAssistToggleButtonClick()
	toggleAimAssist()
end



local function OnModuleButtonPressed(button)
	
	local Settings = button.Parent:FindFirstChild("Settings") or button.Parent:WaitForChild("Settings")
	if Settings.Visible == true then
		Settings.Visible = false
	else
		Settings.Visible = true
	end
	
end

local function InitializeAllModuleSettingsButtons()	
	for i, button in pairs(MetalESPFrame:GetChildren()) do
		if button.Name == "ToggleModuleSettings" then
			button.MouseButton1Click:Connect(function()
				print("Pressed!")
				OnModuleButtonPressed(button)
			end)
		end
	end
end



UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		if MainGUI.Enabled == false then
			MainGUI.Enabled = true
			blur.Enabled = true
		else
			MainGUI.Enabled = false
			blur.Enabled = false
		end
	end
	if input.KeyCode == Enum.KeyCode.Q  then
		toggleAimAssist()
	end
end)

player.CharacterAdded:Connect(function()
	task.wait(1)
	GetMetalLoot()	
end)

InitializeAllModuleSettingsButtons()
GetMetalLoot()


AimAssistToggleButton.MouseButton1Click:Connect(OnAimAssistToggleButtonClick)
MetalESPToggleButton.MouseButton1Click:Connect(OnMetalESPToggleButtonClick)
StarESPToggleButton.MouseButton1Click:Connect(OnStarESPToggleButtonClick)
