-- 400_codecompanion.lua
-- AI coding assistant integration with local Ollama
-- TomWare AI Infrastructure - mgua 2025
--
-- Prerequisites:
--   - Ollama running locally (http://127.0.0.1:11434)
--   - Custom models: qwen-coder, rnj-coder
--
-- Keymaps use <leader>a prefix for AI (to avoid conflict with <leader>c for copy)
--
-- Usage:
--   <leader>aa  - Toggle chat window
--   <leader>ac  - Open actions menu (Code actions)
--   <leader>ai  - Inline assistant (visual mode)
--   <leader>aq  - Quick chat (ask a question)
--   <leader>as  - Switch model
--   gA          - Add selection to chat (visual mode)

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",  -- Optional: for action picker
  },
  lazy = false,  -- Load on startup so keymaps are available

  config = function()
    require("codecompanion").setup({

      -- =======================================================================
      -- STRATEGIES: Which adapter to use for different features
      -- =======================================================================
      strategies = {
        chat = {
          adapter = "qwen_coder",  -- Primary model for chat
        },
        inline = {
          adapter = "qwen_coder",  -- For inline code assistance
        },
        agent = {
          adapter = "qwen_coder",  -- For agentic tasks
        },
      },

      -- =======================================================================
      -- ADAPTERS: Connection settings for Ollama models
      -- =======================================================================
      adapters = {
        -- Primary coding model: Qwen2.5-Coder 7B
        qwen_coder = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "qwen_coder",
            schema = {
              model = {
                default = "qwen-coder",
              },
              num_ctx = {
                default = 16384,
              },
              temperature = {
                default = 0.2,
              },
            },
          })
        end,

        -- Alternative model: RNJ-1 8B
        rnj_coder = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "rnj_coder",
            schema = {
              model = {
                default = "rnj-coder",
              },
              num_ctx = {
                default = 16384,
              },
              temperature = {
                default = 0.2,
              },
            },
          })
        end,

        -- Direct Ollama adapter (for ad-hoc model selection)
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              url = "http://127.0.0.1:11434",
            },
            schema = {
              num_ctx = {
                default = 16384,
              },
            },
          })
        end,
      },

      -- =======================================================================
      -- DISPLAY: Chat window appearance
      -- =======================================================================
      display = {
        chat = {
          window = {
            layout = "vertical",  -- vertical | horizontal | float
            width = 0.35,         -- 35% of screen width for vertical
            height = 0.4,         -- 40% of screen height for horizontal
            relative = "editor",
          },
          intro_message = "Local AI ready (qwen-coder). Type /help for commands.",
          show_settings = false,  -- Don't show settings on open
          show_token_count = true,
        },
        inline = {
          diff = {
            enabled = true,
            priority = 130,
          },
        },
        action_palette = {
          provider = "telescope",  -- Use telescope for action picker
        },
      },

      -- =======================================================================
      -- SLASH COMMANDS: Available in chat with /command
      -- =======================================================================
      slash_commands = {
        ["buffer"] = {
          description = "Add current buffer to context",
          opts = { contains_code = true },
        },
        ["file"] = {
          description = "Add a file to context",
          opts = { contains_code = true },
        },
        ["help"] = {
          description = "Show available commands",
        },
      },

      -- =======================================================================
      -- PROMPT LIBRARY: Reusable prompts for common tasks
      -- =======================================================================
      prompt_library = {
        -- Code explanation
        ["Explain Code"] = {
          strategy = "chat",
          description = "Explain the selected code",
          prompts = {
            {
              role = "user",
              content = "Please explain this code. Focus on what it does, not line-by-line details:\n\n```\n${selection}\n```",
              opts = { contains_code = true },
            },
          },
        },

        -- Code review
        ["Review Code"] = {
          strategy = "chat",
          description = "Review code for bugs and improvements",
          prompts = {
            {
              role = "user",
              content = "Review this code for bugs, potential issues, and improvements. Be concise:\n\n```${filetype}\n${selection}\n```",
              opts = { contains_code = true },
            },
          },
        },

        -- Generate tests
        ["Generate Tests"] = {
          strategy = "chat",
          description = "Generate unit tests for selected code",
          prompts = {
            {
              role = "user",
              content = "Generate unit tests for this code. Use appropriate testing framework for ${filetype}:\n\n```${filetype}\n${selection}\n```",
              opts = { contains_code = true },
            },
          },
        },

        -- Fix code
        ["Fix Code"] = {
          strategy = "inline",
          description = "Fix issues in selected code",
          prompts = {
            {
              role = "user",
              content = "Fix any bugs or issues in this code. Return only the corrected code:\n\n```${filetype}\n${selection}\n```",
              opts = { contains_code = true },
            },
          },
        },

        -- Refactor
        ["Refactor"] = {
          strategy = "inline",
          description = "Refactor selected code",
          prompts = {
            {
              role = "user",
              content = "Refactor this code to be cleaner and more maintainable. Keep the same functionality:\n\n```${filetype}\n${selection}\n```",
              opts = { contains_code = true },
            },
          },
        },

        -- Add docstring/comments
        ["Add Documentation"] = {
          strategy = "inline",
          description = "Add documentation to code",
          prompts = {
            {
              role = "user",
              content = "Add appropriate documentation (docstrings, comments) to this ${filetype} code. Return the documented code:\n\n```${filetype}\n${selection}\n```",
              opts = { contains_code = true },
            },
          },
        },

        -- Quick question
        ["Quick Question"] = {
          strategy = "chat",
          description = "Ask a quick coding question",
          prompts = {
            {
              role = "user",
              content = function()
                local input = vim.fn.input("Question: ")
                if input == "" then return nil end
                return input
              end,
            },
          },
        },
      },

      -- =======================================================================
      -- OPTS: Miscellaneous options
      -- =======================================================================
      opts = {
        log_level = "ERROR",  -- DEBUG, TRACE, INFO, WARN, ERROR
        send_code = true,     -- Allow sending code to the model
        use_default_actions = true,
        use_default_prompts = true,
      },
    })

    -- =========================================================================
    -- KEYMAPS - Using <leader>a prefix for AI
    -- =========================================================================
    -- Avoids conflicts with:
    --   <leader>c  = Copy (last-keymaps.lua)
    --   <leader>ca = LSP Code Action (200_mason.lua)
    -- =========================================================================
    local map = vim.keymap.set

    -- Chat operations
    map("n", "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI: Toggle Chat" })
    map("n", "<leader>an", "<cmd>CodeCompanionChat<cr>", { desc = "AI: New Chat" })
    map("n", "<leader>ac", "<cmd>CodeCompanionActions<cr>", { desc = "AI: Actions Menu" })

    -- Quick question (opens chat with input prompt)
    map("n", "<leader>aq", function()
      local input = vim.fn.input("Ask AI: ")
      if input ~= "" then
        vim.cmd("CodeCompanionChat " .. input)
      end
    end, { desc = "AI: Quick Question" })

    -- Visual mode: chat with selection
    map("v", "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI: Toggle Chat" })
    map("v", "<leader>ac", "<cmd>CodeCompanionActions<cr>", { desc = "AI: Actions Menu" })
    map("v", "gA", "<cmd>CodeCompanionChat Add<cr>", { desc = "AI: Add to Chat" })

    -- Inline assistance (visual mode)
    map("v", "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "AI: Inline Assist" })

    -- Quick prompts with selection (visual mode)
    map("v", "<leader>ae", function()
      require("codecompanion").prompt("Explain Code")
    end, { desc = "AI: Explain Code" })

    map("v", "<leader>ar", function()
      require("codecompanion").prompt("Review Code")
    end, { desc = "AI: Review Code" })

    map("v", "<leader>af", function()
      require("codecompanion").prompt("Fix Code")
    end, { desc = "AI: Fix Code" })

    map("v", "<leader>at", function()
      require("codecompanion").prompt("Generate Tests")
    end, { desc = "AI: Generate Tests" })

    map("v", "<leader>ad", function()
      require("codecompanion").prompt("Add Documentation")
    end, { desc = "AI: Add Docs" })

    -- Switch adapter on the fly
    map("n", "<leader>as", function()
      local adapters = { "qwen_coder", "rnj_coder" }
      vim.ui.select(adapters, { prompt = "Select AI Model:" }, function(choice)
        if choice then
          -- Update the chat strategy adapter
          require("codecompanion").setup({
            strategies = {
              chat = { adapter = choice },
              inline = { adapter = choice },
            },
          })
          vim.notify("Switched to " .. choice, vim.log.levels.INFO)
        end
      end)
    end, { desc = "AI: Switch Model" })

  end,
}
