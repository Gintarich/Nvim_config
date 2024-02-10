require("GB.remap")
require("GB.set")
require("GB.lazy_init")

local augroup = vim.api.nvim_create_augroup
local GBGroup = augroup('GB', {})

local autocmd = vim.api.nvim_create_autocmd

autocmd("VimEnter", {
  group = augroup("capslockstuff", { clear = true }),
  callback = function()
    vim.cmd("!setxkbmap -option caps:escape")
  end,
})

autocmd("VimLeave", {
  group = augroup("capslockstuff", { clear = true }),
  callback = function()
    vim.cmd("!setxkbmap -option")
  end,
})

autocmd('LspAttach', {
    group = GBGroup,
    callback = function(e)
        vim.cmd('set noshellslash')
        -- if e.name == "omnisharp" then e.server_capabilities.semanticTokensProvider = nil end
        local opts = { buffer = e.buf}
        vim.keymap.set("n","gd",function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n","K",function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n","<leader>vws",function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n","<leader>vd",function() vim.lsp.buf.open_float() end, opts)
        vim.keymap.set("n","[d",function() vim.lsp.buf.goto_next() end, opts)
        vim.keymap.set("n","]d",function() vim.lsp.buf.goto_prev() end, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set("n","<leader>vrr",function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n","<leader>vrn",function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n","<C-h>",function() vim.lsp.buf.signature_help() end, opts)
    end
    })

-- vim.api.nvim_create_autocmd("VimEnter", {
--	callback = function()
--		vim.cmd("set noshellslash")
--	end,
-- })
