return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "notes",
          path = "~/Notes",
        },
      },
      picker = {
        name = "snacks.picker",
      },
      new_notes_location = "notes_subdir",
      notes_subdir = "inbox",
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
      },
      templates = {
        folder = "templates",
      },
      attachments = {
        img_folder = "attachments",
      },
    },
    keys = {
      { "<leader>nn", "<cmd>Obsidian new<cr>", desc = "New note" },
      { "<leader>nq", "<cmd>Obsidian quick_switch<cr>", desc = "Find note" },
      { "<leader>ns", "<cmd>Obsidian search<cr>", desc = "Search notes" },
      { "<leader>nb", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
      { "<leader>nd", "<cmd>Obsidian today<cr>", desc = "Daily note" },
    },
  },
}
