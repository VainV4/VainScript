-- ui.lua (Fully updated)
--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

--// SETTINGS
local Settings = _G.Vain.Config.Settings

--// SCREEN GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "VainDashboard_V4"
ScreenGui.ResetOnSpawn = false

--// MAIN CONTAINER
local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Size = UDim2.new(0.7,0,0.7,0)
MainContainer.Position = UDim2.new(0.5,0,0.5,0)
MainContainer.AnchorPoint = Vector2.new(0.5,0.5)
MainContainer.BackgroundColor3 = Settings.UI_COLOR
Instance.new("UICorner", MainContainer).CornerRadius = UDim.new(0,10)
MainContainer.ClipsDescendants = true

--// TOP BAR
local TopBar = Instance.new("Frame", MainContainer)
TopBar.Size = UDim2.new(1,0,0,40)
TopBar.BackgroundColor3 = Color3.fromRGB(8,8,10)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = " VAIN SYSTEM DASHBOARD v4"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(200,200,205)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,1,0)
Title.TextXAlignment = Enum.TextXAlignment.Left

--// SIDEBAR
local Sidebar = Instance.new("ScrollingFrame", MainContainer)
Sidebar.Size = UDim2.new(0, 170, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(15,15,18)
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 0
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0,10)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0,20)

--// CONTENT AREA
local Content = Instance.new("Frame", MainContainer)
Content.Size = UDim2.new(1, -170, 1, -40)
Content.Position = UDim2.new(0, 170, 0, 40)
Content.BackgroundTransparency = 1

--// PANELS & BUTTONS REGISTRY
local Panels = {}
local Buttons = {}

--// CREATE CATEGORY
local function CreateCategory(name)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0,140,0,35)
    btn.Text = name:upper()
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamMedium
    btn.BackgroundColor3 = Color3.fromRGB(22,22,26)
    btn.TextColor3 = Color3.fromRGB(150,150,150)
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
        for _, p in pairs(Panels) do p.Visible = false end
        for _, b in pairs(Buttons) do
            b.BackgroundColor3 = Color3.fromRGB(22,22,26)
            if b:FindFirstChild("UIStroke") then
                b.UIStroke.Color = Color3.fromRGB(45,45,50)
            end
        end
        panel.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(0,120,255)
        if s then s.Color = Color3.fromRGB(255,255,255) end
    end)

    Panels[name] = panel
    Buttons[name] = btn
    return panel
end

--// UI ELEMENTS
local function CreateToggle(parent,text,default,callback)
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
    dot.BackgroundColor3 = default and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,200)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

    btn.MouseButton1Click:Connect(function()
        default = not default
        TweenService:Create(btn,TweenInfo.new(0.3),{BackgroundColor3=default and Color3.fromRGB(0,170,255) or Color3.fromRGB(45,45,50)}):Play()
        dot:TweenPosition(default and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7),"Out","Quad",0.25,true)
        TweenService:Create(dot,TweenInfo.new(0.25),{BackgroundColor3=default and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,200)}):Play()
        callback(default)
    end)
end

local function CreateSlider(parent,text,min,max,default,callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,0,0,45)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,24)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

    local label = Instance.new("TextLabel", frame)
    label.Name = "SliderLabel"
    label.Text = text.." "..tostring(default)
    label.Size = UDim2.new(1,-20,0,20)
    label.Position = UDim2.new(0,10,0,5)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200,200,205)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14

    local sliderFrame = Instance.new("Frame", frame)
    sliderFrame.Size = UDim2.new(1,-20,0,6)
    sliderFrame.Position = UDim2.new(0,10,0,30)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(45,45,50)
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0,5)

    local bar = Instance.new("Frame", sliderFrame)
    bar.Size = UDim2.new((default-min)/(max-min),0,1,0)
    bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0,5)

    local dragging = false
    local function move(input)
        local relative = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X)/sliderFrame.AbsoluteSize.X,0,1)
        local value = min + (max-min)*relative
        bar.Size = UDim2.new(relative,0,1,0)
        label.Text = text.." "..math.floor(value*100)/100
        callback(value)
    end

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            move(input)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then move(input) end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
end

local function CreateColorPicker(parent,text,defaultColor,callback)
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

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0,30,0,30)
    btn.Position = UDim2.new(1,-35,0.5,-15)
    btn.BackgroundColor3 = defaultColor
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)

    btn.MouseButton1Click:Connect(function()
        local r,g,b = math.random(),math.random(),math.random()
        local newColor = Color3.fromRGB(r*255,g*255,b*255)
        btn.BackgroundColor3 = newColor
        callback(newColor)
    end)
end

--// CREATE PANELS
local CombatPanel = CreateCategory("Combat")
local VisualsPanel = CreateCategory("Visuals")
local SettingsPanel = CreateCategory("Settings")

--// POPULATE COMBAT
CreateToggle(CombatPanel,"Aim Assist (Q)",Settings.AIM_ASSIST.ENABLED,function(v) 
    Settings.AIM_ASSIST.ENABLED = v 
end)

--// POPULATE VISUALS
CreateToggle(VisualsPanel,"Metal ESP",Settings.METAL_ESP.ENABLED,function(v) Settings.METAL_ESP.ENABLED=v end)
CreateToggle(VisualsPanel,"Star ESP",Settings.STAR_ESP.ENABLED,function(v) Settings.STAR_ESP.ENABLED=v end)
CreateToggle(VisualsPanel,"Tree ESP",Settings.TREE_ESP.ENABLED,function(v) Settings.TREE_ESP.ENABLED=v end)
CreateToggle(VisualsPanel,"Bee ESP",Settings.BEE_ESP.ENABLED,function(v) Settings.BEE_ESP.ENABLED=v end)

--// POPULATE SETTINGS
CreateColorPicker(SettingsPanel,"UI Color",Settings.UI_COLOR,function(c)
    Settings.UI_COLOR=c
    MainContainer.BackgroundColor3=c
end)
CreateColorPicker(SettingsPanel,"Metal ESP Color",Settings.METAL_ESP.COLOR,function(c)
    Settings.METAL_ESP.COLOR=c
end)
CreateColorPicker(SettingsPanel,"Star ESP Color",Settings.STAR_ESP.COLOR,function(c)
    Settings.STAR_ESP.COLOR=c
end)
CreateColorPicker(SettingsPanel,"Tree ESP Color",Settings.TREE_ESP.COLOR,function(c)
    Settings.TREE_ESP.COLOR=c
end)
CreateColorPicker(SettingsPanel,"Bee ESP Color",Settings.BEE_ESP.COLOR,function(c)
    Settings.BEE_ESP.COLOR=c
end)
-- Aim Assist sliders only in Settings
CreateSlider(SettingsPanel,"Aim Smoothness",0,1,Settings.AIM_ASSIST.SMOOTHNESS,function(v) Settings.AIM_ASSIST.SMOOTHNESS=v end)
CreateSlider(SettingsPanel,"Aim Max Distance",10,500,Settings.AIM_ASSIST.MAX_DISTANCE,function(v) Settings.AIM_ASSIST.MAX_DISTANCE=v end)
CreateSlider(SettingsPanel,"Aim Max Angle",10,180,Settings.AIM_ASSIST.MAX_ANGLE,function(v) Settings.AIM_ASSIST.MAX_ANGLE=v end)

--// UI VISIBILITY TOGGLE (FIXED)
local UIS = game:GetService("UserInputService")
local visible = true

MainContainer.Visible = true
if blur then blur.Enabled = true end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        visible = not visible
        MainContainer.Visible = visible

        if blur then
            blur.Enabled = visible
        end
    end
end)


-- DEFAULT TAB
Panels["Combat"].Visible = true
Buttons["Combat"].BackgroundColor3 = Color3.fromRGB(0,120,255)
