---
title: Javascript——基础
date: 2019-10-10
tags: []
categories: 

    - 程序设计语言

---

## JavaScript 快速入门

### 1.1 基本语法

一句语句完成用 `;` 结尾；  
块语句用 `{...}` 框选；  
编译器可以直接使用Chrome浏览器；

### 1.2 数据类型

#### 1.2.1 Number

JavaScript 不区分整数和浮点数，统一表示为Number；

``` JavaScript
123 // 整数123
0.456 //浮点数0.456
1.2345e3 // 科学计数法表示浮点数
NaN // NaN表示Not a Number，当无法计算时用NaN表示（区分Python的NaN）
Infinity // Infinity表示无限大，当数值超界时用Infinity表示
```

数字运算符， `+` 、 `-` 、 `*` 、 `/` 、 `%`

#### 1.2.2 字符串

`"abc"` 、 `'abc'` 都是字符串的表示形式；

### 1.2.3 布尔值

``` JavaScript
true
false

&& // 与运算
|| // 或运算
! //非运算

2 > 5; // false
5 >= 2; // true
7 == 7; // true

// 实际上JavaScript允许任意数据类型做比较
false == 0; // true，会自动转换数据类型再比较，有时候结果会很诡异
false === 0; // false，不会转换，数据类型不一致则会false
```

#### 1.2.4 缺失值

#### `NaN`

需要注意的是

``` JavaScript
NaN == NaN //false，NaN不等于任何对象包括它自己
isNaN(NaN) //true，这是唯一判断NaN的方法
typeof(NaN) //Number，还是会返回Number
```

关于浮点数计算误差，这一点在每一门编程语言中都会出现，这是计算机内部对浮点数的表示造成的问题。

### `null` 和 `undefined`

`null` 表示空值， `undefined` 表示未定义；

``` Javascript
typeof(null) //object
typeof(undefined) //undefined
```

通常 `undefined` 用于判断函数参数是否传递的情况下有用；

### 1.2.5 数组

数组也是对象

``` JavaScript
[1, 2, 3, 14, 'Hello', null, true];

new Array(1, 2, 3);

// 注意这里的元素数量是 3 但是数组内没有内容，都是undefined
new Array(3)

var arr = [1, 2, 3];
arr[0] //数组切片
arr[1]
arr[3] // 索引超界返回undefined
arr.pop() // 尾部弹出
arr.shift() // 顶部流出
arr.push("elem") // 尾部推入
arr.unshift("elem") // 顶部推入
```

* array.splice()

用法： `arr.splice(index[, deleteCount, elem1, ..., elemN])`

``` JavaScript
let arr = ["I", "study", "JavaScript"];
arr.splice(1, 1); // 从索引 1 开始删除 1 个元素
alert(arr); // ["I", "JavaScript"]
```

* array.find()/array.findIndex()

``` JavaScript
let arr = ["I", "study", "JavaScript"];
arr.findIndex(item => item == "I") // 0
arr.find(item => item == "I") // "I"
```

### 1.2.6 对象

键值对  
JavaScript对象的键都是字符串，值可以为任意类型。

``` JavaScript
var person = {
    name: 'Bob',
    age: 20,
    tags: ['js', 'web', 'mobile'],
    city: 'Beijing',
    hasCar: true,
    zipcode: null
};
person.name; // 'Bob'
person.zipcode; // null
```

### 1.2.7 变量

``` JavaScript
var a; // 申明了变量a，此时a的值为undefined
var $b = 1; // 申明了变量$b，同时赋值为1
var s_001 = '007';
var answer = true;
var t = null;
```

这种类型声明时无需指定类型的语言为动态语言，反之为静态语言；

### 1.2.8 strict 模式

该模式为修复早期JavaScript全局变量（无需 `var` 声明的变量）带来的种种问题而产生，在JavaScript代码的第一行中输入

``` JavaScript
'use strict'
```

支持strict模式的浏览器便可以开启strict模式。这时如果声明变量不使用 `var` 便会报错。

## 1.3 字符串

### 1.3.1 转义字符

同其他语言。  
ASCII字符表示 `\x##`
Unicode字符 `\u####`

### 1.3.2 多行字符串

使用反引号

``` JavaScript
`多行字符串
多行字符串
多行字符串`
```

### 1.3.3 模板字符串

用于连接字符串，注意用的是反引号

``` JavaScript
var name = '小明`;
var age = 20;
var message = `你好，${name}，你今年${age}岁了！` 
```

另一种方式时 `+` ，同其他语言。

### 1.3.4 操作字符串

``` JavaScript
var s = 'abcDEF';
s.length; // 3

s[0] // 'a'

s.toUpperCase() // 'ABCDEF'

s.toLowerCase() // 'abcdef'

s.indexOf('a') // 0
s.indexOf('A') // -1，找不到
```

## 1.4 数组

``` JavaScript
var arr = [1, 2, 3]

arr.length; // 3
arr.length = 6; // 6
arr; // [1, 2, 3, undefined, undefined, undefined]
arr.length = 2; // 2
arr; // [1, 2]
```

`indexOf()` 同其他语言，找不到返回-1  

`slice()` 类似于索引

``` JavaScript
var arr = [1, 2, 3];
arr.slice(1, 2); // [2, 3]
arr.silce(3); // [1, 2, 3]
```

`push()` 和 `pop()`
`push()` 添加， `pop()` 去除，类似于栈

``` JavaScript
var arr = [1, 2];
arr.push('A', 'B');
arr; // [1, 2, 'A', 'B']
arr.pop() // 'B'
```

`unshift()` 和 `shift()`
`unshift()` 头部添加， `shift()` 尾部删除

``` JavaScript
var arr = [1, 2];
arr.unshift('A', 'B');
arr; // ['A', 'B', 1, 2]
arr.shift(); // 'A'
```

`sort()`
排序。

``` JavaScript
var arr = ['B', 'A', 'C'];
arr.sort();
arr; // ['A', 'B', 'C']
```

`reverse()`
反转整个数组。

``` JavaScript
var arr = ['B', 'A', 'C'];
arr.reverse(); // ['C', 'A', 'B']
```

`splice()`
修改 `Array` 的万能方法；

``` JavaScript
var arr = ['Microsoft', 'Apple', 'Yahoo', 'AOL', 'Excite', 'Oracle'];
// 从索引2开始删除3个元素，再添加两个元素；
arr.splice(2, 3, 'Google', 'Facebook'); // 返回删除的元素['Yahoo', 'AOL', 'Excite']
arr; // ['Microcoft', 'Apple', 'Google', 'Facebook', 'Oracle']
// 只删除，不添加；
arr.splice(2, 2); // ['Google', 'Facebook']
arr; // ['Microsoft', 'Apple', 'Oracle']
// 只添加，不删除；
arr.splice(2, 0, 'Google', 'Facebook');
arr; // ['Microsoft', 'Apple', 'Google', 'Facebook', 'Oracle']
```

`concat()`
连接两个 `Array` 并返回结果；

``` JavaScript
var arr = ['A', 'B', 'C'];
var added = arr.concat([1, 2, 3]);
added; // ['A', 'B', 'C', 1, 2, 3]
arr; // ['A', 'B', 'C']
```

**值得注意的是**， `concat()` 并不会修改调用它的 `Array` ，而是返回新的 `Array` 。  
**而且**， `concat()` 方法可以接受任意的元素和 `Arrary` ，并且自动拆开 `Array` 。

`join()`
连接数组中的元素并且可以用指定的字符串连接起来；

``` JavaScript
var arr = ['A', 'B', 'C', 1, 2, 3];
arr.join('-'); // 'A--B-C-1-2-3'
```

该方法会自动转换元素为字符串再拼接。

多维数组  
索引同其他编程语言。

## 1.5 对象

就是键-值对  
通过 `object.attribute` 访问，若键不是一个有效的变量名，而是字符串，那就只能用 `object['attribute']` 访问。  
对于对象的增删改查；

``` JavaScript
var xiaming = {
    name: '小明'
};
xiaoming.age; // undefined
xiaoming.age = 18; // 新增一个age属性
delete xiaoming.age; //删除age属性
delete xiaoming.school; // 删除一个不存在的school属性也不会报错
```

用 `in` 操作符判断属性是否存在。

``` JavaScript
'toString' in xiaoming; // true,Object对象从Object继承来的toString
```

用 `hasOwnProperty()` 判断是否对象自己拥有的而不是继承来的；

``` JavaScript
var xiaming = {
    name: '小明'
};
xiaoming.hasOwnProperty('name'); // true
xiaoming.hasOwnProperty('toString'); // false
```

## 1.6 条件判断

用 `if () {...} else if() {...} else {...}` 来进行条件判断。支持嵌套，同其它语言。

## 1.7 循环

`for (...;...;...)` 同其他语言。  
`for var key in iterable` 类似python。**注意**：对 `Array` 的迭代，只会迭代 `Array` 的索引。  
`while (...)` 同其他语言。  
`do {...} while(...)` 同其他语言。  

## 1.8 Map和Set

为解决对象的键只能是字符串的问题，JavaScript提供了Map对象。  
Map的增删改查。

``` JavaScript
var m = new Map([
    ['Michael', 95],
    ['Bob', 59],
    ['Tracy', 85]
]);
m.get('Michael'); // 95
var m = new Map();
m.set('Adam', 67);
m.has('Adam'); // true
m.delete('Adam');
m.get('Adam'); // undefined
```

Set类似Map但是不存储value, Key值不重复。

``` JavaScript
var s1 = new Set();
var s2 = new Set([1, 2, 3]);
s1.add(4);
s1.delete(3);
```

注意在 `Set` 中 `1` 和 `'1'` 是不同元素。  
重复 `add()` 元素不会报错，但也没有效果。  

## 1.9 iterable

`Array` 、 `Map` 和 `Set` 都输入 `iterable` 类型。  
`iterable` 可以用 `for...of` 来遍历。  
`for ... in` 循环由于历史遗留问题，它遍历的实际上是对象的属性名称。一个 `Array` 数组实际上也是一个对象，它的每个元素的索引被视为一个属性。
`for ... of` 循环则完全修复了这些问题，它只循环集合本身的元素。  
然而，更好的方式是直接使用 `iterable` 内置的 `forEach` 方法，它接收一个函数，每次迭代就自动回调该函数。  
