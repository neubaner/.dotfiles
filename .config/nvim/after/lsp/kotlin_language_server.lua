local root_files = {
  'settings.gradle', -- Gradle (multi-project)
  'settings.gradle.kts', -- Gradle (multi-project)
  'build.xml', -- Ant
  'pom.xml', -- Maven
  'build.gradle', -- Gradle
  'build.gradle.kts', -- Gradle
}

---@type vim.lsp.Config
return {
  filetypes = { 'kotlin' },
  root_markers = root_files,
  cmd = {
    vim.fn.expand '$HOME/git/kotlin-language-server/server/build/install/server/bin/kotlin-language-server',
  },
  cmd_env = {
    JAVA_HOME = vim.fn.expand '$HOME/.sdkman/candidates/java/17.0.12-amzn',
  },
  settings = {
    kotlin = {
      scripts = {
        enabled = true,
        buildScriptsEnabled = true,
      },
      codegen = {
        enabled = true,
      },
    },
  },
  init_options = {
    -- Enables caching and use project root to store cache data.
    -- storagePath = vim.fs.root(vim.fn.expand '%:p:h', root_files),
  },
}
