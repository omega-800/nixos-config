syntax on
set path=.,,**
set guicursor=""
set nu
set relativenumber
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set clipboard=unnamedplus
set termguicolors
set smartindent
set scrolloff=8
set undofile
set undodir="~/.vim/undodir"
set incsearch
set nohls
set colorcolumn=120
set cursorline
set cursorcolumn
set autoread
set updatetime=50
set mouse=
hi Normal guibg=NONE ctermfg=None ctermbg=DarkGreen
hi Cursor guibg=NONE ctermfg=None ctermbg=DarkGreen
hi CursorColumn guibg=NONE ctermfg=None ctermbg=Black
hi CursorLine guibg=NONE ctermfg=None ctermbg=Black
hi ColorColumn ctermbg=235 guibg=#262626
set foldmethod=indent
set foldnestmax=10
set foldlevel=5
set foldenable
filetype on
filetype plugin on
filetype indent on
set showmode
set showmatch
set showcmd
set history=1000
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'

let g:airline_theme='angr'

let mapleader=' '
map <leader>dt :packadd termdebug<CR>
map <leader>dd :Termdebug<CR>
map <leader>db :Break<CR>
map <leader>ds :Step<CR>
map <leader>dc :Continue<CR>
map <leader>dx :Clear<CR>
map <leader>dr :Run<CR>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><

nmap <C-n> :set number! \| :set relativenumber!<CR>
nmap <C-p> :set paste!<CR>
nmap <C-m> :set modifiable!<CR>
