---
title: 组件-component
tags: []
categories:
  - article
  - 计算机
  - 框架
  - 前台
  - Vue
date: 2021-10-07 00:00:00
---

- [组件-component](#组件-component)
  - [组件注册](#组件注册)
  - [组件间通信](#组件间通信)
    - [父组件通过 props 向子组件传值](#父组件通过-props-向子组件传值)

## 组件-component

Vue 的页面是由一个个组件嵌套、拼装组成的。每个组件相当于一个单 Vue 文件应用。

### 组件注册

组件需要注册之后才能使用，有本低注册和全局注册两种方式：

```JavaScript
// 本地注册
import componentA from 'componentA.vue'

export default {
  components: {
    componentA: conponentA
  }
}

// 全局注册，在 main.js 内
const App = Vue.createApp()
app.component('component-a', {
  // options
})
```

### 组件间通信

前面说到 Vue 的组件其实是一个单 .vue 文件应用，文件之间的作用域相互隔离。但组件之间是有交互行为的，子组件收到不同父组件传来的消息，可以对这些消息作出变化。比如说 Post 组件是存放博客的，不同页面博客内容不同，这个内容是由父组件传进来的。子组件只关心样式。

#### 父组件通过 props 向子组件传值

子组件中，有两种定义 `props` 的方式：

- 通过数组定义，接收类型只能是字符串；
- 通过对象的方式定义可以指定具体类型；

```JavaScript
// child-component
export default {
  props: ['title'],
  setup(props, context) {
    console.log(props.title)
  }
}
```

```JavaScript
// child-component
export default {
  props: {
    title: String,
    pager: Object,
    today: Number
  }
}
```

父组件传值：

```JavaScript
// parent-component
<template>
  <child-component title="create"></child-component>
</template>
export default {
  ...
}
```
