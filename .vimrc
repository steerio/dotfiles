" --- My settings ---

set nocompatible ttimeoutlen=50
set bs=2 ts=2 sw=2 expandtab
set lazyredraw modeline modelines=3
set nowrap noshowmode nohlsearch nobackup nowritebackup
set ignorecase smartcase autoindent
set foldmethod=marker
set wildmode=longest,list
set visualbell
set mouse=a
set dir=~/.vim/swap,.,~/tmp,~/

let g:airline_powerline_fonts = 1

call pathogen#infect()
filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on
syn on

" --- Looks ---

set ruler ls=2 bg=dark
highlight Folded ctermbg=darkmagenta ctermfg=darkcyan
highlight StatusLine cterm=bold ctermbg=blue ctermfg=white
highlight StatusLineNC cterm=NONE ctermbg=blue ctermfg=darkcyan
set fillchars=vert:\|,fold:\ 

fu! MyTab()
  if &omnifunc == '' || strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
    return "\<Tab>"
  else
    return "\<C-X>\<C-O>"
  endif
endfunction

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
nnoremap <Leader>c :lcd ~/Wrk/
nnoremap <Leader>C :lcd ~/Clj/
"inoremap <Tab> <C-R>=MyTab()<cr>
nnoremap <Leader>n :lne<CR>
nnoremap <Leader>N :lp<CR>
nnoremap <Leader>f :lnf<CR>
nnoremap <Leader>F :lpf<CR>
nnoremap <Leader>v :set invpaste<CR>
nnoremap <Leader>/ :set invhlsearch<CR>

let maplocalleader=','
set lispwords+=GET,POST,PUT,DELETE,HEAD
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with-', '^def', '^do']
let g:clojure_align_multiline_strings = 1
let g:paredit_electric_return = 0
let g:netrw_list_hide = '^\..*swp$,^\.git/$,^\.bundle/$'

au VimEnter * AirlineTheme molokai

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
