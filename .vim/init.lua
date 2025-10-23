vim.opt.runtimepath:prepend(vim.fn.expand("~/.vim"))
vim.cmd("runtime ./shared.vim")

package.path = package.path .. ';' .. os.getenv("HOME") .. '/.vim/nvim/lua/?.lua'

require'nvim-treesitter.configs'.setup { highlight = { enable = true }}

-- Set up LSP

local util = require("lspconfig.util")

-- vim.lsp.config("elixirls", { cmd = { "elixir-ls" } })
-- vim.lsp.enable("elixirls")
vim.lsp.enable("pyright")
-- lsp.rust_analyzer.setup {}
vim.lsp.enable("ts_ls")
vim.lsp.config("ruby_lsp", {
  root_dir = util.root_pattern("Gemfile")
})
vim.lsp.enable("ruby_lsp")
vim.lsp.config("biome", {
  -- Biome’s LSP binary
  cmd = { "npx", "biome", "lsp-proxy" },
  root_dir = util.root_pattern("biome.json", "biome.jsonc", ".biome.json"),
  single_file_support = false,
})
vim.lsp.enable("biome")
vim.lsp.enable("hls")

vim.keymap.set('n', ',D', vim.diagnostic.open_float)
vim.keymap.set('n', '[e', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']e', vim.diagnostic.goto_next)
vim.keymap.set('n', ',L', vim.diagnostic.setloclist)

if pcall(require, 'osc52') then
  vim.keymap.set('n', '<C-c>', require('osc52').copy_operator, {expr = true})
  vim.keymap.set('n', 'gy', require('osc52').copy_operator, {expr = true})
  vim.keymap.set('n', 'gyy', 'gy_', {remap = true})
  vim.keymap.set('n', '<C-c><C-c>', 'gy_', {remap = true})
  vim.keymap.set('n', 'gY', 'gy$', {remap = true})
  vim.keymap.set('v', 'gy', require('osc52').copy_visual)
  vim.keymap.set('v', '<C-c>', require('osc52').copy_visual)
end

vim.keymap.set("n", ",lf", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "quickfix" },
      diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
    },
  })
end)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

    vim.keymap.set('n', 'gd', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'g!', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'g>', vim.lsp.buf.references, opts)

    vim.keymap.set('n', '<C-W>gd', ':split | lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.keymap.set('n', '<C-W><C-]>', ':split | lua vim.lsp.buf.definition()<CR>', opts)
    vim.keymap.set('n', '<C-W>gD', ':split | lua vim.lsp.buf.declaration()<CR>', opts)
  end
})

vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', { expr = true, silent = true, script = true, replace_keycodes = false })

-- Set up nvim-cmp

local cmp = require'cmp'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local longest_common_prefix = function(strings)
  if #strings == 0 then return "" end
  local prefix = strings[1]
  for i = 2, #strings do
    while strings[i]:sub(1, #prefix) ~= prefix do
      prefix = prefix:sub(1, #prefix - 1)
      if prefix == "" then return prefix end
    end
  end
  return prefix
end

local complete = function(fallback)
  if cmp.visible() then
    -- The option list is already open, just select the next item
    cmp.select_next_item()
  elseif has_words_before() then
    cmp.complete()
    local entries = cmp.get_entries()

    if #entries == 1 then
      -- There's only one match, confirm it and close the menu
      cmp.select_next_item()
      cmp.confirm({ select = true })
    elseif #entries == 0 then
      -- There are no matches, don't do anything
      return
    else
      -- Check for the longest common prefix and complete it
      local input = entries[1].match_view_args_ret.input
      local common_prefix = longest_common_prefix(vim.tbl_map(function(entry) return entry:get_insert_text() end, entries))

      if common_prefix and common_prefix ~= '' and common_prefix:sub(1, #input) == input then
        vim.fn.feedkeys(common_prefix:sub(#input + 1))
        cmp.complete()
      end
    end
  else
    fallback()
  end
end

local back = function(callback)
  if cmp.visible() then
    cmp.select_prev_item()
  else
    fallback()
  end
end

local modes = { "i" }

local mapping = {
  ['<C-e>'] = cmp.mapping.abort(),
  ['<Tab>'] = cmp.mapping(complete, modes),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ['<S-Tab>'] = cmp.mapping(back, modes)
}

cmp.setup({
  completion = { autocomplete = false },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert(mapping),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})
require("cmp_git").setup() ]]-- 

-- Syntax engine helpers

local helpers = require'helpers'

vim.api.nvim_create_user_command("SyntaxEngine", function()
  print(helpers.is_treesitter_active() and "Treesitter" or "Standard")
end, {})

local ts_utils = require("nvim-treesitter.ts_utils")

function print_ts_node()
  local node = ts_utils.get_node_at_cursor()
  if not node then
    print("No Tree-Sitter node found under cursor.")
    return
  end

  local node_type = node:type()
  local node_range = { node:range() }
  print(string.format("Node: %s [%d, %d] - [%d, %d]", node_type, node_range[1], node_range[2], node_range[3], node_range[4]))
end

vim.keymap.set('n', ',N', print_ts_node, { noremap = true, silent = true })
