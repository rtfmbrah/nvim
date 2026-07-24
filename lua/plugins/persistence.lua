local workspace = require("config.workspace")

local function session_exists(persistence)
  local branch_session = persistence.current()
  local default_session = persistence.current({
    branch = false,
  })

  return vim.fn.filereadable(branch_session) == 1 or vim.fn.filereadable(default_session) == 1
end

return {
  {
    "folke/persistence.nvim",

    init = function()
      if not workspace.started_with_directory() then
        return
      end

      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        nested = true,

        callback = function()
          vim.schedule(function()
            local persistence = require("persistence")

            if session_exists(persistence) then
              persistence.load()
            end
          end)
        end,
      })
    end,
  },
}
