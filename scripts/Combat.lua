-- combat.lua
-- Verantwortlich für Aim Assist / Combat-Logik

local Combat = _G.Vain.Combat
local Config = _G.Vain.Config

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// GET NEAREST VALID PLAYER
local function getNearestPlayer()
	local closest = nil
	local minDist = Config.Settings.AIM_ASSIST.MAX_DISTANCE

	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
		return nil
	end

	local camPos = camera.CFrame.Position
	local lookDir = camera.CFrame.LookVector

	for _, p in ipairs(Players:GetPlayers()) do
		if p == player then continue end
		if p.Team and player.Team and p.Team == player.Team then continue end

		local char = p.Character
		if not char then continue end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum or hum.Health <= 0 then continue end

		local dist = (hrp.Position - camPos).Magnitude
		if dist < 5 or dist > Config.Settings.AIM_ASSIST.MAX_DISTANCE then continue end

		local dir = (hrp.Position - camPos).Unit
		local angle = math.deg(math.acos(math.clamp(lookDir:Dot(dir), -1, 1)))

		if angle <= Config.Settings.AIM_ASSIST.MAX_ANGLE and dist < minDist then
			minDist = dist
			closest = p
		end
	end

	return closest
end

--// AIM ASSIST LOOP
RunService.Heartbeat:Connect(function()
	if not Config.Settings.AIM_ASSIST.ENABLED then return end

	local target = getNearestPlayer()
	if not target then return end

	local char = target.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local targetCF = CFrame.new(camera.CFrame.Position, hrp.Position)
	camera.CFrame = camera.CFrame:Lerp(
		targetCF,
		Config.Settings.AIM_ASSIST.SMOOTHNESS
	)
end)

--// KEYBIND TOGGLE (Q)
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Config.Settings.KEY_AIM_TOGGLE then
		Config.Settings.AIM_ASSIST.ENABLED = not Config.Settings.AIM_ASSIST.ENABLED
	end
end)
