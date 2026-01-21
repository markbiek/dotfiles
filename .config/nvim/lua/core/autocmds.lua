local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Reload file when changed externally (for Claude Code)
augroup("AutoReload", { clear = true })
autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = "AutoReload",
  command = "checktime",
})

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- File type specific settings
augroup("FileTypeSettings", { clear = true })
autocmd("FileType", {
  group = "FileTypeSettings",
  pattern = { "javascript", "typescript", "json", "lua" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})
