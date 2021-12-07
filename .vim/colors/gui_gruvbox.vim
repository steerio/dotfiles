hi clear
syntax reset
let g:colors_name = 'gui_gruvbox'

hi Normal guibg=black guifg=#eddbb2
hi StatusNormal  guibg=#ebdbb2 guifg=#282828
hi StatusVisual  guibg=#d79921 guifg=#282828
hi StatusInsert  guibg=#b8bb26 guifg=#282828
hi StatusReplace guibg=#cc241d guifg=#282828
hi StatusTerm    guibg=#b8bb26 guifg=#282828
hi StatusMid     guibg=#504945 guifg=#ebdbb2
hi StatusNC      guibg=#504945 guifg=#a89984

hi! link TabLineFill StatusLine
hi! link TabLine StatusNC
hi! link TabLineSel StatusNormal

hi StatusLineNC     gui=NONE guibg=#121212 guifg=#a89984
hi StatusLine       gui=NONE guibg=#1d2021 guifg=#a89984
hi VertSplit        gui=NONE guibg=Black guifg=#504945

hi SpecialKey       guifg=#8ec07c
hi NonText          gui=bold guifg=#83a598
hi Directory        guifg=#83a598
hi ErrorMsg         guifg=#ebdbb2 guibg=#cc241d
hi IncSearch        gui=reverse
hi Search           guifg=#282828 guibg=#fabd2f
hi MoreMsg          gui=bold guifg=#b8bb26
hi ModeMsg          gui=bold
hi LineNr           guifg=#444444
hi CursorLineNr     gui=bold guifg=#fabd2f
hi Question         gui=bold guifg=#b8bb26
hi Title            gui=bold guifg=#fabd2f
hi Visual           guibg=#7c6f64
hi VisualNOS        gui=bold,underline
hi WarningMsg       guifg=#fb4934
hi WildMenu         guifg=#282828 guibg=#fabd2f
hi Folded           guifg=#b8bb26 guibg=#1d2021
hi FoldColumn       guifg=#8ec07c guibg=#1d2021
hi DiffAdd          guibg=#458588
hi DiffChange       guibg=#b16286
hi DiffDelete       gui=bold guifg=#83a598 guibg=#689d6a
hi DiffText         gui=bold guibg=#fb4934
hi SignColumn       guifg=#689d6a guibg=Black
hi Conceal          guifg=#a89984 guisp=#6c6c6c
hi SpellBad         gui=undercurl guisp=#fb4934
hi SpellCap         gui=undercurl guisp=#83a598
hi SpellRare        gui=undercurl guisp=#d3869b
hi SpellLocal       gui=undercurl guisp=#8ec07c
hi Pmenu            guifg=#ebdbb2
hi PmenuSel         guibg=#83a598 guifg=#282828
hi PmenuSbar        guibg=#bdae93
hi PmenuThumb       guibg=#ebdbb2
hi CursorColumn     guibg=#6c6c6c
hi CursorLine       guibg=#6c6c6c
hi ColorColumn      guibg=#d12d00
hi MatchParen       guibg=#689d6a
hi ToolbarLine      guibg=#6c6c6c
hi ToolbarButton    gui=bold guifg=#282828 guibg=#a89984
hi Comment          guifg=#a89984
hi Constant         guifg=#d3869b
hi Identifier       guifg=#83a598
hi Function         guifg=#b8bb26
hi Statement        guifg=#fb4934
hi Underlined       gui=underline guifg=#8ec07c
hi Ignore           guifg=#282828
hi Error            guifg=#ebdbb2 guibg=#fb4934
hi Todo             guifg=#282828 guibg=#fabd2f

hi Special          guifg=#ebdbb2
hi Type             guifg=#fabd2f
hi StorageClass     guifg=#fe8019
hi PreProc          guifg=#8ec07c

hi String           guifg=#b8bb26
hi Structure        guifg=#8ec07c

hi rubyInterpolation guifg=#689d6a
hi rubyInterpolationDelimiter guifg=#8ec07c
hi rubyInteger guifg=#8ec07c
hi link rubyFloat rubyInteger
