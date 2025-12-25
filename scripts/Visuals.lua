local Visuals = {}
_G.Vain.Visuals = Visuals
local Config = _G.Vain.Config
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Cleans up visuals for a specific category 
local function clearCategory(category)
    if Config.ActiveObjects[category] then
        for target, data in pairs(Config.ActiveObjects[category]) do
            if data.Highlight then data.Highlight:Destroy() end
            if data.Beam then data.Beam:Destroy() end
            if data.A0 then data.A0:Destroy() end
            if data.A1 then data.A1:Destroy() end
        end
        Config.ActiveObjects[category] = {}
    end
end

-- Creates the visual elements (Highlight and Beam) [cite: 11]
local function createESP(target, category, color)
    if Config.ActiveObjects[category][target] then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local adornee = target:IsA("Model") and target.PrimaryPart or target
    if not adornee then return end

    local h = Instance.new("Highlight")
    h.Adornee = adornee
    h.FillColor = color
    h.FillTransparency = 0.55
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = workspace

    local a0 = Instance.new("Attachment", character.HumanoidRootPart)
    local a1 = Instance.new("Attachment", adornee)
    local beam = Instance.new("Beam", workspace)
    beam.Attachment0, beam.Attachment1 = a0, a1
    beam.Width0, beam.Width1, beam.Color = 0.15, 0.15, ColorSequence.new(color)

    Config.ActiveObjects[category][target] = { Highlight = h, Beam = beam, A0 = a0, A1 = a1 }
end

-- Refreshes objects based on tags or workspace search [cite: 12]
function Visuals.Refresh(category)
    local settings = Config.Settings[category:upper() .. "_ESP"]
    if not settings.ENABLED then return end

    if settings.TAG then
        for _, obj in ipairs(CollectionService:GetTagged(settings.TAG)) do
            if category == "bee" and obj.Name == "TamedBee" then continue end
            createESP(obj, category, settings.COLOR)
        end
    elseif category == "star" then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name:lower():find("star") then
                createESP(obj, "star", settings.COLOR)
            end
        end
    end
end

-- The Toggle function used by the UI 
function Visuals.Toggle(category, state)
    Config.Settings[category:upper() .. "_ESP"].ENABLED = state
    if state then
        Visuals.Refresh(category)
    else
        clearCategory(category)
    end
end

-- Listeners for newly added objects [cite: 12]
for cat, data in pairs(Config.ActiveObjects) do
    local setting = Config.Settings[cat:upper().."_ESP"]
    if setting.TAG then
        CollectionService:GetInstanceAddedSignal(setting.TAG):Connect(function(obj)
            if setting.ENABLED then createESP(obj, cat, setting.COLOR) end
        end)
    end
end
