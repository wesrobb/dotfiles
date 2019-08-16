source $VIMRUNTIME/mswin.vim

call plug#begin('~/.vim/plugged') 
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-speeddating'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'
Plug 'derekmcloughlin/gvimfullscreen_win32'

" Themes
Plug 'dracula/vim'
Plug 'fatih/molokai'
Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim'
call plug#end()

if has('gui_running')
    colorscheme dracula
    set background=dark
endif

set number
set updatetime=100
set guifont=Consolas_NF:h16:cANSI:qDRAFT
set encoding=utf-8
set autowrite
set expandtab
set shiftwidth=4
set softtabstop=4
set switchbuf=useopen,split
set splitbelow

set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb= " Do we need this?

" Set leader to space
nnoremap <SPACE> <Nop>
let mapleader=" "

" jj leaves insert mode
inoremap jj <ESC>

" Ctrl-j & Ctrl-k navigate the quickfix window
map <C-j> :cn<CR>
map <C-k> :cp<CR>

" Hide useless gvim stuff
set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "right-hand scroll bar
set guioptions-=L  "left-hand scroll bar

" Sane settings for swap and backup files
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//

" Airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" gvim_fullscreen settings
"run the command immediately when starting vim
" autocmd VimEnter * call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)

" activate/deactivate full screen with function key <F11>  
map <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>

" ["x][N]""         List contents of the passed register / [N] named
"                   registers / all registers (that typically contain
"                   pasteable text).
nnoremap <silent> <expr> "" ':<C-u>registers ' . (v:register ==# '"' ? (v:count ? strpart('abcdefghijklmnopqrstuvwxyz', 0, v:count1) : '"0123456789abcdefghijklmnopqrstuvwxyz*+.') : v:register) . "<CR>"

" build settings

" Microsoft MSBuild
set errorformat+=\\\ %#%f(%l\\\,%c):\ %m
" Microsoft compiler: cl.exe
set errorformat+=\\\ %#%f(%l)\ :\ %#%t%[A-z]%#\ %m
" Microsoft HLSL compiler: fxc.exe
set errorformat+=\\\ %#%f(%l\\\,%c-%*[0-9]):\ %#%t%[A-z]%#\ %m

function! s:build()
  let &makeprg='build'
  silent make
  cw
  :echo "Build Complete"
endfunction

command! Build call s:build()
map <Leader>b :Build<cr>

function! s:load_url(url)
    execute "silent !start explorer \"" . a:url . "\""
endfunction

function! s:lookup()
    let s:url = "http://social.msdn.microsoft.com/Search/en-US/?Query=" . expand("<cword>")
    call s:load_url(s:url)
endfunction

command! Lookup call s:lookup()
map <silent> <F1> :Lookup<CR>
