return {
  "saghen/blink.cmp",
  lazy = true,
  dependencies = { "saghen/blink.compat" },
  opts = {
    sources = {
      default = { "avante_commands", "avante_mentions", "avante_files" },
      compat = {
        "avante_commands",
        "avante_mentions",
        "avante_files",
      },
      -- LSP score_offset is typically 60
      providers = {
        avante_commands = {
          name = "avante_commands",
          module = "blink.compat.source",
          score_offset = 90,
          opts = {},
        },
        avante_files = {
          name = "avante_files",
          module = "blink.compat.source",
          score_offset = 100,
          opts = {},
        },
        avante_mentions = {
          name = "avante_mentions",
          module = "blink.compat.source",
          score_offset = 1000,
          opts = {},
        },
      },
    },
  },
  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = "mono",
  },
}
