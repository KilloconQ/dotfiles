return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      svelte = {},
      astro = {},
    },
  },
  init = function()
    -- Workaround: ignora el version check de los text document edits
    -- (algunos servidores envían versiones desincronizadas)
    local orig = vim.lsp.util.apply_text_document_edit
    vim.lsp.util.apply_text_document_edit = function(text_document_edit, index, offset_encoding)
      local patched = vim.deepcopy(text_document_edit)
      if patched.textDocument then
        patched.textDocument.version = nil
      end
      orig(patched, index, offset_encoding)
    end
  end,
}
