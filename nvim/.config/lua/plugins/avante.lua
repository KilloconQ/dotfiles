return {
  {
    "yetone/avante.nvim",
    -- Avante main plugin configuration for Neovim
    -- If you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ Must add this setting for proper functionality!
    build = function()
      -- Conditionally use the correct build system for the current OS
      if vim.fn.has("win32") == 1 then
        -- Use PowerShell build for Windows
        return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      else
        -- Use make for Unix-based systems
        return "make"
      end
    end,
    event = "VeryLazy", -- Load plugin lazily for performance
    version = false, -- Never set this value to "*"! This prevents unwanted upgrades.
    ---@module 'avante'
    opts = function(_)
      -- Track Avante's internal state during window resizing operations
      local in_resize = false
      local original_cursor_win = nil
      -- List of filetypes used by Avante plugin windows
      local avante_filetypes = { "Avante", "AvanteInput", "AvanteAsk", "AvanteSelectedFiles" }

      -- Checks if the current window is an Avante window
      local function is_in_avante_window()
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.api.nvim_buf_get_option(buf, "filetype")

        for _, avante_ft in ipairs(avante_filetypes) do
          if ft == avante_ft then
            return true, win, ft
          end
        end
        return false
      end

      -- Temporarily move cursor away from Avante window during resize to avoid redraw issues
      local function temporarily_leave_avante()
        local is_avante, avante_win, avante_ft = is_in_avante_window()
        if is_avante and not in_resize then
          in_resize = true
          original_cursor_win = avante_win

          -- Find a non-Avante window to switch to so resizing does not affect Avante UI
          local target_win = nil
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_buf_get_option(buf, "filetype")

            local is_avante_ft = false
            for _, aft in ipairs(avante_filetypes) do
              if ft == aft then
                is_avante_ft = true
                break
              end
            end

            if not is_avante_ft and vim.api.nvim_win_is_valid(win) then
              target_win = win
              break
            end
          end

          -- Switch to non-Avante window if found
          if target_win then
            vim.api.nvim_set_current_win(target_win)
            return true
          end
        end
        return false
      end

      -- Restore cursor to the original Avante window after resize is complete
      local function restore_cursor_to_avante()
        if in_resize and original_cursor_win and vim.api.nvim_win_is_valid(original_cursor_win) then
          -- Small delay to ensure resize is complete before switching back
          vim.defer_fn(function()
            pcall(vim.api.nvim_set_current_win, original_cursor_win)
            in_resize = false
            original_cursor_win = nil
          end, 50)
        end
      end

      -- Cleanup duplicate Avante windows after resize
      local function cleanup_duplicate_avante_windows()
        local seen_filetypes = {}
        local windows_to_close = {}
        -- Iterate all windows and mark duplicates for closing
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_buf_get_option(buf, "filetype")

          -- Special handling for Ask and Select Files panels
          if ft == "AvanteAsk" or ft == "AvanteSelectedFiles" then
            if seen_filetypes[ft] then
              -- Found duplicate, mark for closing
              table.insert(windows_to_close, win)
            else
              seen_filetypes[ft] = win
            end
          end
        end

        -- Close duplicate windows
        for _, win in ipairs(windows_to_close) do
          if vim.api.nvim_win_is_valid(win) then
            pcall(vim.api.nvim_win_close, win, true)
          end
        end
      end

      -- Create autocmd group for resize fix to avoid conflicts between autocmds
      vim.api.nvim_create_augroup("AvanteResizeFix", { clear = true })

      -- Main handler for VimResized event
      vim.api.nvim_create_autocmd({ "VimResized" }, {
        group = "AvanteResizeFix",
        callback = function()
          -- Move cursor away from Avante before resize
          local moved = temporarily_leave_avante()

          if moved then
            -- Let resize happen, then restore cursor and force redraw
            vim.defer_fn(function()
              restore_cursor_to_avante()
              vim.cmd("redraw!")
            end, 100)
          end

          -- Cleanup duplicates after resize completes
          vim.defer_fn(cleanup_duplicate_avante_windows, 150)
        end,
      })

      -- Prevent Avante from responding to scroll/resize events during resize
      vim.api.nvim_create_autocmd({ "WinScrolled", "WinResized" }, {
        group = "AvanteResizeFix",
        pattern = "*",
        callback = function(args)
          local buf = args.buf
          if buf and vim.api.nvim_buf_is_valid(buf) then
            local ft = vim.api.nvim_buf_get_option(buf, "filetype")

            for _, avante_ft in ipairs(avante_filetypes) do
              if ft == avante_ft then
                -- Prevent event propagation for Avante buffers during resize
                if in_resize then
                  return true -- This should stop the event for Avante buffers
                end
                break
              end
            end
          end
        end,
      })

      -- Additional cleanup on focus events to ensure state is reset
      vim.api.nvim_create_autocmd("FocusGained", {
        group = "AvanteResizeFix",
        callback = function()
          -- Reset resize state on focus gain
          in_resize = false
          original_cursor_win = nil
          -- Clean up any duplicate Avante windows
          vim.defer_fn(cleanup_duplicate_avante_windows, 100)
        end,
      })

      -- Return Avante plugin options
      return {
        -- Provider for suggestions and completions
        provider = "copilot",
        providers = {
          copilot = {
            -- Model for Copilot provider
            -- model = "claude-sonnet-4",
            model = "gpt-4.1",
          },
        },
        cursor_applying_provider = "copilot", -- Provider for cursor actions
        auto_suggestions_provider = "copilot", -- Provider for auto suggestions
        behaviour = {
          enable_cursor_planning_mode = true, -- Enable advanced cursor planning
        },
        -- File selector configuration
        --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string
        file_selector = {
          provider = "snacks", -- Use snacks provider to avoid native provider issues
          provider_opts = {},
        },
        windows = {
          ---@type "right" | "left" | "top" | "bottom" | "smart"
          position = "right", -- Sidebar position
          wrap = true, -- Enable line wrapping similar to vim.o.wrap
          width = 30, -- Default width (percentage of available width)
          sidebar_header = {
            enabled = true, -- Enable/disable sidebar header
            align = "center", -- Title alignment (left, center, right)
            rounded = false, -- Disable rounded corners
          },
          input = {
            prefix = "> ", -- Input prompt prefix
            height = 8, -- Height of the input window in vertical layout
          },
          edit = {
            start_insert = true, -- Start in insert mode when opening the edit window
          },
          ask = {
            floating = false, -- Do not open 'AvanteAsk' prompt in floating window
            start_insert = true, -- Start insert mode when opening the ask window
            ---@type "ours" | "theirs"
            focus_on_apply = "ours", -- Which diff to focus after applying (ours/theirs)
          },
        },
      }
    end,
    dependencies = {
      "MunifTanjim/nui.nvim", -- Required for UI components
      {
        -- Support for image pasting in Avante
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- Recommended settings for image handling
          default = {
            embed_image_as_base64 = false, -- Do not embed images as base64 by default
            prompt_for_file_name = false, -- Do not prompt for file name on paste
            drag_and_drop = {
              insert_mode = true, -- Enable insert mode for drag and drop
            },
            -- Required for Windows users to handle paths
            use_absolute_path = true,
          },
        },
      },
    },
  },
}
