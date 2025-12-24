local UI = _G.Vain.UI
local Config = _G.Vain.Config
local Visuals = _G.Vain.Visuals

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

CreateToggle(VisualsPanel, "Metal ESP", false, function(v)
	Config.Settings.METAL_ESP.ENABLED = v
	Visuals.Toggle("metal", v)
end)

CreateToggle(CombatPanel, "Aim Assist (Q)", false, function(v)
	Config.Settings.AIM_ASSIST.ENABLED = v
end)

return UI
