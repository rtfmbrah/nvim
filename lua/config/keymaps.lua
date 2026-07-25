-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>e", function()
  Snacks.explorer()
end, {
  desc = "Explorer",
})

map("n", "<leader>ff", function()
  Snacks.picker.files()
end, {
  desc = "Find File",
})

map("n", "<leader>fg", function()
  Snacks.picker.files()
end, {
  desc = "Find Text",
})

map("n", "<leader>pw", "<cmd>Workspace<cr>", {
  desc = "Find File",
})

map("n", "<leader>q", "<cmd>confirm qa<cr>", {
  desc = "Quit Neovim",
})
