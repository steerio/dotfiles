set rtp^=~/.vim
set pp^=~/.vim,~/.vim/nvim
set dir^=~/.vim/nvim/swap
source ~/.vim/nvimrc.lua
source ~/.vim/vimrc

command! SyntaxEngine lua vim.cmd('echo ' .. (require'helpers'.is_treesitter_active() and '"Treesitter"' or '"Standard"'))
