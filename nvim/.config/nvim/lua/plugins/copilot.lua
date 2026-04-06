return {
  "zbirenbaum/copilot.lua",
  optional = true,
  opts = {
    filetypes = {
      yaml = false,
      markdown = false,
      help = false,
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      ["."] = false,
    },
    server_opts_overrides = {
      root_dir = function(filename)
        if not filename or filename == "" or vim.startswith(filename, "oil://") then
          return vim.fn.getcwd()
        end
        local ok, util = pcall(require, "lspconfig.util")
        if ok then
          return util.root_pattern(".git", ".hg")(filename) or vim.fn.getcwd()
        end
        return vim.fn.getcwd()
      end,
    },
  },
}
