---
title: myvimrc
tags:
  - vimrc
categories:
  - article
  - 计算机
  - 工具
  - vim
date: 2020-06-21 00:00:00
---

## My vimrc

### user .vimrc

```lua
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugin
call plug#begin('.vim-plugin')
Plug 'lervag/vimtex'
Plug 'preservim/nerdcommenter'

" Track the engine.
Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

Plug 'preservim/nerdtree'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'

call plug#end()

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" vimtex config
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

set nu
set tabstop=4
set hls
set is
set bg=dark
set autoindent
set ru

```
