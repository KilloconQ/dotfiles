local wezterm = require("wezterm")
local config = {}
local target = wezterm.target_triple

-- Esquema de colores y apariencia
config.color_scheme = "Catppuccin Mocha"
config.enable_tab_bar = false
config.font_size = 10.0
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.macos_window_background_blur = 20
config.win32_system_backdrop = "Tabbed"

config.window_background_image_hsb = {
	brightness = 0.01,
	hue = 1.0,
	saturation = 0.5,
}

config.window_background_opacity = 0.92
config.window_decorations = "RESIZE"
config.max_fps = 240

-- Definición de teclas
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
if target == "x86_64-pc-windows-msvc" then
	config.default_domain = "WSL:Ubuntu"
	config.front_end = "OpenGL"

	local gpus = wezterm.gui.enumerate_gpus()
	if #gpus > 0 then
		config.webgpu_preferred_adapter = gpus[1] -- se utiliza el primer GPU disponible
	else
		-- Se usa la configuración por defecto o se registra un mensaje
		wezterm.log_info("No GPUs found, using default settings")
	end
elseif target == "x86_64-apple-darwin" or target == "aarch64-apple-darwin" then
	config.front_end = "Metal"

	local gpus = wezterm.gui.enumerate_gpus()
	if #gpus > 0 then
		config.webgpu_preferred_adapter = gpus[1] -- se utiliza el primer GPU disponible
	else
		-- Se usa la configuración por defecto o se registra un mensaje
		wezterm.log_info("No GPUs found, using default settings")
	end
end

return config
