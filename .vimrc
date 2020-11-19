set nocompatible
let mapleader=','
let maplocalleader='+'
nnoremap \ ,

set vi=<0,'0,/16,f1,h history=100
set number
set ttimeoutlen=50
set bs=2 ts=2 sw=2 expandtab
set lazyredraw modeline modelines=3
set nowrap noshowmode nohlsearch nobackup nowritebackup
set ignorecase smartcase autoindent
set foldmethod=marker foldnestmax=3 foldminlines=3
set wildmode=longest,list
set bo=all
set mouse=v
set dir=~/.vim/swap,.,~/tmp,~/

" --- Mappings ---

fun! s:wipe_buffers()
  let l:tablist = []
  for i in range(tabpagenr('$'))
    call extend(l:tablist, tabpagebuflist(i + 1))
  endfor

  let l:count = 0
  for i in range(1, bufnr('$'))
    " bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
    if bufexists(i) && !getbufvar(i,"&mod") && index(l:tablist, i) == -1
      silent exec 'bwipeout' i
      let l:count = l:count + 1
    endif
  endfor
  echomsg l:count . ' buffer(s) wiped out.'
endfun

command! -nargs=? -complete=dir SDirvish split | silent Dirvish <args>

nnoremap <silent><Leader>s :SDirvish %<CR>
nnoremap <silent><Leader>S :SDirvish .<CR>
nnoremap <silent><Leader>e :Dirvish %<CR>
nnoremap <silent><Leader>E :Dirvish .<CR>
nnoremap <silent><Leader>~ :Dirvish ~<CR>
nnoremap <silent><Leader>b :Buffers<CR>
nnoremap <silent><Leader>f :Files<CR>
nnoremap <silent><Leader>g :GFiles<CR>
nnoremap <silent><Leader>G :GFiles?<CR>
nnoremap <silent><Leader>n :set invnumber<CR>
nnoremap <silent><Leader>v :set invpaste<CR>
nnoremap <silent><Leader>m :set invwrap invlinebreak<CR>
nnoremap <silent><Leader>/ :set invhlsearch<CR>
nnoremap <silent><Leader>( :RainbowToggle<CR>
nnoremap <silent><C-W>S :exe "res ".line('$')<CR>gg''
nnoremap <silent>du :diffupdate<CR>
nnoremap <silent>dP :.diffput<CR>

if !exists('s:lasttab')
  let s:lasttab = 1
endif

fun! s:rotate_tab()
  exe "tabn " . s:lasttab
endfun

nnoremap <silent><Leader>i :-tabnew<CR>
nnoremap <silent><Leader>a :tabnew<CR>
nnoremap <silent><Leader>I :0tabnew<CR>
nnoremap <silent><Leader>A :$tabnew<CR>
" The following two are the same thing, but whatever.
nnoremap <silent><Leader>0 :tabfirst<CR>
nnoremap <silent><Leader>1 :tabn 1<CR>
nnoremap <silent><Leader>2 :tabn 2<CR>
nnoremap <silent><Leader>3 :tabn 3<CR>
nnoremap <silent><Leader>4 :tabn 4<CR>
nnoremap <silent><Leader>$ :tablast<CR>
nnoremap <Leader>h gT
nnoremap <Leader>l gt
nnoremap <silent><Leader><Tab> :call <SID>rotate_tab()<CR>
nnoremap <silent><Leader>W :call <SID>wipe_buffers()<CR>
nnoremap <Leader>r :Rg<Space>
nnoremap <Leader>c :tcd<Space>
nnoremap <Leader>C :tcd ../
nnoremap <silent><Leader>p :echo "Current path:" getcwd()<CR>
au TabClosed,TabLeave * let s:lasttab = tabpagenr()

nmap SS <Plug>YSsurround
nmap Ss <Plug>YSsurround
nmap ss <Plug>Yssurround
nmap S <Plug>YSurround
nmap s <Plug>Ysurround

nnoremap <Up> <C-W>+
nnoremap <Down> <C-W>-
nnoremap <Left> <C-W><
nnoremap <Right> <C-W>>
nnoremap <C-W>" :term<CR>
nnoremap <C-W>% :vert rightb term<CR>
tnoremap <C-B>" <C-W>:term<CR>
tnoremap <C-B>% <C-W>:vert rightb term<CR>

vnoremap <Leader>: :normal<Space>

" --- Lightline ---

let s:sid = has('nvim') ? '<SNR>'.(maparg('s','n','',1).sid).'_' : expand('<SID>')

fun! s:maybe_shorten(path)
  return strlen(a:path) < winwidth(0) - 90 ? a:path : pathshorten(a:path)
endfun

fun! s:ll_tabmodified(n)
  for l:i in tabpagebuflist(a:n)
    if getbufvar(l:i, '&mod')
      return '+'
    endif
  endfor
endfun

fun! s:ll_tab(n)
  let l:num = tabpagewinnr(a:n)
  let l:bufnr = tabpagebuflist(a:n)[l:num - 1]
  let l:buftype = getbufvar(l:bufnr, '&buftype')

  if empty(l:buftype) || getbufvar(l:bufnr, '&ft') ==# 'dirvish'
    let l:path = expand('#'.l:bufnr.':p:~')
    let l:empty = empty(l:path)
    if !empty && l:path[0] !=# '~'
      " Path is not within home
      return pathshorten(l:path)
    endif
    " Path is within home or empty
    let l:cwd = fnamemodify(getcwd(l:num, a:n), ':~')

    if l:cwd[0] ==# '~' && strlen(l:cwd) > 2 && (l:empty || stridx(l:path, l:cwd) == 0)
      " Tag needed: cwd is within home, but deeper; file empty or path within cwd
      let l:tag = '[' . fnamemodify(l:cwd, ':t') . ']'
      if l:empty
        return l:tag
      else
        let l:right = l:path[strlen(l:cwd)+1:]
        if !strlen(l:right)
          return l:tag
        endif
        return l:tag . ' ' . (l:right[-1:] ==# '/'
              \ ? pathshorten(l:right[0:-2]).'/'
              \ : fnamemodify(l:right, ':t'))
      endif
    else
      " No tag
      return l:empty ? '' : pathshorten(l:path)
    endif
  else
    return expand('#' . l:bufnr . ':t')
  endif
endfun

fun! s:ll_status_path()
  if empty(&buftype)
    let l:path = expand('%')
    if empty(l:path)
      return &mod ? '[+]' : '[-]'
    endif
    return s:maybe_shorten(fnamemodify(l:path, ':~:.')) . (&mod ? '[+]' : '')
  elseif &ft ==# 'dirvish'
    let _ = expand('%:~:.')
    return empty(_)
          \ ? s:maybe_shorten(expand('%:~')) . ' [cwd]'
          \ : s:maybe_shorten(_)
  else
    return expand('%:t')
  endif
endfun

fun! s:ll_type_or_branch()
  if empty(&buftype) || &ft ==# 'dirvish'
    let l:branch = FugitiveHead()
    return empty(l:branch)
          \ ? 'no '
          \ : ' '.substitute(l:branch, '^feature-', 'f-', '')
  else
    return &buftype
  endif
endfun

fun! s:ll_filetype()
  return winwidth(0) > 80 ? &ft : '' 
endfun

fun! s:ll_fileformat()
  return winwidth(0) > 80 && &ff != 'unix' ? 'f:'.&ff : '' 
endfun

fun! s:ll_fileenc()
  return winwidth(0) > 80 && !empty(&fenc) && &fenc !=# 'utf-8' ? 'e:'.&fenc : '' 
endfun

fun! s:ll_ro()
  return (&ro || !&ma ? '' : '')
endfun

let g:lightline = {
      \ 'colorscheme': 'almost_ansi',
      \ 'active': {
      \   'left': [
      \     [ 'filename', 'readonly' ],
      \     [ 'type_or_branch' ]],
      \   'right': [
      \     [ 'mode', 'paste' ],
      \     [ 'lineinfo' ],
      \     [ 'fileformat', 'fileencoding', 'filetype' ]]},
      \ 'inactive': {
      \   'right': [['lineinfo'], ['filetype']]},
      \ 'tab': {
      \   'active': [ 'tabnum', 'loc', 'tabmodified' ],
      \   'inactive': [ 'tabnum', 'loc', 'tabmodified' ]},
      \ 'component': {
      \   'lineinfo': '%3l/%L:%2c' },
      \ 'component_function': {
      \   'readonly': s:sid.'ll_ro',
      \   'type_or_branch': s:sid.'ll_type_or_branch',
      \   'filename': s:sid.'ll_status_path',
      \   'fileencoding': s:sid.'ll_fileenc',
      \   'fileformat': s:sid.'ll_fileformat',
      \   'filetype': s:sid.'ll_filetype' },
      \ 'mode_map': {
      \   'n': 'N', 'i': 'I', 'R': 'R', 'v': 'V',
      \   't': 'TERM', 'c': 'CMD', 's': 'SELECT',
      \   'V': 'L', "\<C-v>": 'BK',
      \   'S': 'SELECT/LN', "\<C-s>": 'SELECT/BK' },
      \ 'tab_component_function': {
      \   'tabmodified': s:sid.'ll_tabmodified',
      \   'loc': s:sid.'ll_tab' },
      \ 'tabline': { 'right': [] }}

unlet s:sid

if (has('nvim') ? $TERM : &term) !=# 'linux'
  let g:lightline.separator = { 'left': '', 'right': '' }
  let g:lightline.subseparator = { 'left': '', 'right': '' }
endif

" --- Looks ---

let &t_SI = "\e[5 q"
let &t_EI = "\e[2 q" 
let &t_SR = "\e[4 q"
let &t_ER = "\e[2 q"
syn on

colorscheme almost_ansi
set ruler ls=2 bg=dark
set fillchars=vert:│,fold:\  " That's an escaped space.
" --- Au --

augroup vimrc
  au BufNewFile,BufRead * set fo-=o
augroup END

" --- Config ---

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

let g:closetag_filenames = '*.html,*.xhtml,*.js'
let g:closetag_xhtml_filenames = '*.xhtml,*.js'
let g:closetag_filetypes = 'html,xhtml'
let g:closetag_xhtml_filetypes = 'html,xhtml,js'
let g:closetag_regions = { 'javascript': 'jsxRegion' }
let g:rainbow_active = 0
let g:rainbow_conf = {
      \ 'ctermfgs': [129, 39, 48, 190, 202],
      \ 'separately': {
      \   'elixir': {
      \     'parentheses_options': 'containedin=elixirMap' }}}
