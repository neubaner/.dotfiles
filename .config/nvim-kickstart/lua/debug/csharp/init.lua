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

dap.configurations.cs = {
  {
    type = 'coreclr',
    request = 'attach',
    name = 'Attach .NET',
    processId = require('dap.utils').pick_process,
  },
}

---@param project Roslyn.ProjectInformation
local function start_debug_session(project)
  local project_directory = vim.fn.fnamemodify(project.projectPath, ':h')
  require('debug.csharp.launch-profile').select_launch_profile(project_directory, function(launch_profile)
    local config = {
      type = 'coreclr',
      request = 'launch',
      name = 'Launch' .. project.projectName,
      program = project.outputPath,
      env = {},
      args = {},
    }

    if launch_profile ~= nil then
      if launch_profile.environmentVariables then
        for key, value in pairs(launch_profile.environmentVariables) do
          config.env[key] = value
        end
      end

      if launch_profile.commandLineArgs then
        local args = vim.split(launch_profile.commandLineArgs, ' ', { trimempty = true })
        for _, arg in ipairs(args) do
          table.insert(config.args, arg)
        end
      end

      if launch_profile.applicationUrl then
        config.env['ASPNETCORE_URLS'] = launch_profile.applicationUrl
      end
    end

    vim.notify(vim.inspect(config), vim.log.levels.INFO, {})

    dap.launch(dap.adapters.coreclr, config, {})
  end)
end

function M.setup()
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
end

return M
