
-- Mason-nvim
local mason = require("mason")

require("mason-lspconfig").setup()
-- After setting up mason-lspconfig you may set up servers via lspconfig
-- require("lspconfig").vimls.setup {}

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

-- Setup language servers.
local lspconfig = require('lspconfig')
require("lspconfig").pyright.setup {}
require("lspconfig").clangd.setup {}
require("lspconfig").lua_ls.setup {}
require("lspconfig").vimls.setup {}
require("lspconfig").cmake.setup {}
require("lspconfig").bufls.setup {}


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    -- 转到申明
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    -- 转到定义
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- 展示注释文档
    vim.keymap.set('n', '<C-d>', vim.lsp.buf.hover, opts)
    -- 转到实现
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    -- 跳转到引用位置
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- ref: https://stackoverflow.com/a/70760302
vim.diagnostic.config({virtual_text = false})
vim.o.updatetime = 250
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end


local dap = require("dap")
vim.keymap.set({"n"}, "<F5>", "<cmd>lua require'dap'.continue()<CR>")
vim.keymap.set({"n"}, "<F10>", "<cmd>lua require'dap'.step_over()<CR>")
vim.keymap.set({"n"}, "<F11>", "<cmd>lua require'dap'.step_into()<CR>")
vim.keymap.set({"n"}, "<F12>", "<cmd>lua require'dap'.step_over()<CR>")
vim.keymap.set({"n"}, "<F9>", "<cmd>lua require'dap'.toggle_breakpoint()<CR>")

local dapui = require("dapui")
dapui.setup({})
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
vim.keymap.set({"n"}, "<LEADER>ui", "<cmd>lua require'dapui'.toggle()<CR>")

require("nvim-dap-virtual-text").setup({})


-- dap pretty
local dap_breakpoint_color = {
    breakpoint = {
        ctermbg=0,
        fg='#993939',
        bg='#31353f',
    },
    logpoing = {
        ctermbg=0,
        fg='#61afef',
        bg='#31353f',
    },
    stopped = {
        ctermbg=0,
        fg='#98c379',
        bg='#31353f'
    },
}

vim.api.nvim_set_hl(0, 'DapBreakpoint', dap_breakpoint_color.breakpoint)
vim.api.nvim_set_hl(0, 'DapLogPoint', dap_breakpoint_color.logpoing)
vim.api.nvim_set_hl(0, 'DapStopped', dap_breakpoint_color.stopped)

local dap_breakpoint = {
    error = {
        text = "",
        texthl = "DapBreakpoint",
        linehl = "DapBreakpoint",
        numhl = "DapBreakpoint",
    },
    condition = {
        text = 'ﳁ',
        texthl = 'DapBreakpoint',
        linehl = 'DapBreakpoint',
        numhl = 'DapBreakpoint',
    },
    rejected = {
        text = "",
        texthl = "DapBreakpint",
        linehl = "DapBreakpoint",
        numhl = "DapBreakpoint",
    },
    logpoint = {
        text = '',
        texthl = 'DapLogPoint',
        linehl = 'DapLogPoint',
        numhl = 'DapLogPoint',
    },
        stopped = {
        text = '',
        texthl = 'DapStopped',
        linehl = 'DapStopped',
        numhl = 'DapStopped',
    },
}

vim.fn.sign_define('DapBreakpoint', dap_breakpoint.error)
vim.fn.sign_define('DapBreakpointCondition', dap_breakpoint.condition)
vim.fn.sign_define('DapBreakpointRejected', dap_breakpoint.rejected)
vim.fn.sign_define('DapLogPoint', dap_breakpoint.logpoint)
vim.fn.sign_define('DapStopped', dap_breakpoint.stopped)

-- dap-ui pretty
-- dapui.setup({
--   mappings = {
--     -- Use a table to apply multiple mappings
--     expand = { "<CR>", "<2-LeftMouse>" },
--     open = "o",
--     remove = "d",
--     edit = "e",
--     repl = "r",
--     toggle = "t",
--   },
--   layouts = {
--     {
--       elements = {
--         {
--           id = 'scopes',
--           size = 0.35
--         },
--         { id = "stacks",      size = 0.35 },
--         { id = "watches",     size = 0.15 },
--         { id = "breakpoints", size = 0.15 },
--       },
--       size = 40,
--       position = "left",
--     },
--
--     {
--       elements = {
--         "repl"
--       },
--       size = 5,
--       position = "bottom",
--     }
--   },
--
--   -- controls = { enabled = false },
--   floating = {
--     max_height = nil,      -- These can be integers or a float between 0 and 1.
--     max_width = nil,       -- Floats will be treated as percentage of your screen.
--     border = "single",     -- Border style. Can be "single", "double" or "rounded"
--     mappings = {
--       close = { "q", "<Esc>" },
--     },
--   },
--   windows = { indent = 1 },
-- })
