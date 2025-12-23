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
    STAR_ESP = { ENABLED = false },
    TREE_ESP = { ENABLED = false, COLOR = Color3.fromRGB(255, 100, 0) },
    AIM_ASSIST = { ENABLED = false, SMOOTHNESS = 0.15 },
    VISIBLE = true
}

local ActiveObjects = {
    ["metal"] = {},
    ["star"] = {},
    ["tree"] = {}
}

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
MainContainer.Size = UDim2.new(0.5, 0, 0.55, 0)
MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
MainContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
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
Title.Text = "  VAIN SYSTEM DASHBOARD v4"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
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

--// ESP LOGIC
local function createESP(target, category, color, enabled)
    local root = target:IsA("Model") and target.PrimaryPart or (target:IsA("BasePart") and target)
    if not root or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local finalColor = color
    if category == "star" then
        if target.Name:lower():find("green") then
            finalColor = Color3.fromRGB(80, 255, 80)
        elseif target.Name:lower():find("yellow") then
            finalColor = Color3.fromRGB(255, 230, 50)
        else
            finalColor = Color3.fromRGB(255, 255, 255)
        end
    end

    local data = {}

    -- Attachments for beams
    data.A0 = Instance.new("Attachment", player.Character.HumanoidRootPart)
    data.A1 = Instance.new("Attachment", root)

    -- Beam
    if category ~= "star" then
        data.Beam = Instance.new("Beam", root)
        data.Beam.Attachment0 = data.A0
        data.Beam.Attachment1 = data.A1
        data.Beam.Color = ColorSequence.new(finalColor)
        data.Beam.Width0, data.Beam.Width1 = 0.2, 0.2
        data.Beam.Texture = "rbxassetid://4955566540"
        data.Beam.FaceCamera = true
        data.Beam.Enabled = enabled
    end

    -- Highlight
    data.Highlight = Instance.new("Highlight", target)
    data.Highlight.FillColor = finalColor
    data.Highlight.OutlineColor = Color3.new(1, 1, 1)
    data.Highlight.FillTransparency = 0.6
    data.Highlight.Enabled = enabled

    -- Metal part highlight (replace SelectionBox)
    if category == "metal" then
        local metalPart = target:FindFirstChildWhichIsA("BasePart") or root
        local highlight = Instance.new("Highlight", metalPart)
        highlight.FillColor = finalColor
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.6
        highlight.Enabled = enabled
        data.MetalPartHighlight = highlight
    end

    -- Star beam fix
    if category == "star" then
        for _, part in ipairs(target:GetDescendants()) do
            if part:IsA("BasePart") then
                local att0 = Instance.new("Attachment", player.Character.HumanoidRootPart)
                local att1 = Instance.new("Attachment", part)
                local beam = Instance.new("Beam", part)
                beam.Attachment0 = att0
                beam.Attachment1 = att1
                beam.Color = ColorSequence.new(finalColor)
                beam.Width0, beam.Width1 = 0.2, 0.2
                beam.Texture = "rbxassetid://4955566540"
                beam.FaceCamera = true
                beam.Enabled = enabled
                data["Beam_"..part.Name] = beam
            end
        end
    end

    ActiveObjects[category][target] = data
end

local function toggleCategory(category, state)
    if ActiveObjects[category] then
        for target, data in pairs(ActiveObjects[category]) do
            if data.Beam then data.Beam.Enabled = state end
            if data.Highlight then data.Highlight.Enabled = state end
            if data.MetalPartHighlight then data.MetalPartHighlight.Enabled = state end
            for k, v in pairs(data) do
                if typeof(v) == "Instance" and v:IsA("Beam") and k:find("Beam_") then
                    v.Enabled = state
                end
            end
        end
    end
end

local function clearAllESP()
    for cat, list in pairs(ActiveObjects) do
        for obj, data in pairs(list) do
            for _, inst in pairs(data) do
                if typeof(inst) == "Instance" then
                    inst:Destroy()
                end
            end
        end
        ActiveObjects[cat] = {}
    end
end

--// AIM ASSIST
local function getNearestPlayer()
    local closest, minDistance = nil, 35
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local lookDir = char.HumanoidRootPart.CFrame.LookVector
    for _, p in pairs(Players:GetPlayers()) do
        if p == player or p.Team == player.Team then continue end
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            local targetPos = p.Character.HumanoidRootPart.Position
            local dist = (targetPos - char.HumanoidRootPart.Position).Magnitude
            local dir = (targetPos - char.HumanoidRootPart.Position).Unit
            if dist < minDistance and math.deg(math.acos(lookDir:Dot(dir))) <= 80 then
                minDistance = dist
                closest = p
            end
        end
    end
    return closest
end

RunService.Heartbeat:Connect(function()
    if Settings.AIM_ASSIST.ENABLED then
        local target = getNearestPlayer()
        if target then
            local newCFrame = CFrame.new(camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            camera.CFrame = camera.CFrame:Lerp(newCFrame, Settings.AIM_ASSIST.SMOOTHNESS)
        end
    end
end)

--// UI FACTORY
local Panels = {}
local Buttons = {}

local function CreateCategory(name)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0, 140, 0, 35)
    btn.Text = name:upper()
    btn.Font = Enum.Font.GothamMedium
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
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
        for _, p in pairs(Panels) do
            p.Visible = false
        end
        for _, b in pairs(Buttons) do
            b.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
            if b:FindFirstChild("UIStroke") then b.UIStroke.Color = Color3.fromRGB(45,45,50) end
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
    label.Text = "  "..text
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200,200,205)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamMedium

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
        TweenService:Create(btn,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
            {BackgroundColor3 = default and Color3.fromRGB(0,170,255) or Color3.fromRGB(45,45,50)}):Play()
        dot:TweenPosition(default and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7),"Out","Quad",0.25,true)
        TweenService:Create(dot,TweenInfo.new(0.25),{BackgroundColor3=default and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,200)}):Play()
        callback(default)
    end)
end

--// INITIALIZATION
local Combat = CreateCategory("Combat")
local Visuals = CreateCategory("Visuals")

CreateToggle(Visuals,"Metal ESP",false,function(v)
    Settings.METAL_ESP.ENABLED = v
    toggleCategory("metal",v)
end)

CreateToggle(Visuals,"Star ESP",false,function(v)
    Settings.STAR_ESP.ENABLED = v
    toggleCategory("star",v)
end)

CreateToggle(Visuals,"Tree Orb ESP",false,function(v)
    Settings.TREE_ESP.ENABLED = v
    toggleCategory("tree",v)
end)

CreateToggle(Combat,"Aim Assist (Q)",false,function(v)
    Settings.AIM_ASSIST.ENABLED = v
end)

--// DATA REFRESH
local function RefreshESP()
    for _, obj in ipairs(CollectionService:GetTagged("hidden-metal")) do
        createESP(obj,"metal",Settings.METAL_ESP.COLOR,Settings.METAL_ESP.ENABLED)
    end
    for _, obj in ipairs(CollectionService:GetTagged("tree-orb")) do
        createESP(obj,"tree",Settings.TREE_ESP.COLOR,Settings.TREE_ESP.ENABLED)
    end
end

--// EVENTS
CollectionService:GetInstanceAddedSignal("hidden-metal"):Connect(function(o)
    createESP(o,"metal",Settings.METAL_ESP.COLOR,Settings.METAL_ESP.ENABLED)
end)

CollectionService:GetInstanceAddedSignal("tree-orb"):Connect(function(o)
    createESP(o,"tree",Settings.TREE_ESP.COLOR,Settings.TREE_ESP.ENABLED)
end)

workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") and (child.Name:find("Star") or child.Name:find("star")) then
        task.wait(0.2)
        createESP(child,"star",Color3.new(1,1,1),Settings.STAR_ESP.ENABLED)
    end
end)

local function activatePanel(name)
    for _, p in pairs(Panels) do
        p.Visible = false
    end
    for _, b in pairs(Buttons) do
        b.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        if b:FindFirstChild("UIStroke") then b.UIStroke.Color = Color3.fromRGB(45,45,50) end
    end
    Panels[name].Visible = true
    Buttons[name].BackgroundColor3 = Color3.fromRGB(0,120,255)
    if Buttons[name]:FindFirstChild("UIStroke") then
        Buttons[name].UIStroke.Color = Color3.fromRGB(255,255,255)
    end
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Settings.VISIBLE = not Settings.VISIBLE
        blur.Enabled = Settings.VISIBLE
        MainContainer.Visible = Settings.VISIBLE
    elseif input.KeyCode == Enum.KeyCode.Q then
        Settings.AIM_ASSIST.ENABLED = not Settings.AIM_ASSIST.ENABLED
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    clearAllESP()
    RefreshESP()
end)

-- Startup
RefreshESP()
Buttons["Visuals"].BackgroundColor3 = Color3.fromRGB(0,120,255)
Panels["Visuals"].Visible = true
