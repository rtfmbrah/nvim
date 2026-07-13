return {
  {
    "mfussenegger/nvim-dap",
    optional = true,

    opts = function()
      local dap = require("dap")

      dap.adapters.lldb = {
        type = "executable",
        command = vim.fn.exepath("lldb-dap"),
        name = "lldb",
      };

      dap.configurations.asm = {
        {
          name = "Launch executable",
          type = "lldb",
          request = "launch",

          program = function()
            return vim.fn.input(
              "Executable: ",
              vim.fn.getcwd() .. "/",
              "file"
            )
          end,

          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }
    end,
  },
}
