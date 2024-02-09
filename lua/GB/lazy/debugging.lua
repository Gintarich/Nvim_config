return{
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
    },
    config = function ()
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup()
        -- Setting up UI
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
        -- Setting up keymaps
        vim.keymap.set('n','<Leader>dd',dap.toggle_breakpoint, {})
        vim.keymap.set('n','<F5>',dap.continue, {})
        -- Setup debugger for c#
        dap.adapters.coreclr = {
            type = 'executable',
            -- "C:\\Users\\Admin\\AppData\\Local\\nvim-data\\mason\\bin\\"
            command = 'C:\\Users\\Admin\\AppData\\Local\\nvim-data\\mason\\packages\\netcoredbg\\netcoredbg\\netcoredbg.exe',
            args = {'--interpreter=vscode'}
        }

        -- Hover logic
        local api = vim.api
        local keymap_restore = {}
        dap.listeners.after['event_initialized']['me'] = function()
            for _, buf in pairs(api.nvim_list_bufs()) do
                local keymaps = api.nvim_buf_get_keymap(buf, 'n')
                for _, keymap in pairs(keymaps) do
                    if keymap.lhs == "K" then
                        table.insert(keymap_restore, keymap)
                        api.nvim_buf_del_keymap(buf, 'n', 'K')
                    end
                end
            end
            api.nvim_set_keymap(
            'n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
        end

        dap.listeners.after['event_terminated']['me'] = function()
            for _, keymap in pairs(keymap_restore) do
                api.nvim_buf_set_keymap(
                keymap.buffer,
                keymap.mode,
                keymap.lhs,
                keymap.rhs,
                { silent = keymap.silent == 1 }
                )
            end
            keymap_restore = {}
        end

        -- Setup
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "launch - netcoredbg",
                request = "launch",
                program = function()
                    -- return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/net7.0', 'file')
                    return coroutine.create(function(coro)
                        local opts = {}
                        pickers
                        .new(opts, {
                            prompt_title = "Path to DLL",
                            finder = finders.new_oneshot_job({ "fd", "-e", "dll", "--hidden", "--no-ignore", "--type", "f" }, {}),
                            sorter = conf.generic_sorter(opts),
                            attach_mappings = function(buffer_number)
                                actions.select_default:replace(function()
                                    actions.close(buffer_number)
                                    coroutine.resume(coro, action_state.get_selected_entry()[1])
                                end)
                                return true
                            end,
                        })
                        :find()
                    end)
                end,
            },
        }
    end
}
