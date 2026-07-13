return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },

        markdown = { "prettier" },

        nix = { "nixfmt" },

        tex = { "latexindent" },
        plaintex = { "latexindent" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },

        nix = { "statix" },

        tex = { "chktex" },
        plaintex = { "chktex" },
      },
    },
  },
}
