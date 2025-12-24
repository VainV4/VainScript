local Combat = _G.Vain.Combat
local Config = _G.Vain.Config

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local function getNearestPlayer()
	-- dein getNearestPlayer Code
end

RunService.Heartbeat:Connect(function()
	if Config.Settings.AIM_ASSIST.ENABLED then
		local target = getNearestPlayer()
		if target and target.Character then
			local hrp = target.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				camera.CFrame = camera.CFrame:Lerp(
					CFrame.new(camera.CFrame.Position, hrp.Position),
					Config.Settings.AIM_ASSIST.SMOOTHNESS
				)
			end
		end
	end
end)
