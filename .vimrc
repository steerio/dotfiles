" --- My settings ---

set nocompatible
set bs=2 ts=2 sw=2 expandtab
set lazyredraw modeline modelines=3
set nowrap nohlsearch nobackup nowritebackup ignorecase smartcase autoindent
set foldmethod=marker
set wildmode=longest,list

call pathogen#infect()
filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on
syn on

" --- Looks ---

set ruler ls=2 bg=dark
set statusline=%f%(\ [%M%R%H%W]%)%=%l,%c%V%5P\ [%03b\ 0x%02B]
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

function StartRepl()
  :silent !osascript -e 'tell application "Terminal"' -e "do script \"cd `pwd`; lein repl\"" -e activate -e 'end tell'
  redraw!
endfunction

function StartTerm()
  :silent !osascript -e 'tell application "Terminal"' -e "do script \"cd `pwd`\"" -e activate -e 'end tell'
  redraw!
endfunction

command! Repl call StartRepl()
command! Term call StartTerm()

au BufNewFile,BufRead *.lsp call PareditInitBuffer()
au BufNewFile,BufRead Jemfile,Buildfile,*.framespec,*.rabl,*.prawn set filetype=ruby
au BufNewFile,BufRead *.json set filetype=javascript
au BufNewFile,BufRead * set formatoptions-=o
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
au FileType clojure call MyCljBindings()
au FileType html,xml source ~/.vim/scripts/closetag.vim
nnoremap <Leader>s :Sexplore<CR>z10<CR>8Gz<CR>j
nnoremap <Leader>S :s .<CR>z10<CR>8Gz<CR>j
nnoremap <Leader>e :Explore<CR>8Gz<CR>j
nnoremap <Leader>E :e .<CR>8Gz<CR>j
nnoremap <Leader>c :cd ~/Wrk/
nnoremap <Leader>C :cd ~/Clj/
nnoremap <Leader>p :cd ~/Wrk/pillango/
inoremap <Tab> <C-R>=MyTab()<cr>
nnoremap <Leader>n :lne<CR>
nnoremap <Leader>N :lp<CR>
nnoremap <Leader>f :lnf<CR>
nnoremap <Leader>F :lpf<CR>

cnoreabbrev / lgrep -r

let maplocalleader=','
set lispwords+=->,->>
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let']
let g:clojure_align_multiline_strings = 1
let g:paredit_electric_return = 0
let g:netrw_liststyle=1
