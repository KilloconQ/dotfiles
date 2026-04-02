-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, sp = "Red" })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, sp = "Yellow" })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, sp = "Blue" })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, sp = "Green" })
  end,
})
