function! s:dot2png()
  let l:filepath = expand('%:p')
  let l:output_file = expand('%:r') . '.png'
  let l:output = system('dot -Tpng ' . shellescape(l:filepath) . ' -o ' . shellescape(l:output_file) . ' 2>&1')
  if v:shell_error
    echoerr l:output
  else
    echo 'Generated ' . l:output_file
  endif
endfunction

nmap <buffer> <silent> <LocalLeader>m :call <SID>dot2png()<CR>
