return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    -- prettier is the fallback for JS/TS/JSON; biome/oxfmt only run in projects
    -- that actually opt into them (have their own config file), otherwise
    -- they'd ignore .prettierrc
    for _, ft in ipairs({
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "json",
      "jsonc",
    }) do
      opts.formatters_by_ft[ft] = { "biome", "oxfmt", "prettier", stop_after_first = true }
    end

    opts.formatters_by_ft.astro = { "prettier" }

    opts.formatters = opts.formatters or {}
    opts.formatters.biome = {
      condition = function(_, ctx)
        return vim.fs.find({ "biome.json", "biome.jsonc" }, {
          path = ctx.dirname,
          upward = true,
        })[1] ~= nil
      end,
    }
    opts.formatters.oxfmt = {
      -- only oxfmt's own config marks opt-in; oxlint's config is a separate
      -- tool (linting) and shouldn't hijack formatting from prettier
      condition = function(_, ctx)
        return vim.fs.find({
          ".oxfmtrc.json",
          ".oxfmtrc.jsonc",
          "oxfmt.config.ts",
        }, {
          path = ctx.dirname,
          upward = true,
        })[1] ~= nil
      end,
    }
  end,
}
