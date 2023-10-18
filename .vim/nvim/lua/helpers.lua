local M = {}

M.is_treesitter_active = function()
  local parsers = require'nvim-treesitter.parsers'
  local current_buf = vim.api.nvim_get_current_buf()
  local lang = parsers.get_buf_lang(current_buf)
  return lang and parsers.has_parser(lang) or false
end

return M
