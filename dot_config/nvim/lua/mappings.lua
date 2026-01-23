require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Lazygit
map("n", "<leader>gg", "<cmd> LazyGit <CR>", { desc = "Open Lazygit" })

-- split buffer
map("n", "<leader>wv", "<cmd> :vsplit <CR>", { desc = "Vertical Split" })
map("n", "<leader>wh", "<cmd> :hsplit <CR>", { desc = "Horizontal Split" })

-- show outline
map("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
