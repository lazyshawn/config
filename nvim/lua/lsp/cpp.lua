

local lspconfig = require('lspconfig')
-- advertise capabilities from `nvim-cmp` to `clangd`.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- lsp server
require'lspconfig'.clangd.setup {
  capabilities = capabilities,
}

