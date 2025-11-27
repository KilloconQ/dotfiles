-- ~/.config/nvim/lua/config/snippets.lua
local ls = require("luasnip")

-- Carga tus snippets personalizados
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets/" })
