local data_path = vim.fs.joinpath(vim.fn.stdpath 'cache', 'jdtls_workspace', vim.fn.sha256(vim.fn.getcwd()))
local lombok_jar = vim.fn.expand '$HOME/.jdks/lombok/share/java/lombok.jar'

local bundles = {
  vim.fn.glob('path/to/com.microsoft.java.debug.plugin-*.jar', true),
}

-- This is the new part
local java_test_bundles = vim.split(vim.fn.glob('/path/to/vscode-java-test/server/*.jar', true), '\n')
local excluded = {
  'com.microsoft.java.test.runner-jar-with-dependencies.jar',
  'jacocoagent.jar',
}
for _, java_test_jar in ipairs(java_test_bundles) do
  local fname = vim.fn.fnamemodify(java_test_jar, ':t')
  if not vim.tbl_contains(excluded, fname) then
    table.insert(bundles, java_test_jar)
  end
end

---@type vim.lsp.Config
return {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'jdtls',
    '--jvm-arg=' .. '-javaagent:' .. lombok_jar,
    '-data',
    data_path,
  },
  capabilities = vim.tbl_extend('force', vim.lsp.protocol.make_client_capabilities(), require('jdtls').extendedClientCapabilities),
  handlers = require('jdtls').commands,
  root_dir = vim.fs.root(0, { 'gradlew', '.git', 'mvnw' }),
  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-1.8',
            path = vim.fn.expand '$HOME/.jdks/temurin-8',
          },
          {
            name = 'JavaSE-21',
            path = vim.fn.expand '$HOME/.jdks/temurin-21',
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
    -- TODO: Re-enable this option later
    -- bundles = bundles,
  },
}
