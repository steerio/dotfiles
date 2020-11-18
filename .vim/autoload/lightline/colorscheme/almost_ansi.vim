" =============================================================================
" Filename: autoload/lightline/colorscheme/almost_ansi.vim
" Author: itchyny, jackno, steerio
" License: MIT License
" =============================================================================

let s:fallback = (has('nvim') ? $TERM : &term) !=# 'linux'

let s:black = [ '#000000', 0 ]
let s:maroon = [ '#bf2900', 1 ]
let s:green = [ '#427b00', 2 ]
let s:olive = [ '#d99800', 3 ]
let s:navy = [ '#006fd1', 4 ]
let s:purple = [ '#8a21bf', 5 ]
let s:teal = [ '#008585', 6 ]
let s:silver = [ '#acc1d3', 7 ]
let s:gray = [ '#283842', 8]
let s:red = [ '#e74d23', 9 ]
let s:lime = [ '#7dc030', 10 ]
let s:yellow = [ '#ffc233', 11 ]
let s:blue = [ '#5aa2e0', 12 ]
let s:fuchsia = [ '#b968d9', 13 ]
let s:aqua = [ '#15c1bb', 14 ]
let s:white = [ '#b9cbda', 15 ]
let s:darkgray = [ '#121212', s:fallback ? 8 : 233 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [[ s:black, s:white ], [ s:white, s:gray ]]
let s:p.normal.middle = [[ s:silver, s:darkgray ]]
let s:p.normal.right = copy(s:p.normal.left)
let s:p.normal.error = [[ s:black, s:red ]]
let s:p.normal.warning = [[ s:black, s:olive ]]
let s:p.inactive.left =  [[ s:silver, s:gray ], [ s:gray, s:darkgray ]]
let s:p.inactive.middle = [[ s:silver, s:darkgray ]]
let s:p.inactive.right = copy(s:p.inactive.left)
let s:p.insert.left = [[ s:black, s:lime ], [ s:white, s:gray ]]
let s:p.insert.right = copy(s:p.insert.left)
let s:p.replace.left = [[ s:white, s:maroon ], [ s:white, s:gray ]]
let s:p.replace.right = copy(s:p.replace.left)
let s:p.visual.left = [[ s:black, s:olive ], [ s:white, s:gray ]]
let s:p.visual.right = copy(s:p.visual.left)
let s:p.tabline.left = [[ s:silver, s:gray ]]
let s:p.tabline.tabsel = copy(s:p.normal.right)
let s:p.tabline.middle = [[ s:silver, s:darkgray ]]
let s:p.tabline.right = copy(s:p.normal.right)

let g:lightline#colorscheme#almost_ansi#palette = lightline#colorscheme#flatten(s:p)
