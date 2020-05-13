set nocompatible

" --- My settings ---

if has("nvim")
  set termguicolors
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

set number
set ttimeoutlen=50
set bs=2 ts=2 sw=2 expandtab
set lazyredraw modeline modelines=3
set nowrap noshowmode nohlsearch nobackup nowritebackup
set ignorecase smartcase autoindent
set foldmethod=marker foldnestmax=3 foldminlines=3
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
syn on

" --- Looks ---

highlight LineNr ctermfg=238 guifg=#444444
highlight Normal guibg=black guifg=#c7c7c7
set ruler ls=2 bg=dark guioptions=c
highlight Folded ctermbg=232 Ctermfg=darkcyan guibg=#0b0b0b guifg=#407040
highlight StatusLine cterm=NONE ctermbg=235 ctermfg=white
highlight StatusLineNC cterm=NONE ctermbg=235 ctermfg=darkcyan
highlight ColorColumn ctermbg=232 guibg=#0b0b0b
highlight VertSplit cterm=NONE ctermbg=NONE ctermfg=249
set fillchars=vert:│,fold:\  " That's an escaped space.

fun! FixSplitColors()
  let l:theme = get(g:, 'airline_theme')
  let l:colors = g:airline#themes#{l:theme}#palette['inactive']['airline_a']
  exec 'hi VertSplit ctermfg=' . l:colors[2]
  exec 'hi StatusLine ctermbg=' . l:colors[3]
  exec 'hi StatusLineNC ctermbg=' . l:colors[3]
endfun
au User AirlineAfterInit,AirlineAfterTheme call FixSplitColors()

if has('GUI_GTK')
  " Linux/BSD
  set guifont=Droid\ Sans\ Mono\ 9
else
  " OS X
  set guifont=Droid\ Sans\ Mono\ Slashed\ for\ Powerline:h12
endif

fu! ClojureSetup()
  packadd 'vim-salve'
  packadd 'vim-fireplace'
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

command! -nargs=? -complete=dir SDirvish split | silent Dirvish <args>

au BufNewFile,BufRead *.svelte set filetype=html
au BufNewFile,BufRead *.lsp,*.jl call PareditInitBuffer()
au BufNewFile,BufRead *.go setlocal noexpandtab
au BufNewFile,BufRead Jemfile,Buildfile,Capfile,*.framespec,*.rabl,*.prawn set filetype=ruby
au BufNewFile,BufRead *.json set filetype=javascript
au BufNewFile,BufRead *.md set filetype=ghmarkdown wrap linebreak
au BufNewFile,BufRead * set formatoptions-=o
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
au FileType clojure call ClojureSetup()
au FileType html,xml,eruby source ~/.vim/scripts/closetag.vim
nnoremap <Leader>s :SDirvish %<CR>
nnoremap <Leader>S :SDirvish .<CR>
nnoremap <Leader>e :Dirvish %<CR>
nnoremap <Leader>E :Dirvish .<CR>
nnoremap <Leader>~ :Dirvish ~<CR>
nnoremap <Leader>n :lne<CR>
nnoremap <Leader>N :lp<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>g :GFiles<CR>
nnoremap <Leader>G :GFiles?<CR>
nnoremap <Leader>1 :set invnumber<CR>
nnoremap <Leader>v :set invpaste<CR>
nnoremap <Leader>t :set invwrap invlinebreak<CR>
nnoremap <Leader>/ :set invhlsearch<CR>
nnoremap <C-W>S :exe "res ".line('$')<CR>gg''
nnoremap du :diffupdate<CR>
nnoremap dP :.diffput<CR>

if !exists('g:lasttab')
  let g:lasttab = 1
endif
nnoremap <Leader>r gt
nnoremap <Leader>w gT
nnoremap gH :-tabfind .<CR>
nnoremap gL :tabfind .<CR>
nnoremap <Leader><Tab> :exe "tabn ".g:lasttab<CR>
au TabClosed,TabLeave * let g:lasttab = tabpagenr()

let maplocalleader=','
set lispwords+=GET,POST,PUT,DELETE,HEAD
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with-', '^def', '^do', '^if-']
let g:clojure_align_multiline_strings = 1
let g:paredit_electric_return = 0

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
