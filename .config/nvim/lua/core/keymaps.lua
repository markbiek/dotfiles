vim.g.mapleader = "\\"  -- Backslash as leader key

local keymap = vim.keymap.set

-- File tree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })
keymap("n", "<leader>ef", ":NvimTreeFocus<CR>", { desc = "Focus file tree" })
keymap("n", "<leader>el", ":NvimTreeFindFile<CR>", { desc = "Locate current file in tree" })
keymap("n", "<leader>ec", ":NvimTreeCollapse<CR>", { desc = "Collapse file tree" })

-- Telescope (fuzzy finding)
keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Grep in files" })
keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })

-- Git
keymap("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
keymap("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
keymap("n", "<leader>gd", ":Gvdiffsplit<CR>", { desc = "Git diff" })

-- LSP (set in lsp.lua on_attach, but previewing here)
-- <leader>ca = code actions
-- <leader>rn = rename
-- gd = go to definition
-- K = hover docs

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Clear search highlight
keymap("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- Quick save
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- Buffer switching by position in the listed buffer list
local function get_listed_bufs()
	return vim.tbl_filter(function(b)
		return vim.bo[b].buflisted
	end, vim.api.nvim_list_bufs())
end

local function go_to_buf_by_index(index)
	local bufs = get_listed_bufs()
	if bufs[index] then
		vim.api.nvim_set_current_buf(bufs[index])
	end
end

local function buf_position_info()
	local bufs = get_listed_bufs()
	local current = vim.api.nvim_get_current_buf()
	for i, b in ipairs(bufs) do
		if b == current then
			return i, #bufs
		end
	end
	return nil, #bufs
end

for i = 1, 9 do
	keymap("n", "<leader>" .. i, function()
		go_to_buf_by_index(i)
		local pos, total = buf_position_info()
		if pos then
			vim.notify("[" .. pos .. "/" .. total .. "]", vim.log.levels.INFO)
		end
	end, { desc = "Go to buffer " .. i })
end

-- Show current buffer position
keymap("n", "<leader>bi", function()
	local pos, total = buf_position_info()
	if pos then
		vim.notify("Buffer [" .. pos .. "/" .. total .. "]", vim.log.levels.INFO)
	else
		vim.notify("Buffer not in list", vim.log.levels.WARN)
	end
end, { desc = "Show buffer position" })
