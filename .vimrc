call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-sensible'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --all' }
Plug 'rhysd/vim-clang-format'
Plug 'junegunn/goyo.vim'
Plug 'jceb/vim-orgmode'
Plug 'scrooloose/syntastic'
Plug 'jeaye/color_coded', {'do': 'cmake . && make && make install' }
Plug 'chriskempson/base16-vim'
Plug 'gilligan/vim-lldb'
Plug 'vim-scripts/indentpython.vim'
Plug 'nvie/vim-flake8'
Plug 'rust-lang/rust.vim'
Plug 'NigoroJr/color_coded-colorschemes'
Plug 'tomasr/molokai'
Plug 'rking/ag.vim'
Plug 'Chun-Yang/vim-action-ag'
call plug#end()

set background=dark
colorscheme molokaied

" File encoding
set encoding=utf-8

" Tab settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set cindent
set colorcolumn=121
set listchars=tab:>·,trail:~
set list

" Python PEP8 spec formatting
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" Web dev formatting
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

let python_highlight_all=1
syntax on

" Disable the damn error bell
set visualbell t_vb=
if has("autocmd") && has("gui")
    au GUIEnter * set t_vb=
endif

" Key bindings
let mapleader=" " " <Leader> is comma

" Clang format settings
nmap <Leader>C :ClangFormatAutoToggle<CR> " Toggle auto formatting
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
let g:clang_format#style_options = {
                        \ "BasedOnStyle": "LLVM",
                        \ "ColumnLimit" : "120",
                        \ "IndentWidth": "4",
                        \ "UseTab": "Never",
                        \ "BreakBeforeBraces": "Linux",
                        \ "AllowShortIfStatementsOnASingleLine" : "false",
                        \ "IndentCaseLabels": "false",
                        \ "BinPackArguments": "false", 
                        \ "BinPackParameters": "false",
                        \ "AllowAllParametersOfDeclarationOnNextLine": "false", 
                        \ "AllowShortBlocksOnASingleLine": "true",
                        \ "AllowShortFunctionsOnASingleLine": "Empty"}

" YCM settings
let g:ycm_confirm_extra_conf = 0                       " Disable the dialog asking if it's ok to load the extra conf
let g:ycm_autoclose_preview_window_after_insertion = 1 " Close the extra info window after leaving insert mode
let g:ycm_python_binary_path = '/usr/local/bin/python3'
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_rust_src_path='/Users/wes/Projects/rustc-1.9.0/src/'

" Syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

" use * to search current word in normal mode
nmap <leader>f <Plug>AgActionWord
" use * to search selected text in visual mode
vmap <leader>f <Plug>AgActionVisual
