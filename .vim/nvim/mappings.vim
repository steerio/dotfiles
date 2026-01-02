fun! s:buffer_dir()
  return expand(&ft == 'dirvish' ? '%' : '%:h')
endfun

nnoremap <silent>,b :Buffers<CR>
nnoremap <silent>,f :Files<CR>
nnoremap <silent>,g :GFiles?<CR>
nnoremap <silent>,G :GFiles<CR>
nnoremap ,/ :BLines<Space>
nnoremap ,? :Lines<Space>
nnoremap <silent>,( :RainbowToggle<CR>
nnoremap <silent>,. :execute("tcd ".<SID>buffer_dir())<CR>

nmap <M-J> <M-j><C-W>_
nmap <M-K> <M-k><C-W>_
