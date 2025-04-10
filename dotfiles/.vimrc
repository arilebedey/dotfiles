" Disable swap file
set noswapfile
set undodir=~/.vim/undodir
set undofile

" Enable syntax highlighting
syntax on

" Enable line numbers
set number

" Highlight matching parentheses and brackets
set showmatch

" Enable 256-color support for better syntax colors
set t_Co=256

nnoremap ge :Explore<CR>

"
" colorscheme habamax
" colorscheme evening
" colorscheme sorbet
colorscheme slate


" Leader keys
let mapleader = "."
let maplocalleader = "."

nnoremap <leader>kl :q!<CR>
nnoremap <leader>lk :q!<CR>
nnoremap <leader>. :w!<CR>
nnoremap <leader>, :wq!<CR>

" Use system clipboard
set clipboard+=unnamedplus

nnoremap s k
nnoremap t j
vnoremap s k
vnoremap t j

" Line numbers
set number
set relativenumber

" Always show sign column
set signcolumn=yes

" Undo history
if !isdirectory($HOME . "/.local/nvim/undodir")
    call mkdir($HOME . "/.local/nvim/undodir", "p")
endif
set undodir=~/.local/nvim/undodir
set undofile

" Tabs & Indentation
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set nowrap

" Search
set ignorecase
set smartcase

" Theme
set background=dark

" Backspace behavior
set backspace=indent,eol,start

" Split windows
set splitright
set splitbelow

" Update time (affects CursorHold delay, etc.)
set updatetime=300

" Enable mouse
set mouse=a

" GUI cursor settings
set termguicolors
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
set guicursor=n:block,v:ver25,i:ver25

" Disable clipboard override when pasting over a selection
xnoremap p "0p
xnoremap P "0P

set laststatus=2

" MacOS clipboard VIM
vnoremap <C-c> :w !pbcopy<CR>
vnoremap <C-v> :r !pbpaste<CR>

" vV for selecting a line and replacing it with clipboard content
nnoremap vV V"_dP
xnoremap vV V"_dP

nnoremap <F5> :w<CR>:!gcc -o output_file %<CR>
nnoremap <F6> :!./output_file<CR>

let g:netrw_keepdir = 0

" Set proper indentation for C files
autocmd FileType c setlocal shiftwidth=4 tabstop=4 noexpandtab
set autoindent          " Enable auto-indentation
" set smartindent         " Enable smart indentation

" DISPLAY CHARACTERS (optional)
set list                " Show whitespace characters
set listchars=tab:>-,trail:- " Customize how tabs/trailing spaces look

" Enable filetype detection and related plugins
" filetype plugin indent on


" OneDark theme
"
"
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


call plug#begin('~/.vim/plugged')

" Add OneDark theme
Plug 'joshdick/onedark.vim'
Plug 'jiangmiao/auto-pairs'

call plug#end()

" Enable OneDark theme
syntax on
colorscheme onedark

" Map gc to comment selected lines in visual mode
xnoremap <silent> gc :<C-u>'<,'>s/^/\/\//<CR>

" Map gu to uncomment selected lines in visual mode
xnoremap <silent> gu :<C-u>'<,'>s/^\/\///<CR>
