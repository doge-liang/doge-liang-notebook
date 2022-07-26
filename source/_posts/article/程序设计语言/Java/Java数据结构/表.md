---
title: Java 的表 List
date: 2021-03-12
tags: []
categories:
  - 程序设计语言
  - Java
---

<style>
.center {
width: auto;
display: table;
margin - left: auto;
margin - right: auto;
}
// 图片居中
img {
position: relative;
left: 50%;
transform: translateX(-50%);
}
</style>

## Java 的表 List

![picture 1](../../../../../assets/%E7%A8%8B%E5%BA%8F%E8%AE%BE%E8%AE%A1%E8%AF%AD%E8%A8%80/Java/Java%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/Java%20%E7%9A%84%E8%A1%A8%20List/653b516fdee70785f8e34b94cef2b5b81f40f302292c3ff911e040c0a9c9ca18.png)  

### List<?> 转换成 ?[]

```JAVA
int[] array = list.stream().mapToInt(i -> i).toArray();
```

注意 `list.toArray()` 返回的是 `Object[]` 或者 `T[]`

### 从 List 复制效率看浅拷贝与深拷贝

- 浅拷贝：将 A 的指向 B 所指的对象，此时 A 、 B 所指对象相同，对象的改变会同时影响 A 、 B 的值；
- 深拷贝：将 B 所指的对象在内存中复制一份， A 指向新的对象，此时 A 、 B 所指对象不同，变化不会互相影响；

复制 List 的几种方法：

- 实例化一个新的 List 与原 List 相同大小，循环遍历调用 `add()` 方法；
- `Arrays.copyOf()` ，`new ArrayList<>(srcList)` 用源 List 构造新的 List 实际上使用的是 `Arrays.copyOf()` 方法，而 `Arrays.copyOf()` 实质上是使用 `System.arraycopy()` 方法；
- 实例化一个空的 List ，然后调用 `destList.addAll(srcList)` 将 srcList 的元素全部添加到 destList 中；
- `System.arraycopy()` 方法；

上面这几种都属于是浅拷贝，原列表的对象发生变化，复制对象的元素也会发生改变；

- 使用序列化方法
- `Object.clone()`

这几种方法属于深拷贝方法；

效率对比：

1. `System.arraycopy()` ，这是一个 native 方法，一般是效率更高的语言编写的，并且看 javadoc 可知，这个方法不用经过 JNI 的编译，而是直接用 cpp 写好的；
2. `clone()`，虽然该方法也是 native 方法，但是需要通过 JNI 编译才能执行，因此速度差一点；
3. `Arrays.copyOf()`，不是 native 方法，且依赖于 `System.arraycopy()` ，所以要更慢；
4. `for()`，是深拷贝了，比浅拷贝要慢得多；
