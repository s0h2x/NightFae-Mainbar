local addon, nf = ...
local name = GetAddOnInfo(addon, 'name')
local path = 'Interface\\AddOns\\'..name..'\\media\\'

-- config
nf.Config = {

	global = {
		range = true,		-- show range color buttons 
		gryphons = false,	-- show gryphons art
		barstyle = true,	-- button borders, colors, background and icon coords
		stancebar = true,	-- show stancebar
		hotkey = true,		-- show hotkey name
		macro = true,		-- show macro name
		count = true,		-- show item count
		showexpbar = true,	-- show experience\reputation bars
	},
	
	size = {
		mainbar = .94,		-- mainbar scale
		petbar = 1,			-- petbar scale
		stancebar = 1,		-- stancebar scale
		vehicle = 1,		-- vehicle scale (stop flying the gryphone)
		hotkey = 16,		-- hotkey font size
		macro = 14,			-- macro font size
		count = 14,			-- count font size
	},
	
	fade = {
		expbar = true,		-- experience text hover fade
		repbar = true,		-- reputation text hover fade
		leftbar = false,	-- leftbar hover fade
		rightbar = false,	-- rightbar hover fade
		petbar = true,		-- petbar hover fade
		stancebar = false,	-- stancebar hover fade
		bottomleftbar = false,	
		bottomrightbar = true,
		
		-- 0.00 to 1
		alpha = {
			minimal = 0.3,	-- start alpha
			leftbar = 1,	
			rightbar = 1,
			petbar = .8,
			stancebar = 1,
			bottomleftbar = 1,
			bottomrightbar = 1,
		},
	},

	direction = {
		horizontal = {
			leftbar = false,
			rightbar = false,
		},
		vertical = {
			petbar = false,
			bottomrightbar = false,
			bottomrightbar_right = false,
		},
	},
	
	-- R, G, B
	colors = {
		normal = {.80, .80, 1},-- .90, .90, .98 | .94, .87, .80
		isequipped = {0, 1, 0},
		notusable = {.35, .35, .35},
		rangeout = {.9, 0, 0},
		rangemana = {.3, .3, 1},
		hotkey = {.6, .6, .6},
		macro = {1, .85, .73},
		count = {1, 1, 1},
	},
	
	-- media
	assets = {
		font = path..'font.ttf',
		bg = path..'UIFrameNightFaeSmall',
		cast = path..'castbar',
		button = path..'buttonbg',
		normal = path..'default',
		active = path..'active',
		pushed = path..'pushed',
	},
	
	move_buttons = false,
}