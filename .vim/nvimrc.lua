package.path = package.path .. ';' .. os.getenv("HOME") .. '/.vim/nvim/lua/?.lua'

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  }
}

local lsp = require('lspconfig')
lsp.tsserver.setup {}
lsp.ruby_lsp.setup {}
lsp.hls.setup {}

vim.keymap.set('n', ',d', vim.diagnostic.open_float)
vim.keymap.set('n', '[e', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']e', vim.diagnostic.goto_next)
vim.keymap.set('n', ',q', vim.diagnostic.setloclist)

if pcall(require, 'osc52') then
  vim.keymap.set('n', 'Y', require('osc52').copy_operator, {expr = true})
  vim.keymap.set('n', 'YY', 'Y_', {remap = true})
  vim.keymap.set('v', 'Y', require('osc52').copy_visual)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', ',jd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', ',jD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', ',jt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', ',ji', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', ',jr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', ',wd', ':split | lua vim.lsp.buf.definition()<CR>', opts)
    vim.keymap.set('n', ',wD', ':split | lua vim.lsp.buf.declaration()<CR>', opts)
    vim.keymap.set('n', ',wt', ':split | lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.keymap.set('n', ',wi', ':split | lua vim.lsp.buf.implementation()<CR>', opts)
    vim.keymap.set('n', ',wr', ':split | lua vim.lsp.buf.references()<CR>', opts)
  end
})
