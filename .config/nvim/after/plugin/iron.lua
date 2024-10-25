local iron = require("iron.core")


iron.setup {
  config = {
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    -- Your repl definitions come here
    repl_definition = {
        python = {
            format = require("iron.fts.common").bracketed_paste,
            command = { "ipython", "--no-autoindent" },
        },
    },
--     repl_definition = {
--       sh = {
--         -- Can be a table or a function that
--         -- returns a table (see below)
--         command = {"bash"}
--       }
--     },
    -- How the repl window will be displayed
    -- See below for more information
    repl_open_cmd = require('iron.view').right("50%"),
  },
  -- Iron doesn't set keymaps by default anymore.
  -- You can set them here or manually add keymaps to the functions in iron.core
  keymaps = {
    visual_send = "<leader>ss",
    send_file = "<leader>sf",
    send_line = "<leader>ss",
    send_paragraph = "<leader>sp",
    send_until_cursor = "<leader>su",
    cr = "<leader>s<cr>",
    interrupt = "<leader>s<leader>",
    exit = "<leader>sq",
    clear = "<leader>cl",
  },
  ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set('n', '<leader>rs', '<cmd>IronRepl<cr>')
vim.keymap.set('n', '<leader>rr', '<cmd>IronRestart<cr>')
vim.keymap.set('n', '<leader>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<leader>rh', '<cmd>IronHide<cr>')
