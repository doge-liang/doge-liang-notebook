---
title: 插槽-slot
tags: []
categories:
  - article
  - 框架
  - 前台
  - Vue
date: 2021-10-07 00:00:00
---

## 插槽-slot

- [插槽-slot](#插槽-slot)
- [插槽-slot](#插槽-slot-1)
  - [示例：一个简单的插槽](#示例一个简单的插槽)
  - [插槽作用域](#插槽作用域)
  - [备选内容](#备选内容)
  - [具名插槽](#具名插槽)
  - [插槽的作用域](#插槽的作用域)

## 插槽-slot

VUe 受 [Web Components spec draft](https://github.com/w3c/webcomponents/blob/gh-pages/proposals/Slots-Proposal.md) 启发实现了一个内容分配的 API 。用 `<slot>` 元素可以在子组件中设置一个插槽，父组件借助插槽可以定制化子组件这部分要显示的内容，具有高度的灵活性。

### 示例：一个简单的插槽

```HTML
<!-- TodoButton.vue -->
<template>
<button class="btn-primary">
  <slot></slot>
</button>
</template>
```

```HTML
<!-- ParentComp.vue -->
<template>
  <todo-button>
    <i class="fas-fa-plus"></i>
  </todo-button>
</template>
```

```HTML
<!-- rendered HTML -->
<button class="btn-primary">
  <i class="fas-fa-plus"></i>
</button>
```

### 插槽作用域

插槽内的元素变量作用域在父组件中，因为插槽是先在父组件内生成再插入到子组件中的，所以插槽无法使用子组件内的变量。

如下的访问方式则不成功：

```HTML
<todo-button action="delete">
  Clicking here will {{ action }} an item
  <!--
  The `action` will be undefined, because this content is passed
  _to_ <todo-button>, rather than defined _inside_ the
  <todo-button> component.
  -->
</todo-button>
```

`action` 属于是 `<todo-button>` 的 `props` ，是在 `TotoButton.vue` 中定义的，所以 `slot` 无法访问。

### 备选内容

在 `<slot>` 标签内部写入内容，可以设定无外来插件的时候使用默认的内容。

```HTML
<button type="submit">
  <slot>Submit</slot>
</button>
```

### 具名插槽

当我们要在一个组件内定义多个插槽的时候我们会需要这个特性。

```HTML
<!-- BaseLayout.Vue -->
<div class="container">
  <header>
    <slot name="header"></slot>
  </header>
  <main>
    <slot></slot>
  </main>
  <footer>
    <slot name="footer"></slot>
  </footer>
</div>
```

没有 `name` 属性的插槽有一个隐含的名字 `default` 。

```HTML
<!-- Vue 2.x 写法 -->
<base-layout>
  <template v-slot:header>
    <h1>Here might be a page title</h1>
  </template>

  <template v-slot:default>
    <p>A paragraph for the main content.</p>
    <p>And another one.</p>
  </template>

  <template v-slot:footer>
    <p>Here's some contact info</p>
  </template>
</base-layout>

<!-- Vue 3.x 写法 -->
<base-layout>
  <template #header>
    <h1>Here might be a page title</h1>
  </template>
...
</base-layout>
```

### 插槽的作用域

有时候我们希望 `<slot>` 标签可以使用子组件中的一些值，例如：

```HTML
<todo-list>
  <template v-slot:default="">
    <div>
     <ul>
      <li v-for="(item, index) in items">
        {{ item }}
      </li>
    </ul>
    </div>
  </template>
```

使用这个组件：

```HTML
<todo-list>
  <i class="fas fa-check"></i>
  <span class="green">{{item}}</span>
<todo-list>
```
