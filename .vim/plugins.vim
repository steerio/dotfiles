call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-sandwich'
Plug 'mechatroner/rainbow_csv'
Plug 'slim-template/vim-slim'
Plug 'tpope/vim-fugitive'
Plug 'urxvtcd/vim-indent-object'

Plug 'jxnblk/vim-mdx-js'

if has('nvim')
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'neovim/nvim-lspconfig'
  Plug 'ojroques/nvim-osc52'
  Plug 'nvim-treesitter/nvim-treesitter'
else
  Plug 'MaxMEllon/vim-jsx-pretty'
  Plug 'elixir-editors/vim-elixir'
  Plug 'hail2u/vim-css3-syntax'
  Plug 'jparise/vim-graphql'
  Plug 'leafgarland/typescript-vim'
  Plug 'neovimhaskell/haskell-vim'
  Plug 'ojroques/vim-oscyank'
  Plug 'yuezk/vim-js'
endif

call plug#end()
