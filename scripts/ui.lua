--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

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
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIAspectRatioConstraint", Main).AspectRatio = 1.667

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(45, 45, 50)
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

--// TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local SearchLabel = Instance.new("TextLabel")
SearchLabel.Text = "  SYSTEM DASHBOARD"
SearchLabel.Font = Enum.Font.GothamBold
SearchLabel.TextSize = 12
SearchLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
SearchLabel.BackgroundTransparency = 1
SearchLabel.TextXAlignment = Enum.TextXAlignment.Left
SearchLabel.Size = UDim2.new(1, 0, 1, 0)
SearchLabel.Parent = TopBar

--// SIDEBAR
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 170, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 6
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.ClipsDescendants = true
Sidebar.Parent = Main

local SideLine = Instance.new("Frame")
SideLine.Size = UDim2.new(0, 1, 1, 0)
SideLine.Position = UDim2.new(1, -1, 0, 0)
SideLine.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
SideLine.BorderSizePixel = 0
SideLine.Parent = Main  -- move it out of the ScrollingFrame


local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 10)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
SideLayout.VerticalAlignment = Enum.VerticalAlignment.Top
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar

local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop = UDim.new(0, 20)
SidePad.PaddingLeft = UDim.new(0, 15)
SidePad.Parent = Sidebar

--// CONTENT AREA
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -170, 1, -40)
Content.Position = UDim2.new(0, 170, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = Main

--// HELPERS
local Panels = {}
local Buttons = {}

local function PlayHoverSound()
    local sound = Instance.new("Sound", ScreenGui)
    sound.SoundId = "rbxassetid://6895079853"
    sound.Volume = 0.3
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

local function HidePanels()
	for name, p in pairs(Panels) do 
        p.Visible = false 
        local btn = Buttons[name]
        if btn then
            TweenService:Create(btn, TweenInfo.new(0.25), {
                BackgroundColor3 = Color3.fromRGB(22, 22, 26),
                TextColor3 = Color3.fromRGB(140, 140, 140)
            }):Play()
            TweenService:Create(btn.UIStroke, TweenInfo.new(0.25), {Color = Color3.fromRGB(45, 45, 50), Transparency = 0.5}):Play()
        end
    end
end

local function CreateSidebarButton(text, order)
	local btn = Instance.new("TextButton")
	btn.Name = text .. "Btn"
    btn.LayoutOrder = order
	btn.Size = UDim2.new(0, 140, 0, 38)
	btn.Text = text
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.TextColor3 = Color3.fromRGB(140, 140, 140)
	btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
	btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
	btn.Parent = Sidebar
	
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", btn)
    s.Color = Color3.fromRGB(45, 45, 50)
    s.Thickness = 1.5
    s.Transparency = 0.5

    btn.MouseEnter:Connect(function()
        PlayHoverSound()
        if not Panels[text].Visible then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
            TweenService:Create(s, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 170, 255), Transparency = 0.2}):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if not Panels[text].Visible then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 26)}):Play()
            TweenService:Create(s, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 50), Transparency = 0.5}):Play()
        end
    end)

    Buttons[text] = btn
	return btn
end

local function CreatePanel(name)
	local panel = Instance.new("Frame")
	panel.Name = name .. "Panel"
	panel.Size = UDim2.new(1, -40, 1, -40)
	panel.Position = UDim2.new(0, 20, 0, 20)
	panel.BackgroundTransparency = 1
	panel.Visible = false
	panel.Parent = Content

	local title = Instance.new("TextLabel")
	title.Text = name:upper()
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, 0, 0, 30)
    title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = panel

	Panels[name] = panel
	return panel
end

--// INITIALIZE SIDEBAR
local categories = { "Combat", "Visuals", "Interface", "Misc" }
for i, name in ipairs(categories) do
	local panel = CreatePanel(name)
	local btn = CreateSidebarButton(name, i)
    
	btn.MouseButton1Click:Connect(function()
		HidePanels()
		panel.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(btn.UIStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 255, 255), Transparency = 0}):Play()
	end)
end

--// METAL ESP BEAM TOGGLE
local BeamToggleFrame = Instance.new("Frame")
BeamToggleFrame.Size = UDim2.new(1, 0, 0, 50)
BeamToggleFrame.Position = UDim2.new(0, 0, 0, 110) -- below previous toggle (50 + 50 padding)
BeamToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
BeamToggleFrame.BorderSizePixel = 0
BeamToggleFrame.Parent = Panels.Visuals

Instance.new("UICorner", BeamToggleFrame).CornerRadius = UDim.new(0, 8)
local tsBeam = Instance.new("UIStroke", BeamToggleFrame)
tsBeam.Color = Color3.fromRGB(40, 40, 45)

local BeamToggleText = Instance.new("TextLabel")
BeamToggleText.Text = "Metal ESP Beam"
BeamToggleText.Font = Enum.Font.GothamMedium
BeamToggleText.TextSize = 13
BeamToggleText.TextColor3 = Color3.fromRGB(200, 200, 200)
BeamToggleText.BackgroundTransparency = 1
BeamToggleText.Position = UDim2.new(0, 15, 0, 0)
BeamToggleText.Size = UDim2.new(0.6, 0, 1, 0)
BeamToggleText.TextXAlignment = Enum.TextXAlignment.Left
BeamToggleText.Parent = BeamToggleFrame

local BeamToggleButton = Instance.new("TextButton")
BeamToggleButton.Size = UDim2.new(0, 40, 0, 20)
BeamToggleButton.Position = UDim2.new(1, -55, 0.5, -10)
BeamToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
BeamToggleButton.Text = ""
BeamToggleButton.Parent = BeamToggleFrame
Instance.new("UICorner", BeamToggleButton).CornerRadius = UDim.new(1, 0)

local BeamCircle = Instance.new("Frame", BeamToggleButton)
BeamCircle.Size = UDim2.new(0, 16, 0, 16)
BeamCircle.Position = UDim2.new(0, 2, 0.5, -8)
BeamCircle.BackgroundColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", BeamCircle).CornerRadius = UDim.new(1,0)

-- ui.lua (Inside the BeamToggleButton.MouseButton1Click connection)
local beamEnabled = false
BeamToggleButton.MouseButton1Click:Connect(function()
    beamEnabled = not beamEnabled
    
    -- Animation
    TweenService:Create(BeamToggleButton, TweenInfo.new(0.2), {
        BackgroundColor3 = beamEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 45)
    }):Play()
    BeamCircle:TweenPosition(beamEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.15, true)
    
    -- Logic Trigger: Passing "Metal" as the category and "TargetPart" as the instance name
    if beamEnabled then
        if _G.App.Visuals.EnableBeam then 
            _G.App.Visuals.EnableBeam("Metal", "TargetPart") 
        end
    else
        if _G.App.Visuals.DisableBeam then 
            _G.App.Visuals.DisableBeam("Metal") 
        end
    end
end)

-- Force Visuals active on start
Panels.Visuals.Visible = true
Buttons.Visuals.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Buttons.Visuals.TextColor3 = Color3.fromRGB(255, 255, 255)
Buttons.Visuals.UIStroke.Color = Color3.fromRGB(255, 255, 255)
Buttons.Visuals.UIStroke.Transparency = 0

--// INPUT TOGGLE
local Visible = true
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
		Visible = not Visible
        TweenService:Create(Main, TweenInfo.new(0.2), {GroupTransparency = Visible and 0 or 1}):Play()
        if Visible then Main.Visible = true else task.delay(0.2, function() if not Visible then Main.Visible = false end end) end
	end
end)
