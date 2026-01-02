return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      local cmp = require("cmp")

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
            :sub(col, col)
            :match("%s") == nil
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
          cmp.select_next_item()
        elseif has_words_before() then
          cmp.complete()
          local entries = cmp.get_entries()

          if #entries == 1 then
            cmp.select_next_item()
            cmp.confirm({ select = true })
          elseif #entries > 1 then
            local input = entries[1].match_view_args_ret.input
            local common_prefix = longest_common_prefix(
              vim.tbl_map(function(entry)
                return entry:get_insert_text()
              end, entries)
            )

            if common_prefix ~= ""
              and common_prefix:sub(1, #input) == input
            then
              vim.fn.feedkeys(common_prefix:sub(#input + 1))
              cmp.complete()
            end
          end
        else
          fallback()
        end
      end

      local back = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end

      local modes = { "i" }

      cmp.setup({
        completion = { autocomplete = false },
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping(complete, modes),
          ["<S-Tab>"] = cmp.mapping(back, modes),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
        },
      })
    end,
  },
}
