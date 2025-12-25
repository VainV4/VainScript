--[[
    VAIN UI RECODE
    Cleaned, Optimized, and Modularized
--]]

local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- // UI SETUP (Referencing your Converted Table)
local UI = Converted -- Assuming the 'Converted' table is defined above
local MainGUI = UI["_VainUI"]
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // CONFIGURATION & STATE
local Config = {
    Colors = {
        Enabled = Color3.fromRGB(0, 255, 100),
        Disabled = Color3.fromRGB(20, 20, 20),
        ESP_Metal = Color3.fromRGB(255, 0, 0),
        ESP_Star = Color3.fromRGB(255, 255, 0)
    },
    AimSettings = {
        Smoothness = 0.1,
        FOV = 80,
        MaxDistance = 35
    }
}

local State = {
    MetalESP = false,
    StarESP = false,
    AimAssist = false,
    Beams = {
        Metal = {},
        Star = {}
    }
}

-- // UTILITIES
local function TweenColor(object, color)
    TweenService:Create(object, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
end

local function GetClosestTarget()
    local target, closestDist = nil, Config.AimSettings.MaxDistance
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    local origin = char.HumanoidRootPart.Position
    local lookDir = char.HumanoidRootPart.CFrame.LookVector

    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or p.Team == LocalPlayer.Team then continue end
        local pChar = p.Character
        if pChar and pChar:FindFirstChild("HumanoidRootPart") and pChar.Humanoid.Health > 0 then
            local pos = pChar.HumanoidRootPart.Position
            local dist = (pos - origin).Magnitude
            local dirTo = (pos - origin).Unit
            local angle = math.deg(math.acos(lookDir:Dot(dirTo)))

            if dist < closestDist and angle < Config.AimSettings.FOV then
                closestDist = dist
                target = pChar.HumanoidRootPart
            end
        end
    end
    return target
end

-- // ESP CORE
local function CreateVisualLink(target, beamType, color)
    if not target:IsA("Model") or not target.PrimaryPart then return end
    
    local char = LocalPlayer.Character
    if not char or not char.PrimaryPart then return end

    local att0 = Instance.new("Attachment", char.PrimaryPart)
    local att1 = Instance.new("Attachment", target.PrimaryPart)
    
    local beam = Instance.new("Beam")
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Color = ColorSequence.new(color)
    beam.Texture = "rbxassetid://4955566540"
    beam.Width0, beam.Width1 = 0.2, 0.2
    beam.FaceCamera = true
    beam.Enabled = State[beamType]
    beam.Parent = target.PrimaryPart

    -- Highlight logic
    if not target:FindFirstChildOfClass("Highlight") then
        local hl = Instance.new("Highlight", target)
        hl.FillColor = color
        hl.OutlineColor = color
        hl.FillTransparency = 0.5
    end

    table.insert(State.Beams[beamType == "MetalESP" and "Metal" or "Star"], beam)
end

-- // MODULE TOGGLES
local function ToggleAim()
    State.AimAssist = not State.AimAssist
    TweenColor(UI["_Toggle2"], State.AimAssist and Config.Colors.Enabled or Config.Colors.Disabled)
end

local function ToggleMetal()
    State.MetalESP = not State.MetalESP
    TweenColor(UI["_Toggle"], State.MetalESP and Config.Colors.Enabled or Config.Colors.Disabled)
    for _, b in ipairs(State.Beams.Metal) do b.Enabled = State.MetalESP end
end

local function ToggleStar()
    State.StarESP = not State.StarESP
    TweenColor(UI["_Toggle1"], State.StarESP and Config.Colors.Enabled or Config.Colors.Disabled)
    for _, b in ipairs(State.Beams.Star) do b.Enabled = State.StarESP end
end

-- // RUNTIME LOOPS
RunService.Heartbeat:Connect(function()
    if State.AimAssist then
        local target = GetClosestTarget()
        if target then
            local targetCF = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, Config.AimSettings.Smoothness)
        end
    end
end)

-- // INITIALIZATION & EVENTS
local function RefreshESP()
    for _, loot in ipairs(CollectionService:GetTagged("hidden-metal")) do
        CreateVisualLink(loot, "MetalESP", Config.Colors.ESP_Metal)
    end
end

-- Input Handling
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainGUI.Enabled = not MainGUI.Enabled
        Lighting:FindFirstChildOfClass("BlurEffect").Enabled = MainGUI.Enabled
    elseif input.KeyCode == Enum.KeyCode.Q then
        ToggleAim()
    end
end)

-- UI Click Connections
UI["_Toggle"].MouseButton1Click:Connect(ToggleMetal)
UI["_Toggle1"].MouseButton1Click:Connect(ToggleStar)
UI["_Toggle2"].MouseButton1Click:Connect(ToggleAim)

-- Settings Visibility Toggle
UI["_ToggleModuleSettings"].MouseButton1Click:Connect(function()
    UI["_Settings"].Visible = not UI["_Settings"].Visible
end)

-- Setup Character Events
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    RefreshESP()
end)

-- Boot
RefreshESP()
