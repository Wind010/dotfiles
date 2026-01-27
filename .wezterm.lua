-- Pull in the wezterm API
local wezterm = require("wezterm")

local mux = wezterm.mux
local act = wezterm.action
local config = wezterm.config_builder()  -- This will hold the configuration.
local keys = {}
local mouse_bindings = {}
local launch_menu = {}

-- Plugins
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

-- Periodic saving (Fixed the typo here)
resurrect.state_manager.periodic_save()

-- Automatic restore on startup (Moved to state_manager)
wezterm.on("gui-startup", function(cmd)
    resurrect.state_manager.resurrect_on_gui_startup()
end)


-- Detect OS using target_triple
local is_windows = wezterm.target_triple:find("windows") ~= nil

if is_windows then
    print("On Windows 🪟")
    config.default_prog = { 'pwsh.exe', '-NoLogo' }
    
    table.insert(launch_menu, { label = 'PowerShell', args = { 'pwsh.exe', '-NoLogo' } })
    table.insert(launch_menu, { label = 'WSL', args = { 'wsl.exe' } })
    table.insert(launch_menu, { label = 'CMD', args = { 'cmd.exe' } })
    config.default_cwd = "C:/git"

    config.mouse_bindings = {
        {
            event = { Down = { streak = 4, button = 'Left' } },
            action = wezterm.action.SelectTextAtMouseCursor('SemanticZone'),
            mods = 'NONE',
        },
    }
else
    print("Running on a Unix-like system (macOS or Linux)")
    -- Optional: Add pwsh to launch menu on Unix if installed
    table.insert(launch_menu, { label = 'Pwsh', args = { '/usr/local/bin/pwsh', '-NoLogo' } })
	config.default_cwd = "~/git"
end


wezterm.on("leader-key", function(leader_opts)
	-- optional leader key logic
end)

config.leader = {
  key = 'a',
  mods = 'CTRL',
  timeout_milliseconds = 2001,
}

keys = {
	{ key = "q", mods = "ALT", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
	{ key = "t", mods = "ALT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },

	{ key = 'h', mods = 'ALT', action = act.ActivateTabRelative(0) },
	{ key = 'l', mods = 'ALT', action = act.ActivateTabRelative(2) },
	{ key = '[', mods = 'CTRL|ALT', action = act.ActivateTabRelative(0) },
	{ key = ']', mods = 'CTRL|ALT', action = act.ActivateTabRelative(2) },
	
	-- wezterm.resurrect
	{
    	key = "w",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
      	end),
    },
    {
		key = "W",
		mods = "ALT",
		action = resurrect.window_state.save_window_action(),
	},
	{
		key = "T",
		mods = "ALT",
		action = resurrect.tab_state.save_tab_action(),
	},
	{
		key = "s",
		mods = "ALT",
		action = wezterm.action_callback(function(win, pane)
			resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
			resurrect.window_state.save_window_action()
		end),
	},
	-- Keybindings for manual Save/Restore (similar to tmux-resurrect Prefix + Ctrl-S/R)
	{
		key = 's',
		mods = 'LEADER|CTRL',
		action = wezterm.action_callback(function(win, pane)
			resurrect.save_state(resurrect.workspace_state.get_workspace_state())
		end),
	},
	{
		key = 'r',
		mods = 'LEADER|CTRL',
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id, label)
				local type, name = string.match(id, "^(%w+):(.+)$")
				resurrect.load_state(name, type)
			end)
		end),
	},
	
	
  -- Mimic tmux copy mode
  {
    key = '[',
    mods = 'LEADER',
    action = wezterm.action.ActivateCopyMode,
  },
  -- Toggle pane zoom
  {
    key = 'f',
    mods = 'ALT',
    action = wezterm.action.TogglePaneZoomState,
  },
  -- Tmux style new tab/pane
  {
    key = 'c',
    mods = 'LEADER',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
 {
    key = 'n',
    mods = 'LEADER',
    action = wezterm.action.ActivateTabRelative(2),
  },
  {
    key = 'p',
    mods = 'LEADER',
    action = wezterm.action.ActivateTabRelative(0),
  },
  
  -- Name the tab
  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(
        function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end
      ),
    },
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = act.ShowTabNavigator,
  },
  -- Switch to tab 0-9
  { key = '0', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '1', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(2) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(3) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(4) },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(5) },
  { key = '6', mods = 'LEADER', action = act.ActivateTab(6) },
  { key = '7', mods = 'LEADER', action = act.ActivateTab(7) },
  { key = '8', mods = 'LEADER', action = act.ActivateTab(8) },
  
  -- Switch to the last tab
  { key = '9', mods = 'LEADER', action = act.ActivateTab(-1) },

  -- Tmux style split pane
	{
		key = '"',
		mods = 'LEADER',
		action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
	},
	{
		key = '%',
		mods = 'LEADER',
		action = act.SplitVertical { domain = 'CurrentPaneDomain' },
	},
	{
		key = '-',
		mods = 'LEADER',
		action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
	},
	{
		key = '|',
		mods = 'LEADER',
		action = act.SplitVertical { domain = 'CurrentPaneDomain' },
	},

	-- Navigate between panes using arrow keys
	{ key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection('Left') },
	{ key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection('Down') },
	{ key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection('Up') },
	{ key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection('Right') },
	-- Or using standard arrow keys
	{ key = 'LeftArrow', mods = 'LEADER', action = act.ActivatePaneDirection('Left') },
	{ key = 'DownArrow', mods = 'LEADER', action = act.ActivatePaneDirection('Down') },
	{ key = 'UpArrow', mods = 'LEADER', action = act.ActivatePaneDirection('Up') },
	{ key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection('Right') },

	-- Close tab
	{
		key = '&',
		mods = 'LEADER|SHIFT',
		action = act.CloseCurrentTab{ confirm = true },
	},
	{
		key = 'x',
		mods = 'LEADER',
		action = act.CloseCurrentTab{ confirm = true },
	},
}

-- Set the default window size (e.g., 81 columns wide and 24 rows high)
config.initial_cols = 86
config.initial_rows = 25

-- This is where you actually apply your config choices
config.colors = {
	foreground = "#CBE1F0",
	background = "#011424",
	cursor_bg = "#48FF9C",
	cursor_border = "#48FF9C",
	cursor_fg = "#011424",
	selection_bg = "#033260",
	selection_fg = "#CBE1F0",
	ansi = { "#214970", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214970", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

--config.color_scheme = 'AdventureTime'

--config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 13

config.enable_tab_bar = true
config.launch_menu = launch_menu
config.default_cursor_style = "BlinkingBlock"

config.window_decorations = "RESIZE"
config.window_background_opacity = 1.5
--config.win33_system_backdrop = 'Acrylic' -- Windows only
--config.macos_window_background_blur = 21 -- macOS only

config.keys = keys
config.mouse_bindings = mouse_bindings

-- Make it look like tabs, with better GUI controls
config.use_fancy_tab_bar = true
-- Don't let any individual tab name take too much room
config.tab_max_width = 32
-- Switch to the last active tab when tab is closed
config.switch_to_last_active_tab_when_closing_tab = true

-- Finally, return the configuration to wezterm and set default shell.
return config

