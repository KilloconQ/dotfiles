return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = {
          finder = "files",
          exclude = {
            "node_modules",
            ".git",
          },
        },
      },
    },
  },
}
