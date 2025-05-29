runtime ./plugins.vim

let mapleader='\'
let maplocalleader='\'
nnoremap ,, ,

set vi=<0,'0,/16,f1,h history=100
set bs=indent sts=2 sw=2 expandtab nojoinspaces
set lazyredraw modeline modelines=3 winminheight=1 noshowcmd
set nowrap noshowmode nohlsearch noincsearch nobackup nowritebackup
set ignorecase smartcase autoindent
set foldmethod=marker foldnestmax=3 foldminlines=3
set wildmode=longest,list
set bo=all
set mouse=v

set number scl=number
set shortmess=atToscC
set ttimeoutlen=50 updatetime=800
filetype plugin indent on

if has('macunix')
  set rtp+=/opt/homebrew/opt/fzf
elseif isdirectory("/usr/share/vim/vimfiles")
  set rtp+=/usr/share/vim/vimfiles
endif

nnoremap <silent> [q :cprev<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k

nnoremap yY :%yank <c-r>=v:register<cr><cr>
nnoremap dD :%delete <c-r>=v:register<cr><cr>

" --- Plugins ---

" --- Mappings ---

fun! s:buffer_dir()
  return expand(&ft == 'dirvish' ? '%' : '%:h')
endfun

fun! s:wipe_buffers()
  let tablist = []
  for i in range(tabpagenr('$'))
    call extend(tablist, tabpagebuflist(i + 1))
  endfor

  let bc = 0
  for i in range(1, bufnr('$'))
    " bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
    if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
      silent exec 'bwipeout' i
      let bc = bc+1
    endif
  endfor
  if &filetype == 'dirvish'
    let l:view = winsaveview()
    e!
    call winrestview(l:view)
  endif
  echomsg bc . ' buffer(s) wiped out.'
endfun

fun! s:fit_window_to_buffer()
  let bottom = line('$')
  let size = &lines
  let result = 0
  let i = 0
  while result < size && i < bottom
    let result += 1
    if foldclosed(i) > 0
      let i = foldclosedend(i)+1
    else
      let i += 1
    endif
  endw
  exe 'resize '.result
endfun

if index(g:plugs_order, 'vim-fern') != -1
  fun! s:buffer_dir()
    if &ft == 'fern'
      return b:fern.root._path
    else
      return expand('%:h')
    endif
  endfun

  command! -nargs=? -complete=dir SFern split | silent Fern <args>

  nnoremap <silent>,s :SFern %:h<CR>
  nnoremap <silent>,S :SFern .<CR>
  nnoremap <silent><BS> :Fern %:h<CR>
  nnoremap <silent>,e :Fern . -reveal=%<CR>
  nnoremap <silent>,d :Fern . -drawer -toggle -width=40 -reveal=%<CR>
  nnoremap <silent>,E :Fern .<CR>
  nnoremap <silent>,~ :Fern ~<CR>
elseif index(g:plugs_order, 'vim-dirvish') != -1
  let g:dirvish_mode = ':sort | sort ,^.*/,i'
  fun! s:buffer_dir()
    return expand(&ft == 'dirvish' ? '%' : '%:h')
  endfun

  nnoremap <silent>,s :sp %:h<CR>
  nnoremap <silent>,S :sp .<CR>
  nnoremap <silent><BS> <Plug>(dirvish_up)
  nnoremap <silent>,e :e %:h<CR>
  nnoremap <silent>,E :e .<CR>
  nnoremap <silent>,~ :e ~<CR>
endif
nnoremap <silent>,b :Buffers<CR>
nnoremap <silent>,f :Files<CR>
nnoremap <silent>,g :GFiles?<CR>
nnoremap <silent>,G :GFiles<CR>
nnoremap ,/ :BLines<Space>
nnoremap ,? :Lines<Space>
nnoremap ,n :set invnumber<CR>
nnoremap ,v :set invpaste<CR>
nnoremap ,m :set invwrap invlinebreak<CR>
nnoremap ,H :set invhlsearch<CR>
nnoremap <silent>,( :RainbowToggle<CR>
nnoremap <silent><C-W>S :call <SID>fit_window_to_buffer()<CR>gg''
nnoremap <silent>du :diffupdate<CR>
nnoremap <silent>dP :.diffput<CR>

nnoremap <silent>,i :-tabnew<CR>
nnoremap <silent>,a :tabnew<CR>
nnoremap <silent>,I :0tabnew<CR>
nnoremap <silent>,A :$tabnew<CR>
" The following two are the same thing, but whatever.
nnoremap <silent>,0 :tabfirst<CR>
nnoremap <silent>,1 :tabn 1<CR>
nnoremap <silent><M-1> :tabn 1<CR>
nnoremap <silent>,2 :tabn 2<CR>
nnoremap <silent><M-2> :tabn 2<CR>
nnoremap <silent>,3 :tabn 3<CR>
nnoremap <silent><M-3> :tabn 3<CR>
nnoremap <silent>,4 :tabn 4<CR>
nnoremap <silent><M-4> :tabn 4<CR>
nnoremap <silent>,5 :tabn 5<CR>
nnoremap <silent><M-5> :tabn 5<CR>
nnoremap <silent>,$ :tablast<CR>
nnoremap ,h gT
nnoremap ,l gt
nnoremap <silent>,<Tab> g<Tab>
nnoremap <silent>,W :call <SID>wipe_buffers()<CR>
nnoremap ,r :Rg<Space>
nnoremap ,c :tcd<Space>
nnoremap ,C :tcd ../
nnoremap <silent>,. :execute("tcd ".<SID>buffer_dir())<CR>
nnoremap <silent>,p :echo "Current path:" getcwd()<CR>
nnoremap ,B :Git blame<CR>

xmap i= <Plug>(indent-object_linewise-none)
omap i= <Plug>(indent-object_linewise-none)
xmap a= <Plug>(indent-object_linewise-end)
omap a= <Plug>(indent-object_linewise-end)
nmap <silent> [= <Plug>(indent-start)
nmap <silent> ]= <Plug>(indent-end)
omap <silent> [= <Plug>(indent-line-start)
omap <silent> ]= <Plug>(indent-line-end)
vmap <silent> [= <Plug>(indent-visual-start)
vmap <silent> ]= <Plug>(indent-visual-end)

nnoremap <Up> <C-W>+
nnoremap <Down> <C-W>-
nnoremap <Left> <C-W><
nnoremap <Right> <C-W>>
nnoremap <M-k> <C-W>k
nnoremap <M-j> <C-W>j
nnoremap <M-h> <C-W>h
nnoremap <M-l> <C-W>l
nnoremap <C-W>" :term<CR>
nnoremap <C-W>% :vert rightb term<CR>
tnoremap <C-B>" <C-W>:term<CR>
tnoremap <C-B>% <C-W>:vert rightb term<CR>

vnoremap ,: :normal<Space>

" --- Looks ---

let &t_SI = "\e[5 q"
let &t_EI = "\e[2 q" 
let &t_SR = "\e[4 q"
let &t_ER = "\e[2 q"
syn on

set ruler ls=2 bg=dark
set fillchars=vert:│,fold:\  " That's an escaped space.

" --- Autocmd ---

if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '-p90%,60%' }
  let g:fzf_preview_window=['right:60%', 'ctrl-/']
else
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

  fun! s:resized()
    if &co > 159
      let g:fzf_preview_window=['right:60%', 'ctrl-/']
    else
      let g:fzf_preview_window=['up:40%', 'ctrl-/']
    endif
  endfun

  call s:resized()
endif

augroup vimrc
  autocmd!
  au BufNewFile,BufRead * set fo-=o
  if !exists('$TMUX')
    au VimResized * call s:resized()
  endif
augroup END

" --- Config ---

let g:oscyank_term = 'default'
let g:paredit_leader = '\'
let g:rainbow_active = 0
let g:rainbow_conf = {
      \ 'ctermfgs': [9, 208, 11, 10, 14, 12, 13],
      \ 'separately': {
      \   'elixir': {
      \     'parentheses_options': 'containedin=elixirMap' }}}

if !empty($VIM_COLORSCHEME)
  execute 'colorscheme ' . $VIM_COLORSCHEME
elseif has('gui_running')
  colorscheme gui_gruvbox
else
  colorscheme almost_ansi
endif

function! s:toggle_quick_fix()
  let l:qf_is_open = len(filter(getwininfo(), 'v:val.quickfix'))
  if l:qf_is_open
    cclose
  else
    let l:winview = winsaveview()
    botright copen
    call winrestview(l:winview)
    wincmd p
  endif
endfunction

nnoremap ,Q :call <SID>toggle_quick_fix()<CR>
nnoremap ,q <C-w>c

function! s:max_or_equal()
  " Save the current height of the window
  let current_height = winheight(0)

  " Maximize the window height
  wincmd _

  " If the height didn't change, perform equalize windows
  if winheight(0) == current_height
    wincmd =
  endif
endfunction

nnoremap <silent> <M--> :call <SID>max_or_equal()<CR>
nnoremap <M-n> <C-w>n

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <M-h> :<C-U>TmuxNavigateLeft<CR>
nnoremap <silent> <M-j> :<C-U>TmuxNavigateDown<CR>
nnoremap <silent> <M-k> :<C-U>TmuxNavigateUp<CR>
nnoremap <silent> <M-l> :<C-U>TmuxNavigateRight<CR>
nnoremap <silent> <M-\> :<C-U>TmuxNavigatePrevious<CR>
nmap <M-J> <M-j><C-W>_
nmap <M-K> <M-k><C-W>_
