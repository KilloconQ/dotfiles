return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    -- prettier is the default for JS/TS/JSON; biome only runs in projects that
    -- actually opt into it (have a biome.json), otherwise it'd ignore .prettierrc
    for _, ft in ipairs({
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "json",
      "jsonc",
    }) do
      opts.formatters_by_ft[ft] = { "biome", "prettier", "oxfmt", stop_after_first = true }
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
  end,
}
