return {
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

    keys = {
      {
        "<leader>mp",
        "<cmd>RenderMarkdown toggle<cr>",
        desc = "Markdown Preview",
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
