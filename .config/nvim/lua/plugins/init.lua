return {
  -- Colorscheme
  {
    "sonjapeterson/1989.vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("1989")
    end,
  },

  -- File tree
  require("plugins.tree"),

  -- Fuzzy finder
  require("plugins.telescope"),

  -- LSP
  require("plugins.lsp"),

  -- Formatting
  require("plugins.formatting"),

  -- Git
  require("plugins.git"),

  -- Treesitter (better syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- New API: use vim.treesitter directly
      vim.treesitter.language.register("bash", "sh")

      -- Install parsers
      local ensure_installed = { "php", "javascript", "typescript", "lua", "json", "html", "css", "bash", "markdown" }
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local installed = require("nvim-treesitter.install")
          for _, lang in ipairs(ensure_installed) do
            pcall(function() installed.ensure_installed(lang) end)
          end
        end,
        once = true,
      })

      -- Enable highlighting and indentation via vim.treesitter
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  -- GitHub Copilot
  {
    "github/copilot.vim",
    lazy = false,
  },

  -- Quality of life
  { "tpope/vim-sleuth" },  -- Auto-detect indent settings
  { "numToStr/Comment.nvim", config = true },  -- gcc to comment
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "auto" },
      })
    end,
  },
}
