local wezterm = require("wezterm")
local config = {}
local target = wezterm.target_triple

-- OldWorld Theme
config.colors = {
	-- --- Base colors ---
	foreground = "#C9C7CD", -- na: main text (light gray)
	background = "#131314", -- bl: dark background (almost black)

	-- --- Cursor colors ---
	cursor_bg = "#92A2D5", -- ca: blue lavender (cursor background)
	cursor_fg = "#C9C7CD", -- na: main text (cursor foreground)
	cursor_border = "#92A2D5", -- ca: blue lavender (cursor border)

	-- --- Selection colors ---
	selection_fg = "#C9C7CD", -- na: main text (selection foreground)
	selection_bg = "#3B4252", -- gr: dark gray (selection background)

	-- --- UI colors ---
	scrollbar_thumb = "#4C566A", -- nb: medium gray (scrollbar thumb)
	split = "#4C566A", -- nb: medium gray (split line)

	-- --- ANSI colors ---
	ansi = {
		"#000000", -- Black: bl: dark background (almost black)
		"#EA83A5", -- Red: ia: intense pink (errors)
		"#90B99F", -- Green: va: soft green (success)
		"#E6B99D", -- Yellow: ca: beige (warnings)
		"#85B5BA", -- Blue: va: light blue-green (information)
		"#92A2D5", -- Magenta: ca: blue lavender (highlight)
		"#85B5BA", -- Cyan: va: light blue-green (links)
		"#C9C7CD", -- White: na: main text (light gray)
	},

	-- --- Bright ANSI colors ---
	brights = {
		"#4C566A", -- Bright Black: nb: medium gray (bright black)
		"#EA83A5", -- Bright Red: ia: intense pink (bright red)
		"#90B99F", -- Bright Green: va: soft green (bright green)
		"#E6B99D", -- Bright Yellow: ca: beige (bright yellow)
		"#85B5BA", -- Bright Blue: va: light blue-green (bright blue)
		"#92A2D5", -- Bright Magenta: ca: blue lavender (bright magenta)
		"#85B5BA", -- Bright Cyan: va: light blue-green (bright cyan)
		"#C9C7CD", -- Bright White: na: main text (bright white)
	},

	-- --- Indexed colors ---
	indexed = {
		[16] = "#F5A191", -- ca: light peach (orange)
		[17] = "#E29ECA", -- ia: soft pink (pink)
	},
}

config.enable_tab_bar = false
config.font_size = 14.0
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.macos_window_background_blur = 20

config.window_background_image_hsb = {
	brightness = 0.01,
	hue = 1.0,
	saturation = 0.5,
}

config.window_background_opacity = 0.92
config.window_decorations = "RESIZE"
config.max_fps = 240

-- Definición de teclas/
config.keys = {
	{
		key = "f",
		mods = "CTRL",
		action = wezterm.action.ToggleFullScreen,
	},
}

-- Bindings del mouse
config.mouse_bindings = {
	-- Ctrl + click abrirá el enlace bajo el cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-- Configuraciones adicionales
if target == "x86_64-pc-windows-msvc" or target:find("wsl") then
	config.font_size = 12.0
	config.default_domain = "WSL:Ubuntu"
	config.front_end = "OpenGL"
	config.win32_system_backdrop = "Acrylic"
	local gpus = wezterm.gui.enumerate_gpus()
	if #gpus > 0 then
		for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
			if gpu.backend == "Vulkan" and gpu.device_type == "IntegratedGpu" then
				config.webgpu_preferred_adapter = gpu
				config.front_end = "WebGpu"
				break
			end
		end

		return config
	else
		-- Se usa la configuración por defecto o se registra un mensaje
		wezterm.log_info("No GPUs found, using default settings")
	end
end

return config
