--========================================
-- Vain Script Hub (Enhanced Edition)
--========================================

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local BASE_URL = "https://raw.githubusercontent.com/VainV4/VainScript/main/"
local REGISTRY_FILE = "modules.json"

-- Simple Tween Helper
local function Tween(obj, info, goal)
    local tween = TweenService:Create(obj, info, goal)
    tween:Play()
    return tween
end

--========================================
-- Registry & Settings
--========================================

local Registry = {}
do
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(BASE_URL .. REGISTRY_FILE .. "?t=" .. tick()))
    end)
    Registry = success and result or {}
end

local function SaveSettings(name, data)
    if writefile then writefile(name .. ".json", HttpService:JSONEncode(data)) end
end

local function LoadSettings(name)
    if isfile and isfile(name .. ".json") then
        return HttpService:JSONDecode(readfile(name .. ".json"))
    end
    return {}
end

--========================================
-- Enhanced UI Elements
--========================================

local function CreateToggle(parent, module, categoryName)
    local toggleBG = Instance.new("Frame", parent)
    toggleBG.Size = UDim2.new(0, 45, 0, 22)
    toggleBG.Position = UDim2.new(1, -60, 0.5, -11)
    toggleBG.BackgroundColor3 = module.Settings.Enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", toggleBG).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", toggleBG)
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = module.Settings.Enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", toggleBG)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    btn.MouseButton1Click:Connect(function()
        module.Settings.Enabled = not module.Settings.Enabled
        local goalColor = module.Settings.Enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 50)
        local goalPos = module.Settings.Enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        
        Tween(toggleBG, TweenInfo.new(0.3), {BackgroundColor3 = goalColor})
        Tween(circle, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = goalPos})
        
        SaveSettings(categoryName .. "_" .. module.Name, module.Settings)
        if module.Run then task.spawn(module.Run, module.Settings) end
    end)
end

local function CreateSlider(parent, name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame", parent)
    sliderFrame.Size = UDim2.new(1, -30, 0, 40)
    sliderFrame.BackgroundTransparency = 1
    
    local title = Instance.new("TextLabel", sliderFrame)
    title.Size = UDim2.new(0.4, 0, 0.5, 0)
    title.Text = name .. ": " .. default
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.Gotham
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1

    local barBG = Instance.new("Frame", sliderFrame)
    barBG.Size = UDim2.new(1, 0, 0, 6)
    barBG.Position = UDim2.new(0, 0, 0.7, 0)
    barBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", barBG)

    local fill = Instance.new("Frame", barBG)
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    Instance.new("UICorner", fill)

    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - barBG.AbsolutePosition.X) / barBG.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        title.Text = name .. ": " .. value
        Tween(fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)})
        callback(value)
    end

    barBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
    end)
end

--========================================
-- Main UI Creation
--========================================

local function CreateUI()
    if CoreGui:FindFirstChild("VainUI") then CoreGui.VainUI:Destroy() end

    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "VainUI"

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 700, 0, 450)
    main.Position = UDim2.new(0.5, 0, 0.5, 50) -- Start slightly lower for entrance anim
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
    
    -- Fade In Animation
    main.BackgroundTransparency = 1
    Tween(main, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 0
    })

    local sideBar = Instance.new("Frame", main)
    sideBar.Size = UDim2.new(0, 180, 1, 0)
    sideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    sideBar.BorderSizePixel = 0
    
    local scrollContainer = Instance.new("ScrollingFrame", main)
    scrollContainer.Position = UDim2.new(0, 190, 0, 20)
    scrollContainer.Size = UDim2.new(1, -210, 1, -40)
    scrollContainer.BackgroundTransparency = 1
    scrollContainer.ScrollBarThickness = 2
    local listLayout = Instance.new("UIListLayout", scrollContainer)
    listLayout.Padding = UDim.new(0, 8)

    -- Categories & Modules Processing
    local CategoriesData = {}
    for cat, mods in pairs(Registry) do
        CategoriesData[cat] = {}
        for name, path in pairs(mods) do
            local success, mod = pcall(function() return loadstring(game:HttpGet(BASE_URL .. path))() end)
            if success then
                CategoriesData[cat][name] = {Name = name, Settings = LoadSettings(cat.."_"..name) or {Enabled=false}, Run = mod.Run}
            end
        end
    end

    local function LoadCategory(catName)
        scrollContainer:ClearAllChildren()
        listLayout.Parent = scrollContainer
        
        for _, mod in pairs(CategoriesData[catName]) do
            local card = Instance.new("Frame", scrollContainer)
            card.Size = UDim2.new(1, 0, 0, 50)
            card.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
            
            local label = Instance.new("TextLabel", card)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.Size = UDim2.new(0.5, 0, 1, 0)
            label.Text = mod.Name
            label.TextColor3 = Color3.new(1, 1, 1)
            label.Font = Enum.Font.GothamMedium
            label.TextSize = 14
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left

            CreateToggle(card, mod, catName)
        end
    end

    -- Create Side Buttons
    local catLayout = Instance.new("UIListLayout", sideBar)
    catLayout.Padding = UDim.new(0, 5)
    catLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    for name, _ in pairs(CategoriesData) do
        local b = Instance.new("TextButton", sideBar)
        b.Size = UDim2.new(0.9, 0, 0, 40)
        b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        b.Text = name
        b.TextColor3 = Color3.fromRGB(200, 200, 200)
        b.Font = Enum.Font.Gotham
        Instance.new("UICorner", b)
        
        b.MouseButton1Click:Connect(function() 
            LoadCategory(name) 
            Tween(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
            task.wait(0.1)
            Tween(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
        end)
    end
end

CreateUI()
