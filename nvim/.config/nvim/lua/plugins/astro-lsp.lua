return {
  "neovim/nvim-lspconfig",
  opts = { servers = { astro = {} } },
  init = function()
    local orig = vim.lsp.util.apply_text_document_edit
    vim.lsp.util.apply_text_document_edit = function(text_document_edit, index, offset_encoding)
      -- Elimina el version check poniendo la versión del edit a nil
      local patched = vim.deepcopy(text_document_edit)
      if patched.textDocument then
        patched.textDocument.version = nil
      end
      orig(patched, index, offset_encoding)
    end
  end,
}
