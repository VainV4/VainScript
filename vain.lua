-- =====================================
-- Vain Script Hub (Dynamic Categories)
-- =====================================

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local BASE_URL = "https://raw.githubusercontent.com/VainV4/VainScript/main/"

-- =====================================
-- SETTINGS STORAGE
-- =====================================
local function SaveSettings(name, data)
    if writefile then
        writefile(name .. ".json", HttpService:JSONEncode(data))
    end
end

local function LoadSettings(name)
    if isfile and isfile(name .. ".json") then
        return HttpService:JSONDecode(readfile(name .. ".json"))
    end
    return {}
end

-- =====================================
-- LOAD MODULE REGISTRY
-- =====================================
local Registry = HttpService:JSONDecode(
    game:HttpGet(BASE_URL .. "modules.json")
)

local Categories = {}

-- =====================================
-- LOAD MODULES DYNAMICALLY
-- =====================================
for categoryName, modules in pairs(Registry) do
    Categories[categoryName] = {}

    for moduleName, path in pairs(modules) do
        local moduleFunc = loadstring(game:HttpGet(BASE_URL .. path))

        local defaults = moduleFunc.DefaultSettings or { Enabled = true }
        local saved = LoadSettings(categoryName .. "_" .. moduleName)

        local settings = {}
        for k, v in pairs(defaults) do
            settings[k] = saved[k] ~= nil and saved[k] or v
        end

        Categories[categoryName][moduleName] = {
            name = moduleName,
            settings = settings,
            run = moduleFunc
        }

        task.spawn(function()
            moduleFunc(settings)
        end)
    end
end

-- =====================================
-- UI TOGGLE
-- =====================================
local uiVisible = true
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        uiVisible = not uiVisible
        if CoreGui:FindFirstChild("VainUI") then
            CoreGui.VainUI.Enabled = uiVisible
        end
    end
end)

-- =====================================
-- CREATE UI
-- =====================================
local function CreateUI()
    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "VainUI"
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 800, 0, 500)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(20,20,20)
    main.BorderSizePixel = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

    -- Categories
    local catPanel = Instance.new("Frame", main)
    catPanel.Size = UDim2.new(0,200,1,0)
    catPanel.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Instance.new("UICorner", catPanel).CornerRadius = UDim.new(0,16)

    local catLayout = Instance.new("UIListLayout", catPanel)
    catLayout.Padding = UDim.new(0,8)

    -- Modules
    local modPanel = Instance.new("ScrollingFrame", main)
    modPanel.Position = UDim2.new(0,210,0,10)
    modPanel.Size = UDim2.new(1,-220,1,-20)
    modPanel.ScrollBarThickness = 6
    modPanel.BackgroundTransparency = 1

    local modLayout = Instance.new("UIListLayout", modPanel)
    modLayout.Padding = UDim.new(0,6)

    local function LoadCategory(category)
        modPanel:ClearAllChildren()
        modLayout.Parent = modPanel

        for _, module in pairs(Categories[category]) do
            local card = Instance.new("Frame", modPanel)
            card.Size = UDim2.new(1,0,0,40)
            card.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Instance.new("UICorner", card).CornerRadius = UDim.new(0,12)

            local btn = Instance.new("TextButton", card)
            btn.Size = UDim2.new(1,-40,1,0)
            btn.Text = module.name
            btn.BackgroundTransparency = 1
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 18

            local pill = Instance.new("Frame", card)
            pill.Size = UDim2.new(0,16,0,16)
            pill.Position = UDim2.new(1,-22,0.5,-8)
            pill.BackgroundColor3 = module.settings.Enabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
            Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)

            btn.MouseButton1Click:Connect(function()
                module.settings.Enabled = not module.settings.Enabled
                pill.BackgroundColor3 = module.settings.Enabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
                SaveSettings(category .. "_" .. module.name, module.settings)
            end)
        end
    end

    for category in pairs(Categories) do
        local btn = Instance.new("TextButton", catPanel)
        btn.Size = UDim2.new(1,0,0,40)
        btn.Text = category
        btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 18
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

        btn.MouseButton1Click:Connect(function()
            LoadCategory(category)
        end)
    end

    for first in pairs(Categories) do
        LoadCategory(first)
        break
    end
end

CreateUI()
print("[Vain] Dynamic hub loaded")
