-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Plugin configuration in on ftplugin/java.lua
  { 'bufbuild/vim-buf' },
  {
    'prichrd/netrw.nvim',
    opts = {
      -- Put your configuration here, or leave the object empty to take the default
      -- configuration.
      icons = {
        symlink = '', -- Symlink icon (directory and file)
        directory = '', -- Directory icon
        file = '', -- File icon
      },
      use_devicons = true, -- Uses nvim-web-devicons if true, otherwise use the file icon specified above
      mappings = {}, -- Custom key mappings
    },
  },
  -- This didn't worked out of the box for me, so I'm back to nvim-jdtls for now.
  --
  -- {
  --   'nvim-java/nvim-java',
  --   tag = 'v1.0.5',
  --   dependencies = {
  --     'nvim-java/lua-async-await',
  --     'nvim-java/nvim-java-core',
  --     'nvim-java/nvim-java-test',
  --     'nvim-java/nvim-java-dap',
  --     'MunifTanjim/nui.nvim',
  --     'neovim/nvim-lspconfig',
  --     'mfussenegger/nvim-dap',
  --     {
  --       'williamboman/mason.nvim',
  --       opts = {
  --         registries = {
  --           'github:nvim-java/mason-registry',
  --           'github:mason-org/mason-registry',
  --         },
  --       },
  --     },
  --   },
  --   config = function()
  --     require('java').setup {
  --       root_markers = {
  --         'settings.gradle',
  --         'gradlew',
  --       },
  --       jdk = {
  --         auto_install = true,
  --       },
  --     }
  --
  --     require('lspconfig').jdtls.setup {
  --       settings = {
  --         java = {
  --           configuration = {
  --             runtimes = {
  --               {
  --                 name = 'JavaSE-1.8',
  --                 path = '/home/neubaner/.asdf/installs/java/corretto-8.372.07.1/bin',
  --                 default = true,
  --               },
  --             },
  --           },
  --         },
  --       },
  --     }
  --   end,
  -- },
}
