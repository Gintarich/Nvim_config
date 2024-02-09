return{
    {
        -- Compiler
        "Zeioth/compiler.nvim",
        cmd = {"CompilerOpen", "CompilerToggleResults", "CompilerRedo"},
        dependencies = { "stevearc/overseer.nvim" },
        opts = {},
        config = {
            -- Open compiler
            vim.api.nvim_set_keymap('n', '<C-b>', "<cmd>CompilerOpen<cr>", { noremap = true, silent = true }),
            -- Toggle compiler results
            vim.api.nvim_set_keymap('n', '<S-F7>', "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })
        }
    },
    {
        -- The task runner we use
        "stevearc/overseer.nvim",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        opts = {
            task_list = {
                direction = "bottom",
                min_height = 25,
                max_height = 25,
                default_detail = 1
            },
        },
    },
}
