set guioptions=c
highlight Normal guibg=black guifg=#c7c7c7
highlight LineNr guifg=#444444
highlight Folded guibg=#203020 guifg=#407040
highlight ColorColumn guibg=#0b0b0b
highlight VertSplit guibg=NONE

if has('GUI_GTK')
  " Linux/BSD
  set guifont=Droid\ Sans\ Mono\ 9
else
  " OS X
  set guifont=Droid\ Sans\ Mono\ Slashed\ for\ Powerline:h12
endif
