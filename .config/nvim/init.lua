--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.opt`
-- For more options, you can see `:help option-list`

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
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Stop search highlighting' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'File viewer' })
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

vim.keymap.set('n', '<space>xl', '<cmd>source %<CR>', { desc = 'E[X]ecute [L]ua (source)' })
vim.keymap.set('v', '<space>xl', ':lua<CR>', { desc = 'E[X]ectue [L]ua' })

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

local job_id = 0
vim.keymap.set('n', '<space>st', function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 15)
  vim.cmd.normal 'G'
  job_id = vim.bo.channel
end, { desc = '[S]tart [T]erminal' })

-- https://www.reddit.com/r/neovim/comments/1b1sv3a/function_to_get_visually_selected_text/
-- Return the visually selected text as an array with an entry for each line
-- @return string[]|nil lines The selected text as an array of lines.
-- Used to send text to REPL (e.g. Python and Julia)
local function get_visual_selection_text()
  local _, srow, scol = unpack(vim.fn.getpos 'v')
  local _, erow, ecol = unpack(vim.fn.getpos '.')

  -- visual line mode
  if vim.fn.mode() == 'V' then
    if srow > erow then
      return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
    else
      return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
    end
  end

  -- regular visual mode
  if vim.fn.mode() == 'v' then
    if srow < erow or (srow == erow and scol <= ecol) then
      return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
    else
      return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
    end
  end

  -- visual block mode
  if vim.fn.mode() == '\22' then
    local lines = {}
    if srow > erow then
      srow, erow = erow, srow
    end
    if scol > ecol then
      scol, ecol = ecol, scol
    end
    for i = srow, erow do
      table.insert(lines, vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1])
    end
    return lines
  end
end

vim.keymap.set('v', '<S-CR>', function()
  local vtext = get_visual_selection_text()
  local all_str = ''
  for _, v in pairs(vtext) do
    all_str = all_str .. v
  end
  vim.fn.chansend(job_id, { all_str .. '\r\n' })
end, { desc = 'Send visual-mode text to terminal' })

vim.keymap.set('n', '<S-CR>', function()
  local all_str = vim.api.nvim_get_current_line()
  vim.fn.chansend(job_id, { all_str .. '\r\n' })
  vim.cmd.normal 'j'
end, { desc = 'Send current line to terminal' })

-- [[ Configure and install plugins ]]

-- Native
vim.cmd.packadd "nvim.undotree"
require("undotree")

-- External
vim.pack.add {
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  'https://github.com/folke/tokyonight.nvim',
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/Bilal2453/luvit-meta',

  -- Highlight todo, notes, etc in comments
  'https://github.com/nvim-lua/plenary.nvim', -- is a dependency: todo-comments
  'https://github.com/folke/todo-comments.nvim',
}

require("todo-comments").setup({signs=false})

vim.cmd.colorscheme 'tokyonight-night'

require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

vim.lsp.enable { 'lua_ls', 'pyright', 'rust_analyzer', 'julials', 'nt_pref_ls', 'ttl_pref_ls' }

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    -- We create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

    -- Find references for the word under your cursor.
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

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

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install LAZY plugins ]]
require('lazy').setup {
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).

  -- Plugins can also be added by using a table, with the first argument being the
  -- link and the following keys can be used to configure plugin behavior/loading/etc.

  -- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  --  Add all plugins from `lua/custom/plugins/*.lua`
  { import = 'custom.plugins' },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    lazy = false,
    setup = {
      -- Enable this plugin (Can be enabled/disabled later via commands)
      enable = true,

      -- Enable multiwindow support.
      multiwindow = false,

      -- How many lines the window should span. Values <= 0 mean no limit.
      -- Can be '<int>%' like '30%' - to specify percentage of win.height
      max_lines = 0,

      -- Minimum editor window height to enable context. Values <= 0 mean no
      -- limit.
      min_window_height = 0,

      -- Whether to show line numbers
      line_numbers = true,

      -- Maximum number of lines to show for a single context
      multiline_threshold = 20,

      -- Which context lines to discard if `max_lines` is exceeded.
      -- Choices: 'inner', 'outer'
      trim_scope = 'outer',

      -- Line used to calculate context.
      -- Choices: 'cursor', 'topline'
      mode = 'cursor',

      -- Separator between context and content. Should be a single character
      -- string, like '-'. When separator is set, the context will only show
      -- up when there are at least 2 lines above cursorline.
      separator = nil,

      -- The Z-index of the context window
      zindex = 20,

      -- (fun(buf: integer): boolean) return false to disable attaching
      on_attach = nil,
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      { '<leader>tc', '<Cmd>TSContext<CR>', desc = '[T]oggle Treesitter [C]ontext' },
    },
  },

  -- require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
}

--
-- require("nvim-lspconfig").setup(
--   -- Main LSP Configuration
--   {
--     dependencies = {
--       -- Automatically install LSPs and related tools to stdpath for Neovim
--       { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
--       'williamboman/mason-lspconfig.nvim',
--       'WhoIsSethDaniel/mason-tool-installer.nvim',
--
--       -- Useful status updates for LSP.
--       -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
--       { 'j-hui/fidget.nvim', opts = {} },
--
--       -- Allows extra capabilities provided by nvim-cmp
--       'hrsh7th/cmp-nvim-lsp',
--     },
--     config = function()
--       --  This function gets run when an LSP attaches to a particular buffer.
--       --    That is to say, every time a new file is opened that is associated with
--       --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--       --    function will be executed to configure the current buffer
--       vim.api.nvim_create_autocmd('LspAttach', {
--         group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
--         callback = function(event)
--           -- We create a function that lets us more easily define mappings specific
--           -- for LSP related items. It sets the mode, buffer and description for us each time.
--           local map = function(keys, func, desc, mode)
--             mode = mode or 'n'
--             vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
--           end
--
--           -- Jump to the definition of the word under your cursor.
--           --  This is where a variable was first declared, or where a function is defined, etc.
--           --  To jump back, press <C-t>.
--           map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
--
--           -- Find references for the word under your cursor.
--           map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--
--           -- Jump to the implementation of the word under your cursor.
--           --  Useful when your language has ways of declaring types without an actual implementation.
--           map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
--
--           -- Jump to the type of the word under your cursor.
--           --  Useful when you're not sure what type a variable is and you want to see
--           --  the definition of its *type*, not where it was *defined*.
--           map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
--
--           -- Fuzzy find all the symbols in your current document.
--           --  Symbols are things like variables, functions, types, etc.
--           map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
--
--           -- Fuzzy find all the symbols in your current workspace.
--           --  Similar to document symbols, except searches over your entire project.
--           map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
--
--           -- Rename the variable under your cursor.
--           --  Most Language Servers support renaming across files, etc.
--           map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
--
--           -- Execute a code action, usually your cursor needs to be on top of an error
--           -- or a suggestion from your LSP for this to activate.
--           map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
--
--           -- WARN: This is not Goto Definition, this is Goto Declaration.
--           --  For example, in C this would take you to the header.
--           map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--
--           -- The following two autocommands are used to highlight references of the
--           -- word under your cursor when your cursor rests there for a little while.
--           --    See `:help CursorHold` for information about when this is executed
--           --
--           -- When you move your cursor, the highlights will be cleared (the second autocommand).
--           local client = vim.lsp.get_client_by_id(event.data.client_id)
--           if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
--             local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
--             vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--               buffer = event.buf,
--               group = highlight_augroup,
--               callback = vim.lsp.buf.document_highlight,
--             })
--
--             vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--               buffer = event.buf,
--               group = highlight_augroup,
--               callback = vim.lsp.buf.clear_references,
--             })
--
--             vim.api.nvim_create_autocmd('LspDetach', {
--               group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
--               callback = function(event2)
--                 vim.lsp.buf.clear_references()
--                 vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
--               end,
--             })
--           end
--
--           -- The following code creates a keymap to toggle inlay hints in your
--           -- code, if the language server you are using supports them
--           if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
--             map('<leader>th', function()
--               vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
--             end, '[T]oggle Inlay [H]ints')
--           end
--         end,
--       })
--
--       -- Change diagnostic symbols in the sign column (gutter)
--       if vim.g.have_nerd_font then
--         local signs = { Error = '', Warn = '', Hint = '', Info = '' }
--         for type, icon in pairs(signs) do
--           local hl = 'DiagnosticSign' .. type
--           vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
--         end
--       end
--
--       -- LSP servers and clients are able to communicate to each other what features they support.
--       --  By default, Neovim doesn't support everything that is in the LSP specification.
--       --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--       --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
--       local capabilities = vim.lsp.protocol.make_client_capabilities()
--       capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
--
--       -- Enable the following language servers
--       --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--       --
--       --  Add any additional override configuration in the following tables. Available keys are:
--       --  - cmd (table): Override the default command used to start the server
--       --  - filetypes (table): Override the default list of associated filetypes for the server
--       --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--       --  - settings (table): Override the default settings passed when initializing the server.
--       --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
--       -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
--       local servers = {
--         -- clangd = {},
--         -- gopls = {},
--         -- pyright = {},
--         -- rust_analyzer = {},
--         --
--         -- Some languages (like typescript) have entire language plugins that can be useful:
--         --    https://github.com/pmizio/typescript-tools.nvim
--         --
--         -- But for many setups, the LSP (`ts_ls`) will work just fine
--         -- ts_ls = {},
--         --
--         lua_ls = {
--           settings = {
--             Lua = {
--               completion = {
--                 callSnippet = 'Replace',
--               },
--             },
--           },
--         },
--       }
--
--       -- Ensure the servers and tools above are installed
--       --  To check the current status of installed tools and/or manually install
--       --  other tools, you can run
--       --    :Mason
--       --
--       --  You can press `g?` for help in this menu.
--       require('mason').setup()
--
--       -- You can add other tools here that you want Mason to install
--       -- for you, so that they are available from within Neovim.
--       local ensure_installed = vim.tbl_keys(servers or {})
--       vim.list_extend(ensure_installed, {
--         'stylua', -- Used to format Lua code
--       })
--       require('mason-tool-installer').setup { ensure_installed = ensure_installed }
--
--       require('mason-lspconfig').setup {
--         handlers = {
--           function(server_name)
--             local server = servers[server_name] or {}
--             -- This handles overriding only values explicitly passed
--             -- by the server configuration above. Useful when disabling
--             -- certain features of an LSP (for example, turning off formatting for ts_ls)
--             server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
--             require('lspconfig')[server_name].setup(server)
--           end,
--         },
--       }
--     end,
--   },
-- )

-- See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
