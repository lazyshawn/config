
-- onedark
require('onedark').setup {
  -- dark, darker, cool, deep, warm, warmer
  style = 'warm'
}
require('onedark').load()

-- Gruvbox
-- vim.cmd[[
--   set termguicolors  " enable true colors support
--   let $NVIM_TUI_ENABLE_TRUE_COLOR=1
--   colorscheme gruvbox
--   set background=dark
--   " 显示十六进制格式的颜色
--   let g:colorizer_syntax = 1
-- ]]

local lualine = require('lualine')

lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = { 'buffers' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'tabs' }
  },
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
