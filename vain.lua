-- ==============================
-- VainScript Modern UI Loader
-- ==============================

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ==============================
-- Persistence (Executor Only)
-- ==============================
local function SaveSettings(name, data)
    if writefile then
        writefile(name..".json", HttpService:JSONEncode(data))
    end
end

local function LoadSettings(name)
    if isfile and isfile(name..".json") then
        return HttpService:JSONDecode(readfile(name..".json"))
    end
    return {}
end

-- ==============================
-- Module & Category Loader
-- ==============================
local Categories = {}
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

-- Load modules dynamically from scripts folder
local function LoadModules()
    local function LoadFolder(path)
        local success, files = pcall(function() return listfiles(path) end)
        if not success then return end

        for _, file in pairs(files) do
            if file:sub(-4) == ".lua" then
                local ok, moduleFunc = pcall(function() return loadfile(file) end)
                if ok and type(moduleFunc) == "function" then
                    local category = file:match("scripts/(.-)/") or "Misc"
                    local moduleName = file:match("scripts/.-/([%w_]+)%.lua$")

                    local defaultSettings = moduleFunc.DefaultSettings or {Enabled = true}
                    local savedSettings = LoadSettings(category.."_"..moduleName)
                    local settings = {}
                    for k,v in pairs(defaultSettings) do
                        settings[k] = savedSettings[k] ~= nil and savedSettings[k] or v
                    end

                    Categories[category] = Categories[category] or {}
                    Categories[category][moduleName] = {
                        name = moduleName,
                        settings = settings,
                        init = moduleFunc
                    }

                    coroutine.wrap(function() moduleFunc(settings) end)()
                end
            elseif file:sub(-1) == "/" then
                LoadFolder(file)
            end
        end
    end
    LoadFolder("scripts")
end

-- ==============================
-- Modern UI (Glassmorphism)
-- ==============================
local function CreateUI()
    local CoreGui = game:GetService("CoreGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VainScriptUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    -- Main Frame
    MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 800, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Rounded corners (UICorner)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,15)
    corner.Parent = MainFrame

    -- Left Panel: Categories
    local LeftPanel = Instance.new("Frame")
    LeftPanel.Size = UDim2.new(0, 200, 1, 0)
    LeftPanel.BackgroundColor3 = Color3.fromRGB(30,30,30)
    LeftPanel.BackgroundTransparency = 0.1
    LeftPanel.BorderSizePixel = 0
    LeftPanel.Parent = MainFrame

    local LeftCorner = Instance.new("UICorner")
    LeftCorner.CornerRadius = UDim.new(0,15)
    LeftCorner.Parent = LeftPanel

    local LeftLayout = Instance.new("UIListLayout")
    LeftLayout.Padding = UDim.new(0,10)
    LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LeftLayout.Parent = LeftPanel

    -- Right Panel: Modules & Settings
    local RightPanel = Instance.new("Frame")
    RightPanel.Size = UDim2.new(1, -220, 1, 0)
    RightPanel.Position = UDim2.new(0,220,0,0)
    RightPanel.BackgroundColor3 = Color3.fromRGB(40,40,40)
    RightPanel.BackgroundTransparency = 0.1
    RightPanel.BorderSizePixel = 0
    RightPanel.Parent = MainFrame

    local RightCorner = Instance.new("UICorner")
    RightCorner.CornerRadius = UDim.new(0,15)
    RightCorner.Parent = RightPanel

    local ModuleScroller = Instance.new("ScrollingFrame")
    ModuleScroller.Size = UDim2.new(1,-10,1,-10)
    ModuleScroller.Position = UDim2.new(0,5,0,5)
    ModuleScroller.BackgroundTransparency = 1
    ModuleScroller.BorderSizePixel = 0
    ModuleScroller.ScrollBarThickness = 6
    ModuleScroller.Parent = RightPanel

    local ModuleLayout = Instance.new("UIListLayout")
    ModuleLayout.Padding = UDim.new(0,5)
    ModuleLayout.Parent = ModuleScroller

    local CurrentCategory = nil

    -- Populate modules dynamically
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
            ModuleFrame.Size = UDim2.new(1,0,0,35)
            ModuleFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
            ModuleFrame.BorderSizePixel = 0
            ModuleFrame.Parent = ModuleScroller

            local moduleCorner = Instance.new("UICorner")
            moduleCorner.CornerRadius = UDim.new(0,10)
            moduleCorner.Parent = ModuleFrame

            -- Module button
            local ModuleButton = Instance.new("TextButton")
            ModuleButton.Size = UDim2.new(1,0,1,0)
            ModuleButton.BackgroundTransparency = 1
            ModuleButton.TextColor3 = Color3.fromRGB(255,255,255)
            ModuleButton.Font = Enum.Font.SourceSansBold
            ModuleButton.TextSize = 18
            ModuleButton.Text = module.name.." ["..(module.settings.Enabled and "ON" or "OFF").."]"
            ModuleButton.Parent = ModuleFrame

            -- Status pill
            local pill = Instance.new("Frame")
            pill.Size = UDim2.new(0,20,0,20)
            pill.Position = UDim2.new(1,-25,0,7)
            pill.BackgroundColor3 = module.settings.Enabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
            pill.BorderSizePixel = 0
            pill.Parent = ModuleFrame

            local pillCorner = Instance.new("UICorner")
            pillCorner.CornerRadius = UDim.new(0,10)
            pillCorner.Parent = pill

            ModuleButton.MouseButton1Click:Connect(function()
                module.settings.Enabled = not module.settings.Enabled
                ModuleButton.Text = module.name.." ["..(module.settings.Enabled and "ON" or "OFF").."]"
                pill.BackgroundColor3 = module.settings.Enabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
                SaveSettings(categoryName.."_"..module.name,module.settings)
            end)

            -- Settings drop-down
            local SettingsOpen = false
            local SettingsFrame = Instance.new("Frame")
            SettingsFrame.Size = UDim2.new(1,0,0,0)
            SettingsFrame.Position = UDim2.new(0,0,0,35)
            SettingsFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
            SettingsFrame.BorderSizePixel = 0
            SettingsFrame.ClipsDescendants = true
            SettingsFrame.Parent = ModuleFrame

            local YOffset = 0
            local SettingButtons = {}

            local function RefreshSettings()
                for _, btn in pairs(SettingButtons) do btn:Destroy() end
                SettingButtons = {}
                YOffset = 0
                for key,value in pairs(module.settings) do
                    if key ~= "Enabled" then
                        local btn = Instance.new("TextButton")
                        btn.Size = UDim2.new(1,0,0,30)
                        btn.Position = UDim2.new(0,0,0,YOffset)
                        btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
                        btn.TextColor3 = Color3.fromRGB(255,255,255)
                        btn.Font = Enum.Font.SourceSans
                        btn.TextSize = 16
                        btn.Text = key.." ["..tostring(value).."]"
                        btn.Parent = SettingsFrame

                        btn.MouseButton1Click:Connect(function()
                            if typeof(module.settings[key])=="boolean" then
                                module.settings[key] = not module.settings[key]
                            end
                            btn.Text = key.." ["..tostring(module.settings[key]).."]"
                            SaveSettings(categoryName.."_"..module.name,module.settings)
                        end)
                        YOffset = YOffset+35
                        table.insert(SettingButtons,btn)
                    end
                end
            end

            RefreshSettings()

            ModuleButton.MouseButton2Click:Connect(function()
                SettingsOpen = not SettingsOpen
                if SettingsOpen then
                    SettingsFrame:TweenSize(UDim2.new(1,0,0,YOffset),"Out","Quad",0.3,true)
                    ModuleFrame.Size = UDim2.new(1,0,0,35+YOffset)
                else
                    SettingsFrame:TweenSize(UDim2.new(1,0,0,0),"Out","Quad",0.3,true)
                    ModuleFrame.Size = UDim2.new(1,0,0,35)
                end
            end)
        end
    end

    -- Category buttons
    for categoryName,_ in pairs(Categories) do
        local CatButton = Instance.new("TextButton")
        CatButton.Size = UDim2.new(1,0,0,40)
        CatButton.BackgroundColor3 = Color3.fromRGB(55,55,55)
        CatButton.TextColor3 = Color3.fromRGB(255,255,255)
        CatButton.Font = Enum.Font.SourceSansBold
        CatButton.TextSize = 18
        CatButton.Text = categoryName
        CatButton.Parent = LeftPanel

        local catCorner = Instance.new("UICorner")
        catCorner.CornerRadius = UDim.new(0,12)
        catCorner.Parent = CatButton

        CatButton.MouseButton1Click:Connect(function()
            PopulateModules(categoryName)
        end)
    end

    -- Select first category automatically
    for firstCat,_ in pairs(Categories) do
        PopulateModules(firstCat)
        break
    end
end

-- ==============================
-- Auto-save every 5 seconds
-- ==============================
local saveInterval = 5
local accumulatedTime = 0
RunService.Heartbeat:Connect(function(dt)
    accumulatedTime = accumulatedTime + dt
    if accumulatedTime >= saveInterval then
        accumulatedTime = 0
        for categoryName,modules in pairs(Categories) do
            for moduleName,module in pairs(modules) do
                SaveSettings(categoryName.."_"..moduleName,module.settings)
            end
        end
    end
end)

-- ==============================
-- Run Everything
-- ==============================
LoadModules()
CreateUI()
print("VainScript Modern UI Loaded!")
