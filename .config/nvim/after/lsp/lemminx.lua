return {
  settings = {
    xml = {
      catalogs = {
        vim.fn.expand '$HOME/xsd/Microsoft.Build.Core.xsd',
        vim.fn.expand '$HOME/xsd/Microsoft.Build.CommonTypes.xsd',
      },
      fileAssociations = {
        {
          systemId = vim.fn.expand '$HOME/xsd/Microsoft.Build.CommonTypes.xsd',
          pattern = '**.csproj',
        },
      },
    },
  },
  filetypes = { 'xml', 'csproj', 'fsproj', 'vbproj', 'props', 'targets' },
}
