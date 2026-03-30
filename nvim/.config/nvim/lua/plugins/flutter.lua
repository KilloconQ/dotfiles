return {
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    opts = {
      ui = {
        border = "rounded",
        notification_style = "plugin",
      },
      decorations = {
        statusline = {
          app_version = true,
          device = true,
        },
      },
      flutter_path = vim.fn.expand("~/dev/flutter/bin/flutter"),
      flutter_lookup_cmd = nil,
      fvm = false,
      widget_guides = {
        enabled = true,
      },
      closing_tags = {
        highlight = "Comment",
        prefix = "// ",
        priority = 10,
        enabled = true,
      },
      dev_log = {
        enabled = true,
        notify_errors = false,
        open_cmd = "tabedit",
      },
      dev_tools = {
        autostart = false,
        auto_open_browser = false,
      },
      outline = {
        open_cmd = "30vnew",
        auto_open = false,
      },
      lsp = {
        color = {
          enabled = true,
          background = false,
          background_color = nil,
          foreground = false,
          virtual_text = true,
          virtual_text_str = "■",
        },
        on_attach = function(_, bufnr)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Flutter: " .. desc })
          end
          map("<leader>Fr", "<cmd>FlutterRun<cr>", "Run")
          map("<leader>Fq", "<cmd>FlutterQuit<cr>", "Quit")
          map("<leader>Fd", "<cmd>FlutterDevices<cr>", "Devices")
          map("<leader>Fe", "<cmd>FlutterEmulators<cr>", "Emulators")
          map("<leader>Fh", "<cmd>FlutterReload<cr>", "Hot Reload")
          map("<leader>FH", "<cmd>FlutterRestart<cr>", "Hot Restart")
          map("<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", "Outline")
          map("<leader>Fl", "<cmd>FlutterLogClear<cr>", "Clear Log")
          map("<leader>Fs", "<cmd>FlutterSuper<cr>", "Go to Super Class")
          map("<leader>Fw", "<cmd>FlutterCopyProfilerUrl<cr>", "Copy Profiler URL")
        end,
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          renameFilesWithClasses = "prompt",
          enableSnippets = true,
          updateImportsOnRename = true,
        },
      },
      debugger = {
        enabled = true,
        run_via_dap = true,
        register_configurations = function(_)
          local dap = require("dap")
          dap.adapters.dart = {
            type = "executable",
            command = "flutter",
            args = { "debug_adapter" },
          }
        end,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "dart" })
    end,
  },
}
