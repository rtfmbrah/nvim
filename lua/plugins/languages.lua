return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Assembly-IntelliSense
        asm_lsp = {},

        -- Vimscript-IntelliSense
        vimls = {},
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}

      vim.list_extend(opts.ensure_installed, {
        "asm",
        "vim",
        "vimdoc",
      })
    end,
  },
}
