vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })

-- Move lines up and down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("x", "<leader>ae", ":'<,'>AvanteEdit<CR>", {
  noremap = true,
  silent = true,
  desc = "Avante: editar selección visual",
})

vim.keymap.set({ "i", "n", "v" }, "<C-c>", [[<C-\><C-n>]])
