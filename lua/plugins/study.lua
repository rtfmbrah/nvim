local workspace = require("config.workspace")

-- Snacks.image works only in supported terminals
local image_terminal = vim.env.KITTY_WINDOW_ID ~= nil
  or vim.env.WEZTERM_PANE ~= nil
  or vim.env.GHOSTTY_RESOURCES_DIR ~= nil
  or (vim.env.TERM_PROGRAM or ""):lower() == "ghostty"
  or (vim.env.TERM_PROGRAM or ""):lower() == "wezterm"
  or (vim.env.TERM or ""):lower():find("kitty", 1, true) ~= nil

local function resolve_pdf(path)
  if not path or path == "" then
    return nil
  end

  path = vim.fn.expand(path)
  path = vim.fn.fnamemodify(path, ":p")
  path = vim.fs.normalize(path)

  if vim.fn.filereadable(path) ~= 1 then
    return nil
  end

  if path:lower():sub(-4) ~= ".pdf" then
    return nil
  end

  return path
end

local function open_pdf_external(path)
  if vim.fn.executable("zathura") ~= 1 then
    vim.notify("Zathura not found in PATH", vim.log.levels.ERROR)
    return false
  end

  local pdf = resolve_pdf(path)

  if not pdf then
    vim.notify("Not a valid PDF file: " .. tostring(path), vim.log.levels.ERROR)
    return false
  end

  local job = vim.fn.jobstart({
    "zathura",
    pdf,
  }, {
    detach = true,
  })

  if job <= 0 then
    vim.notify("Could not start Zathura", vim.log.levels.ERROR)
    return false
  end

  return true
end

local function snacks_image_supported()
  if not image_terminal then
    return false
  end

  local ok, supported = pcall(function()
    return Snacks.image.supports_terminal()
  end)

  return ok and supported
end

local function open_pdf_split(path)
  local pdf = resolve_pdf(path)

  if not pdf then
    vim.notify("Not a valid PDF file: " .. tostring(path), vim.log.levels.ERROR)
    return false
  end

  vim.cmd("vsplit " .. vim.fn.fnameescape(pdf))

  return true
end

local function open_pdf(path)
  if snacks_image_supported() then
    return open_pdf_split(path)
  end

  return open_pdf_external(path)
end

local function pick_pdf(opener)
  opener = opener or open_pdf

  Snacks.picker.files({
    cwd = workspace.get(),
    ft = "pdf",
    title = "PDFs im Workspace",
    preview = "",

    confirm = function(picker, item)
      picker:close()

      if not item then
        return
      end

      local path = item.file or item.text

      vim.schedule(function()
        opener(path)
      end)
    end,
  })
end

return {
  {
    "folke/snacks.nvim",

    opts = {
      image = image_terminal and {
        enabled = true,

        doc = {
          enabled = true,
          inline = true,
          float = true,
        },
      } or nil,
    },

    init = function()
      vim.api.nvim_create_user_command("Pdf", function(command)
        local opener = command.bang and open_pdf_external or open_pdf

        if command.args == "" then
          pick_pdf(opener)
          return
        end

        opener(command.args)
      end, {
        nargs = "?",
        bang = true,
        complete = "file",
        desc = "Open PDF in Neovim or Zathura",
      })

      -- Not supported terminal? -> Open Zathura
      if not image_terminal then
        vim.api.nvim_create_autocmd("BufReadCmd", {
          pattern = "*.pdf",

          callback = function(event)
            open_pdf_external(event.file)

            vim.bo[event.buf].buflisted = false

            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(event.buf) then
                vim.api.nvim_buf_delete(event.buf, {
                  force = true,
                })
              end
            end)
          end,
        })
      end
    end,

    keys = {
      {
        "<leader>n",
        "",
        desc = "+notes/study",
      },
      {
        "<leader>np",
        function()
          pick_pdf(open_pdf)
        end,
        desc = "Open PDF",
      },
    },
  },
}
