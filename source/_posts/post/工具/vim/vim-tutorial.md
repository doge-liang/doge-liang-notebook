---
title: vim-tutorial
date: 2020-06-20
tags: [vim]
categories: 

    - 工具
    - vim

---

## vim tutorial

### basic

This part is the **SUMMARY** of the oficial basic interactive tutorial. By typing `vimtutor` in the terminal you can see the complete tutorial.

`j`  `k`  `h`  `l` up down left right

`x` delete

`i` insert

`a` append

`A` append after the end of the line

`dw` delete one word to the head of next word

`de` delete one word to the end of the word

`d$` delete to the end of the line

`dd` delete the whole line

`d3w`  `d2e`  `d4$`  `9dd` delete `n` words/lines

`0` to the start of the line

`u` undo one step

`U` undo the whole line to origin

`ctrl R` Redo one step

`p` put the content in the buffer

`r` replace the content in the cursor

`R` switch to the replace mode

`ce`  `cw`  `c$` correct word/line

`ctrl G` file status

`G` to the bottom of the file

`gg` to the head of the file

`/pattern` search pattern

`%` match the parentheses

`:%s/old/new` substitude old words with new words
`:%s/old/new/g` substitude old words with new words **global**
`:%s/old/new/gc` substitude ... global interactively

`:!<command>` execute an external command`

`:r <FILENAME>` retriving and merging file

`o` new line **below**

`O` new line **above**

`e` jump to next word

`y` yand(copy) the selection

`yy` yand(copy) the whole line into the buffer

`<n> yy` yand(copy) the next n line into the buffer

`ctrl W` jump to another window

### vimrc

``` vimrc
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

" Snippets are separated from the engine. Add this if you want m:
Plug 'honza/vim-snippets'

Plug 'preservim/nerdtree'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'

call plug#end()

" Trigger configuration. Do not use <tab> if you use https://hub.com/Valloric/YouCompleteMe.
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
