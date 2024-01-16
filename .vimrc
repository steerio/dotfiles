set pp^=~/.vim/vim90
set dir^=~/.vim/vim90/swap

source ~/.vim/vimrc

fun! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfun

nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)
nmap <silent> ,jd <Plug>(coc-definition)
nmap <silent> ,wd :call CocAction('jumpDefinition', 'split')<CR>
nmap <silent> ,jt <Plug>(coc-type-definition)
nmap <silent> ,ji <Plug>(coc-implementation)
nmap <silent> ,jr <Plug>(coc-references)
nnoremap <silent>,d :CocFzfList diagnostics --current-buf<CR>
nnoremap <silent>,D :CocFzfList diagnostics<CR>
nnoremap <silent>,o :CocFzfList outline<CR>

nnoremap <silent> Y <Plug>OSCYank
nmap <silent> YY <C-c>_
nmap <silent> Yy :call OSCYankString(join(getline(1, '$'), "\n")
