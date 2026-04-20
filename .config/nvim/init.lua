-- neovim 0.12

-- [[ Global options ]]
--  NOTE: <leader> must be set before plugins are loaded
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.opt` and `:help option-list`
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.scrolloff = 10
vim.opt.colorcolumn = '80'
-- Shift for tabs (4 spaces)
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.smarttab = false
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'
-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Stop search highlighting' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>pv', '<cmd>Oil<Cr>', { desc = 'File viewer' })
vim.keymap.set('n', 'Q', '<nop>', { desc = 'Disable Q (Ex mode)' })
vim.keymap.set('n', '<leader>ct', ':% !column -t <ENTER>', { desc = 'Column tabs' })
vim.keymap.set('v', '<leader>ct', ':!column -t <ENTER>', { desc = 'Column tabs' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected line down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected line up' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Remove endline from current line' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Improved scrolling (C-d)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Improved scrolling (C-u)' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Improved search (n)' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Improved search (N)' })
vim.keymap.set('n', '<leader>xl', '<cmd>source %<CR>', { desc = 'E[X]ecute [L]ua (source)' })
vim.keymap.set('v', '<leader>xl', ':lua<CR>', { desc = 'E[X]ectue [L]ua' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Disable numbering in terminal',
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Show diagnostics when holding cursor for a second.
-- vim.api.nvim_create_autocmd('CursorHold', {
--   callback = function()
--     vim.diagnostic.open_float(nil, { focusable = false })
--   end,
-- })
--

-- [[ Other settings ]]
-- Set syntax for .bashrc_local and .nt files
vim.filetype.add {
  filename = {
    ['.bashrc_local'] = 'bash',
  },
  extension = {
    nt = 'nt',
  },
}

-- [[ Advanced Keymaps ]]

vim.keymap.set('n', '<leader>tl', function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config { virtual_lines = new_config }
end, { desc = '[T]oggle Diagnostic [L]ines' })

local function start_terminal()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 15)
  vim.cmd.normal 'G'
end
vim.keymap.set('n', '<leader>st', start_terminal, { desc = '[S]tart [T]erminal' })

-- [[ Configure and install plugins ]]

-- [Undotree]
vim.cmd.packadd "nvim.undotree"
require("undotree")

-- [Colorscheme]. See also `:Telescope colorscheme`.
vim.pack.add { 'https://github.com/folke/tokyonight.nvim' }
vim.cmd.colorscheme 'tokyonight-night'

-- [tree-sitter]
-- vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter' }
-- require("nvim-treesitter.install").update("all") -- :TSUpdate all
-- require("nvim-treesitter.configs").setup({
--   auto_install = true, -- autoinstall languages that are not installed yet
-- })

-- [todo-comments] Highlight todo, notes, etc in comments
vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/folke/todo-comments.nvim',
}
require("todo-comments").setup({signs=false})

-- [gitsigns] Adds git related signs to the gutter, as well as utilities for
-- managing changes
vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [oil] file explorer
vim.pack.add { 'https://github.com/stevearc/oil.nvim' }
require("oil").setup({
  default_file_explorer = true,
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- [LSP] config
vim.pack.add { 'https://github.com/neovim/nvim-lspconfig' }
-- Disable missing global warning for "vim" in e.g. init.lua
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
})

vim.lsp.enable {
  'lua_ls', -- https://luals.github.io/#neovim-install
  'pyright', -- npm i -g pyright
  'rust_analyzer', -- rustup component add rust-src
  -- 'julials',
}
-- vim.lsp.enable { 'nt_pref_ls', 'ttl_pref_ls' } -- Custom LSP for ontologies


-- [Telescope]
vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end
    local builtin = require('telescope.builtin')

    map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
    map('gr', builtin.lsp_references, '[G]oto [R]eferences')
    map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
    map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

    -- When you move your cursor, the highlights will be cleared
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- [[ Configure Telescope ]]
-- Two important keymaps to use while in Telescope are:
--  - Insert mode: <c-/>
--  - Normal mode: ?
--
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
}

require('telescope').load_extension('ui-select')

-- See `:help telescope.builtin`
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

-- shortcut for searching your neovim configuration files
vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[s]earch [n]eovim files' })

-- shortcut for searching all configuration files
vim.keymap.set('n', '<leader>sc', function()
  builtin.find_files { cwd = '~/.dotfiles/', hidden = true }
end, { desc = '[s]earch [c]onfig files' })

-- [which-key] When tapping <leader>, show all possible keymaps
vim.pack.add { 'https://github.com/folke/which-key.nvim' }
require("which-key").setup({})

-- See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
