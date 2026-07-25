local M = {}

local root
local started_with_directory = false

local function normalize_dir(path)
  if not path or path == "" then
    return nil
  end

  path = vim.fn.expand(path)
  path = vim.fn.fnamemodify(path, ":p")
  path = vim.fs.normalize(path)

  if vim.fn.isdirectory(path) ~= 1 then
    return nil
  end

  return path
end

local function startup_root()
  if vim.fn.argc() == 1 then
    local argument = vim.fn.argv(0)
    local directory = normalize_dir(argument)

    if directory then
      started_with_directory = true
      vim.g.workspace_started_with_directory = true

      vim.cmd("silent! %argdelete")

      return directory
    end
  end

  vim.g.workspace_started_with_directory = false

  return normalize_dir(vim.fn.getcwd())
end

local function modified_buffers()
  local buffers = {}

  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buffer) and vim.bo[buffer].buftype == "" and vim.bo[buffer].modified then
      local name = vim.api.nvim_buf_get_name(buffer)

      buffers[#buffers + 1] = name ~= "" and vim.fn.fnamemodify(name, ":~:.") or "[No Name]"
    end
  end

  return buffers
end

local function has_file_buffers()
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_loaded(buffer)
      and vim.bo[buffer].buflisted
      and vim.bo[buffer].buftype == ""
      and vim.api.nvim_buf_get_name(buffer) ~= ""
    then
      return true
    end
  end

  return false
end

local function session_exists(persistence)
  local branch_session = persistence.current()

  local default_session = persistence.current({
    branch = false,
  })

  return vim.fn.filereadable(branch_session) == 1 or vim.fn.filereadable(default_session) == 1
end

local function clear_editor()
  -- First remove tabs and splits
  vim.cmd("silent! tabonly")
  vim.cmd("silent! only")

  -- Then remove all buffers of old workspace
  vim.cmd("silent! %bwipeout!")
end

function M.get()
  return root or vim.g.workspace_root or vim.fn.getcwd()
end

function M.started_with_directory()
  return started_with_directory
end

function M.set(path, opts)
  opts = opts or {}

  local directory = normalize_dir(path)

  if not directory then
    vim.notify("Not a valid workspace folder: " .. tostring(path), vim.log.levels.ERROR)
    return false
  end

  root = directory
  vim.g.workspace_root = directory

  vim.api.nvim_set_current_dir(directory)

  vim.api.nvim_exec_autocmds("User", {
    pattern = "WorkspaceChanged",
    data = {
      root = directory,
    },
  })

  if not opts.silent then
    vim.notify("Workspace: " .. directory)
  end

  return true
end

function M.switch(path)
  local directory = normalize_dir(path)

  if not directory then
    vim.notify("Not a valid workspace folder: " .. tostring(path), vim.log.levels.ERROR)
    return false
  end

  if directory == M.get() then
    vim.notify("Workspace already active: " .. directory)
    return true
  end

  local modified = modified_buffers()

  if modified ~= nil and #modified > 0 then
    vim.notify("Cannot change workspace. Unsaved buffer:\n" .. table.concat(modified, "\n"), vim.log.levels.WARN)
    return false
  end

  local persistence_ok, persistence = pcall(require, "persistence")

  -- Save old workspace session
  if persistence_ok and has_file_buffers() then
    persistence.save()
  end

  clear_editor()

  -- Change cwd
  M.set(directory, {
    silent = true,
  })

  -- Load new workspace
  if persistence_ok and session_exists(persistence) then
    persistence.load()
  end

  vim.notify("Workspace: " .. directory)

  return true
end

function M.setup()
  if vim.g.workspace_initialized then
    return
  end

  vim.g.workspace_initialized = true

  local directory = startup_root()

  if directory then
    M.set(directory, {
      silent = true,
    })
  end

  vim.api.nvim_create_user_command("Workspace", function(command)
    if command.args == "" then
      vim.notify("Workspace: " .. M.get())
      return
    end

    M.switch(command.args)
  end, {
    nargs = "?",
    complete = "dir",
    desc = "Show or change the current workspace",
  })
end

return M
