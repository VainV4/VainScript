-- MetalESP.lua
-- Category: Visuals
-- This module demonstrates a dynamic module with settings

local module = {}

-- Default settings
module.DefaultSettings = {
    Enabled = true,
    ShowBeams = true,
    ShowDistance = false
}

-- Module function (runs when loaded)
return function(settings)
    -- For demonstration, print every 2 seconds
    spawn(function()
        while true do
            if settings.Enabled then
                print("[MetalESP] Enabled")
                print("ShowBeams:", settings.ShowBeams)
                print("ShowDistance:", settings.ShowDistance)
            end
            wait(2)
        end
    end)
end
