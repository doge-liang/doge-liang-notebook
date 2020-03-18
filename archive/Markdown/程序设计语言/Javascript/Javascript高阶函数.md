# Javascript 高阶函数

## 3.1 闭包

闭包指的是能够读取其他函数内部变量的函数，使用函数作为返回值，我们可以实现闭包，函数的内部变量将无法从外部访问；
``` Javascript
'use strict';

function create_counter(initial) {
    var x = initial || 0;
    return {
        inc: function () {
            x += 1;
            return x;
        }
    }
}
```
上面的代码中，函数`create_counter()`中有一个局部变量`x`。除了在函数调用时能够改变其值外，没有其他方式能够访问到`x`，相当于其他语言使用`private`封装了。

## 3.2 箭头函数

``` Javascript
(x, y, ...rest) => {
    ...
}
```