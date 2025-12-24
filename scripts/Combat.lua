-- combat.lua
-- Aim Assist (Luau-kompatibel)

local Combat = _G.Vain.Combat
local Config = _G.Vain.Config

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// GET NEAREST PLAYER
local function getNearestPlayer()
	local closest = nil
	local minDist = Config.Settings.AIM_ASSIST.MAX_DISTANCE

	if not player.Character then return nil end
	local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
	if not myHRP then return nil end

	local camPos = camera.CFrame.Position
	local lookDir = camera.CFrame.LookVector

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			if not (p.Team and player.Team and p.Team == player.Team) then
				local char = p.Character
				if char then
					local hrp = char:FindFirstChild("HumanoidRootPart")
					local hum = char:FindFirstChildOfClass("Humanoid")

					if hrp and hum and hum.Health > 0 then
						local dist = (hrp.Position - camPos).Magnitude
						if dist >= 5 and dist <= Config.Settings.AIM_ASSIST.MAX_DISTANCE then
							local dir = (hrp.Position - camPos).Unit
							local dot = math.clamp(lookDir:Dot(dir), -1, 1)
							local angle = math.deg(math.acos(dot))

							if angle <= Config.Settings.AIM_ASSIST.MAX_ANGLE then
								if dist < minDist then
									minDist = dist
									closest = p
								end
							end
						end
					end
				end
			end
		end
	end

	return closest
end

--// AIM ASSIST LOOP
RunService.Heartbeat:Connect(function()
	if not Config.Settings.AIM_ASSIST.ENABLED then return end

	local target = getNearestPlayer()
	if not target or not target.Character then return end

	local hrp = target.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local targetCF = CFrame.new(camera.CFrame.Position, hrp.Position)
	camera.CFrame = camera.CFrame:Lerp(
		targetCF,
		Config.Settings.AIM_ASSIST.SMOOTHNESS
	)
end)

--// KEYBIND (Q)
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Config.Settings.KEY_AIM_TOGGLE then
		Config.Settings.AIM_ASSIST.ENABLED = not Config.Settings.AIM_ASSIST.ENABLED
	end
end)
