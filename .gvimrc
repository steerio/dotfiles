highlight Folded guibg=#203020 guifg=#407040
set guioptions=c

if has('GUI_GTK')
  " Linux/BSD
  highlight Normal guibg=black guifg=white
  set guifont=Droid\ Sans\ Mono\ 9
else
  " OS X
  set guifont=Droid\ Sans\ Mono\ for\ Powerline:h12
  highlight normal guibg=black
endif
