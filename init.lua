-- This config is a port of my .vimrc for Neovim.
-- Commented options needed to be set in Vim, but are defaults in Neovim.
vim.opt.modeline = false

-- LSP Setup Configs copied from https://github.com/neovim/nvim-lspconfig on 2026-01-14.
vim.lsp.config('ty', {
    cmd = { 'ty', 'server' },
    filetypes = { 'python' },
    root_markers = { 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
    settings = { ty={} }
})
vim.lsp.config('ruff', {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
    settings = {
        lineLength = 121,
        configuration = {
            format = {
                ['quote-style'] = 'single'
            }
        }
    },
})
vim.lsp.enable('ty')
vim.lsp.enable('ruff')

-- Tab Settings
-- vim.opt.autoindent = true -- Copy indent from current line when starting a new one.
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
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.linebreak = true -- Wrap lines that are too long at a convenient place.
-- TODO: Look at formatoptions, spectifically 'l' and 'v'.
vim.opt.textwidth = 121
vim.opt.colorcolumn = '-10' -- This is relative to 'textwidth'
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#434443' })
vim.opt.cursorline = true
-- vim.opt.wildmenu = true
-- vim.opt.lazyredraw = true -- Docs suggest this should not be set all the time.
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 5
-- vim.opt.display = 'lastline'
-- vim.opt.backup = false -- Docs say this is default in Vim.
-- vim.opt.backspace = { 'indent', 'eol', 'start' }
-- vim.opt.encoding = 'utf-8'
vim.opt.fileformats = { 'unix', 'dos' } -- This is the Unix default, reversed for Windows.
vim.opt.fileformat = 'unix' -- This is the Unix default, set for Windows.
vim.opt.tildeop = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.matchpairs:append({ '<:>', '":"', "':'", '`:`' })
-- vim.opt.errorbells = false
-- vim.opt.visualbell = true -- Neovim sets 'belloff' to 'all' by default.
vim.opt.wildignorecase = true -- Ignore case when completing filenames.

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
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

vim.pack.add({
    'https://github.com/phha/zenburn.nvim',
    'https://github.com/nvim-lualine/lualine.nvim',
    'https://github.com/windwp/nvim-autopairs',
    'https://github.com/lewis6991/gitsigns.nvim',
})
require('zenburn').setup()
require('lualine').setup({ options = { theme = 'zenburn' } })
require('nvim-autopairs').setup()
require('gitsigns').setup()
