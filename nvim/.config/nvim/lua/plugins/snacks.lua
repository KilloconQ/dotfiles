return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = {
          finder = "files",
          args = { "--no-ignore-vcs" }, -- ignora solo .gitignore, no .ignore de fd
          exclude = {
            "node_modules",
            ".git",
          },
        },
      },
    },
  },
}
