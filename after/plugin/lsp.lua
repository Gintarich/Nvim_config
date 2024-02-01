local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'omnisharp' ,'clangd'},
  handlers = {
    lsp_zero.default_setup,
    omnisharp = function ()
        local omnisharp_server_location = "C:\\Users\\Admin\\AppData\\Local\\nvim-data\\mason\\packages\\omnisharp\\libexec\\OmniSharp.dll"
        require('lspconfig').omnisharp.setup({
            cmd = {"dotnet", omnisharp_server_location}
        })
        
    end,
   -- lua_ls = function()
   --   local lua_opts = lsp_zero.nvim_lua_ls()
   --   require('lspconfig').lua_ls.setup(lua_opts)
   -- end,
  },
})

local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

-- this is the function that loads the extra snippets
-- from rafamadriz/friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    -- if you don't know what is a "source" in nvim-cmp read this:
    -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/autocomplete.md#adding-a-source
    sources = {
        {name = 'omnisharp'},
        {name = 'nvim_lsp_signature_help'}, 
        {name = 'path'},
        {name = 'nvim_lsp'},
        {name = 'nvim_lua'},
        {name = 'luasnip', keyword_length = 2},
        {name = 'buffer', keyword_length = 3},
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    -- default keybindings for nvim-cmp are here:
    -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/README.md#keybindings-1
    mapping = cmp.mapping.preset.insert({
        -- confirm completion item
        ['<Enter>'] = cmp.mapping.confirm({ select = true }),

     -- trigger completion menu
     ['<C-Space>'] = cmp.mapping.complete(),
 
     -- scroll up and down the documentation window
     ['<C-u>'] = cmp.mapping.scroll_docs(-4),
     ['<C-d>'] = cmp.mapping.scroll_docs(4),   
 
     -- navigate between snippet placeholders
     ['<C-f>'] = cmp_action.luasnip_jump_forward(),
     ['<C-b>'] = cmp_action.luasnip_jump_backward(),
   }),
   -- note: if you are going to use lsp-kind (another plugin)
   -- replace the line below with the function from lsp-kind
   formatting = lsp_zero.cmp_format(),
 })

