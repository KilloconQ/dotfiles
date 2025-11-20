return {
  "sudo-tee/opencode.nvim",
  config = function()
    require("opencode").setup({
      preferred_picker = nil,
      preferred_completion = nil,
      default_global_keymaps = false, -- 🔥 Desactivamos los defaults para usar los tuyos
      default_mode = "build",
      keymap_prefix = "<leader>a",

      ---------------------------------------------------------------------
      -- 🔥 TUS KEYMAPS PERSONALIZADOS (los que enviaste al inicio)
      ---------------------------------------------------------------------
      keymap = {
        editor = {
          ["<leader>aa"] = { "toggle" }, -- Open/close
          ["<leader>ai"] = { "open_input" },
          ["<leader>aI"] = { "open_input_new_session" },
          ["<leader>ao"] = { "open_output" },
          ["<leader>at"] = { "toggle_focus" },
          ["<leader>aq"] = { "close" },
          ["<leader>af"] = { "toggle_fullscreen" },
          ["<leader>as"] = { "select_session" },
          ["<leader>ap"] = { "configure_provider" },
          ["<leader>ad"] = { "diff_open" },
          ["<leader>a]"] = { "diff_next" },
          ["<leader>a["] = { "diff_prev" },
          ["<leader>ac"] = { "diff_close" },
          ["<leader>ara"] = { "diff_revert_all_last_prompt" },
          ["<leader>art"] = { "diff_revert_this_last_prompt" },
          ["<leader>arA"] = { "diff_revert_all" },
          ["<leader>arT"] = { "diff_revert_this" },
          ["<leader>ax"] = { "swap_position" },
        },

        input_window = {
          ["<cr>"] = { "submit_input_prompt", mode = { "n", "i" } },
          ["<esc>"] = { "close" },
          ["<C-c>"] = { "cancel" },
          ["~"] = { "mention_file", mode = "i" },
          ["@"] = { "mention", mode = "i" },
          ["/"] = { "slash_commands", mode = "i" },
          ["#"] = { "context_items", mode = "i" },
          ["<C-i>"] = { "focus_input", mode = { "n", "i" } },
          ["<tab>"] = { "toggle_pane", mode = { "n", "i" } },
          ["<up>"] = { "prev_prompt_history", mode = { "n", "i" } },
          ["<down>"] = { "next_prompt_history", mode = { "n", "i" } },
          ["<M-m>"] = { "switch_mode" },
        },

        output_window = {
          ["<esc>"] = { "close" },
          ["<C-c>"] = { "cancel" },
          ["]]"] = { "next_message" },
          ["[["] = { "prev_message" },
          ["<tab>"] = { "toggle_pane", mode = { "n", "i" } },
          ["i"] = { "focus_input", "n" },
        },

        permission = {
          accept = "a",
          accept_all = "A",
          deny = "d",
        },

        session_picker = {
          rename_session = { "<C-r>" },
          delete_session = { "<C-d>" },
          new_session = { "<C-n>" },
        },

        timeline_picker = {
          undo = { "<C-u>", mode = { "i", "n" } },
          fork = { "<C-f>", mode = { "i", "n" } },
        },
      },

      ---------------------------------------------------------------------
      -- 🔧 Resto de la configuración (UI, context, etc.)
      ---------------------------------------------------------------------
      ui = {
        position = "right",
        input_position = "bottom",
        window_width = 0.40,
        input_height = 0.15,
        display_model = true,
        display_context_size = true,
        display_cost = true,
        window_highlight = "Normal:OpencodeBackground,FloatBorder:OpencodeBorder",
        icons = {
          preset = "nerdfonts",
          overrides = {},
        },
        output = {
          tools = { show_output = true },
          rendering = {
            markdown_debounce_ms = 250,
            on_data_rendered = nil,
          },
        },
        input = {
          text = { wrap = false },
        },
        completion = {
          file_sources = {
            enabled = true,
            preferred_cli_tool = "server",
            ignore_patterns = {
              "^%.git/",
              "node_modules/",
              "%.pyc$",
              "%.o$", "%.dll$", "%.so$", "%.dylib$",
              "dist/", "build/", "target/",
              "%.log$", "%.cache$",
            },
            max_files = 10,
            max_display_length = 50,
          },
        },
      },

      context = {
        enabled = true,
        diagnostics = { warn = true, error = true },
        current_file = { enabled = true },
        selection = { enabled = true },
      },

      debug = { enabled = false },
      prompt_guard = nil,
    })
  end,

  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
        file_types = { "markdown", "opencode_output" },
      },
      ft = { "markdown", "opencode_output" },
    },
    "saghen/blink.cmp",
    "folke/snacks.nvim",
  },
}
