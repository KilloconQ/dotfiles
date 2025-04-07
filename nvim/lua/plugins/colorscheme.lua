-- Instalar el esquema de color tokyonight
return {
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   lazy = false,
  --   opts = {
  --     transparent_background = true,
  --     flavour = "mocha",
  --   },
  --   integrations = {
  --     cmp = true,
  --     gitsigns = true,
  --     nvimtree = true,
  --     treesitter = true,
  --     notify = false,
  --     mini = {
  --       enabled = true,
  --       indentscope_color = "",
  --     },
  --     -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  --   },
  -- },
  {
    {
      "xiyaowong/transparent.nvim",
      config = function()
        require("transparent").setup({
          extra_groups = { -- table/string: additional groups that should be cleared
            "Normal",
            "NormalNC",
            "Comment",
            "Constant",
            "Special",
            "Identifier",
            "Statement",
            "PreProc",
            "Type",
            "Underlined",
            "Todo",
            "String",
            "Function",
            "Conditional",
            "Repeat",
            "Operator",
            "Structure",
            "LineNr",
            "NonText",
            "SignColumn",
            "CursorLineNr",
            "EndOfBuffer",
          },
          exclude = {}, -- table: groups you don't want to clear
        })
      end,
    },
    {
      "Alan-TheGentleman/oldworld.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "oldworld",
      },
    },
  },
}
