" I couldn't care less about Vi.
set nocompatible
" Modelines may be a security hole.
set nomodeline

" Pathogen!
call pathogen#infect()
filetype plugin indent on

" Powerline settings.
"set t_Co=256 " Explicitly make the terminal colorful. (This shouldn't be necessary.)
let g:Powerline_symbols = 'fancy'
set noshowmode " Eliminate redundant message on bottom line.

" Git Gutter settings.
let g:gitgutter_diff_args = '-w --patience'

" Attempt to fix autoclose.


" GUI options.
if has('gui_running')
    set guioptions-=T " No stupid toolbar.
    set guifont=Inconsolata-dz-pl:h12 " Best damn font. Suck it Helvetica and Proxima Nueue!
    set showtabline=0 " Never show tab bar. File name is in powerline. Use buffers and splits!
endif

" Windows!
if has("win32") || has("win64")
    augroup windows
        autocmd!
        autocmd GUIEnter * simalt ~x " Fullscreen.
        autocmd GUIEnter * set guifont=Inconsolata-dz-pl:h10 " Resize for home.
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
" I like my colors.
colorscheme zenburn
" Number lines
set number
" Lightly highlight column 99
set colorcolumn=99
highlight ColorColumn ctermbg=236 guibg=#3f4040
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
" Angle brackets, doublequotes, and singlequotes are matched.
set matchpairs +=<:>
set matchpairs +=":"
set matchpairs +=':'
" NO BELLS
set noerrorbells
set visualbell
"set vb t_vb= " Uncomment to get rid of any bell.
" Always show the status line.
set laststatus=2

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
" Resize font for blind people.
nnoremap <F11> :set guifont=Inconsolata-dz-pl:h12<CR>
nnoremap <F12> :set guifont=Inconsolata-dz-pl:h27<CR>
