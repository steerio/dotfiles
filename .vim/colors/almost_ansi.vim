hi clear
syntax reset
set notermguicolors
let g:colors_name = 'almost_ansi'

hi StatusNormal  ctermbg=15 ctermfg=0
hi StatusVisual  ctermbg=3  ctermfg=0
hi StatusInsert  ctermbg=10 ctermfg=0
hi StatusReplace ctermbg=1  ctermfg=0
hi StatusTerm    ctermbg=10 ctermfg=0
hi StatusMid     ctermbg=8  ctermfg=15
hi StatusNC      ctermbg=8  ctermfg=7

hi clear TabLineFill
hi link TabLineFill StatusLine
hi clear TabLine
hi link TabLine StatusNC
hi clear TabLineSel
hi link TabLineSel StatusNormal

hi StatusLineNC     cterm=NONE ctermfg=7 ctermbg=233
hi StatusLine       cterm=NONE ctermfg=7 ctermbg=234
hi StatusLineTermNC term=reverse ctermfg=7 ctermbg=233
hi StatusLineTerm   term=reverse ctermfg=7 ctermbg=234
hi VertSplit        cterm=NONE ctermbg=0 ctermfg=8

hi SpecialKey       term=bold ctermfg=14
hi NonText          term=bold ctermfg=12
hi Directory        term=bold ctermfg=12
hi ErrorMsg         term=standout ctermfg=15 ctermbg=1
hi IncSearch        term=reverse cterm=reverse
hi Search           term=reverse ctermfg=0 ctermbg=11
hi MoreMsg          term=bold ctermfg=10
hi ModeMsg          term=bold cterm=bold
hi LineNr           term=underline ctermfg=238
hi CursorLineNr     term=bold cterm=underline ctermfg=11
hi Question         term=standout ctermfg=10
hi Title            term=bold ctermfg=11
hi Visual           term=reverse ctermbg=243
hi VisualNOS        term=bold,underline cterm=bold
hi WarningMsg       term=standout ctermfg=9
hi WildMenu         term=standout ctermfg=0 ctermbg=11
hi Folded           term=standout ctermfg=10 ctermbg=234
hi FoldColumn       term=standout ctermfg=14 ctermbg=234
hi DiffAdd          term=bold ctermbg=4
hi DiffChange       term=bold ctermbg=5
hi DiffDelete       term=bold ctermfg=12 ctermbg=6
hi DiffText         term=reverse cterm=bold ctermbg=9
hi SignColumn       term=standout ctermfg=6 ctermbg=0
hi Conceal          ctermfg=7 ctermbg=242
hi SpellBad         term=reverse ctermbg=9
hi SpellCap         term=reverse ctermbg=12
hi SpellRare        term=reverse ctermbg=13
hi SpellLocal       term=underline ctermbg=14
hi Pmenu            ctermfg=15 ctermbg=240
hi PmenuSel         ctermfg=0 ctermbg=12
hi PmenuSbar        ctermbg=248
hi PmenuThumb       ctermbg=15
hi CursorColumn     term=reverse ctermbg=242
hi CursorLine       term=underline cterm=underline
hi ColorColumn      term=reverse ctermbg=232
hi MatchParen       term=reverse ctermbg=6
hi ToolbarLine      term=underline ctermbg=242
hi ToolbarButton    cterm=bold ctermfg=0 ctermbg=7
hi Comment          ctermfg=243
hi Constant         term=underline ctermfg=13
hi Identifier       term=bold ctermfg=12
hi Function         term=bold cterm=bold ctermfg=10
hi Statement        term=bold ctermfg=9
hi Underlined       term=underline cterm=underline ctermfg=14
hi Ignore           ctermfg=0
hi Error            term=reverse ctermfg=15 ctermbg=9
hi Todo             term=standout ctermfg=0 ctermbg=11

hi Special          term=bold ctermfg=223
hi Type             term=underline ctermfg=11
hi StorageClass     ctermfg=208
hi PreProc          term=underline ctermfg=14

hi String           ctermfg=10
hi Structure        ctermfg=14
hi Number           ctermfg=14

hi CocFloating ctermbg=234
hi FgCocErrorFloatBgCocFloating ctermfg=9 ctermbg=234
hi FgCocHintFloatBgCocFloating ctermfg=4 ctermbg=234

hi rubyInterpolation ctermfg=6
hi rubyInterpolationDelimiter ctermfg=14
hi link rubyInteger Number
hi link rubyFloat Number
hi link jsonNumber Number
hi link jsonKeyword Constant
hi jsxOpenPunct ctermfg=4
hi link jsxClosePunct jsxOpenPunct
hi link jsxCloseString jsxOpenPunct
