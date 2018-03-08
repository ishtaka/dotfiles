set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'chr4/nginx.vim'
Plugin 'avakhov/vim-yaml'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'tomasr/molokai'

call vundle#end()
filetype plugin indent on

syntax on
colorscheme molokai

set fenc=utf-8
set nobackup
set noswapfile
set autoread

set number
set nowrap
set virtualedit=onemore
set smartindent
set showmatch
set laststatus=2
set listchars=tab:>.,trail:_
set list

set backspace=indent,eol,start
