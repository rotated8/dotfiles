-- This config is a port of my .vimrc for Neovim.
-- vim.opt.compatible = false -- NeoVim is always 'nocompatible', this option has been removed.
vim.opt.modeline = false

-- Not necessary to remove autocommands, this version uses groups that automatically clear.

-- Plugin Management. Replace Vundle with lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    { 'phha/zenburn.nvim', opts = {} , priority = 1000, lazy = false },
    { 'nvim-lualine/lualine.nvim', opts = { options = { theme = 'zenburn' } } },
    { 'windwp/nvim-autopairs', opts = {} },
    { 'lewis6991/gitsigns.nvim', opts = {} },
})

-- GUI settings have been removed. Neovim doesn't provide a GUI.

-- Tab Settings
-- vim.opt.autoindent = true -- Copy indent from current line when starting a new one (Neovim default).
vim.opt.expandtab = true -- Never tabs, always convert to spaces.
vim.opt.tabstop = 4 -- Tabs are four spaces...
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
-- ... unless it's a ruby file.
local rubytabs = vim.api.nvim_create_augroup('rubytabs', { clear = true })
vim.api.nvim_create_autocmd({ 'Filetype' }, {
    desc = 'Set tabs to equal two spaces in Ruby files.',
    group = rubytabs,
    pattern = { 'ruby', 'eruby' },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end
})

-- General Settings
-- Syntax highlighting is on by default.
vim.opt.number = true
vim.opt.linebreak = true -- New! Wraps lines that are too long at a convenient place.
-- TODO: Look at formatoptions, spectifically 'l' and 'v'.
vim.opt.textwidth = 121
vim.opt.colorcolumn = '-10' -- New way to set! This is relative to 'textwidth'
vim.opt.termguicolors = true -- New! Force Neovim to use 256 colors.
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#434443' })
vim.opt.cursorline = true
-- vim.opt.wildmenu = true -- A Neovim default.
-- vim.opt.lazyredraw = true -- Docs suggest this should not be set all the time.
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 5
-- vim.opt.display = 'lastline' -- A Neovim default.
-- vim.opt.backup = false -- Docs say this is default in Vim.
-- vim.opt.backspace = { 'indent', 'eol', 'start' } -- A Neovim default.
-- vim.opt.encoding = 'utf-8' -- A Neovim default.
vim.opt.fileformats = { 'unix', 'dos' } -- This is the Unix default, reversed for Windows.
vim.opt.fileformat = 'unix' -- This is the Unix default, set for Windows.
vim.opt.tildeop = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.matchpairs:append({ '<:>', '":"', "':'", '`:`' })
-- vim.opt.errorbells = false -- A Neovim default.
-- vim.opt.visualbell = true -- Neovim sets 'belloff' to 'all' by default.
vim.opt.wildignorecase = true -- New! Ignore case when completing filenames.

-- Whitespace Highlighting
vim.api.nvim_set_hl(0, 'BadWhitespace', { bg = 'DarkRed' })
local badwhitespace = vim.api.nvim_create_augroup('badwhitespace', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    desc = 'Highlight trailing whitespace, or when tabs and spaces are mixed at the start.',
    group = badwhitespace,
    pattern = '*',
    once = true,
    callback = function()
        vim.fn.matchadd('BadWhitespace', '^\\( *\\t\\+\\)\\+')
        vim.fn.matchadd('BadWhitespace', '\\s\\+$')
        if vim.opt.filetype:get() == 'help' then
            vim.fn.clearmatches()
        end
    end
})

-- Key remaps
vim.opt.mouse = 'h'
vim.keymap.set('', '<F1>', '<Nop>')
vim.keymap.set('', '<Up>', '<Nop>')
vim.keymap.set('', '<Down>', '<Nop>')
vim.keymap.set('', '<Left>', '<Nop>')
vim.keymap.set('', '<Right>', '<Nop>')
vim.keymap.set('n', '<S-Up>', '<Cmd>ls<CR>')
vim.keymap.set('n', '<S-Down>', '<Nop>')
vim.keymap.set('n', '<S-Left>', '<Cmd>bprevious<CR>')
vim.keymap.set('n', '<S-Right>', '<Cmd>bnext<CR>')
vim.keymap.set('n', '<Leader>ev', '<Cmd>edit $MYVIMRC<CR>')
vim.keymap.set('n', '<Leader>sv', '<Cmd>source $MYVIMRC<CR>')
vim.keymap.set('n', '<Leader>ez', '<Cmd>edit ~/.zshrc<CR>')
vim.keymap.set('n', '<Leader>eb', '<Cmd>edit ~/.bashrc<CR>')
vim.keymap.set('n', '<Leader>eg', '<Cmd>edit ~/.gitconfig<CR>')
-- Removed font resizing. I don't use it enough.
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
