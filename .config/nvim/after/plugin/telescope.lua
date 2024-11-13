local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})


vim.keymap.set('n', '<leader>sh', builtin.help_tags, {desc = '[s]earch [h]elp'})
vim.keymap.set('n', '<leader>sg', builtin.git_files, {desc = '[s]earch [g]it'})
vim.keymap.set('n', '<leader>sf', builtin.find_files, {desc = '[s]earch [f]iles'})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", {clear=true}),
    callback = function(event)
        local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            desc = desc or ""
            vim.keymap.set(mode, keys, func, {buffer=event.buf, desc = "LSP: " .. desc })
        end

        map("gd", builtin.lsp_definitions, "[g]oto [d]efinition")
        map("gr", builtin.lsp_references)
        map("gI", builtin.lsp_implementations)
        map('<leader>ds', builtin.lsp_document_symbols, "[d]ocument [s]ymbols")
        map("K", vim.lsp.buf.hover)
        map("<leader>vws", vim.lsp.buf.workspace_symbol)
        map("<leader>vd", vim.diagnostic.open_float)
        map("[d", vim.diagnostic.goto_next)
        map("]d", vim.diagnostic.goto_prev)
        map("<leader>vca", vim.lsp.buf.code_action)
        map("<leader>vrr", vim.lsp.buf.references)
        map("<leader>vrn", vim.lsp.buf.rename)
        map("<C-h>", vim.lsp.buf.signature_help, "", "i")
    end
})
