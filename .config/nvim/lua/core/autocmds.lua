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

-- Locate file in nvim-tree when opening via Telescope
augroup("NvimTreeLocate", { clear = true })
autocmd("BufEnter", {
  group = "NvimTreeLocate",
  callback = function()
    local api = require("nvim-tree.api")
    if api.tree.is_visible() then
      api.tree.find_file({ open = false, focus = false })
    end
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
