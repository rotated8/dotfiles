-- This config is a port of my .vimrc for Neovim.
vim.opt.compatible = false
vim.opt.modeline = false

-- Remove Autocommands

-- Plugin Management

-- Filetype setup

-- Plugin Settings

-- GUI Settings

-- Windows Settings

-- Tab Settings
vim.opt.autoindent = true -- Copy indent from current line when starting a new one (Neovim default).
vim.opt.expandtab = true -- Never tabs, always convert to spaces.
vim.opt.tabstop = 4 -- Tabs are four spaces...
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
-- ... unless it's a ruby file.
-- TODO

-- General Settings
-- TODO: turn on syntax highlighting
-- TODO: Use the Zenburn colorscheme
vim.opt.number = true
vim.opt.textwidth = 111
-- TODO: Highlight column 99
vim.opt.cursorline = true
vim.opt.wildmenu = true
vim.opt.lazyredraw = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 5
vim.opt.display = 'lastline'
vim.opt.backup = false
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.encoding = 'utf-8'
vim.opt.fileformats = { 'unix', 'dos' }
vim.opt.fileformat = 'unix'
vim.opt.tildeop = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.matchpairs:append({ '<:>', '":"', "':'", '`:`' })
vim.opt.errorbells = false
vim.opt.visualbell = true

-- Whitespace Highlighting

-- Key remaps
vim.opt.mouse = 'h'
vim.keybind.set('', '<F1>', '<Nop>')
vim.keybind.set('', '<Up>', '<Nop>')
vim.keybind.set('', '<Down>', '<Nop>')
vim.keybind.set('', '<Left>', '<Nop>')
vim.keybind.set('', '<Right>', '<Nop>')
vim.keybind.set('n', '<S-Up>', '<Cmd>ls<CR>')
vim.keybind.set('n', '<S-Down>', '<Nop>')
vim.keybind.set('n', '<S-Left>', '<Cmd>bprevious<CR>')
vim.keybind.set('n', '<S-Right>', '<Cmd>bnext<CR>')
vim.keybind.set('n', '<Leader>ev', '<Cmd>edit $MYVIMRC<CR>')
vim.keybind.set('n', '<Leader>sv', '<Cmd>source $MYVIMRC<CR>')
vim.keybind.set('n', '<Leader>ez', '<Cmd>edit ~/.zshrc<CR>')
vim.keybind.set('n', '<Leader>eb', '<Cmd>edit ~/.bashrc<CR>')
vim.keybind.set('n', '<Leader>eg', '<Cmd>edit ~/.gitconfig<CR>')
-- TODO: Font resizing?
vim.keybind.set('t', '<Esc>', '<C-\><C-n>')
