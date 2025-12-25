--========================================
-- Vain Script Hub (Full Enhanced Edition)
--========================================

-- Services
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Config
local BASE_URL = "https://raw.githubusercontent.com/VainV4/VainScript/main/"
local REGISTRY_FILE = "modules.json"

--========================================
-- Helpers
--========================================

local function Tween(obj, info, goal)
    local t = TweenService:Create(obj, info, goal)
    t:Play()
    return t
end

local function Gradient(parent, c1, c2)
    local g = Instance.new("UIGradient", parent)
    g.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,c1), ColorSequenceKeypoint.new(1,c2)}
    g.Rotation = 90
    return g
end

-- Settings storage
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

-- Load Registry
local Registry = {}
pcall(function()
    Registry = HttpService:JSONDecode(game:HttpGet(BASE_URL..REGISTRY_FILE .. "?t="..os.clock()))
end)

--========================================
-- UI Elements
--========================================

local function CreateToggle(parent, module, category)
    local bg = Instance.new("Frame", parent)
    bg.Size = UDim2.new(0,46,0,24)
    bg.Position = UDim2.new(1,-60,0.5,-12)
    bg.BackgroundColor3 = module.Settings.Enabled and Color3.fromRGB(0,160,120) or Color3.fromRGB(40,40,40)
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", bg)
    knob.Size = UDim2.new(0,18,0,18)
    knob.Position = module.Settings.Enabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local click = Instance.new("TextButton", bg)
    click.Size = UDim2.new(1,0,1,0)
    click.Text = ""
    click.BackgroundTransparency = 1

    local function Refresh()
        Tween(bg, TweenInfo.new(0.25), {BackgroundColor3 = module.Settings.Enabled and Color3.fromRGB(0,160,120) or Color3.fromRGB(40,40,40)})
        Tween(knob, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Position = module.Settings.Enabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)})
    end
    Refresh()

    click.MouseButton1Click:Connect(function()
        module.Settings.Enabled = not module.Settings.Enabled
        SaveSettings(category.."_"..module.Name,module.Settings)
        if module.Run then task.spawn(module.Run,module.Settings) end
        Refresh()
    end)
end

local function CreateSlider(parent,labelText,min,max,settingTable,key)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,-20,0,42)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,0,0,16)
    label.Text = labelText..": "..settingTable[key]
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local bar = Instance.new("Frame", frame)
    bar.Position = UDim2.new(0,0,0,24)
    bar.Size = UDim2.new(1,0,0,8)
    bar.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Instance.new("UICorner", bar)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((settingTable[key]-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(0,140,255)
    Instance.new("UICorner", fill)
    Gradient(fill, Color3.fromRGB(0,170,255), Color3.fromRGB(0,90,255))

    local dragging = false
    local function Update(x)
        local p = math.clamp((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
        local val = math.floor(min+(max-min)*p)
        settingTable[key] = val
        label.Text = labelText..": "..val
        Tween(fill, TweenInfo.new(0.1), {Size = UDim2.new(p,0,1,0)})
    end

    bar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            Update(i.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
            Update(i.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
end

--========================================
-- Main UI
--========================================

local uiVisible = true
UserInputService.InputBegan:Connect(function(input,gp)
    if not gp and input.KeyCode==Enum.KeyCode.RightShift then
        uiVisible = not uiVisible
        if CoreGui:FindFirstChild("VainUI") then
            CoreGui.VainUI.Enabled = uiVisible
        end
    end
end)

local function CreateUI()
    if CoreGui:FindFirstChild("VainUI") then CoreGui.VainUI:Destroy() end

    local gui = Instance.new("ScreenGui",CoreGui)
    gui.Name="VainUI"

    local main = Instance.new("Frame", gui)
    main.Size=UDim2.new(0,760,0,480)
    main.Position=UDim2.new(0.5,0,0.5,0)
    main.AnchorPoint=Vector2.new(0.5,0.5)
    main.BackgroundColor3=Color3.fromRGB(18,18,18)
    Instance.new("UICorner", main).CornerRadius=UDim.new(0,14)
    Gradient(main,Color3.fromRGB(22,22,22),Color3.fromRGB(14,14,14))

    local sidebar = Instance.new("Frame", main)
    sidebar.Size=UDim2.new(0,180,1,0)
    sidebar.BackgroundColor3=Color3.fromRGB(20,20,20)
    Instance.new("UICorner", sidebar).CornerRadius=UDim.new(0,14)

    local sidebarLayout = Instance.new("UIListLayout", sidebar)
    sidebarLayout.Padding=UDim.new(0,8)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local content = Instance.new("ScrollingFrame", main)
    content.Position = UDim2.new(0,190,0,16)
    content.Size = UDim2.new(1,-206,1,-32)
    content.ScrollBarThickness = 3
    content.BackgroundTransparency = 1

    local contentLayout = Instance.new("UIListLayout", content)
    contentLayout.Padding = UDim.new(0,10)

    -- Auto-update CanvasSize
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0,0,0,contentLayout.AbsoluteContentSize.Y+10)
    end)

    -- Load Modules
    local Modules = {}
    for cat,mods in pairs(Registry) do
        Modules[cat]={}
        for name,path in pairs(mods) do
            local ok,mod = pcall(function() return loadstring(game:HttpGet(BASE_URL..path))() end)
            if ok and mod then
                mod.Settings = LoadSettings(cat.."_"..name)
                if mod.Settings.Enabled==nil then mod.Settings.Enabled=false end
                Modules[cat][name] = mod
                mod.Name = name
            end
        end
    end

    -- Load Category Function
    local function LoadCategory(cat)
        content:ClearAllChildren()
        contentLayout.Parent = content
        content.CanvasPosition = Vector2.new(0,0)

        for _,mod in pairs(Modules[cat]) do
            local card = Instance.new("Frame", content)
            card.Size = UDim2.new(1,0,0,54)
            card.BackgroundColor3 = Color3.fromRGB(26,26,26)
            Instance.new("UICorner", card).CornerRadius=UDim.new(0,10)

            local title = Instance.new("TextButton", card)
            title.Position=UDim2.new(0,14,0,0)
            title.Size=UDim2.new(0.5,0,1,0)
            title.Text=mod.Name
            title.TextColor3=Color3.new(1,1,1)
            title.Font=Enum.Font.GothamMedium
            title.TextSize=15
            title.BackgroundTransparency=1
            title.TextXAlignment=Enum.TextXAlignment.Left

            -- Module toggle
            CreateToggle(card,mod,cat)

            -- Dropdown frame
            local settingsFrame = Instance.new("Frame", card)
            settingsFrame.Position = UDim2.new(0,0,1,4)
            settingsFrame.Size = UDim2.new(1,0,0,0)
            settingsFrame.BackgroundTransparency = 1
            settingsFrame.ClipsDescendants = true

            local settingsLayout = Instance.new("UIListLayout", settingsFrame)
            settingsLayout.Padding = UDim.new(0,4)

            -- Expand / collapse signal
            local expanded = false
            settingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if expanded then
                    Tween(settingsFrame, TweenInfo.new(0.2,Enum.EasingStyle.Quad), {Size=UDim2.new(1,0,0,settingsLayout.AbsoluteContentSize.Y)})
                end
            end)

            -- Fill settings dynamically
            for key,value in pairs(mod.Settings) do
                if type(value)=="boolean" then
                    local frame = Instance.new("Frame", settingsFrame)
                    frame.Size = UDim2.new(1,0,0,28)
                    frame.BackgroundTransparency = 1
                    local lbl = Instance.new("TextLabel", frame)
                    lbl.Text = key
                    lbl.Size = UDim2.new(0.6,0,1,0)
                    lbl.TextColor3 = Color3.new(1,1,1)
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.Font = Enum.Font.Gotham
                    lbl.TextSize = 13
                    lbl.BackgroundTransparency = 1
                    CreateToggle(frame,{Settings=mod.Settings,Name=key},cat)
                elseif type(value)=="number" then
                    CreateSlider(settingsFrame,key,0,100,mod.Settings,key)
                end
            end

            -- Expand/collapse
            title.MouseButton1Click:Connect(function()
                expanded = not expanded
                local goal = expanded and settingsLayout.AbsoluteContentSize.Y or 0
                Tween(settingsFrame,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(1,0,0,goal)})
            end)
        end
    end

    -- Sidebar buttons
    for cat in pairs(Modules) do
        local btn = Instance.new("TextButton", sidebar)
        btn.Size = UDim2.new(0.9,0,0,40)
        btn.Text = cat
        btn.TextColor3 = Color3.fromRGB(220,220,220)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 15
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        Instance.new("UICorner", btn)

        btn.MouseButton1Click:Connect(function()
            LoadCategory(cat)
        end)
    end

    -- Load first category by default
    for first in pairs(Modules) do
        LoadCategory(first)
        break
    end
end

CreateUI()
