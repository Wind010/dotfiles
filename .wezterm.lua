-- Pull in the wezterm API
local wezterm = require("wezterm")

local mux = wezterm.mux
local act = wezterm.action
local config = {}
local keys = {}
local mouse_bindings = {}
local launch_menu = {}

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Detect if Windows
local path_separator = package.config:sub(1, 1)
if path_separator == "\\" then
	print("On Windows 🪟")
	config.default_prog = { "pwsh.exe", "-NoLogo" }

	table.insert(launch_menu, {
		label = "PowerShell",
		args = { "pwsh.exe", "-NoLogo" },
	})
	table.insert(launch_menu, {
		label = "WSL",
		args = { "wsl.exe" },
	})
	table.insert(launch_menu, {
		label = "CMD",
		args = { "cmd.exe" },
	})

	mouse_bindings = {
		{
			event = { Down = { streak = 3, button = "Left" } },
			action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
			mods = "NONE",
		},
	}
else
	-- Use default shell.  Should be ZSH on MacOS or Linux
	print("Running on a Unix-like system (macOS or Linux)")
	table.insert(launch_menu, {
		label = "Pwsh",
		args = { "/usr/local/bin/pwsh", "-NoLogo" },
	})
end

wezterm.on("leader-key", function(leader_opts)
	-- optional leader key logic
end)

keys = {
	{ key = "q", mods = "ALT", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
	{ key = "t", mods = "ALT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },

	x,
}

-- Set the default window size (e.g., 80 columns wide and 24 rows high)
config.initial_cols = 80
config.initial_rows = 24

-- This is where you actually apply your config choices
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

--config.color_scheme = 'AdventureTime'

--config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 12

config.enable_tab_bar = true
config.launch_menu = launch_menu
config.default_cursor_style = "BlinkingBlock"

config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.8
-- config.macos_window_background_blur = 10

config.keys = keys
config.mouse_bindings = mouse_bindings

-- Finally, return the configuration to wezterm and set default shell.
return config

