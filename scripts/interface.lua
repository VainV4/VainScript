--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "VapeStyleUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// Main Toggle
local UI_ENABLED = true

--// Colors (Modified Vape Style)
local COLORS = {
	Background = Color3.fromRGB(20, 20, 20),
	Panel = Color3.fromRGB(25, 25, 25),
	Accent = Color3.fromRGB(0, 170, 150),
	Text = Color3.fromRGB(230, 230, 230),
	Muted = Color3.fromRGB(140, 140, 140)
}

--// Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.fromScale(0.55, 0.6)
main.Position = UDim2.fromScale(0.225, 0.2)
main.BackgroundColor3 = COLORS.Background
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

--// Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.fromScale(0.18, 1)
sidebar.BackgroundColor3 = COLORS.Panel
sidebar.BorderSizePixel = 0
sidebar.Parent = main

Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

--// Title
local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(1, 0.08)
title.Text = "Vape"
title.TextColor3 = COLORS.Accent
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = sidebar

--// Sidebar Layout
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = sidebar

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 8)
pad.Parent = sidebar

--// Content Holder
local contentHolder = Instance.new("Frame")
contentHolder.Size = UDim2.fromScale(0.82, 1)
contentHolder.Position = UDim2.fromScale(0.18, 0)
contentHolder.BackgroundTransparency = 1
contentHolder.Parent = main

--// Helpers
local panels = {}

local function hidePanels()
	for _, panel in pairs(panels) do
		panel.Visible = false
	end
end

local function createSidebarButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromScale(0.9, 0.065)
	btn.Text = text
	btn.TextColor3 = COLORS.Text
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	btn.BackgroundColor3 = COLORS.Background
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = COLORS.Accent
	end)

	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = COLORS.Background
	end)

	return btn
end

local function createPanel(name)
	local panel = Instance.new("Frame")
	panel.Size = UDim2.fromScale(0.95, 0.95)
	panel.Position = UDim2.fromScale(0.025, 0.025)
	panel.BackgroundColor3 = COLORS.Panel
	panel.BorderSizePixel = 0
	panel.Visible = false
	panel.Parent = contentHolder

	Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)

	local header = Instance.new("TextLabel")
	header.Size = UDim2.fromScale(1, 0.1)
	header.Text = name
	header.TextColor3 = COLORS.Text
	header.Font = Enum.Font.GothamBold
	header.TextScaled = true
	header.BackgroundTransparency = 1
	header.Parent = panel

	panels[name] = panel
	return panel
end

--// Categories
local categoryNames = {
	"Combat",
	"Support",
	"Interface",
	"Misc"
}

for _, name in ipairs(categoryNames) do
	local panel = createPanel(name)
	local button = createSidebarButton(name)
	button.Parent = sidebar

	button.MouseButton1Click:Connect(function()
		hidePanels()
		panel.Visible = true
	end)
end

--// Settings
local settingsPanel = createPanel("Settings")
local settingsBtn = createSidebarButton("⚙")
settingsBtn.Parent = sidebar

settingsBtn.MouseButton1Click:Connect(function()
	hidePanels()
	settingsPanel.Visible = true
end)

--// Default
panels.Combat.Visible = true

--// ALT Toggle
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
		UI_ENABLED = not UI_ENABLED
		main.Visible = UI_ENABLED
	end
end)
