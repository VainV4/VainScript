local BASE_URL = "https://raw.githubusercontent.com/vmopds/VainV3/main/scripts/"

local function Load(file)
	local url = BASE_URL .. file

	local ok, res = pcall(game.HttpGet, game, url)
	if not ok then
		warn("[Loader] Failed:", file)
		return
	end

	local fn, err = loadstring(res)
	if not fn then
		warn("[Loader] Compile error:", file, err)
		return
	end

	local ran, runtimeErr = pcall(fn)
	if not ran then
		warn("[Loader] Runtime error:", file, runtimeErr)
	end
end

-- LOAD ORDER (IMPORTANT)
Load("ui.lua")
Load("combat.lua")
Load("support.lua")
Load("misc.lua")
