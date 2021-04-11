---
title: python 面向对象入门
date: 2021-04-02
tags: []
categories: 
    - 程序设计语言
    - python
    - 面向对象
---

## python 面向对象入门

面向对象的要素：

- 类
- 属性
- 方法

- 继承
- 封装
- 多态

### 类

python 类对象支持两种操作：属性引用、实例化

``` Python
class Car:
    """A Car Class"""

    # 类变量，在所有实例中共享
    # 类似于 Java 中的 static 变量
    CarCount = 0

    # 私有变量，不能直接访问，也不能继承
    __price = 0

    # 构造方法
    def __init__(self, carNo, driver):
        # 实例变量，为单个实例拥有
        self.carNo = carNo
        self.driver = driver

    # 成员方法
    def get_price(self):
        print(self.__price)

    def get_driver(self):
        print(self.driver)

# 属性引用
Car.CarCount
# 内置方法，返回 "A Car Class"
Car.__doc__ 

# 实例化
car = Car("粤A2333", "老司机")
car.carNo # 访问实例对象

class People:
    
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def get_driver(self):
        print(self.name, '是司机')

    # 私有方法，只能在类内访问
    def __get_IDcard(self):
        print("这是一个私有方法")

# 单继承
class BMW(Car):
    model = ''
    def __init__(self, carNo, driver, model):
        # 调用父类的构造函数
        Car.__init__(self, carNo, driver):
        self.model = model
    # 覆盖父类的方法
    def get_driver(self):
        print(self.driver)

# 多继承
def License(Car, Driver):

    def __init__(self, carNo, driver, name, age):
        Car.__init__(self, carNo, driver)
        People.__init__(self, name, age)

a = License('粤A7846', '小明', '小明', 22)
a.get_driver() 
# 在遇到多继承的父类中都有同样方法的情况下，
# 默认执行在括号中，排前面的类的那个方法
# 所以输出:
# 
# 小明
# 
```

### 私有方法

除了可以自己定义私有方法外，这些方法都是类内可以使用的私有方法：

__init__ : 构造函数，在生成对象时调用
__del__ : 析构函数，释放对象时使用
__repr__ : 打印，转换
__setitem__ : 按照索引赋值
__getitem__: 按照索引获取值
__next__: 逐一访问容器内的下一个对象，直到触发 `StopIteration`  异常
__iter__: for 语句会执行这个方法，返回一个定义了 `__next__()` 方法的容器对象
__len__: 获得长度
__cmp__: 比较运算
__call__: 函数调用
__add__: 加运算
__sub__: 减运算
__mul__: 乘运算
__truediv__: 除运算
__mod__: 求余运算
__pow__: 乘方

类型转换相关的方法：
__int__
__str__
__bytes__
...

此外还有很多预定义的函数，很多 python 的一些操作都可以通过重写预定义函数来定制化，比如下面的运算符重载。

#### 运算符重载

通过对以上类内使用的私有方法的重新定义来达到运算符重载的效果，比如重载 `+` ：

``` Python
class Vector:
    x = 0
    y = 0

    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __str__(self):
        return 'Vector (%d, %d)' % (self.x, self.y)

    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y)


if __name__ == '__main__':
    v1 = Vector(0, 0)
    v2 = Vector(10, -10)

    print(v1 + v2)
```

输出:

``` BASH
(10, -10)
```

#### 自定义迭代器

`for` 语句会调用类的 `iter()` 方法，返回一个定义了 `next()` 函数的容器对象，然后不停调用 `next()` 方法，访问容器内的对象。直到 `__next__()` 方法触发 `StopIteration` 异常来通知 `for` 终止循环。下面定义了一个迭代器类。

``` Python
class Reverse:
    """Iterator for looping over a sequence backwards."""
    def __init__(self, data):
        self.data = data
        self.index = len(data)

    def __iter__(self):
        return self

    def __next__(self):
        if self.index == 0:
            raise StopIteration
        self.index = self.index - 1
        return self.data[self.index]


if __name__ == '__main__':
    r = Reverse([1, 2, 3, 4])
    for i in r:
        print(i)
# 1
# 2
# 3
# 4
```

#### 生成器

上面实现的迭代器是通过自定义 `__iter__()` 和 `__next__()` 方法实现的，实际上要完成同样的功能，生成器也可以实现，而且生成器的语法会更加紧凑。

``` Python
def reverse(data):
    for index in range(len(data)-1, -1, -1):
        yield data[index]


if __name__ == '__main__':
    for i in reverse('golf'):
        print(char)
# f
# l
# o
# g
```

通过 `next()` 函数调用生成器，就会在执行到 `yield` 的时候离开函数，每执行一次 `next()` 还会从上次离开的地方继续执行。

``` Python
if __name__ == '__main__':
    r = reverse([1, 2, 3, 4])
    print(next(r))
    print(next(r))
    print(next(r))
    print(next(r))

# 4
# 3
# 2
# 1
```

##### 生成器表达式

``` Python
if __name__ == '__main__':
    print([i for i in reverse('abcd')])
```
