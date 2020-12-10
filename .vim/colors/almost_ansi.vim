hi clear
syntax reset
let g:colors_name = 'almost_ansi'

hi StatusLineNC     cterm=reverse ctermfg=8 ctermbg=15 guibg=#283842 guifg=White
hi StatusLine       cterm=reverse ctermfg=7 ctermbg=15 guibg=#acc1d3 guifg=White
hi StatusLineTermNC cterm=reverse ctermfg=8 ctermbg=15 guibg=#283842 guifg=White
hi StatusLineTerm   cterm=reverse ctermfg=7 ctermbg=15 guibg=#acc1d3 guifg=White
hi VertSplit        cterm=NONE ctermbg=0 ctermfg=8 gui=NONE guibg=Black guifg=#283842

hi SpecialKey       term=bold ctermfg=14 guifg=#15c1bb
hi NonText          term=bold ctermfg=12 gui=bold guifg=#5aa2e0
hi Directory        term=bold ctermfg=12 guifg=#5aa2e0
hi ErrorMsg         term=standout ctermfg=15 ctermbg=1 guifg=White guibg=#d12d00
hi IncSearch        term=reverse cterm=reverse gui=reverse
hi Search           term=reverse ctermfg=0 ctermbg=11 guifg=Black guibg=#ffc233
hi MoreMsg          term=bold ctermfg=10 gui=bold guifg=#7dc030
hi ModeMsg          term=bold cterm=bold gui=bold
hi LineNr           term=underline ctermfg=238 guifg=#444444
hi CursorLineNr     term=bold cterm=underline ctermfg=11 gui=bold guifg=#ffc233
hi Question         term=standout ctermfg=10 gui=bold guifg=#7dc030
hi Title            term=bold ctermfg=11 gui=bold guifg=#ffc233
hi Visual           term=reverse ctermbg=243 guibg=DarkGrey
hi VisualNOS        term=bold,underline cterm=bold,underline gui=bold,underline
hi WarningMsg       term=standout ctermfg=9 guifg=#e74d23
hi WildMenu         term=standout ctermfg=0 ctermbg=11 guifg=Black guibg=#ffc233
hi Folded           term=standout ctermfg=10 ctermbg=234 guifg=#7dc030 guibg=#080808
hi FoldColumn       term=standout ctermfg=14 ctermbg=234 guifg=#15c1bb guibg=#6c6c6c
hi DiffAdd          term=bold ctermbg=4 guibg=#006fd1
hi DiffChange       term=bold ctermbg=5 guibg=#8a21bf
hi DiffDelete       term=bold ctermfg=12 ctermbg=6 gui=bold guifg=#5aa2e0 guibg=#119c97
hi DiffText         term=reverse cterm=bold ctermbg=9 gui=bold guibg=#e74d23
hi SignColumn       term=standout ctermfg=14 ctermbg=242 guifg=#15c1bb guibg=#6c6c6c
hi Conceal          ctermfg=7 ctermbg=242 guifg=#acc1d3 guibg=#6c6c6c
hi SpellBad         term=reverse ctermbg=9 gui=undercurl guisp=#e74d23
hi SpellCap         term=reverse ctermbg=12 gui=undercurl guisp=#5aa2e0
hi SpellRare        term=reverse ctermbg=13 gui=undercurl guisp=#b968d9
hi SpellLocal       term=underline ctermbg=14 gui=undercurl guisp=#15c1bb
hi Pmenu            ctermfg=0 ctermbg=13 guibg=#b968d9
hi PmenuSel         ctermfg=242 ctermbg=0 guibg=#6c6c6c
hi PmenuSbar        ctermbg=248 guibg=#a8a8a8
hi PmenuThumb       ctermbg=15 guibg=White
hi TabLine          cterm=NONE,reverse ctermbg=15 ctermfg=242 guibg=#6c6c6c
hi TabLineSel       ctermbg=0 ctermfg=7
hi TabLineFill      cterm=reverse ctermfg=242
hi CursorColumn     term=reverse ctermbg=242 guibg=#6c6c6c
hi CursorLine       term=underline cterm=underline guibg=#6c6c6c
hi ColorColumn      term=reverse ctermbg=232 guibg=#d12d00
hi MatchParen       term=reverse ctermbg=6 guibg=#008585
hi ToolbarLine      term=underline ctermbg=242 guibg=#6c6c6c
hi ToolbarButton    cterm=bold ctermfg=0 ctermbg=7 gui=bold guifg=Black guibg=#acc1d3
hi Comment          term=bold ctermfg=6 guifg=#15c1bb
hi Constant         term=underline ctermfg=13 guifg=#b968d9
hi Identifier       term=underline cterm=bold ctermfg=14 guifg=#15c1bb
hi Statement        term=bold ctermfg=12 gui=bold guifg=#ffc233
hi Underlined       term=underline cterm=underline ctermfg=14 gui=underline guifg=#15c1bb
hi Ignore           ctermfg=0 guifg=bg
hi Error            term=reverse ctermfg=15 ctermbg=9 guifg=White guibg=#e74d23
hi Todo             term=standout ctermfg=0 ctermbg=11 guifg=Black guibg=#ffc233

hi Special          term=bold ctermfg=223 guifg=Orange
hi Type             term=underline ctermfg=14 gui=bold guifg=#60ff60
hi PreProc          term=underline ctermfg=12 guifg=#5fd7ff
