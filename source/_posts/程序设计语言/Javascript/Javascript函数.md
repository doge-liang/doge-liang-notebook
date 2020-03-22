---
title: Javascript程序设计语言——函数
date: 2019-10-10
tags: [程序设计语言, Javascript]
categories: 
    - [程序设计语言]
---
# Javascript函数

## 2.1 函数定义

```JavaScript
function abs(x) {
	if (x >= 0) {
		return x;
	} else {
		return -x;
	}
}
```
注意，若没有`return`那么函数也会有返回值，只不过返回值为`undefined`。

JavaScript的函数也是一个对象，上述`abs(x)`实际上是一个函数对象，而函数名`abs`可以视为函数指针。

因此还有一种定义函数的方式为：
```JavaScript
var abs = function (x) {
	if (x >= 0) {
		return x;
	} else {
		return -x;
	}
};
```
这种情况下，相当于定义了一个匿名函数`function (x) {...}`，然后再赋值类`abs`变量，这时我们便可以使用`abs`访问函数了。

## 2.2 函数调用

```JavaScript
abs(10, null, 'blablabla'); // 10
abs(-9, null, 'hehe', 'haha'); // 9
abs() // NaN
```
JavaScript允许传入任意参数而不影响调用，而函数不接受参数也不会报错，而是返回`NaN`。

## 2.3 函数自带参数

### 2.3.1 arguments 参数

JavaScript的函数自带一个参数`arguments`，常用于判断函数参数个数：
```JavaScript
// 这里实现了一个b为可选参数的函数
function foo(a, b, c) {
	if (arguments.length === 2) {
		// 当函数只给了两个参数时，将b变为可选参数
		c = b; // 将c赋值给b
		b = null; // 将b赋值为默认值
	}
}
```

### 2.3.2 rest参数

rest参数只能写在最后，前面用`...`标识：
```JavaScript
function foo(a, b, ...rest) {
	console.log(a);
	console.log(b);
	console.log(c);
}


foo(1, 2, 3, 4, 5);
// 结果:
// a = 1
// b = 2
// Array [ 3, 4, 5 ]

foo(1);
// 结果:
// a = 1
// b = undefined
// Array []
```

**小心return**：由于JavaScript行末自动添加分号的特性，所以随便换行，可能导致return后面的语句无法运行；
```JavaScript
function foo() {
	return // JavaScript自动添加分号
		{name: 'foo'}; // 这段代码无法运行
}
```

## 2.4 作用域

作用域：不同于其他语言的块作用域，JavaScript的作用域实际上实在函数内部的；  

**变量提升**：JavaScript会将变量的声明部分提升到函数顶部，而变量赋值则留在原位；ex：
```JavaScript
function foo() {
	var x = 'x+' + y;
	console.log(x);
	var y = 'y';
}

foo();
// x+undefined
```

为了避免麻烦，我们通常会在函数顶部定义所有变量；
```JavaScript
function foo() {
    var
        x = 1, // x初始化为1
        y = x + 1, // y初始化为2
        z, i; // z和i为undefined
    // 其他语句:
    for (i=0; i<100; i++) {
        ...
    }
}
```

全局作用域：  
不在任何函数内定义的变量就具有全局作用域。实际上，JavaScript默认有一个全局对象window，全局作用域的变量实际上被绑定到window的一个属性：
```JavaScript
'use strict';

var course = 'Learn JavaScript';
alert(course); // 'Learn JavaScript'
alert(window.course); // 'Learn JavaScript'
```
由于函数定义有两种方式，以变量方式var foo = function () {}定义的函数实际上也是一个全局变量，因此，顶层函数的定义也被视为一个全局变量，并绑定到window对象：
```JavaScript
'use strict';

function foo() {
    alert('foo');
}

foo(); // 直接调用foo()
window.foo(); // 通过window.foo()调用
```
名字空间  
全局变量会绑定到window上，不同的JavaScript文件如果使用了相同的全局变量，或者定义了相同名字的顶层函数，都会造成命名冲突，并且很难被发现。

减少冲突的一个方法是把自己的所有变量和函数全部绑定到一个全局变量中。例如：
```JavaScript
// 唯一的全局变量MYAPP:
var MYAPP = {};

// 其他变量:
MYAPP.name = 'myapp';
MYAPP.version = 1.0;

// 其他函数:
MYAPP.foo = function () {
    return 'foo';
};
```
把自己的代码全部放入唯一的名字空间MYAPP中，会大大减少全局变量冲突的可能。

许多著名的JavaScript库都是这么干的：jQuery，YUI，underscore等等。

局部作用域  
由于JavaScript的变量作用域实际上是函数内部，我们在for循环等语句块中是无法定义具有局部作用域的变量的：
```JavaScript
'use strict';

function foo() {
    for (var i=0; i<100; i++) {
        //
    }
    i += 100; // 仍然可以引用变量i
}
```
为了解决块级作用域，ES6引入了新的关键字let，用let替代var可以申明一个块级作用域的变量：
```JavaScript
'use strict';

function foo() {
    var sum = 0;
    for (let i=0; i<100; i++) {
        sum += i;
    }
    // SyntaxError:
    i += 1;
}
```

常量  
ES6标准引入了新的关键字const来定义常量，const与let都具有块级作用域：
```JavaScript
'use strict';

const PI = 3.14;
PI = 3; // 某些浏览器不报错，但是无效果！
PI; // 3.14
```

解构赋值  
将数组/对象拆开分别赋值给其他变量；
```JavaScript
// 数组解构
var [x, y, z] = ['hello', 'JavaScript', 'ES6'];
// x = hello, y = JavaScript, z = ES6

// 嵌套解构
let [x, [y, z]] = ['hello', ['JavaScript', 'ES6']];
x; // 'hello'
y; // 'JavaScript'
z; // 'ES6'

// 忽略部分
let [, , z] = ['hello', 'JavaScript', 'ES6']; // 忽略前两个元素，只对z赋值第三个元素
z; // 'ES6'

// 解构对象
var person = {
    name: '小明',
    age: 20,
    gender: 'male',
    passport: 'G-12345678',
    school: 'No.4 middle school'
};
var {name, age, passport} = person;
// name = 小明, age = 20, passport = G-12345678

// 对象嵌套
var person = {
    name: '小明',
    age: 20,
    gender: 'male',
    passport: 'G-12345678',
    school: 'No.4 middle school',
    address: {
        city: 'Beijing',
        street: 'No.1 Road',
        zipcode: '100001'
    }
};
var {name, address: {city, zip}} = person;
name; // '小明'
city; // 'Beijing'

// 更换变量名
var person = {
    name: '小明',
    age: 20,
    gender: 'male',
    passport: 'G-12345678',
    school: 'No.4 middle school'
};
// 把passport属性赋值给变量id:
let {name, passport:id} = person;
name; // '小明'
id; // 'G-12345678'

// 赋予默认值
var person = {
    name: '小明',
    age: 20,
    gender: 'male',
    passport: 'G-12345678'
};
// 如果person对象没有single属性，默认赋值为true:
var {name, single=true} = person;
name; // '小明'
single; // true

```
**注意**  
有些时候，如果变量已经被声明了，再次赋值的时候，正确的写法也会报语法错误：
```JavaScript
// 声明变量:
var x, y;
// 解构赋值:
{x, y} = { name: '小明', x: 100, y: 200};
// 语法错误: Uncaught SyntaxError: Unexpected token =
```
这是因为JavaScript引擎把{开头的语句当作了块处理，于是=不再合法。解决方法是用小括号括起来：
```JavaScript
({x, y} = { name: '小明', x: 100, y: 200});
```

## 2.5 方法

定义在对象内部的函数称为方法。普通函数与方法的区别在于，方法`this`指针的指向问题，该指针始终指向自己的对象，便于访问对象内的其他数据、方法。

只有方法的`this`指针才是指向调用对象的，函数的`this`指针指向全局变量`window`（strict模式下指向`undefined`），即使是方法内的函数的`this`指针仍然是指向`window`：
```JavaScript
function getAge() {
    var y = new Date().getFullYear();
    return y - this.birth;
}

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: getAge
};

xiaoming.age(); // 25, 正常结果
getAge(); // NaN
// 即使将对象的方法赋值给另一个变量，this指针仍然指向window
var fn = xiaoming.age; // 先拿到xiaoming的age函数
fn(); // NaN
```
一个修复方法就是在方法头便捕获`this`指针为自己的变量：
```JavaScript
'use strict';

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        var that = this; // 在方法内部一开始就捕获this
        function getAgeFromBirth() {
            var y = new Date().getFullYear();
            return y - that.birth; // 用that而不是this
        }
        return getAgeFromBirth();
    }
};

xiaoming.age(); // 25
```
另一个修复方法是使用函数本身的`apply`方法：
```JavaScript
function getAge() {
    var y = new Date().getFullYear();
    return y - this.birth;
}

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: getAge
};

xiaoming.age(); // 25
getAge.apply(xiaoming, []); // 25, this指向xiaoming, 参数为空
```
它接收两个参数，第一个参数就是需要绑定的this变量，第二个参数是Array，表示函数本身的参数。

装饰器  
利用`apply()`，我们还可以动态改变函数的行为。
比方说我们要统计一个函数的调用次数：
```JavaScript
'use strict';

var count = 0;
var oldParseInt = parseInt; // 保存原函数

window.parseInt = function () {
    count += 1;
    return oldParseInt.apply(null, arguments); // 调用原函数
};
```
这里我们相当于把原函数包裹了一层代码，用来统计执行次数，当然我们也可以在装饰器内放其他代码。

## 2.6 函数作为返回值

Javascript的函数还可以作为函数的返回值来返回；
利用这个特性实现的`Array`计算：
``` Javascript
function lazy_sum(arr) {
    var sum = function(arr) {
        return arr.reduce(function (x, y) {
            return x + y;;
        });
    }
    return sum;
}

var sum = lazy_sum([1, 2, 3, 4, 5, 6]) //sum([1, 2, 3, 4, 5, 6])
sum() //21
```
**值得注意的是：每次调用返回的函数都是不同的函数，结果不互相影响。**