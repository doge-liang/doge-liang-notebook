---
title: vim-plugin
tags:
  - vim
categories:
  - article
  - 工具
  - vim
date: 2020-06-19 00:00:00
---

## vim 插件管理

### vim-plugin

自动检测是否安装并拉取脚本：

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

```bash
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
```
