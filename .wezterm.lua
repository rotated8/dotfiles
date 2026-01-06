local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Zenburn'
config.default_prog = { 'wsl.exe' }
config.launch_menu = {
    {
        label = 'Ubuntu',
        args = { 'wsl.exe', '-d', 'Ubuntu' }
    },
    {
        label = 'PowerShell',
        args = { 'pwsh.exe' }
    },
    {
        label = 'cmd',
        args = { 'cmd.exe'}
    }
}

return config
