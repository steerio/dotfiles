local map = vim.keymap.set
local silent = { silent = true }
local expr = { expr = true }
local remap = { remap = true }
local events = { "BufReadPre", "BufNewFile" }

local copilot_types = {
  "eruby",
  "javascript",
  "json",
  "lua",
  "markdown",
  "python",
  "ruby",
  "scss",
  "sql",
  "typescript",
  "typescriptreact",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
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
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function ()
      vim.g.StatuslineBranchFn = function()
        return vim.b.gitsigns_head
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "GitSignsUpdate",
        callback = function(args)
          if vim.b[args.buf].gitsigns_head then
            vim.wo.signcolumn = "yes"
          else
            vim.wo.signcolumn = "number"
          end
        end,
      })

      local gs = require("gitsigns")
      gs.setup({
        signcolumn = true,
        numhl = false
      })

      vim.keymap.set("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.next_hunk()
        end
      end, { desc = "Next hunk" })

      vim.keymap.set("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.prev_hunk()
        end
      end, { desc = "Previous hunk" })

      vim.keymap.set("n", ",>", gs.stage_hunk)
      vim.keymap.set("n", ",<", gs.reset_hunk)
      vim.keymap.set("n", "<C-Space>", gs.preview_hunk)
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
