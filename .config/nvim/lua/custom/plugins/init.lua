-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- TmuxNavigator. Add keymaps to go between neovim and tmux
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
    },
    keys = {
      { '<C-h>', '<cmd><C-U>TmuxNavigateLeft<CR>' },
      { '<C-j>', '<cmd><C-U>TmuxNavigateDown<CR>' },
      { '<C-k>', '<cmd><C-U>TmuxNavigateUp<CR>' },
      { '<C-l>', '<cmd><C-U>TmuxNavigateRight<CR>' },
    },
  },
}
