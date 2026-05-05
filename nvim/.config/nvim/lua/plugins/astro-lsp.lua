return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      svelte = {},
      astro = {},
    },
  },
  init = function()
    -- Fix para el bug de document_color en Neovim 0.12.x
    -- document_color.enable() se activa en cada LspAttach sin verificar
    -- si el server soporta textDocument/documentColor, lo que causa un
    -- assert al aplicar text edits (ej: al aceptar completaciones de blink.cmp)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
          return
        end
        local supports = client:supports_method("textDocument/documentColor")
        pcall(vim.lsp.document_color.enable, supports, args.buf)
      end,
    })

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
