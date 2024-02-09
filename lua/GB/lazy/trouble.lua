return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        severity = vim.diagnostic.severity.ERROR -- | vim.diagnostic.severity.WARN | vim.diagnostic.severity.HINT, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT WARN | INFO | HINT, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    config = {
        -- Lua
        vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end),
        vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end),
        vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end),
        vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end),
        vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end),
        vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end),
        vim.keymap.set("n", "<leader>xf", function() vim.lsp.buf.format() end),
        vim.keymap.set("n", "<leader>xn", function() require("trouble").next({skip_groups = true, jump = true}) end),
        vim.keymap.set("n", "<leader>xp", function() require("trouble").previous({skip_groups = true, jump = true}); end),
    }
}
