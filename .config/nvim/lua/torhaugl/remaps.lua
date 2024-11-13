vim.g.mapleader = ' '
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>cfv", ":vs $HOME/.config/nvim/lua/torhaugl/remaps.lua <ENTER>")
vim.keymap.set("n", "<leader>ct", ":% !column -t <ENTER>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<leader>ct", ":!column -t <ENTER>")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>rr", ":vs <CR> :term python % <CR>")

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", {clear=true}),
    callback = function ()
        vim.highlight.on_yank()
    end,
})
