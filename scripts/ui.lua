--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

--// CONFIG
local TARGET_INSTANCE_NAME = "TargetPart"

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScriptHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

--// MAIN FRAME
local Main = Instance.new("CanvasGroup") 
Main.Size = UDim2.new(0.5, 0, 0.55, 0) 
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 10)

local Aspect = Instance.new("UIAspectRatioConstraint", Main)
Aspect.AspectRatio = 1.667

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(45, 45, 50)
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

--// TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0, 10)

local SearchLabel = Instance.new("TextLabel")
SearchLabel.Name = "SearchLabel"
SearchLabel.Text = "SYSTEM DASHBOARD"
SearchLabel.Font = Enum.Font.GothamBold
SearchLabel.TextSize = 14
SearchLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchLabel.BackgroundTransparency = 1
SearchLabel.TextXAlignment = Enum.TextXAlignment.Left
SearchLabel.Position = UDim2.new(0, 15, 0, 0)
SearchLabel.Size = UDim2.new(1, -15, 1, 0)
SearchLabel.Parent = TopBar

--// SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SideLine = Instance.new("Frame", Sidebar)
SideLine.Size = UDim2.new(0, 1, 1, 0)
SideLine.Position = UDim2.new(1, 0, 0, 0)
SideLine.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
SideLine.BorderSizePixel = 0

--// CONTENT
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -160, 1, -45)
Content.Position = UDim2.new(0, 160, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = Main

--// SIDEBAR LAYOUT
local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 8)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.Parent = Sidebar

local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop = UDim.new(0, 12)
SidePad.Parent = Sidebar

--// HELPERS
local Panels = {}

local function HidePanels()
	for _, p in pairs(Panels) do
		p.Visible = false
	end
end

local function CreateSidebarButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Text = text
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 13
	btn.TextColor3 = Color3.fromRGB(180, 180, 180)
	btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
	btn.AutoButtonColor = true
	btn.BorderSizePixel = 0
	btn.Parent = Sidebar
	
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(40,40,45)
    
	return btn
end

local function CreatePanel(name)
	local panel = Instance.new("Frame")
	panel.Size = UDim2.new(1, -30, 1, -30)
	panel.Position = UDim2.new(0, 15, 0, 15)
	panel.BackgroundTransparency = 1
	panel.Visible = false
	panel.Parent = Content

	local title = Instance.new("TextLabel")
	title.Text = name:upper()
	title.Font = Enum.Font.GothamBold
	title.TextSize = 20
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 0, 0, 0)
	title.Size = UDim2.new(1, 0, 0, 30)
    title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = panel

	Panels[name] = panel
	return panel
end

--// PANELS (Renamed Support to Visuals)
local CombatPanel = CreatePanel("Combat")
local VisualsPanel = CreatePanel("Visuals")
local InterfacePanel = CreatePanel("Interface")
local MiscPanel = CreatePanel("Misc")

--// SIDEBAR BUTTONS
for _, name in ipairs({ "Combat", "Visuals", "Interface", "Misc" }) do
	local btn = CreateSidebarButton(name)
	btn.MouseButton1Click:Connect(function()
		HidePanels()
		Panels[name].Visible = true
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(180,180,180) end
        end
        btn.TextColor3 = Color3.fromRGB(0, 170, 255)
	end)
end

-- Default View
Panels.Visuals.Visible = true

--// VISUALS → BEAM TOGGLE
local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
ToggleFrame.Position = UDim2.new(0, 0, 0, 50)
ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ToggleFrame.BorderSizePixel = 0
ToggleFrame.Parent = VisualsPanel

local TFStroke = Instance.new("UIStroke", ToggleFrame)
TFStroke.Color = Color3.fromRGB(45, 45, 50)
Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)

local ToggleText = Instance.new("TextLabel")
ToggleText.Text = "Link Beam"
ToggleText.Font = Enum.Font.GothamMedium
ToggleText.TextSize = 14
ToggleText.TextColor3 = Color3.fromRGB(220, 220, 220)
ToggleText.BackgroundTransparency = 1
ToggleText.Position = UDim2.new(0, 15, 0, 0)
ToggleText.Size = UDim2.new(0.5, 0, 1, 0)
ToggleText.TextXAlignment = Enum.TextXAlignment.Left
ToggleText.Parent = ToggleFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 44, 0, 22)
ToggleButton.Position = UDim2.new(1, -59, 0.5, -11)
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = ""
ToggleButton.Parent = ToggleFrame
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

local Circle = Instance.new("Frame", ToggleButton)
Circle.Size = UDim2.new(0, 18, 0, 18)
Circle.Position = UDim2.new(0, 2, 0.5, -9)
Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)

local enabled = false

ToggleButton.MouseButton1Click:Connect(function()
	enabled = not enabled
    ToggleButton.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 50)
    Circle:TweenPosition(enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9), "Out", "Quad", 0.15, true)

	-- Still calls the same back-end functions to avoid breaking your logic
	if enabled then
		if _G.App and _G.App.Support then _G.App.Support.EnableBeam() end
	else
		if _G.App and _G.App.Support then _G.App.Support.DisableBeam() end
	end
end)

--// TOGGLE LOGIC (Alt & RightShift)
local Visible = true
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
    
    local keys = {
        [Enum.KeyCode.LeftAlt] = true,
        [Enum.KeyCode.RightAlt] = true,
        [Enum.KeyCode.RightShift] = true
    }

	if keys[input.KeyCode] then
		Visible = not Visible
        
        local targetOpacity = Visible and 1 or 0
        TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {GroupTransparency = 1 - targetOpacity}):Play()
        
        if not Visible then
            task.delay(0.2, function() if not Visible then Main.Visible = false end end)
        else
            Main.Visible = true
        end
	end
end)
