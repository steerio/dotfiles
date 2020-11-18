RainbowToggleOn

set lispwords+=GET,POST,PUT,DELETE,HEAD
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with-', '^def', '^do', '^if-']
let g:clojure_align_multiline_strings = 1
let g:paredit_electric_return = 0

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
