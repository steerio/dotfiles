highlight Folded guibg=#203020 guifg=#407040

if has('GUI_GTK')
  highlight Normal guibg=black guifg=white
  set guifont=Droid\ Sans\ Mono\ 9
  set guioptions-=T
  set guioptions-=m
else
  set guifont=Droid\ Sans\ Mono\ for\ Powerline:h12
endif
