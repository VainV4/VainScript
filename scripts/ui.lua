--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

--// CONFIG
local TARGET_INSTANCE_NAME = "TargetPart"

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScriptHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

--// MAIN FRAME
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 700, 0, 420)
Main.Position = UDim2.new(0.5, -350, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

--// TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

local SearchLabel = Instance.new("TextLabel")
SearchLabel.Text = "Search for scripts"
SearchLabel.Font = Enum.Font.Gotham
SearchLabel.TextSize = 14
SearchLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
SearchLabel.BackgroundTransparency = 1
SearchLabel.Position = UDim2.new(0, 16, 0, 14)
SearchLabel.Parent = TopBar

--// SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

--// CONTENT
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -150, 1, -50)
Content.Position = UDim2.new(0, 150, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = Main

--// SIDEBAR LAYOUT
local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 6)
SideLayout.Parent = Sidebar

local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop = UDim.new(0, 10)
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
	btn.Size = UDim2.new(1, -12, 0, 36)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(220, 220, 220)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	btn.BorderSizePixel = 0
	btn.Parent = Sidebar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

local function CreatePanel(name)
	local panel = Instance.new("Frame")
	panel.Size = UDim2.new(1, -20, 1, -20)
	panel.Position = UDim2.new(0, 10, 0, 10)
	panel.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
	panel.BorderSizePixel = 0
	panel.Visible = false
	panel.Parent = Content
	Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

	local title = Instance.new("TextLabel")
	title.Text = name
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 16, 0, 12)
	title.Parent = panel

	Panels[name] = panel
	return panel
end

--// PANELS
local CombatPanel = CreatePanel("Combat")
local SupportPanel = CreatePanel("Support")
local InterfacePanel = CreatePanel("Interface")
local MiscPanel = CreatePanel("Misc")

--// SIDEBAR BUTTONS
for _, name in ipairs({ "Combat", "Support", "Interface", "Misc" }) do
	local btn = CreateSidebarButton(name)
	btn.MouseButton1Click:Connect(function()
		HidePanels()
		Panels[name].Visible = true
	end)
end

Panels.Support.Visible = true

--// SUPPORT → BEAM TOGGLE
local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = UDim2.new(1, -32, 0, 60)
ToggleFrame.Position = UDim2.new(0, 16, 0, 60)
ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
ToggleFrame.BorderSizePixel = 0
ToggleFrame.Parent = SupportPanel
Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 10)

local ToggleText = Instance.new("TextLabel")
ToggleText.Text = "Link Beam"
ToggleText.Font = Enum.Font.GothamBold
ToggleText.TextSize = 15
ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleText.BackgroundTransparency = 1
ToggleText.Position = UDim2.new(0, 12, 0, 18)
ToggleText.Parent = ToggleFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 24)
ToggleButton.Position = UDim2.new(1, -62, 0, 18)
ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = ""
ToggleButton.Parent = ToggleFrame
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

local enabled = false

ToggleButton.MouseButton1Click:Connect(function()
	enabled = not enabled
	ToggleButton.BackgroundColor3 = enabled
		and Color3.fromRGB(0, 170, 255)
		or Color3.fromRGB(80, 80, 80)

	if enabled then
		_G.App.Support.EnableBeam()
	else
		_G.App.Support.DisableBeam()
	end
end)


--// ALT TOGGLE
local Visible = true
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
		Visible = not Visible
		Main.Visible = Visible
	end
end)
