local map = vim.keymap.set
local silent = { silent = true }
local expr = { expr = true }
local remap = { remap = true }
local events = { "BufReadPre", "BufNewFile" }

local copilot_types = {
  "javascript",
  "lua",
  "markdown",
  "python",
  "ruby",
  "scss",
  "typescript",
  "typescriptreact",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "master",
    lazy = false,
    config = function()
      local enable = { enable = true }
      require("nvim-treesitter.configs").setup({
        highlight = enable,
        indent = enable,
        matchup = enable,
      })
    end,
  },
  {
    "justinmk/vim-dirvish",
    lazy = false,
    config = function()
      vim.g.dirvish_mode = ":sort | sort ,^.*/,i"
      map("n", "<BS>", "<Plug>(dirvish_up)", { silent = true })
    end,
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
    config = function()
      vim.g.StatuslineBranchFn = vim.fn.FugitiveHead
    end,
  },
  {
    "junegunn/fzf.vim",
    cmd = { "BLines", "Buffers", "Files", "GFiles", "Lines", "Rg", },
  },
  {
    "andymass/vim-matchup",
    event = events,
    opts = {
      matchparen = {
        enabled = false,
      },
      delim = {
        noskips = 2,
      },
      treesitter = {
        stopline = 500
      },
    }
  },
  {
    "urxvtcd/vim-indent-object",
    event = events,
    config = function()
      vim.cmd("runtime patch_indent.vim")
      map({ "x", "o" }, "i=", "<Plug>(indent-object_linewise-none)")
      map({ "x", "o" }, "a=", "<Plug>(indent-object_linewise-end)")
      map("n", "[=", "<Plug>(indent-start)", silent)
      map("n", "]=", "<Plug>(indent-end)", silent)
      map({ "o", "v" }, "[=", "<Plug>(indent-line-start)", silent)
      map({ "o", "v" }, "]=", "<Plug>(indent-line-end)", silent)
      map("v", "[=", "<Plug>(indent-visual-start)", silent)
      map("v", "]=", "<Plug>(indent-visual-end)", silent)
    end
  },
  {
    "machakann/vim-sandwich",
    event = events,
  },
  {
    "github/copilot.vim",
    ft = copilot_types,
    init = function()
      local type_cfg = {
        ["*"] = false,
      }
      for _, ft in ipairs(copilot_types) do
        type_cfg[ft] = true
      end

      vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = type_cfg
    end,
    config = function()
      vim.keymap.set(
        "i",
        "<C-j>",
        'copilot#Accept("\\<CR>")',
        { expr = true, silent = true, script = true, replace_keycodes = false }
      )
    end,
  },
  {
    "Vimjas/vim-python-pep8-indent",
    ft = "python",
  },
  {
    "mechatroner/rainbow_csv",
    ft = "csv",
  },
  {
    "slim-template/vim-slim",
    ft = "slim",
  },
  {
    "jxnblk/vim-mdx-js",
    ft = "mdx",
  },
  {
    "luochen1990/rainbow",
    cmd = "RainbowToggle",
    init = function()
      vim.g.rainbow_active = 0
      vim.g.rainbow_conf = {
        ctermfgs = { 9, 208, 11, 10, 14, 12, 13 },
        separately = {
          elixir = { parentheses_options = "containedin=elixirMap" }
        },
      }
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      map("n", "<M-h>", "<cmd>TmuxNavigateLeft<CR>", silent)
      map("n", "<M-j>", "<cmd>TmuxNavigateDown<CR>", silent)
      map("n", "<M-k>", "<cmd>TmuxNavigateUp<CR>", silent)
      map("n", "<M-l>", "<cmd>TmuxNavigateRight<CR>", silent)
      map("n", "<M-\\>", "<cmd>TmuxNavigatePrevious<CR>", silent)
    end,
  },
  {
    "ojroques/nvim-osc52",
    event = "VeryLazy",
    config = function()
      local osc52 = require("osc52")

      map("n", "<C-c>", osc52.copy_operator, expr)
      map("n", "gy", osc52.copy_operator, expr)
      map("n", "gyy", "gy_", remap)
      map("n", "<C-c><C-c>", "gy_", remap)
      map("n", "gY", "gy$", remap)
      map("v", "gy", osc52.copy_visual)
      map("v", "<C-c>", osc52.copy_visual)
    end,
  },
}
