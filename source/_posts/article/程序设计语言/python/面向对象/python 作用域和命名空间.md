---
title: python 作用域和命名空间
tags: []
categories:
  - article
  - 程序设计语言
  - python
  - 面向对象
date: 2021-04-08 00:00:00
---

## python 作用域和命名空间

- [python 作用域和命名空间](#python-作用域和命名空间)
  - [命名空间](#命名空间)
  - [作用域](#作用域)

### 命名空间

官方文档描述：

> namespace （命名空间）是一个从名字到对象的映射。

我们在编程时使用的内置函数 `len()` 、 `try... catch ...` 中捕获的 `Exception` 类，并不是天然就存在的，他们都源自于 python 内建的包，也就是所谓的 `buildins` 。编译器从 `buildins` 中寻找这个“名”到“指令实体”的过程其实就是在命名空间中搜索。

命名空间也可以由我们自己定义，比方说我定义了一个 `class` ，其中包含了若干的函数和变量。我在类外 `import` 这个类（其实就是导入了这个包的命名空间）我们在使用时，一般就是 `<class_name>.<attribute>` ，解释器就会去 `<class_name>` 下寻找这个 `<attribute>` 这个“名”对应的“对象”，然后调用之。

### 作用域

官方文档描述：

> 一个 作用域 是一个命名空间可直接访问的 Python 程序的文本区域。

从例子中说明：

```Python
def scope_test():
    def do_local():
        # 作用域在 do_local() 内
        spam = "local spam"

    def do_nonlocal():
        # 受 nonlocal 关键字影响，对 spam 的赋值影响到了 scope_test() 了
        nonlocal spam
        spam = "nonlocal spam"

    def do_global():
        # 受 global 关键字影响，对 spam 的赋值影响到了整个模块
        # 在 scope_test() 外的使用受到了影响
        global spam
        spam = "global spam"

    spam = "test spam"
    do_local()
    print("After local assignment:", spam)
    do_nonlocal()
    print("After nonlocal assignment:", spam)
    do_global()
    print("After global assignment:", spam)

scope_test()
print("In global scope:", spam)
```

上述变量 `spam` 被多处定义，被绑定到多个作用域中了，

输出：

```code
After local assignment: test spam
After nonlocal assignment: nonlocal spam
After global assignment: nonlocal spam
In global scope: global spam
```
