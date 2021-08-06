---
title: Markdown 快速入门
date: 2021-07-06
tags: []
categories: 
    - [工具]
    - [markdown]
---

## Markdown 快速入门

### 标题

``` code
# 一级标题

## 二级标题

### 三级标题

#### 四级标题

##### 五级标题

###### 六级标题

```

### 特殊字体


``` code

**加粗**

*斜体*

***斜体加粗***

~~删除线~~
```

### 引用块

``` code
>一级引用
>>二级引用
>>>三级引用
```

### 分割线

``` code
***分割线

---分割线
```

### 图片和超链接

``` code
![图片alt](图片地址)
[超链接名](超链接地址)
```

### 列表

``` code
* 一级无序列表
    * 二级无序列表
        * 三级无序列表

1. 有序列表1
2. 有序列表2
3. 有序列表3
```

### 表格

``` code
| 表头 | 表头 | 表头 |
| ---- | ---- | ---- |
| 内容 | 内容 | 内容 |

表格居中、居左、居右

| 标题一         | 标题二         |         标题三 |     标题四     |
| -------------- | :------------- | -------------: | :------------: |
| xxxxxxxxx      | xxxxxxxxx      |      xxxxxxxxx |   xxxxxxxxx    |
| xxxxxxxxxxxxxx | xxxxxxxxxxxxxx | xxxxxxxxxxxxxx | xxxxxxxxxxxxxx |
| xxxxxxxxx      | xxxxxxxxx      |      xxxxxxxxx |   xxxxxxxxx    |
```

### 代码块

```code
`inline code`

block code

```

``` mermaid
graph LR
  A-->B;
  A-->C;
  B-->D;
  C-->D;
```

脚注的写法：
Content [^1]

[^1]:abc:xxxxxxxxx

​```flow
st=>start: 开始
op=>operation: My Operation
cond=>condition: Yes or No?
e=>end
st->op->cond
cond(yes)->e
cond(no)->op
​```