" I couldn't care less about Vi.
set nocompatible
" Modelines may be a security hole.
set nomodeline
" Remove previously set autocommands, in case this is reloaded.
autocmd!

" Vim-Plug https://github.com/junegunn/vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute '!curl -fLo '~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
Plug 'vim-airline/vim-airline' " A powerline replacement. Makes the bottom line pretty.
Plug 'Townk/vim-autoclose' " Closes matched pairs automatically.
Plug 'airblade/vim-gitgutter' " In a git repo, show the file's git state in the gutter.
Plug 'jnurmine/Zenburn' " Colorscheme.
Plug 'rust-lang/rust.vim', { 'for': 'rust' } " Rust linting
call plug#end()
" Use the Zenburn colorscheme we downloaded with Vim-Plug, but don't complain if it's missing
silent! colorscheme zenburn

" vim-airline Settings
" Be sure to use a patched Powerline font.
" For iTerm2, make sure the profile's non-ASCII font is the same as the ASCII font,
" and transparency is turned off, and text contrast is set to minimum.
let g:airline_powerline_fonts = 1
" Explicitly make the terminal colorful. (This shouldn't be necessary. Use -2 with tmux.)
"set t_Co=256
" Mode is displayed by airline, so don't show it twice.
set noshowmode
" Always show the status line.
set laststatus=2

" vim-autoclose Settings
" Add angle brackets to autoclose for HTML
autocmd Filetype html,xml,eruby let b:AutoClosePairs_add = '<>'

" vim-gitgutter Settings.
let g:gitgutter_diff_args = '-w'

" GUI Settings
if has('gui_running')
    set guioptions-=T " No toolbar.
    " Font included in https://github.com/rotated8/dotfiles
    set guifont=Iosevka:h10:cANSI:qDRAFT
    set showtabline=0 " Never show tab bar. File name is in airline. Use buffers and splits!
endif

" Windows Settings
if has('win64') || has('win32')
    augroup windows
        autocmd!
        "autocmd GUIEnter * simalt ~x " Fullscreen.
    augroup END
endif

" Tabs are four spaces...
set autoindent " Copy indent from current line when starting a new one.
set expandtab " Never tabs, always convert to spaces.
set tabstop=4
set shiftwidth=4
set softtabstop=4
" ...unless you're using Ruby.
augroup rubytabs
    autocmd!
    autocmd FileType ruby,eruby setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END

" Turn syntax highlighting on.
syntax on
" Number lines
set number
" Don't wrap lines until column 111
set textwidth=111
" Lightly highlight column 99
set colorcolumn=99
highlight ColorColumn ctermbg=238 guibg=#444444
" Highlight the line the cursor is on
set cursorline
" Make tab completion interactable.
set wildmenu
" Don't redraw during macros, and other untyped input.
set lazyredraw
" Vertical splits split to the right
set splitright
" Regular splits split below.
set splitbelow
" Keep five lines at top or bottom of the screen if possible.
set scrolloff=5
" If the last line is too long, show as much of it as possible.
set display=lastline
" No more annoying file.ext~ backup files!
set nobackup
" Allow backspace/delete affect what it likes.
set backspace=indent,eol,start
" UTF-8 by default.
set encoding=utf-8
" Attempt to coerce unix line endings
set fileformats=unix,dos
set fileformat=unix
" Tilde changes case. Now it's also an operator.
set tildeop
" Search ignores case, unless I capitalize.
set ignorecase
set smartcase
" Do not highlight search matches.
set nohlsearch
" Angle brackets, doublequotes, and singlequotes are matched.
" Reflects the settings from vim-autoclose
set matchpairs +=<:>
set matchpairs +=":"
set matchpairs +=':'
set matchpairs +=`:`
" NO BELLS
set noerrorbells
set visualbell
"set vb t_vb= " Removes any bell.

" Bad whitespace shows up in red.
highlight BadWhitespace ctermbg=1 guibg=Red
" This function will clear bad whitespace highlighting in help files.
" It is necessary because Filetype events fire after BufEnter ones. See below.
function! IgnoreHelpFiles()
    if &filetype ==? 'help'
        call clearmatches()
    endif
endfunction
" Match whenever we enter a buffer. (These happen in order)
augroup badwhitespace
    autocmd!
    " Tabs at the beginning of a line are bad. Especially if they are mixed in with spaces.
    autocmd BufEnter * call matchadd('BadWhitespace', '^\( *\t\+\)\+')
    " Trailing whitespace is bad, too.
    autocmd BufEnter * call matchadd('BadWhitespace', '\s\+$')
    " Remove matches in help files.
    autocmd BufEnter * call IgnoreHelpFiles()
augroup END

" Enable the mouse in help files only.
set mouse=h
" F1 and arrow keys should not do anything.
noremap <F1>    <Nop>
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>
" Shift-Up gives a list of open buffers. Unbind Shift-Down to prevent confusion.
nnoremap <S-Up> :ls<CR>
nnoremap <S-Down> <Nop>
" Shift-Left and Shift-Right move between buffers in normal mode.
" Only works if your terminal does not use the same combo to switch tabs.
nnoremap <S-Left> :bprevious<CR>
nnoremap <S-Right> :bnext<CR>
" Make it easy to open and reload this file.
" Leader is '\' by default.
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" Make it easy to open other dotfiles too.
nnoremap <leader>ez :edit ~/.zshrc<CR>
nnoremap <leader>eb :edit ~/.bashrc<CR>
nnoremap <leader>eg :edit ~/.gitconfig<CR>
" Allow quick font resizing for presentations and colleagues.
nnoremap <F11> :set guifont=Iosevka_Fixed:h12:cANSI<CR>
nnoremap <F12> :set guifont=Iosevka_Fixed:h27:cANSI<CR>
" In a terminal, allow <Esc> to exit terminal-mode.
:tnoremap <Esc> <C-\><C-n>
