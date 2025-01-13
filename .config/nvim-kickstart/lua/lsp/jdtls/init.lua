local M = {}

function M.setup(opts)
  local mason_registry = require 'mason-registry'

  local mason_package_install_path = function(package_name)
    local package = mason_registry.get_package(package_name)
    return package:get_install_path()
  end

  -- TODO: Change path based on windows
  local path_separator = '/'

  local jdtls_path = mason_package_install_path 'jdtls'
  local lombok_path = mason_package_install_path 'lombok-nightly'

  local java_exe = vim.fn.expand '$HOME/.sdkman/candidates/java/21.0.3-amzn/bin/java'

  local equinox_launcher = vim.fn.glob(jdtls_path .. path_separator .. 'plugins' .. path_separator .. 'org.eclipse.equinox.launcher_*.jar')
  local shared_configuration_path = vim.fn.stdpath 'cache' .. path_separator .. 'jdtls_share_configuration'
  -- TODO: Make this cross platform
  local configuration_path = jdtls_path .. path_separator .. 'config_linux'
  local data_path = vim.fn.stdpath 'cache' .. path_separator .. 'jdtls_workspace' .. path_separator .. vim.fn.sha256(vim.fn.getcwd())

  local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
      java_exe, -- or '/path/to/java17_or_newer/bin/java'
      -- depends on if `java` is in your $PATH env variable and if it points to the right version.

      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Declipse.checkConfiguration=true',
      '-Declipse.sharedConfiguration.area=' .. shared_configuration_path,
      '-Declipse.sharedConfiguration.area.readOnly=true',
      '-Dosgi.configuration.cascaded=true',
      '-Xmx1G',
      '--add-modules=ALL-SYSTEM',
      '--add-opens',
      'java.base/java.util=ALL-UNNAMED',
      '--add-opens',
      'java.base/java.lang=ALL-UNNAMED',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',

      '-javaagent:' .. lombok_path .. path_separator .. 'lombok.jar',

      '-jar',
      equinox_launcher,

      '-configuration',
      configuration_path,

      '-data',
      data_path,
    },

    -- 💀
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew' },

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
      java = {
        configuration = {
          runtimes = {
            {
              name = 'JavaSE-1.8',
              path = vim.fn.expand '$HOME/.sdkman/candidates/java/8.0.412-amzn/',
            },
            {
              name = 'JavaSE-21',
              path = vim.fn.expand '$HOME/.sdkman/candidates/java/21.0.3-amzn/',
              default = true,
            },
          },
        },
      },
    },
    capabilities = opts.capabilities or vim.lsp.protocol.make_client_capabilities(),

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    -- TODO: Add dap and test runner bundles
    init_options = {
      bundles = vim.list_extend({
        vim.fn.glob('~/git/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar', true),
      }, vim.split(vim.fn.glob('~/git/vscode-java-test/server/*.jar', true), '\n')),
    },
  }

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    desc = 'Start jdtls when java related files are open',
    pattern = 'java',
    group = vim.api.nvim_create_augroup('gneubaner-jdtls-filetype', { clear = true }),
    callback = function()
      require('jdtls').start_or_attach(config)
    end,
  })
end

return M
