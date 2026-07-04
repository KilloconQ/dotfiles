return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      angularls = {
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local root = vim.fs.root(fname, { "angular.json", "nx.json" })
          if root then
            on_dir(root)
          end
        end,
      },
      vtsls = {
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {},
            },
          },
        },
      },
    },
  },
}
