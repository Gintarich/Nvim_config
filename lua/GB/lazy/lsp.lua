local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "rafamadriz/friendly-snippets",
        "folke/neodev.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local icons = require('GB.incons')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {"lua_ls",},
                handlers = {
                    function(server_name) -- default handler (optional)
                        if server_name == "lua_ls" then
                            require("neodev").setup {
                                capabilities = capabilities
                            }
                        end
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
                    end,
                    ["omnisharp"] = require("GB/lazy/lsps/omnisharp").omnisharp_setup}
                })
                local cmp_select = { behavior = cmp.SelectBehavior.Select }
                -- Configure autopairs
                local cmp_autopairs = require('nvim-autopairs.completion.cmp')
                cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
                )
                local luasnip = require("luasnip")
                require("luasnip.loaders.from_vscode").lazy_load()
                cmp.setup({
                    snippet = {
                        expand = function(args)
                            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        end,
                    },
                    window = {
                        completion = cmp.config.window.bordered(),
                        documentation = cmp.config.window.bordered(),
                    },
                    mapping = cmp.mapping.preset.insert({
                        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                        ["<C-Space>"] = cmp.mapping.complete(),
                        ["<Tab>"] = cmp.mapping(function()
                            if  luasnip.expandable() and cmp.visible() then
                                luasnip.expand()
                            elseif  luasnip.jumpable(1) then
                                luasnip.jump(1)
                            elseif cmp.visible() then
                                cmp.select_next_item()
                            else
                                require("neotab").tabout()
                            end
                        end, { "i", "s" }),
                        ["<S-Tab>"] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                            elseif luasnip.jumpable(-1) then
                                luasnip.jump(-1)
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                    }),
                    sources = cmp.config.sources({
                        { name = 'nvim_lsp_signature_help' },
                        { name = 'nvim_lsp' },
                        { name = 'luasnip' }, -- For luasnip users.
                        --{ name = 'buffer' },
                    }),})

                    vim.diagnostic.config({
                        signs ={
                            active = true,
                            values ={
                                {name = "DiagnosticSignError", text = icons.diagnostics.Error},
                                {name = "DiagnosticSignWarn", text = icons.diagnostics.Warning},
                                {name = "DiagnosticSignHint", text = icons.diagnostics.Hint},
                                {name = "DiagnosticSignInfo", text = icons.diagnostics.Information},
                            },
                        },
                        virtual_text = false,
                        update_in_insert = false,
                        underline = true,
                        severity_sort = true,
                        float = {
                            focusable = true,
                            style = "minimal",
                            border = "rounded",
                            source = "always",
                            header = "",
                            prefix = "",
                        },
                    })
                    for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
                        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
                    end
                end
            }
