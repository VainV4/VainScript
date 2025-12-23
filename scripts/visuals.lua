-- support.lua

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local TARGET_INSTANCE_NAME = "TargetPart"

local Beam, Attach0, Attach1

function _G.App.Visuals.EnableBeam()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	local target = workspace:FindFirstChild(TARGET_INSTANCE_NAME)
	if not target or not target:IsA("BasePart") then
		warn("Target not found:", TARGET_INSTANCE_NAME)
		return
	end

	Attach0 = Instance.new("Attachment")
	Attach0.Parent = hrp

	Attach1 = Instance.new("Attachment")
	Attach1.Parent = target

	Beam = Instance.new("Beam")
	Beam.Attachment0 = Attach0
	Beam.Attachment1 = Attach1
	Beam.Width0 = 0.15
	Beam.Width1 = 0.15
	Beam.Color = ColorSequence.new(Color3.fromRGB(0, 170, 255))
	Beam.Parent = hrp
end

function _G.App.Visuals.DisableBeam()
	if Beam then Beam:Destroy() end
	if Attach0 then Attach0:Destroy() end
	if Attach1 then Attach1:Destroy() end
	Beam, Attach0, Attach1 = nil, nil, nil
end
