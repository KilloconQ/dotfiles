-- This file contains the configuration for disabling specific Neovim plugins.

return {
  {
    -- Plugin: bufferline.nvim
    -- URL: https://github.com/akinsho/bufferline.nvim
    -- Description: A snazzy buffer line (with tabpage integration) for Neovim.
    "akinsho/bufferline.nvim",
    enabled = true, -- Disable this plugin
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = false,
  },
  {
    "olimorris/codecompanion.nvim",
    enabled = false,
  },
  {
    "yetone/avante.nvim",
    enabled = false,
  },
  {
    "azorng/goose.nvim",
    enabled = false,
  },
  -- {
  --   "NickvanDyke/opencode.nvim",
  --   enabled = true,
  -- },
}
