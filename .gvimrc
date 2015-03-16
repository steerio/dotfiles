highlight Folded guibg=#203020 guifg=#407040

if has('GUI_GTK')
  " Linux/BSD
  highlight Normal guibg=black guifg=white
  set guifont=Droid\ Sans\ Mono\ 9
  set guioptions-=T
  set guioptions-=m
else
  " OS X
  set guioptions-=e
  set guifont=Droid\ Sans\ Mono\ for\ Powerline:h12
  highlight normal guibg=black
endif
