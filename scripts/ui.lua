--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MainInterfaceUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

--// MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 650, 0, 400)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

--// SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

--// CONTENT
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -140, 1, 0)
Content.Position = UDim2.new(0, 140, 0, 0)
Content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Content.BorderSizePixel = 0
Content.Parent = MainFrame

--// SIDEBAR LAYOUT
local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Parent = Sidebar

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 8)
Padding.Parent = Sidebar

--// BUTTON CREATOR
local function CreateButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -12, 0, 36)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(235, 235, 235)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.BorderSizePixel = 0
	return btn
end

--// PANEL CREATOR
local Panels = {}

local function CreatePanel(name)
	local panel = Instance.new("Frame")
	panel.Size = UDim2.new(1, -20, 1, -20)
	panel.Position = UDim2.new(0, 10, 0, 10)
	panel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	panel.BorderSizePixel = 0
	panel.Visible = false
	panel.Parent = Content

	Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 6)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 40)
	label.Text = name
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 18
	label.BackgroundTransparency = 1
	label.Parent = panel

	Panels[name] = panel
	return panel
end

--// SETTINGS
local SettingsPanel = CreatePanel("Settings")
local SettingsButton = CreateButton("Settings")
SettingsButton.Parent = Sidebar

SettingsButton.MouseButton1Click:Connect(function()
	for _, panel in pairs(Panels) do
		panel.Visible = false
	end
	SettingsPanel.Visible = true
end)

--// CATEGORIES
local Categories = { "Combat", "Support", "Interface", "Misc" }

for _, name in ipairs(Categories) do
	local panel = CreatePanel(name)
	local button = CreateButton(name)
	button.Parent = Sidebar

	button.MouseButton1Click:Connect(function()
		for _, p in pairs(Panels) do
			p.Visible = false
		end
		panel.Visible = true
	end)
end

--// DEFAULT PANEL
Panels.Combat.Visible = true

--// ALT TOGGLE
local Visible = true
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
		Visible = not Visible
		MainFrame.Visible = Visible
	end
end)
