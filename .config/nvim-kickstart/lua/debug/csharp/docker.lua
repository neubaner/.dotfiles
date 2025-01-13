local dap = require 'dap'

dap.adapters.docker = function(callback, config, parent)
  if config.platform == 'netCore' then
    vim.print(config.containerName)
    config.type = 'coreclr'
    return callback {
      type = 'executable',
      command = 'podman',
      args = { 'exec', '-i', config.containerName, '/remote_debugger/vsdbg', '--interpreter=vscode' },
      id = 'coreclr',
    }
  end
  error(config.platform .. ' is not supported')
end
