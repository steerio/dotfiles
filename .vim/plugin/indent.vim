function! s:next_line(l, up)
    let nl = a:l + (a:up ? -1 : 1)
    if nl < 1 || nl > line('$')
        throw 'buf_bound'
    endif
    return nl
endfunction

function! <SID>to_indent_end(up, vis)

    let ln = line('.')
    if indent(ln) == 0 && getline(ln) =~ '^$'
        while getline(ln) =~ '^$'
            try
                let ln = s:next_line(ln, a:up)
            catch 'buf_bound'
                break
            endtry
        endwhile
    endif
    let orig_ind = indent(ln)

    try
        let ln = s:next_line(line('.'), a:up)
    catch 'buf_bound'
        return
    endtry
    if a:vis
        normal! gv
    endif
    while indent(ln) >= orig_ind || getline(ln) =~ '^$'
        execute 'normal! ' . (a:up ? 'k' : 'j')
        try
            let ln = s:next_line(ln, a:up)
        catch 'buf_bound'
            return
        endtry
    endwhile
endfunction

nmap <silent> <Plug>(indent-start) :call <SID>to_indent_end(1, 0)<CR>
nmap <silent> <Plug>(indent-end) :call <SID>to_indent_end(0, 0)<CR>
onoremap <silent> <Plug>(indent-line-start) V:call <SID>to_indent_end(1, 0)<CR>
onoremap <silent> <Plug>(indent-line-end) V:call <SID>to_indent_end(0, 0)<CR>
vmap <silent> <Plug>(indent-visual-start) :call <SID>to_indent_end(1, 1)<CR>
vmap <silent> <Plug>(indent-visual-end) :call <SID>to_indent_end(0, 1)<CR>
