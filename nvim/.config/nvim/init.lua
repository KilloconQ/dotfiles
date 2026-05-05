-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.snippets")

vim.g.have_nerd_font = true

vim.opt.autoread = true
vim.cmd("packadd nvim.undotree")

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})
