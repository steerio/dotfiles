if hlID('StatusActive')
  finish
endif

hi link StatusActive StatusNormal
hi link StatusActive_c StatusNormal_c

let s:disp = has('gui_running') ? 'gui' : 'cterm'
let s:ambiguous = ["be", "fe", "bo", "app", "site", "web"]

if &term !=# 'linux'
  fun! s:connecting_highlight(from, to, ...)
    let name    = get(a:, 1, a:from.'_c')
    let from    = synIDtrans(hlID(a:from))
    let to      = synIDtrans(hlID(a:to))

    let reverse = synIDattr(a:from, 'reverse', s:disp)
    let fg = synIDattr(from, l:reverse                        ? 'fg' : 'bg', s:disp)
    let bg = synIDattr(to,   synIDattr(to, 'reverse', s:disp) ? 'fg' : 'bg', s:disp)

    if l:fg ==# '' || l:bg ==# ''
      exe printf('hi link %s %s', name, a:from)
    else
      exe printf('hi %s %s=%s %sfg=%s %sbg=%s',
            \ name,
            \ s:disp, reverse ? 'reverse' : 'NONE',
            \ s:disp, reverse ? bg : fg,
            \ s:disp, reverse ? fg : bg)
    endif
  endfun

  fun! s:update_highlights()
    for n in ['Normal', 'Visual', 'Insert', 'Replace', 'Term']
      call s:connecting_highlight('Status'.n, 'StatusMid')
    endfor
    call s:connecting_highlight('StatusMid', 'StatusLine')
    call s:connecting_highlight('StatusNC', 'StatusLineNC')
    call s:connecting_highlight('Tabline', 'TabLineFill', 'TabLine_end')
    call s:connecting_highlight('TablineSel', 'TabLineFill', 'TabLineSel_end')
    call s:connecting_highlight('Tabline', 'TabLineSel')
    call s:connecting_highlight('TablineSel', 'TabLine')
  endfun

  call s:update_highlights()

  let s:lheavy = ''
  let s:rheavy = ''
  let s:lsep = ''
  let s:rsep = ''
  let s:rsepw = '  '

  fun! s:connect(outside, right)
    return '%#Status'.a:outside.'_c#'.(a:right ? s:rheavy : s:lheavy)
  endfun

  fun! s:tab_connect(sel, last, next_sel)
    if a:sel
      let hl = a:last ? 'Sel_end' : 'Sel_c'
    elseif a:next_sel
      let hl = '_c'
    elseif a:last
      let hl = '_end'
    else
      return s:lsep
    endif
    return '%#TabLine'.hl.'#'.s:lheavy
  endfun
else
  let s:lsep = '|'
  let s:rsep = s:lsep
  let s:rsepw = ' | '

  fun! s:connect(outside, idx)
    return ''
  endfun

  fun! s:tab_connect(sel, last, next_sel)
    if !a:sel && !a:next_sel
      return s:lsep
    else
      return ''
    endif
  endfun
endif

"" Helpers

" Stolen from Lightline
if exists('*win_gettype')
  fun! s:skip() abort " Vim 8.2.0257 (00f3b4e007), 8.2.0991 (0fe937fd86), 8.2.0996 (40a019f157)
    return win_gettype() ==# 'popup' || win_gettype() ==# 'autocmd'
  endfun
else
  fun! s:skip() abort
    return &buftype ==# 'popup'
  endfun
endif

fun! s:maybe_shorten(path)
  return strlen(a:path) < winwidth(0) - 90 ? a:path : pathshorten(a:path)
endfun

"" Elements

fun! s:ro()
  return (&ro || !&ma ? ' '.s:lsep.' ' : '')
endfun

fun! s:filename()
  if empty(&buftype)
    let path = expand('%')
    if empty(path)
      return &mod ? '[+]' : '[-]'
    endif
    return s:maybe_shorten(fnamemodify(path, ':~:.')) . (&mod ? '[+]' : '').s:ro()
  elseif &ft ==# 'dirvish'
    let path = expand('%:~:.')
    return empty(path)
          \ ? s:maybe_shorten(expand('%:~')) . ' [cwd]'
          \ : s:maybe_shorten(path)
  else
    return expand('%:t').s:ro()
  endif
endfun

fun! s:type_branch()
  if empty(&buftype) || &ft ==# 'dirvish'
    let branch = FugitiveHead()
    return empty(branch)
          \ ? ''
          \ : ' '.branch->substitute('^feature\([-/]\)', 'f\1', '')->substitute('^issue[-/]', '#', '')
  else
    return &buftype
  endif
endfun

fun! s:attributes()
  if winwidth(0) < 80 | return '' | endif

  let buf = []
  if &ff != 'unix' | call add(buf, 'f:'.&ff) | endif
  if !empty(&fenc) && &fenc !=# 'utf-8'
    call add(buf, 'e:'.&fenc)
  endif
  if &ft !=# '' | call add(buf, &ft) | endif
  return join(buf, s:rsepw)
endfun

let s:highlights = {
      \ 'i': 'Insert', 'v': 'Visual',
      \ 'R': 'Replace', 't': 'Term' }

let s:labels = {
      \ 'n': 'N', 'i': 'I',
      \ "\<C-v>": 'VB', "\<C-s>": 'SB',
      \ 'c': ':', 't': 'TERM' }

let s:highlights.V = s:highlights.v
let s:highlights["\<C-v>"] = s:highlights.v
let s:highlights.s = s:highlights.v
let s:highlights.S = s:highlights.v
let s:highlights["\<C-s>"] = s:highlights.v

let s:m = ''
fun! s:mode()
  let l:m = mode()[0]

  if l:m !=# s:m
    let hl = get(s:highlights, l:m,  'Normal')
    execute 'hi link StatusActive Status'.hl
    execute 'hi link StatusActive_c Status'.hl.'_c'
    let s:m = l:m
  endif

  let buf = get(s:labels, l:m, l:m)
  if &paste | let buf .= ' '.s:rsep.' PASTE' | endif
  return buf
endfun

"" Templates

" No globals!
let s:sid = expand('<SID>')

let s:templates = [
      \ '%#StatusActive# %{'.s:sid.'filename()} '.s:connect('Active', 0).
      \ '%#StatusMid# %{'.s:sid.'type_branch()} '.s:connect('Mid', 0).
      \ '%#StatusLine#%='.
      \ '%{'.s:sid.'attributes()} '.s:connect('Mid', 1).
      \ '%#StatusMid# %3l/%L:%2c '.s:connect('Active', 1).
      \ '%#StatusActive# %{'.s:sid.'mode()} ',
      \
      \ '%#StatusNC# %{'.s:sid.'filename()} '.s:connect('NC', 0).
      \ '%#StatusLineNC#%='.
      \ '%{&ft} '.s:connect('NC', 1).
      \ '%#StatusNC# %3l/%L:%2c '
      \ ]

"" Tabline

fun! s:tab_modified(n)
  for l:i in tabpagebuflist(a:n)
    if getbufvar(l:i, '&mod')
      return ' +'
    endif
  endfor
  return ''
endfun

fun! s:tab_label(n)
  let tabnum = tabpagewinnr(a:n)
  let bufnr = tabpagebuflist(a:n)[tabnum - 1]
  let buftype = getbufvar(bufnr, '&buftype')

  if empty(buftype) || getbufvar(bufnr, '&ft') ==# 'dirvish'
    let path = expand('#'.bufnr.':p:~')
    let empty = empty(path)
    if !empty && path[0] !=# '~'
      " Path is not within home
      return pathshorten(path)
    endif
    " Path is within home or empty
    let cwd = fnamemodify(getcwd(tabnum, a:n), ':~')

    if cwd[0] ==# '~' && strlen(cwd) > 2 && (empty || stridx(path, cwd) == 0)
      " Tag needed: cwd is within home but deeper; file empty or path within cwd
      let tag = fnamemodify(cwd, ':t')
      if index(s:ambiguous, tag) >= 0
        let tag = fnamemodify(fnamemodify(cwd, ':h'), ':t') . '/' . tag
      endif
      let tag = '[' . tag . ']'

      if empty
        return tag
      else
        let right = path[strlen(cwd)+1:]
        if !strlen(right)
          return tag
        endif
        return tag . ' ' . (right[-1:] ==# '/'
              \ ? pathshorten(right[0:-2]).'/'
              \ : fnamemodify(right, ':t'))
      endif
    else
      " No tag
      return empty ? '' : pathshorten(path)
    endif
  else
    return expand('#' . bufnr . ':t')
  endif
endfun

fun! s:tabline()
  let sel = tabpagenr()
  let last = tabpagenr('$')
  let prev = 1 " Not, but yeah.
  let buf = ''
  for i in range(1, last)
    let curr = sel == i

    if curr
      let buf .= '%#TabLineSel#'
    elseif prev
      let buf .= '%#TabLine#'
    endif

    let buf .= ' '.i.' '.s:tab_label(i).s:tab_modified(i).' '.
          \ s:tab_connect(curr, i == last, sel == i+1)
    let prev = curr
  endfor
  return buf.'%#TabLineFill#'
endfun

"" Plumbing

fun! s:update() abort
  if s:skip() | return | endif
  let w = winnr()
  for n in range(1, winnr('$'))
    call setwinvar(n, '&statusline', s:templates[n!=w])
  endfor
endfun

augroup status
  autocmd!
  autocmd BufEnter,SessionLoadPost,FileChangedShellPost * call s:update()
  if &term !=# 'linux'
    autocmd ColorScheme * call s:update_highlights()
  endif
augroup END

exe 'set tabline=%!'.s:sid.'tabline()'
unlet s:sid
