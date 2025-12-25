-- VainScript LocalScript Loader
-- All modules and GUI are client-side

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- -------------------------
-- Persistence (Executor only)
-- -------------------------
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

-- -------------------------
-- Categories & Modules
-- -------------------------
local Categories = {}

-- -------------------------
-- UI Toggle
-- -------------------------
local uiVisible = true
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        uiVisible = not uiVisible
        if MainFrame then
            MainFrame.Visible = uiVisible
        end
    end
end)

-- -------------------------
-- Dynamic Module Loader
-- -------------------------
local function LoadModules()
    local scriptFolder = "scripts"  -- relative folder
    local function LoadFolder(path)
        local success, files = pcall(function()
            return listfiles(path)  -- executor-only function
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

                    -- Load settings
                    local defaultSettings = moduleFunc.DefaultSettings or {Enabled = true}
                    local savedSettings = LoadSettings(category .. "_" .. moduleName)
                    local settings = {}
                    for k, v in pairs(defaultSettings) do
                        settings[k] = savedSettings[k] ~= nil and savedSettings[k] or v
                    end

                    -- Register
                    Categories[category] = Categories[category] or {}
                    Categories[category][moduleName] = {
                        name = moduleName,
                        settings = settings,
                        init = moduleFunc
                    }

                    -- Run module safely in a coroutine
                    coroutine.wrap(function()
                        moduleFunc(settings)
                    end)()
                end
            elseif file:sub(-1) == "/" then
                LoadFolder(file)  -- recursive
            end
        end
    end
    LoadFolder(scriptFolder)
end

-- -------------------------
-- UI Creation
-- -------------------------
local function CreateUI()
    local CoreGui = game:GetService("CoreGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VainScriptUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = uiVisible
    MainFrame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Title.Text = "VainScript"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 20
    Title.Parent = MainFrame

    local Scroller = Instance.new("ScrollingFrame")
    Scroller.Size = UDim2.new(1, -10, 1, -40)
    Scroller.Position = UDim2.new(0, 5, 0, 35)
    Scroller.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroller.ScrollBarThickness = 6
    Scroller.BackgroundTransparency = 1
    Scroller.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = Scroller

    -- Module buttons
    local function CreateToggle(module)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 25)
        Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.SourceSans
        Button.TextSize = 18
        Button.Text = module.name .. " [" .. (module.settings.Enabled and "ON" or "OFF") .. "]"
        Button.Parent = Scroller

        Button.MouseButton1Click:Connect(function()
            module.settings.Enabled = not module.settings.Enabled
            Button.Text = module.name .. " [" .. (module.settings.Enabled and "ON" or "OFF") .. "]"
            SaveSettings(module.name, module.settings)
        end)
    end

    -- Populate UI dynamically
    for categoryName, modules in pairs(Categories) do
        local CatLabel = Instance.new("TextLabel")
        CatLabel.Size = UDim2.new(1, 0, 0, 25)
        CatLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        CatLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        CatLabel.Font = Enum.Font.SourceSansBold
        CatLabel.TextSize = 18
        CatLabel.Text = categoryName
        CatLabel.Parent = Scroller

        for _, module in pairs(modules) do
            CreateToggle(module)
        end
    end
end

-- -------------------------
-- Run Everything
-- -------------------------
LoadModules()
CreateUI()
print("VainScript (LocalScript) loaded! Categories and modules:")
for cat, mods in pairs(Categories) do
    print("-", cat)
    for modName, _ in pairs(mods) do
        print("   -", modName)
    end
end
