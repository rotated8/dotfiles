" I couldn't care less about Vi. This is a nop in nvim.
set nocompatible
" Modelines may be a security hole.
set nomodeline
" Remove previously set autocommands, in case this is reloaded.
autocmd!

" Vundle Settings
" Run the commands below first on a new computer.
" `git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
" `vim +PluginInstall +qall`
" Make sure to link .vim and .vimrc to .nvim and .nvimrc, too.
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim,
call vundle#begin()
Plugin 'gmarik/Vundle.vim' " Vundle takes care of itself.
Plugin 'bling/vim-airline' " A powerline replacement. Makes the bottom pretty.
Plugin 'Townk/vim-autoclose' " Closes matched pairs automatically.
Plugin 'airblade/vim-gitgutter' " In a git repo, show the file's git state in the gutter.
Plugin 'jnurmine/Zenburn' " Colorscheme. No bleeding-eyes neon.
call vundle#end()
filetype plugin indent on

" vim-airline Settings
" Be sure to use a patched Powerline font.
" For iTerm2, make sure the profile's non-ASCII font is the same as the ASCII font,
" and transparency is turned off, and text contrast is set to minimum.
let g:airline_powerline_fonts = 1
" Explicitly make the terminal colorful. (This shouldn't be necessary. Use -2 with tmux.)
"set t_Co=256
" Eliminate redundant message on bottom line.
set noshowmode
" Always show the status line.
set laststatus=2
"
" vim-autoclose Settings
" Add angle brackets to autoclose for HTML
autocmd Filetype html,eruby let b:AutoClosePairs_add = '<>'

" vim-gitgutter Settings.
let g:gitgutter_diff_args = '-w'

" GUI Settings
if has('gui_running')
    set guioptions-=T " No stupid toolbar.
    set guifont=Vimconsolata:h12 " Best damn font. Included in the dotfile repo.
    set showtabline=0 " Never show tab bar. File name is in airline. Use buffers and splits!
endif

" Windows Settings
if has("win32") || has("win64")
    augroup windows
        autocmd!
        "autocmd GUIEnter * simalt ~x " Fullscreen.
    augroup END
endif

" Tabs are four spaces...
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
" ...unless you're using Ruby.
augroup rubytabs
    autocmd!
    autocmd FileType ruby,eruby setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END

" Syntax Highlighting. MUST.
syntax on
" Colors via the last plugin above.
silent! colorscheme zenburn
" Number lines
set number
" Lightly highlight column 99
set colorcolumn=99
highlight ColorColumn ctermbg=238 guibg=#434443
" Highlight the line the cursor is on
set cursorline
" Make tab completion interactable. On be default in nvim.
set wildmenu
" Don't redraw during macros, and other untyped input.
set lazyredraw
" Vertical splits split to the right
set splitright
" Regular splits split below.
set splitbelow
" Keep five lines at top or bottom of the screen if possible.
set scrolloff=5
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
" It is needed because Filetype events fire after BufEnter ones. See below.
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

" F1 and arrow keys should not work.
noremap <F1>    <Nop>
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>
" Shift-Up gives a list of open buffers. Unbind Shift-Down to prevent confusion.
nnoremap <S-Up> :ls<CR>
nnoremap <S-Down> <Nop>
" Shift-Left and Shift-Right move between buffers in normal mode.
nnoremap <S-Left> :bprevious<CR>
nnoremap <S-Right> :bnext<CR>
" Make it easy to open and reload this file.
" Leader is '\' by default.
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" Make it easy to open the .zshrc file too.
nnoremap <leader>ez :edit ~/.zshrc<CR>
" Resize font for blind people.
nnoremap <F11> :set guifont=Vimconsolata:h12<CR>
nnoremap <F12> :set guifont=Vimconsolata:h27<CR>
