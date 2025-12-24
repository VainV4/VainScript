-- UI.lua
local UI = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

function UI.Init(config)
	local player = Players.LocalPlayer

	-- ScreenGui, Blur, MainContainer, Sidebar, Content
	-- 🔥 exakt dein Code, nur in diese Funktion verschoben
end

function UI.CreateCategory(name)
	-- dein CreateCategory Code
end

function UI.CreateToggle(parent, text, default, callback)
	-- dein CreateToggle Code
end

function UI.CreateSlider(parent, text, min, max, default, callback)
	-- dein CreateSlider Code
end

function UI.CreateColorPicker(parent, text, defaultColor, callback)
	-- dein CreateColorPicker Code
end

return UI
