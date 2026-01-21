return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      desc = "Format buffer",
    },
  },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        php = { "phpcbf" },
        javascript = { "prettier", "eslint_d" },
        typescript = { "prettier", "eslint_d" },
        javascriptreact = { "prettier", "eslint_d" },
        typescriptreact = { "prettier", "eslint_d" },
        json = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        lua = { "stylua" },
      },
      format_on_save = {
        timeout_ms = 3000,  -- phpcbf can be slow
        lsp_fallback = true,
      },
      formatters = {
        phpcbf = {
          command = vim.fn.expand("~/.composer/vendor/bin/phpcbf"),
          args = { "--standard=WordPress", "-q", "-" },
          stdin = true,
        },
      },
    })
  end,
}
