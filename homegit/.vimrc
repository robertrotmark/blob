" Plugins, run PlugInstall after adding a new plugin
call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'

call plug#end()

colorscheme gruvbox

syntax on
set background=dark
set number
set cursorline
set cursorcolumn
set relativenumber
set noautoindent
filetype indent off

" Set color for matching braces/parethesis/brackets
hi MatchParen cterm=none ctermbg=green ctermfg=red

let ale_yaml_yamllint_options = "-c ~/.yamllint"

let g:airline_powerline_fonts = 0

" Enables permanent status line from vim-airline
set laststatus=2

" Toggle line numbers
nnoremap <F2> :set nonumber! norelativenumber!<CR>

" Toggle ALE on and off
nnoremap <F3> :ALEToggle<CR>
