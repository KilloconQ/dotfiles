-- Restaura los iconos "vanilla" estilo nvim-kickstart:
--   1. oil/archivos -> nvim-web-devicons real (anula el mock de mini.icons)
--   2. blink dropdown -> kind_icons default de blink.cmp (anula el override de LazyVim)

return {
  -- mini.icons por default hace `mock_nvim_web_devicons()` en su init.
  -- Reemplazamos init con una función vacía: mini.icons sigue disponible,
  -- pero no se mete con nvim-web-devicons.
  {
    "nvim-mini/mini.icons",
    init = function() end,
  },

  -- El extra blink de LazyVim sobrescribe appearance.kind_icons con
  -- LazyVim.config.icons.kinds. Lo revertimos al default de blink.
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.appearance = opts.appearance or {}
      opts.appearance.kind_icons = require("blink.cmp.config.appearance").default.kind_icons
    end,
  },
}
