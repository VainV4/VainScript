--// Simple Roblox UI Framework (Single Script Template)
--// Place in StarterPlayerScripts (LocalScript)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

--// UI LIBRARY
local UILibrary = {}
UILibrary.Categories = {}

--// ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomUILibrary"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

--// Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromScale(0.5, 0.6)
MainFrame.Position = UDim2.fromScale(0.25, 0.2)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

--// UI Layout
local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 12)

--// Category Holder
local CategoryHolder = Instance.new("Frame")
CategoryHolder.Size = UDim2.fromScale(0.25, 1)
CategoryHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CategoryHolder.Parent = MainFrame

local CategoryLayout = Instance.new("UIListLayout", CategoryHolder)
CategoryLayout.Padding = UDim.new(0, 6)

--// Content Holder
local ContentHolder = Instance.new("Frame")
ContentHolder.Position = UDim2.fromScale(0.25, 0)
ContentHolder.Size = UDim2.fromScale(0.75, 1)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Parent = MainFrame

--------------------------------------------------
-- CATEGORY CREATION
--------------------------------------------------
function UILibrary:CreateCategory(name)
	local Category = {}
	
	-- Button
	local Button = Instance.new("TextButton")
	Button.Text = name
	Button.Size = UDim2.new(1, -10, 0, 40)
	Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.Parent = CategoryHolder
	
	local Corner = Instance.new("UICorner", Button)
	
	-- Page
	local Page = Instance.new("ScrollingFrame")
	Page.Size = UDim2.fromScale(1, 1)
	Page.CanvasSize = UDim2.new(0, 0, 0, 0)
	Page.ScrollBarImageTransparency = 1
	Page.Visible = false
	Page.Parent = ContentHolder
	
	local Layout = Instance.new("UIListLayout", Page)
	Layout.Padding = UDim.new(0, 8)
	
	-- Switch page
	Button.MouseButton1Click:Connect(function()
		for _, cat in pairs(UILibrary.Categories) do
			cat.Page.Visible = false
		end
		Page.Visible = true
	end)
	
	Category.Page = Page
	
	--------------------------------------------------
	-- TOGGLE
	--------------------------------------------------
	function Category:CreateToggle(text, callback)
		local Toggle = false
		
		local Button = Instance.new("TextButton")
		Button.Text = text .. " : OFF"
		Button.Size = UDim2.new(1, -12, 0, 35)
		Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		Button.TextColor3 = Color3.new(1,1,1)
		Button.Parent = Page
		
		Button.MouseButton1Click:Connect(function()
			Toggle = not Toggle
			Button.Text = text .. (Toggle and " : ON" or " : OFF")
			callback(Toggle)
		end)
	end
	
	--------------------------------------------------
	-- SLIDER
	--------------------------------------------------
	function Category:CreateSlider(text, min, max, default, callback)
		local Value = default
		
		local Frame = Instance.new("Frame")
		Frame.Size = UDim2.new(1, -12, 0, 45)
		Frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
		Frame.Parent = Page
		
		local Label = Instance.new("TextLabel")
		Label.Text = text .. ": " .. Value
		Label.Size = UDim2.fromScale(1, 0.5)
		Label.BackgroundTransparency = 1
		Label.TextColor3 = Color3.new(1,1,1)
		Label.Parent = Frame
		
		local Slider = Instance.new("TextButton")
		Slider.Text = ""
		Slider.Size = UDim2.fromScale(1, 0.3)
		Slider.Position = UDim2.fromScale(0, 0.6)
		Slider.BackgroundColor3 = Color3.fromRGB(70,70,70)
		Slider.Parent = Frame
		
		Slider.MouseButton1Down:Connect(function()
			local MoveConn
			MoveConn = UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					local Scale = math.clamp(
						(input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X,
						0, 1
					)
					Value = math.floor(min + (max - min) * Scale)
					Label.Text = text .. ": " .. Value
					callback(Value)
				end
			end)
			
			UserInputService.InputEnded:Wait()
			MoveConn:Disconnect()
		end)
	end
	
	--------------------------------------------------
	-- DROPDOWN
	--------------------------------------------------
	function Category:CreateDropdown(text, options, callback)
		local Button = Instance.new("TextButton")
		Button.Text = text
		Button.Size = UDim2.new(1, -12, 0, 35)
		Button.BackgroundColor3 = Color3.fromRGB(50,50,50)
		Button.TextColor3 = Color3.new(1,1,1)
		Button.Parent = Page
		
		Button.MouseButton1Click:Connect(function()
			for _, option in ipairs(options) do
				callback(option)
				break
			end
		end)
	end
	
	table.insert(UILibrary.Categories, Category)
	return Category
end

--------------------------------------------------
-- EXAMPLE USAGE
--------------------------------------------------
local Combat = UILibrary:CreateCategory("Combat")
Combat:CreateToggle("KillAura", function(state)
	print("KillAura:", state)
end)

Combat:CreateSlider("Range", 1, 20, 5, function(value)
	print("Range:", value)
end)

local Visuals = UILibrary:CreateCategory("Visuals")
Visuals:CreateToggle("ESP", function(state)
	print("ESP:", state)
end)

Visuals:CreateDropdown("Theme", {"Dark", "Light"}, function(option)
	print("Theme:", option)
end)
