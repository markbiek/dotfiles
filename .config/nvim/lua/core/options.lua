local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs and indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = false  -- Adjust based on your standards

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8

-- Behavior
opt.splitright = true
opt.splitbelow = true
opt.undofile = true  -- Persistent undo
opt.updatetime = 250
opt.timeoutlen = 500

-- Clipboard (works on macOS and Linux with xclip/xsel)
opt.clipboard = "unnamedplus"

-- For Claude Code editing files externally
opt.autoread = true
