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
        init_options = {
          addonSettings = {
            ["Ruby LSP Rails"] = {
              enablePendingMigrationsPrompt = false
            }
          }
        },
        reuse_client = function(client, conf)
          return client.name == conf.name and client.config.root_dir == conf.root_dir
        end,
      })
      lsp.enable("ruby_lsp")

      local function serves(name, root)
        for _, client in ipairs(lsp.get_clients({ name = name })) do
          if client.config.root_dir == root then
            return true
          end
        end

        return false
      end

      local function typescript_major(root)
        local manifest = vim.fs.joinpath(root, "node_modules", "typescript", "package.json")

        if vim.fn.filereadable(manifest) == 0 then
          return 0
        end

        local ok, pkg = pcall(vim.json.decode, table.concat(vim.fn.readfile(manifest), "\n"))
        local version = ok and type(pkg) == "table" and vim.version.parse(tostring(pkg.version))

        return version and version.major or 0
      end

      local function typescript_gate(name, accept)
        local root_dir = lsp.config[name].root_dir

        lsp.config(name, {
          root_dir = function(bufnr, on_dir)
            root_dir(bufnr, function(root)
              if serves(name, root) or accept(typescript_major(root)) then
                on_dir(root)
              end
            end)
          end,
        })
        lsp.enable(name)
      end

      typescript_gate("ts_ls", function(major)
        return major > 0 and major < 7
      end)

      typescript_gate("tsc", function(major)
        return major == 0 or major >= 7
      end)

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.INFO]  = "",
            [vim.diagnostic.severity.HINT]  = "",
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
            [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
          },
        },
      })
    end,
  },
}
