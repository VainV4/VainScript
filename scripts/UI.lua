-- ui.lua
-- Verantwortlich NUR für UI + Callbacks

local UI = _G.Vain.UI
local Config = _G.Vain.Config
local Visuals = _G.Vain.Visuals
local Combat = _G.Vain.Combat

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

--// GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VainDashboard_V4"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local blur = Instance.new("BlurEffect")
blur.Size = 20
blur.Enabled = true
blur.Parent = Lighting

local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Size = UDim2.new(0.7, 0, 0.7, 0)
MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
MainContainer.BackgroundColor3 = Config.Settings.UI_COLOR
MainContainer.ClipsDescendants = true
Instance.new("UICorner", MainContainer).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", MainContainer)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(45,45,50)

--// TOP BAR
local TopBar = Instance.new("Frame", MainContainer)
TopBar.Size = UDim2.new(1,0,0,40)
TopBar.BackgroundColor3 = Color3.fromRGB(8,8,10)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.Text = " VAIN SYSTEM DASHBOARD v4"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.fromRGB(200,200,205)

--// DRAGGING
do
	local dragging, dragStart, startPos
	TopBar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = i.Position
			startPos = MainContainer.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - dragStart
			MainContainer.Position =
				UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
						  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

--// SIDEBAR
local Sidebar = Instance.new("Frame", MainContainer)
Sidebar.Size = UDim2.new(0,170,1,-40)
Sidebar.Position = UDim2.new(0,0,0,40)
Sidebar.BackgroundColor3 = Color3.fromRGB(15,15,18)

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0,10)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0,20)

--// CONTENT
local Content = Instance.new("Frame", MainContainer)
Content.Size = UDim2.new(1,-170,1,-40)
Content.Position = UDim2.new(0,170,0,40)
Content.BackgroundTransparency = 1

--// INTERNAL TABLES
local Panels = {}
local Buttons = {}

--// CATEGORY
function UI.CreateCategory(name)
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.new(0,140,0,35)
	btn.Text = name:upper()
	btn.Font = Enum.Font.GothamMedium
	btn.TextColor3 = Color3.fromRGB(150,150,150)
	btn.BackgroundColor3 = Color3.fromRGB(22,22,26)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
	local s = Instance.new("UIStroke", btn)
	s.Color = Color3.fromRGB(45,45,50)

	local panel = Instance.new("Frame", Content)
	panel.Size = UDim2.new(1,-40,1,-40)
	panel.Position = UDim2.new(0,20,0,20)
	panel.Visible = false
	panel.BackgroundTransparency = 1

	local layout = Instance.new("UIListLayout", panel)
	layout.Padding = UDim.new(0,8)

	btn.MouseButton1Click:Connect(function()
		for _,p in pairs(Panels) do p.Visible = false end
		for _,b in pairs(Buttons) do
			b.BackgroundColor3 = Color3.fromRGB(22,22,26)
			b.UIStroke.Color = Color3.fromRGB(45,45,50)
		end
		panel.Visible = true
		btn.BackgroundColor3 = Color3.fromRGB(0,120,255)
		s.Color = Color3.fromRGB(255,255,255)
	end)

	Panels[name] = panel
	Buttons[name] = btn
	return panel
end

--// TOGGLE
function UI.CreateToggle(parent, text, default, callback)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1,0,0,40)
	frame.BackgroundColor3 = Color3.fromRGB(20,20,24)
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.Text = " "..text
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = Color3.fromRGB(200,200,205)

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
		TweenService:Create(btn,TweenInfo.new(0.25),{
			BackgroundColor3 = default and Color3.fromRGB(0,170,255) or Color3.fromRGB(45,45,50)
		}):Play()
		dot:TweenPosition(default and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7),
			"Out","Quad",0.2,true)
		callback(default)
	end)
end

--// CREATE PANELS
UI.CombatPanel = UI.CreateCategory("Combat")
UI.VisualsPanel = UI.CreateCategory("Visuals")
UI.SettingsPanel = UI.CreateCategory("Settings")

--// CONTROLS
UI.CreateToggle(UI.VisualsPanel,"Metal ESP",false,function(v)
	Config.Settings.METAL_ESP.ENABLED = v
	Visuals.Toggle("metal",v)
end)

UI.CreateToggle(UI.VisualsPanel,"Bee ESP",false,function(v)
	Config.Settings.BEE_ESP.ENABLED = v
	Visuals.Toggle("bee",v)
end)

UI.CreateToggle(UI.VisualsPanel,"Star ESP",false,function(v)
	Config.Settings.STAR_ESP.ENABLED = v
	Visuals.Toggle("star",v)
end)

UI.CreateToggle(UI.VisualsPanel,"Tree ESP",false,function(v)
	Config.Settings.TREE_ESP.ENABLED = v
	Visuals.Toggle("tree",v)
end)

UI.CreateToggle(UI.CombatPanel,"Aim Assist (Q)",false,function(v)
	Config.Settings.AIM_ASSIST.ENABLED = v
end)

-- DEFAULT
Buttons["Visuals"].BackgroundColor3 = Color3.fromRGB(0,120,255)
Panels["Visuals"].Visible = true

-- KEYBINDS
UIS.InputBegan:Connect(function(input,gp)
	if gp then return end
	if input.KeyCode == Config.Settings.KEY_UI_TOGGLE then
		Config.Settings.VISIBLE = not Config.Settings.VISIBLE
		MainContainer.Visible = Config.Settings.VISIBLE
		blur.Enabled = Config.Settings.VISIBLE
	end
end)
