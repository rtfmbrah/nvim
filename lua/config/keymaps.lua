-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Fenster wechseln
map("n", "<C-h>", "<C-w>h", {
  desc = "Window left",
})

map("n", "<C-j>", "<C-w>j", {
  desc = "Window down",
})

map("n", "<C-k>", "<C-w>k", {
  desc = "Window up",
})

map("n", "<C-l>", "<C-w>l", {
  desc = "Window right",
})

-- Buffer wechseln
map("n", "<leader>bh", "<cmd>bprevious<cr>", {
  desc = "Previous Buffer",
})

map("n", "<leader>bl", "<cmd>bnext<cr>", {
  desc = "Next Buffer",
})

map("n", "<leader>bd", "<cmd>bd<cr>", {
  desc = "Delete Buffer",
})

map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", {
  desc = "Close Other Buffers",
})

-- Fenster teilen
map("n", "<leader>sv", "<cmd>vsplit<cr>", {
  desc = "Vertical Split",
})

map("n", "<leader>sh", "<cmd>split<cr>", {
  desc = "Horizontal Split",
})

map("n", "<leader>sd", "<cmd>close<cr>", {
  desc = "Close Split",
})

-- Fenstergröße
map("n", "<A-h>", "<cmd>vertical resize -5<cr>", {
  desc = "Window narrower",
})

map("n", "<A-l>", "<cmd>vertical resize +5<cr>", {
  desc = "Window wider",
})

map("n", "<A-j>", "<cmd>resize -3<cr>", {
  desc = "Window shorter",
})

map("n", "<A-k>", "<cmd>resize +3<cr>", {
  desc = "Window taller",
})

-- Dateien und Suche
map("n", "<leader>e", function()
  Snacks.explorer()
end, {
  desc = "Explorer",
})

map("n", "<leader>ee", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype

    if ft == "snacks_picker_list" or ft == "snacks_explorer" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end

  Snacks.explorer()
end, {
  desc = "Focus Explorer",
})

map("n", "<leader>ff", function()
  Snacks.picker.files()
end, {
  desc = "Find File",
})

map("n", "<leader>fg", function()
  Snacks.picker.grep()
end, {
  desc = "Find Text",
})

map("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, {
  desc = "Find Buffer",
})

-- Speichern und Beenden
map("n", "<C-s>", "<cmd>write<cr>", {
  desc = "Save File",
})

map("n", "<leader>qq", "<cmd>confirm qa<cr>", {
  desc = "Quit Neovim",
})
