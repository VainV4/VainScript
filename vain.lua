--========================================
-- Vain Script Hub (High-End Edition)
--========================================

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local BASE_URL = "https://raw.githubusercontent.com/VainV4/VainScript/main/"
local REGISTRY_FILE = "modules.json"

--========================================
-- Helpers & Animations
--========================================

local function Tween(obj, info, goal)
    local t = TweenService:Create(obj, info, goal)
    t:Play()
    return t
end

local function CreateGradient(parent, c1, c2)
    local g = Instance.new("UIGradient", parent)
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2)
    }
    g.Rotation = 90
    return g
end

--========================================
-- Registry & Settings
--========================================

local Registry = {}
local success, result = pcall(function()
    return HttpService:JSONDecode(game:HttpGet(BASE_URL .. REGISTRY_FILE .. "?t=" .. os.clock()))
end)
Registry = success and result or {}

local function SaveSettings(name, data)
    if writefile then
        writefile(name .. ".json", HttpService:JSONEncode(data))
    end
end

local function LoadSettings(name)
    if isfile and isfile(name .. ".json") then
        local ok, content = pcall(readfile, name .. ".json")
        return ok and HttpService:JSONDecode(content) or {}
    end
    return {}
end

--========================================
-- UI Elements: Toggle & Slider
--========================================

local function CreateToggle(parent, module, category, key)
    local bg = Instance.new("Frame", parent)
    bg.Size = UDim2.new(0, 42, 0, 22)
    bg.Position = UDim2.new(1, -50, 0.5, -11)
    bg.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", bg)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = module.Settings[key] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", bg)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    local function Refresh()
        local enabled = module.Settings[key]
        Tween(bg, TweenInfo.new(0.2), {BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 120) or Color3.fromRGB(45, 45, 45)})
        Tween(knob, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = enabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        })
    end

    btn.MouseButton1Click:Connect(function()
        module.Settings[key] = not module.Settings[key]
        SaveSettings(category .. "_" .. (module.Name or "Config"), module.Settings)
        Refresh()
        if key == "Enabled" and module.Run then task.spawn(module.Run, module.Settings) end
    end)
    Refresh()
end

local function CreateSlider(parent, labelText, min, max, settingTable, key)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 45)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.Text = labelText .. ": " .. settingTable[key]
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local bar = Instance.new("Frame", frame)
    bar.Position = UDim2.new(0, 0, 0, 24)
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", bar)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new(math.clamp((settingTable[key] - min) / (max - min), 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    Instance.new("UICorner", fill)
    CreateGradient(fill, Color3.fromRGB(0, 170, 255), Color3.fromRGB(0, 90, 255))

    local dragging = false
    local function Update(x)
        local p = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * p)
        settingTable[key] = val
        label.Text = labelText .. ": " .. val
        Tween(fill, TweenInfo.new(0.1), {Size = UDim2.new(p, 0, 1, 0)})
    end

    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true Update(i.Position.X) end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i.Position.X) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

--========================================
-- Main UI Creation
--========================================

local function CreateUI()
    if CoreGui:FindFirstChild("VainUI") then CoreGui.VainUI:Destroy() end

    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "VainUI"

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 780, 0, 500)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
    CreateGradient(main, Color3.fromRGB(20, 20, 20), Color3.fromRGB(12, 12, 12))

    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0, 200, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 16)
    
    local sideLayout = Instance.new("UIListLayout", sidebar)
    sideLayout.Padding = UDim.new(0, 10)
    sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 20)

    local container = Instance.new("ScrollingFrame", main)
    container.Position = UDim2.new(0, 215, 0, 20)
    container.Size = UDim2.new(1, -235, 1, -40)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 2
    
    local containerLayout = Instance.new("UIListLayout", container)
    containerLayout.Padding = UDim.new(0, 12)
    containerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, containerLayout.AbsoluteContentSize.Y)
    end)

    -- Process Modules
    local CategoryMap = {}
    for cat, mods in pairs(Registry) do
        CategoryMap[cat] = {}
        for name, path in pairs(mods) do
            local ok, m = pcall(function() return loadstring(game:HttpGet(BASE_URL .. path))() end)
            if ok and m then
                m.Settings = LoadSettings(cat.."_"..name)
                m.Settings.Enabled = m.Settings.Enabled or false
                m.Name = name
                CategoryMap[cat][name] = m
            end
        end
    end

    local function Load(cat)
        for _, v in pairs(container:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
        for _, mod in pairs(CategoryMap[cat] or {}) do
            local card = Instance.new("Frame", container)
            card.Size = UDim2.new(1, 0, 0, 56)
            card.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
            
            local title = Instance.new("TextLabel", card)
            title.Size = UDim2.new(0.5, 0, 1, 0)
            title.Position = UDim2.new(0, 15, 0, 0)
            title.Text = mod.Name
            title.TextColor3 = Color3.new(1, 1, 1)
            title.Font = Enum.Font.GothamBold
            title.TextSize = 15
            title.BackgroundTransparency = 1
            title.TextXAlignment = Enum.TextXAlignment.Left

            CreateToggle(card, mod, cat, "Enabled")
        end
    end

    for name in pairs(CategoryMap) do
        local b = Instance.new("TextButton", sidebar)
        b.Size = UDim2.new(0.85, 0, 0, 42)
        b.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        b.Text = name
        b.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        b.Font = Enum.Font.GothamMedium
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        b.MouseButton1Click:Connect(function() Load(name) end)
    end

    -- Initial Load
    for first in pairs(CategoryMap) do Load(first) break end
end

CreateUI()
print("[Vain] Hub successfully loaded.")
