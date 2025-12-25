-- =========================
-- VainScript LocalScript Loader
-- =========================

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- =========================
-- Persistence (Executor Only)
-- =========================
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

-- =========================
-- Categories & Modules
-- =========================
local Categories = {}

-- UI visibility toggle
local uiVisible = true
local MainFrame

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        uiVisible = not uiVisible
        if MainFrame then
            MainFrame.Visible = uiVisible
        end
    end
end)

-- =========================
-- Dynamic Module Loader
-- =========================
local function LoadModules()
    local scriptFolder = "scripts"
    local function LoadFolder(path)
        local success, files = pcall(function()
            return listfiles(path) -- executor-only
        end)
        if not success then return end

        for _, file in pairs(files) do
            if file:sub(-4) == ".lua" then
                local ok, moduleFunc = pcall(function()
                    return loadfile(file)
                end)
                if ok and type(moduleFunc) == "function" then
                    local category = file:match("scripts/(.-)/") or "Misc"
                    local moduleName = file:match("scripts/.-/([%w_]+)%.lua$")

                    local defaultSettings = moduleFunc.DefaultSettings or {Enabled = true}
                    local savedSettings = LoadSettings(category .. "_" .. moduleName)
                    local settings = {}
                    for k, v in pairs(defaultSettings) do
                        settings[k] = savedSettings[k] ~= nil and savedSettings[k] or v
                    end

                    Categories[category] = Categories[category] or {}
                    Categories[category][moduleName] = {
                        name = moduleName,
                        settings = settings,
                        init = moduleFunc
                    }

                    coroutine.wrap(function()
                        moduleFunc(settings)
                    end)()
                end
            elseif file:sub(-1) == "/" then
                LoadFolder(file)
            end
        end
    end
    LoadFolder(scriptFolder)
end

-- =========================
-- GUI Creation
-- =========================
local function CreateUI()
    local CoreGui = game:GetService("CoreGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VainScriptUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Visible = uiVisible
    MainFrame.ClipsDescendants = true
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5,0,0.5,0)

    -- Left Panel: Categories
    local LeftPanel = Instance.new("Frame")
    LeftPanel.Size = UDim2.new(0, 150, 1, 0)
    LeftPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    LeftPanel.BorderSizePixel = 0
    LeftPanel.Parent = MainFrame

    local LeftLayout = Instance.new("UIListLayout")
    LeftLayout.Parent = LeftPanel
    LeftLayout.Padding = UDim.new(0, 5)
    LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Right Panel: Modules
    local RightPanel = Instance.new("Frame")
    RightPanel.Size = UDim2.new(1, -160, 1, 0)
    RightPanel.Position = UDim2.new(0, 160, 0, 0)
    RightPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    RightPanel.BorderSizePixel = 0
    RightPanel.Parent = MainFrame

    local ModuleScroller = Instance.new("ScrollingFrame")
    ModuleScroller.Size = UDim2.new(1, -10, 1, -10)
    ModuleScroller.Position = UDim2.new(0, 5, 0, 5)
    ModuleScroller.BackgroundTransparency = 1
    ModuleScroller.BorderSizePixel = 0
    ModuleScroller.ScrollBarThickness = 6
    ModuleScroller.Parent = RightPanel

    local ModuleLayout = Instance.new("UIListLayout")
    ModuleLayout.Padding = UDim.new(0,5)
    ModuleLayout.Parent = ModuleScroller

    local CurrentCategory = nil

    local function PopulateModules(categoryName)
        for _, child in pairs(ModuleScroller:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        CurrentCategory = categoryName
        local modules = Categories[categoryName] or {}

        for _, module in pairs(modules) do
            local ModuleFrame = Instance.new("Frame")
            ModuleFrame.Size = UDim2.new(1,0,0,30)
            ModuleFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
            ModuleFrame.BorderSizePixel = 0
            ModuleFrame.Parent = ModuleScroller

            local ModuleButton = Instance.new("TextButton")
            ModuleButton.Size = UDim2.new(1,0,1,0)
            ModuleButton.BackgroundTransparency = 1
            ModuleButton.TextColor3 = Color3.fromRGB(255,255,255)
            ModuleButton.Font = Enum.Font.SourceSansBold
            ModuleButton.TextSize = 18
            ModuleButton.Text = module.name .. " ["..(module.settings.Enabled and "ON" or "OFF").."]"
            ModuleButton.Parent = ModuleFrame

            ModuleButton.MouseButton1Click:Connect(function()
                module.settings.Enabled = not module.settings.Enabled
                ModuleButton.Text = module.name .. " ["..(module.settings.Enabled and "ON" or "OFF").."]"
                SaveSettings(categoryName.."_"..module.name, module.settings)
            end)

            local SettingsOpen = false
            local SettingsFrame = Instance.new("Frame")
            SettingsFrame.Size = UDim2.new(1,0,0,0)
            SettingsFrame.Position = UDim2.new(0,0,0,30)
            SettingsFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
            SettingsFrame.BorderSizePixel = 0
            SettingsFrame.ClipsDescendants = true
            SettingsFrame.Parent = ModuleFrame

            local YOffset = 0
            for key, value in pairs(module.settings) do
                if key ~= "Enabled" then
                    local SettingButton = Instance.new("TextButton")
                    SettingButton.Size = UDim2.new(1,0,0,25)
                    SettingButton.Position = UDim2.new(0,0,0,YOffset)
                    SettingButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
                    SettingButton.TextColor3 = Color3.fromRGB(255,255,255)
                    SettingButton.Font = Enum.Font.SourceSans
                    SettingButton.TextSize = 16
                    SettingButton.Text = key.." ["..tostring(value).."]"
                    SettingButton.Parent = SettingsFrame

                    SettingButton.MouseButton1Click:Connect(function()
                        if typeof(module.settings[key]) == "boolean" then
                            module.settings[key] = not module.settings[key]
                        end
                        SettingButton.Text = key.." ["..tostring(module.settings[key]).."]"
                        SaveSettings(categoryName.."_"..module.name,module.settings)
                    end)

                    YOffset = YOffset + 30
                end
            end

            ModuleButton.MouseButton2Click:Connect(function()
                SettingsOpen = not SettingsOpen
                if SettingsOpen then
                    SettingsFrame:TweenSize(UDim2.new(1,0,0,YOffset),"Out","Quad",0.3,true)
                    ModuleFrame.Size = UDim2.new(1,0,0,30+YOffset)
                else
                    SettingsFrame:TweenSize(UDim2.new(1,0,0,0),"Out","Quad",0.3,true)
                    ModuleFrame.Size = UDim2.new(1,0,0,30)
                end
            end)
        end
    end

    -- Populate category buttons
    for categoryName, _ in pairs(Categories) do
        local CatButton = Instance.new("TextButton")
        CatButton.Size = UDim2.new(1,0,0,30)
        CatButton.BackgroundColor3 = Color3.fromRGB(55,55,55)
        CatButton.TextColor3 = Color3.fromRGB(255,255,255)
        CatButton.Font = Enum.Font.SourceSansBold
        CatButton.TextSize = 18
        CatButton.Text = categoryName
        CatButton.Parent = LeftPanel

        CatButton.MouseButton1Click:Connect(function()
            PopulateModules(categoryName)
        end)
    end

    -- Select first category by default
    for firstCat,_ in pairs(Categories) do
        PopulateModules(firstCat)
        break
    end
end

-- =========================
-- Auto-save every 5 seconds
-- =========================
local saveInterval = 5
local accumulatedTime = 0

RunService.Heartbeat:Connect(function(dt)
    accumulatedTime = accumulatedTime + dt
    if accumulatedTime >= saveInterval then
        accumulatedTime = 0
        for categoryName, modules in pairs(Categories) do
            for moduleName, module in pairs(modules) do
                SaveSettings(categoryName.."_"..moduleName,module.settings)
            end
        end
    end
end)

-- =========================
-- Run Everything
-- =========================
LoadModules()
CreateUI()
print("VainScript (LocalScript) loaded! Categories and modules:")
for cat, mods in pairs(Categories) do
    print("-", cat)
    for modName, _ in pairs(mods) do
        print("   -", modName)
    end
end
