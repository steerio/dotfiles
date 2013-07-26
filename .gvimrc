highlight Folded guibg=#102050 guifg=#4060bb

if has('GUI_GTK')
  highlight Normal guibg=black guifg=white
  set guifont=Droid\ Sans\ Mono\ 9
  set guioptions-=T
  set guioptions-=m
else
  set guifont=Monaco:h12
endif
