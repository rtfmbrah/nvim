local workspace = require("config.workspace")

local function notebook_ready()
  local root = workspace.get()

  if vim.fn.isdirectory(root .. "/.zk") == 1 then
    return true
  end

  vim.notify("This workspace is not a zk-Notebook. Run `zk init`.", vim.log.levels.WARN)

  return false
end

local function new_note()
  if not notebook_ready() then
    return
  end

  local title = vim.trim(vim.fn.input("Titel: "))

  if title == "" then
    return
  end

  -- Course notes land under notes/ by default
  vim.fn.mkdir(workspace.get() .. "/notes", "p")

  require("zk").new({
    dir = "notes",
    title = title,
  })
end

local function find_notes()
  if not notebook_ready() then
    return
  end

  require("zk").edit({
    sort = {
      "modified",
    },
  }, {
    title = "Notes",
  })
end

local function search_notes()
  if not notebook_ready() then
    return
  end

  local query = vim.trim(vim.fn.input("Browse notes: "))

  if query == "" then
    return
  end

  require("zk").edit({
    match = {
      query,
    },
    sort = {
      "modified",
    },
  }, {
    title = "Browse notes",
  })
end

local function zk_command(command)
  return function()
    if notebook_ready() then
      vim.cmd(command)
    end
  end
end

local function insert_link_at_selection()
  if notebook_ready() then
    vim.cmd("'<,'>ZkInsertLinkAtSelection")
  end
end

return {
  {
    "zk-org/zk-nvim",
    name = "zk",
    ft = {
      "markdown",
    },

    opts = {
      picker = "snacks_picker",

      lsp = {
        config = {
          name = "zk",
          cmd = {
            "zk",
            "lsp",
          },
          filetypes = {
            "markdown",
          },
        },

        auto_attach = {
          enabled = true,
        },
      },

      tags = {
        multi_select_strategy = "AND",
      },
    },

    keys = {
      {
        "<leader>n",
        "",
        desc = "+notes",
      },
      {
        "<leader>nn",
        new_note,
        desc = "New Note",
      },
      {
        "<leader>nf",
        find_notes,
        desc = "Find Notes",
      },
      {
        "<leader>ns",
        search_notes,
        desc = "Search Notes",
      },
      {
        "<leader>nb",
        zk_command("ZkBacklinks"),
        desc = "Backlinks",
      },
      {
        "<leader>nl",
        zk_command("ZkLinks"),
        desc = "Outgoing Links",
      },
      {
        "<leader>nt",
        zk_command("ZkTags"),
        desc = "Tags",
      },
      {
        "<leader>ni",
        zk_command("ZkInsertLink"),
        desc = "Insert Link",
      },
      {
        "<leader>ni",
        insert_link_at_selection,
        mode = "x",
        desc = "Link Selection",
      },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",

    opts = {
      render_modes = {
        "n",
        "c",
        "t",
      },

      checkbox = {
        enabled = true,
      },

      latex = {
        enabled = true,
        converter = {
          "latex2text",
        },
        inline = true,
        block = true,

        position = "above",
        top_pad = 0,
        bottom_pad = 0,
      },

      completions = {
        lsp = {
          enabled = true,
        },
      },
    },
  },

  {
    "lervag/vimtex",

    init = function()
      vim.g.vimtex_view_method = "zathura"
    end,
  },
}
