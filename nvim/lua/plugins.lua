-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Pretty
  use {'morhetz/gruvbox'}
  use {'navarasu/onedark.nvim'}

  use {
    'nvim-lualine/lualine.nvim',
    'nvim-tree/nvim-web-devicons'
  }
  use {'ryanoasis/vim-devicons'}

  --
  use {'nvim-tree/nvim-tree.lua'}

  -- debug
  use {
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
  }

  -- mason & config | lsp & dap manager
  use {
    -- mason
    "williamboman/mason.nvim",
    -- mason config
    "williamboman/mason-lspconfig.nvim",
    -- nvim lspconfig
    "neovim/nvim-lspconfig",
  }

  -- nvim-cmp
  use {
    -- cmp source
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    -- cmp plugins
    'hrsh7th/nvim-cmp',
    -- fancy icons for cmp menu
    'onsails/lspkind-nvim'
  }

  -- Snippet
  use {
    -- Snippet engin
    'SirVer/ultisnips',
    -- Snippet for cmp
    'quangnguyen30192/cmp-nvim-ultisnips'
  }

  -- syntax highlight
  use {'nvim-treesitter/nvim-treesitter'}

  -- 
  use {'mg979/vim-visual-multi'}
  use {'jiangmiao/auto-pairs'}
  use {'mbbill/undotree'}
  use {'tpope/vim-surround'}
  use {'gcmt/wildfire.vim'}
  use {'preservim/nerdcommenter'}
  use {'lewis6991/gitsigns.nvim'}


end)

