set nocompatible
filetype off

set rtp+=~/.vim/vundle
call vundle#begin()

" --- Plugins here ---
Plugin 'bling/vim-airline'
" Plugin 'edkolev/tmuxline.vim'
" Plugin 'elixir-lang/vim-elixir'
Plugin 'guns/vim-clojure-static'
Plugin 'itchyny/vim-haskell-indent'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'lambdatoast/elm.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'paredit.vim'
Plugin 'slim-template/vim-slim.git'
Plugin 'tomlion/vim-solidity'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-fugitive'
" --- Plugins until this point ---

call vundle#end()
filetype plugin indent on

" --- My settings ---

if has("nvim")
  set termguicolors
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

set ttimeoutlen=50
set bs=2 ts=2 sw=2 expandtab
set lazyredraw modeline modelines=3
set nowrap noshowmode nohlsearch nobackup nowritebackup
set ignorecase smartcase autoindent
set foldmethod=marker
set wildmode=longest,list
set visualbell
set mouse=a
set dir=~/.vim/swap,.,~/tmp,~/

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_close_button = 0
let g:airline_powerline_fonts = 1
let g:jsx_ext_required = 1
syn on

" --- Looks ---

highlight Normal guibg=black guifg=#c7c7c7
set ruler ls=2 bg=dark guioptions=c
highlight Folded ctermbg=232 Ctermfg=darkcyan guibg=#0b0b0b guifg=#407040
highlight StatusLine cterm=bold ctermbg=blue ctermfg=white
highlight StatusLineNC cterm=NONE ctermbg=blue ctermfg=darkcyan
set fillchars=vert:\|,fold:\  " That's an escaped space.

if has('GUI_GTK')
  " Linux/BSD
  set guifont=Droid\ Sans\ Mono\ 9
else
  " OS X
  set guifont=Droid\ Sans\ Mono\ Slashed\ for\ Powerline:h12
endif

fu! MyCljBindings()
  nmap <buffer> <LocalLeader>e <Plug>FireplacePrint
  vmap <buffer> <LocalLeader>e <Plug>FireplacePrint
  nmap <buffer> <LocalLeader>ee <Plug>FireplacePrintip
  nmap <buffer> <LocalLeader>E <Plug>FireplacePrintip
  nmap <buffer> <LocalLeader>e( <Plug>FireplacePrinta(
  nmap <buffer> <LocalLeader>e) <Plug>FireplacePrinta)
  nmap <buffer> <LocalLeader>eb <Plug>FireplacePrintab

  nmap <buffer> <LocalLeader>f <Plug>FireplaceFilter
  vmap <buffer> <LocalLeader>f <Plug>FireplaceFilter
  nmap <buffer> <LocalLeader>ff <Plug>FireplaceFilterip
  nmap <buffer> <LocalLeader>F <Plug>FireplaceFilterip
  nmap <buffer> <LocalLeader>f( <Plug>FireplaceFiltera(
  nmap <buffer> <LocalLeader>f) <Plug>FireplaceFiltera)
  nmap <buffer> <LocalLeader>fb <Plug>FireplaceFilterab
  nmap <buffer> == =ip

  nmap <buffer> <LocalLeader>c <Plug>FireplaceEdit
  vmap <buffer> <LocalLeader>c <Plug>FireplaceEdit
  nmap <buffer> <LocalLeader>cc <Plug>FireplaceEditip
  nmap <buffer> <LocalLeader>C <Plug>FireplaceEditip
  nmap <buffer> <LocalLeader>c( <Plug>FireplaceEdita(
  nmap <buffer> <LocalLeader>c) <Plug>FireplaceEdita)
  nmap <buffer> <LocalLeader>cb <Plug>FireplaceEditab

  nmap <buffer> <LocalLeader>p <Plug>FireplacePrompt
  exe 'nmap <buffer> <LocalLeader>: <Plug>FireplacePrompt' . &cedit . 'i'
endfunction

au BufNewFile,BufRead *.lsp,*.jl call PareditInitBuffer()
au BufNewFile,BufRead *.go setlocal noexpandtab
au BufNewFile,BufRead *.sol setlocal foldmethod=indent
au BufNewFile,BufRead Jemfile,Buildfile,Capfile,*.framespec,*.rabl,*.prawn set filetype=ruby
au BufNewFile,BufRead *.json set filetype=javascript
au BufNewFile,BufRead *.md set filetype=ghmarkdown
au BufNewFile,BufRead * set formatoptions-=o
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
au FileType clojure call MyCljBindings()
au FileType html,xml,eruby source ~/.vim/scripts/closetag.vim
nnoremap <Leader>s :Sexplore<CR>z10<CR>9Gz<CR>j
nnoremap <Leader>S :s .<CR>z10<CR>9Gz<CR>j
nnoremap <Leader>e :Explore<CR>9Gz<CR>j
nnoremap <Leader>E :e .<CR>9Gz<CR>j
nnoremap <Leader>n :lne<CR>
nnoremap <Leader>N :lp<CR>
nnoremap <Leader>f :lnf<CR>
nnoremap <Leader>F :lpf<CR>
nnoremap <Leader>v :set invpaste<CR>
nnoremap <Leader>/ :set invhlsearch<CR>
nnoremap <C-W>l :exe "res ".line('$')<CR>gg''

let maplocalleader=','
set lispwords+=GET,POST,PUT,DELETE,HEAD
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with-', '^def', '^do', '^if-']
let g:clojure_align_multiline_strings = 1
let g:paredit_electric_return = 0
let g:netrw_list_hide = '^\..*swp$,^\.git/$,^\.bundle/$'

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

let g:rbpt_colorpairs = [
  \ ['brown',       'RoyalBlue3'],
  \ ['Darkblue',    'SeaGreen3'],
  \ ['darkgray',    'DarkOrchid3'],
  \ ['darkgreen',   'firebrick3'],
  \ ['darkcyan',    'RoyalBlue3'],
  \ ['darkred',     'SeaGreen3'],
  \ ['darkmagenta', 'DarkOrchid3'],
  \ ['brown',       'firebrick3'],
  \ ['gray',        'RoyalBlue3'],
  \ ['green',       'SeaGreen3'],
  \ ['darkmagenta', 'DarkOrchid3'],
  \ ['Darkblue',    'firebrick3'],
  \ ['darkgreen',   'RoyalBlue3'],
  \ ['darkcyan',    'SeaGreen3'],
  \ ['darkred',     'DarkOrchid3'],
  \ ['red',         'firebrick3'],
  \ ]
