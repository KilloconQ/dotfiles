-- Instalar el esquema de color tokyonight
return {
  -- añadir tokyonight
  { "folke/tokyonight.nvim" },

  -- Configurar LazyVim para cargar tokyonight-night
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
