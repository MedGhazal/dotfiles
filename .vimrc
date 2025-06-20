set encoding=utf-8
set relativenumber
set number
set nocompatible
set foldmethod=indent
set hls is
set wrap linebreak
set backspace=indent,eol,start
set cursorline
set smartindent
set wildmenu
set noshowmode

set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=/usr/local/opt/fzf
set foldtext=gitgutter#fold#foldtext()

syntax on
filetype on

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

au BufNewFile,BufRead *.js,*.html,*.css 
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set foldmethod=indent

call vundle#begin()
	Plugin 'VundleVim/Vundle.vim'
	Plugin 'catppuccin/vim'
	Plugin 'vim-airline/vim-airline'
	Plugin 'vim-airline/vim-airline-themes'
	Plugin 'preservim/nerdtree'
	Plugin 'tpope/vim-fugitive'
	Plugin 'mattn/emmet-vim'
	Plugin 'vim-syntastic/syntastic'
	Plugin 'lervag/vimtex'
	Plugin 'tpope/vim-surround'
	Plugin 'tpope/vim-commentary'
	Plugin 'tpope/vim-repeat'
	Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plugin 'junegunn/fzf.vim'
	Plugin 'preservim/tagbar'
	Plugin 'mbbill/undotree'
	Plugin 'sheerun/vim-polyglot'
call vundle#end()  

let g:lightline = {'colorscheme': 'catppuccin_mocha'}
let g:airline_theme = 'catppuccin_mocha'

colorscheme catppuccin_mocha
set background=dark
set termguicolors

filetype plugin indent on

let g:user_emmet_mode='n'
let g:user_emmet_leader_key=','
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeMinimalUI = 1
let g:fzflayout = { 'window': { 'width': 0.8, 'height': 0.8} }
let $FZF_DEFAULT_OPTS = '--reverse'
let g:ycm_add_preview_to_completeopt = 'popup'

" Keybindings
nnoremap <SPACE> <Nop>
let mapleader=" "
nmap b :Buffers<CR>
nmap <Tab> :bp<CR>
nmap ö :bp<CR>
nmap ä :bn<CR>
nmap - :bd<CR>
nmap <leader>f :Files<CR>
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
map <leader>t :TagbarToggle<CR>
map <leader>n :NERDTreeToggle<CR>
map <leader>nf :NERDTreeFind<CR>
map <leader>ne :NERDTreeExplore<CR>
map <leader>g :Git push<CR>
map <leader>u :UndotreeToggle<CR>

nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

autocmd FileType python map <buffer> <leader>f :call flake8#Flake8()<CR>
autocmd FileType tex,plaintex map <buffer> <leader>c :!./compile.sh<CR>

map <Down> <Nop>
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>

highlight SpellBad ctermfg=009 ctermbg=000 guifg=#000000 guibg=#ffffff

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> {Left-Mapping} :<C-U>TmuxNavigateLeft<cr>
nnoremap <silent> {Down-Mapping} :<C-U>TmuxNavigateDown<cr>
nnoremap <silent> {Up-Mapping} :<C-U>TmuxNavigateUp<cr>
nnoremap <silent> {Right-Mapping} :<C-U>TmuxNavigateRight<cr>
nnoremap <silent> {Previous-Mapping} :<C-U>TmuxNavigatePrevious<cr>

function! GitStatus()
	  let [a,m,r] = GitGutterGetHunkSummary()
	    return printf('+%d ~%d -%d', a, m, r)
endfunction
set statusline+=%{GitStatus()}
