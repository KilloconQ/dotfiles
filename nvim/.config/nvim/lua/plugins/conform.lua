return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    -- oxfmt owns JS/TS/JSON; assignment replaces prettier/biome instead of stacking
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
  end,
}
