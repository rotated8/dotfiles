local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Zenburn'
config.font = wezterm.font 'Iosevka Term'
config.default_prog = { 'pwsh.exe' }
config.default_domain = 'WSL:Ubuntu'
config.keys = {
    { key = 'v', mods = 'CTRL', action = wezterm.action.PasteFrom 'Clipboard' },
}
-- Right-mouse copy and paste, via https://github.com/wezterm/wezterm/discussions/3541#discussioncomment-5633570
config.mouse_bindings = {
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action_callback(function(window, pane)
            local has_selection = window:get_selection_text_for_pane(pane) ~= ""
            if has_selection then
                window:perform_action(wezterm.action.CopyTo("ClipboardAndPrimarySelection"), pane)
                window:perform_action(wezterm.action.ClearSelection, pane)
            else
                window:perform_action(wezterm.action({ PasteFrom = "Clipboard" }), pane)
            end
        end),
    },
}

wezterm.on('gui-startup', function(cmd)
    -- I use a vertical monitor sometimes. Find it, or default to the main one.
    local target_screen = wezterm.gui.screens().main.name
    for screen_name, screen in pairs(wezterm.gui.screens().by_name) do
        if screen.height > screen.width then
            target_screen = screen_name
        end
    end

    -- Edit the command, if any, to move the window to the target screen
    local cmd = cmd or {}
    cmd.position = { ['x']=1, ['y']=1, ['origin']={ ['Named']=target_screen } }

    -- Maximize the window.
    local tab, pane, window = wezterm.mux.spawn_window(cmd)
    window:gui_window():maximize()
end)

return config
