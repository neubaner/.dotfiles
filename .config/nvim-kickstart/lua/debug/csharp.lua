local dap = require 'dap'

local M = {}

--- @class Roslyn.ProjectInformation
--- @field isExe boolean
--- @field outputPath string
--- @field projectName string
--- @field projectPath string
--- @field solutionPath string
--- @field targetsDotnetCore boolean

--- @async
--- @param client vim.lsp.Client
--- @return Roslyn.ProjectInformation[]
local function get_projects(client)
  local co = assert(coroutine.running())

  client.rpc.request('workspace/debugConfiguration', { workspacePath = vim.uv.cwd() }, function(err, projects)
    if err ~= nil then
      vim.notify(err.message, vim.log.levels.ERROR, {})
      return
    end

    coroutine.resume(co, projects)
  end)

  return coroutine.yield()
end

dap.adapters.coreclr = {
  type = 'executable',
  command = 'netcoredbg',
  args = { '--interpreter=vscode' },
}

---@param project Roslyn.ProjectInformation
local function start_debug_session(project)
  dap.launch(dap.adapters.coreclr, {
    type = 'coreclr',
    request = 'launch',
    name = 'Launch' .. project.projectName,
    program = project.outputPath,
  }, {})
end

vim.api.nvim_create_user_command('CSharpDebug', function()
  local co = coroutine.create(function()
    local buf = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_clients({ bufnr = buf })[1]
    local projects = get_projects(client)

    vim.ui.select(projects, {
      prompt = 'Select a project to debug',
      format_item = function(item)
        return item.projectName
      end,
    }, function(choice)
      start_debug_session(choice)
    end)
  end)

  coroutine.resume(co)
end, {})

return M
