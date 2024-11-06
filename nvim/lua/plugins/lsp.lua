local lspconfig = require("lspconfig")

lspconfig.angularls.setup({
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
})
