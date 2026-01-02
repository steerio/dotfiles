return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      local lsp = vim.lsp

      lsp.config("biome", {
        cmd = { "npx", "biome", "lsp-proxy" },
        root_markers = { "biome.json", "biome.jsonc", ".biome.json" },
        single_file_support = false,
      })
      lsp.enable("biome")

      lsp.enable("hls")
      lsp.enable("pyright")

      lsp.config("ruby_lsp", {
        root_markers = { "Gemfile" },
        reuse_client = function(client, conf)
          return client.name == conf.name and client.config.root_dir == conf.root_dir
        end,
      })
      lsp.enable("ruby_lsp")
      lsp.enable("ts_ls")
    end,
  },
}
