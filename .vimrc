" .vimrc file
set nocompatible

" tab-width stuff

set tabstop=2
set shiftwidth=2
set expandtab
set smarttab

" other stuff

set showcmd
set number
set hlsearch
set incsearch
set ignorecase
set smartcase
set autoindent
" set textwidth=79
set formatoptions=c,q,r,t
set ruler
set visualbell
set hidden

filetype plugin indent on
syntax on

" color scheme
if has('termguicolors')
  set termguicolors
endif

let g:sonokai_style = 'default'
let g:sonokai_better_performance = 1

colorscheme sonokai

" key mappings
map <F2> :NERDTreeToggle<CR>

