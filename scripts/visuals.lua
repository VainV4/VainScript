-- visuals.lua
_G.App.Visuals = _G.App.Visuals or {}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Store active beams in a table keyed by category name
local ActiveBeams = {} 

function _G.App.Visuals.EnableBeam(category, targetName)
    -- Clean up existing beam for this category if it exists
    if ActiveBeams[category] then
        _G.App.Visuals.DisableBeam(category)
    end

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Find all targets or a specific target
    -- For "all beams in a category", you might want to loop through workspace
    -- This example looks for a specific instance name provided by the UI
    local target = workspace:FindFirstChild(targetName)
    
    if not target or not target:IsA("BasePart") then
        warn("Target not found for category " .. category .. ":", targetName)
        return
    end

    local beamData = {}
    
    beamData.Attach0 = Instance.new("Attachment")
    beamData.Attach0.Name = category .. "Attach0"
    beamData.Attach0.Parent = hrp

    beamData.Attach1 = Instance.new("Attachment")
    beamData.Attach1.Name = category .. "Attach1"
    beamData.Attach1.Parent = target

    beamData.Beam = Instance.new("Beam")
    beamData.Beam.Name = category .. "Beam"
    beamData.Beam.Attachment0 = beamData.Attach0
    beamData.Beam.Attachment1 = beamData.Attach1
    beamData.Beam.Width0 = 0.15
    beamData.Beam.Width1 = 0.15
    beamData.Beam.Color = ColorSequence.new(Color3.fromRGB(0, 170, 255))
    beamData.Beam.Parent = hrp

    ActiveBeams[category] = beamData
end

function _G.App.Visuals.DisableBeam(category)
    local data = ActiveBeams[category]
    if data then
        if data.Beam then data.Beam:Destroy() end
        if data.Attach0 then data.Attach0:Destroy() end
        if data.Attach1 then data.Attach1:Destroy() end
        ActiveBeams[category] = nil
    end
end
