set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath


let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox' " Theme
Plug 'preservim/nerdtree' " Table of contents
Plug 'vim-airline/vim-airline' " Vim statusbar (bottom)
Plug 'airblade/vim-gitgutter' " Git gutter (left)
Plug 'JuliaEditorSupport/julia-vim' " LaTeX cmds for julia
Plug 'junegunn/goyo.vim' " Text presentation mode :goyo
Plug 'easymotion/vim-easymotion' " Find with key highlighting
Plug 'vim-latex/vim-latex'
"Plug 'tpope/vim-fugitive' " Git wrapper
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
call plug#end()

" General
set nocompatible
set hlsearch
filetype plugin on
syntax on
set encoding=utf-8
set number
set relativenumber
set nowrap
set splitbelow
set splitright
set expandtab
set tabstop=8
set softtabstop=4
set shiftwidth=4
let mapleader=","
set nofixendofline

" Theme
"colorscheme gruvbox " morhetz/gruvbox
"set background=dark

" Disable automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Quote around word
nnoremap <leader>" viw<Esc>a"<Esc>bi"<Esc>eel
nnoremap <leader>' viw<Esc>a'<Esc>bi'<Esc>eel
inoremap jk <Esc>

" FORTRAN
autocmd FileType fortran setlocal softtabstop=3 shiftwidth=3
autocmd FileType fortran match ErrorMsg '\%>132v.\+'
autocmd FileType fortran inoremap <leader>su <CR><Tab>subroutine XXXXX(wf)<CR>!!<CR>!!<Tab><Tab>XXXXX<CR>!!<Tab><Tab>Written by T. S. Haugland, Feb 2020<CR>!!<CR>!!<Tab><Tab>Describe function<CR>!!<CR><Tab><Tab>implicit none<CR>!<CR><Tab><Tab>class() :: wf<CR>!<CR><Tab>end subroutine XXXXX<CR>!<CR>!<Esc>4k:%s/XXXXX//g<Left><Left>
autocmd FileType fortran inoremap <leader>re real(dp), dimension(:,:), allocatable :: 

" Compile
let g:latex_to_unicode_auto = 1
autocmd FileType tex,latex map <C-p> :w<CR>:!lualatex %<CR>
autocmd FileType python map <C-p> :w<CR>:!python %<CR>
"autocmd FileType julia map <C-p> :w<CR>:!julia --startup-file=no -e "using DaemonMode; runargs()" %<CR>
autocmd FileType julia map <C-p> :w<CR>:!julia %<CR>
autocmd FileType fortran map <C-p> :!make -C $ET_DIR/build<CR>
autocmd BufRead *.sh map <C-p> :w<CR>:w !bash<CR>
autocmd BufRead *.md map <C-p> :w<CR>:!pandoc % -o %.pdf<CR>
autocmd BufRead *.gp map <C-p> :w<CR>:!gnuplot %<CR>

" preservim/nerdtree
map <C-n> :NERDTreeToggle<CR>

" Shougo/deoplete
let g:deoplete#enable_at_startup = 1


" Log
"autocmd bufnewfile *og.txt so ~/.vim/sh_header.temp
"autocmd bufnewfile *og.txt exe "1," . 3 . "s/Creation Date :.*/Creation Date : " .strftime("%d.%m.%y %H:%M:%S")
"autocmd Bufwritepre,filewritepre *og.txt exe "normal ma"
"autocmd Bufwritepre,filewritepre *og.txt exe "1," . 3 . "s/Last Modified :.*/Last Modified : " .strftime("%d.%m.%y %H:%M:%S")
"autocmd bufwritepost,filewritepost *og.txt exe "normal `a"

command Time r! date "+\%y.\%m.\%d \%H:\%M:\%S"
nmap <F3> i<C-R>=strftime("%d.%m.%y %H:%M:%S:")<CR><Esc>
imap <F3> <C-R>=strftime("%d.%m.%y %H:%M:%S:")<CR>

