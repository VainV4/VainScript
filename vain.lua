-- bootstrap.lua

_G.App = {
	_G.App.Visuals = _G.App.Visuals or {}
}

local BASE = "https://raw.githubusercontent.com/VainV4/VainScript/main/scripts/"

local function Load(file)
	local src = game:HttpGet(BASE .. file)
	local fn, err = loadstring(src)
	if not fn then
		warn("Compile error:", file, err)
		return
	end
	pcall(fn)
end

-- LOAD ORDER MATTERS
Load("support.lua") -- logic FIRST
Load("ui.lua")      -- UI AFTER
