local Config = _G.Vain.Config

Config.Settings = {
	METAL_ESP = { ENABLED = false, COLOR = Color3.fromRGB(0,170,255) },
	BEE_ESP   = { ENABLED = false, COLOR = Color3.fromRGB(255,214,6) },
	STAR_ESP  = { ENABLED = false, COLOR = Color3.fromRGB(255,255,255) },
	TREE_ESP  = { ENABLED = false, COLOR = Color3.fromRGB(255,100,0) },

	AIM_ASSIST = {
		ENABLED = false,
		SMOOTHNESS = 0.15,
		MAX_DISTANCE = 94,
		MAX_ANGLE = 90
	},

	UI_COLOR = Color3.fromRGB(12,12,14),
	KEY_UI_TOGGLE = Enum.KeyCode.RightShift,
	KEY_AIM_TOGGLE = Enum.KeyCode.Q,
	VISIBLE = true
}

Config.ActiveObjects = {
	metal = {},
	star = {},
	tree = {},
	bee = {}
}
