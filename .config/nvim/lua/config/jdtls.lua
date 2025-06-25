local jdtls_path = vim.fn.expand '$MASON/packages/jdtls'
local java_exe = vim.fn.expand '$HOME/.sdkman/candidates/java/21.0.3-amzn/bin/java'

local equinox_launcher = vim.fn.glob(vim.fs.joinpath(jdtls_path, 'plugins', 'org.eclipse.equinox.launcher_*.jar'))
local shared_configuration_path = vim.fs.joinpath(vim.fn.stdpath 'cache', 'jdtls_share_configuration')
local configuration_path = vim.fs.joinpath(jdtls_path, 'config_linux')
local data_path = vim.fs.joinpath(vim.fn.stdpath 'cache', 'jdtls_workspace', vim.fn.sha256(vim.fn.getcwd()))
local lombok_jar = vim.fs.joinpath(jdtls_path, 'lombok.jar')

local function build_config(opts)
  local debug_adapter_path = vim.fn.expand '$MASON/packages/java-debug-adapter'
  local java_test_path = vim.fn.expand '$MASON/packages/java-test'

  local jar_patterns = {
    vim.fs.joinpath(debug_adapter_path, 'extension', 'server', 'com.microsoft.java.debug.plugin-*.jar'),
    vim.fs.joinpath(java_test_path, 'extension', 'server', '*.jar'),
  }

  local bundles = {}
  for _, jar_pattern in ipairs(jar_patterns) do
    for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), '\n')) do
      table.insert(bundles, bundle)
    end
  end

  return {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
      java_exe,
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dosgi.checkConfiguration=true',
      '-Dosgi.sharedConfiguration.area=' .. shared_configuration_path,
      '-Dosgi.sharedConfiguration.area.readOnly=true',
      '-Dosgi.configuration.cascaded=true',
      '-Xmx1G',
      '--add-modules=ALL-SYSTEM',
      '--add-opens',
      'java.base/java.util=ALL-UNNAMED',
      '--add-opens',
      'java.base/java.lang=ALL-UNNAMED',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',

      '-javaagent:' .. lombok_jar,

      '-jar',
      equinox_launcher,

      '-configuration',
      configuration_path,

      '-data',
      data_path,
    },
    root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),
    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
      java = {
        configuration = {
          runtimes = {
            {
              name = 'JavaSE-21',
              path = vim.fn.expand '$HOME/.sdkman/candidates/java/21.0.3-amzn/',
              default = true,
            },
            {
              name = 'JavaSE-1.8',
              path = vim.fn.expand '$HOME/.sdkman/candidates/java/8.0.412-amzn/',
            },
          },
        },
      },
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
      bundles = bundles,
    },
  }
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'java' },
  callback = function(opts)
    local config = build_config { buf = opts.buf }
    require('jdtls').start_or_attach(config, nil, { bufnr = opts.buf })
  end,
})
