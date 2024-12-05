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
  Plug 'elixir-editors/vim-elixir.git'
  Plug 'jparise/vim-graphql.git'
  Plug 'antoinemadec/coc-fzf.git'
  Plug 'neoclide/coc.nvim'
  Plug 'neovimhaskell/haskell-vim'
  Plug 'leafgarland/typescript-vim.git'
  Plug 'hail2u/vim-css3-syntax.git'
  Plug 'yuezk/vim-js'
  Plug 'MaxMEllon/vim-jsx-pretty.git'
  Plug 'ojroques/vim-oscyank'
endif

call plug#end()
