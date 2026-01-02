vim.opt.runtimepath:prepend(vim.fn.expand("~/.vim"))
vim.cmd("runtime! vimrc mappings.vim")

require'config.lazy'

local map = vim.keymap.set

map('n', ',D', vim.diagnostic.open_float)
map('n', '[e', vim.diagnostic.goto_prev)
map('n', ']e', vim.diagnostic.goto_next)
map('n', ',L', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.cmd("redrawstatus")

    local buf = vim.lsp.buf
    local opts = { buffer = ev.buf }
    map('n', 'K', buf.hover, opts)

    map('n', 'gd', buf.type_definition, opts)
    map('n', 'gD', buf.declaration, opts)
    map('n', '<C-]>', buf.definition, opts)
    map('n', 'g!', buf.implementation, opts)
    map('n', 'g>', buf.references, opts)

    map('n', '<C-W>gd', ':split | lua vim.lsp.buf.type_definition()<CR>', opts)
    map('n', '<C-W><C-]>', ':split | lua vim.lsp.buf.definition()<CR>', opts)
    map('n', '<C-W>gD', ':split | lua vim.lsp.buf.declaration()<CR>', opts)
    map("n", ",lf", function()
      buf.code_action({
        apply = true,
        context = {
          only = { "quickfix" },
          diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
        },
      })
    end)
  end
})

vim.g.StatuslineFlagsFn = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local flags = {}

  -- LSP
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local lang_flag = ""
  for _, client in ipairs(clients) do
    if client.name == "GitHub Copilot" then
      table.insert(flags, "c")
    elseif client.server_capabilities
       and client.server_capabilities.semanticTokensProvider then
      lang_flag = "L"
    elseif lang_flag == "" then
      lang_flag = "l"
    end
  end
  table.insert(flags, lang_flag)

  -- Tree-sitter
  if vim.treesitter.highlighter
     and vim.treesitter.highlighter.active[bufnr] then
    table.insert(flags, "t")
  end

  return table.concat(flags)
end
