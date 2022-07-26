---
title: Java面向对象
date: 2021-03-07
tags: [Java]
categories:
  - 程序设计语言
  - Java
---

## Java 面向对象

## 类和对象

类是对象的抽象，对象是类型的实例。好比人类是每一个人的抽象，每个人都是人类的实例。
每个人都有属于自己的属性：身高、体重、年龄、……，这些叫做 **成员变量** 或 **实例变量** 或 **属性域** 等等 ……；
人类又有属于整个类的属性：种群数量、灵长类、哺乳动物、脊椎动物、……，这些叫做 **类变量** 、 **静态变量** 等等 ……；
每个人也都会有自己的行为：吃、喝、睡、运动、……，这些行为只会影响到这一个个体的属性，不会对其他个体产生影响，称之为 **成员方法** 、 **成员函数** 、……；
个体的行为会影响到整个人类的属性：比如生育使得种群数量增长，这种影响类属性的方法称之为 **静态方法** 、**类方法**；

## 继承、封装、多态

## 接口

有时候我们并不想定义一个类，只是想声明一个行为的集合，用于修饰类型，我们可以定义一个接口。接口可以用来描述一种类型应该会有怎样的行为，比如 Java 中的 `Comparable` 接口用于修饰一个可以比较大小的类，实现这个接口的类则需要实现 `compareTo()` 方法用于比较大小； `Runable` 接口用于修饰可以多线程运行的类，实现这个接口的类需要实现 `run()` 方法用于在执行时被调用。

## 泛型

这个特性使得我们可以将类型参数化，即，将类型定义为参数传入方法中，不需要在传入参数的时候再考虑传入对象类型问题，以及相关的程序调试问题。因此对于使用同样处理逻辑的类型，我们不需要为他们单独编写冗余的代码。

借助于 **自动装箱(autoboxing)** 的特性，支持泛型类在被调用的时候自动进行类型转换成为调用者指定的类型。

``` Java
//这是一个泛型类
public class genericClass<T> {
    //这是一个泛型方法
    public genericMethod(T param) {...}
 ...
}

//这是一个泛型接口
public interface genericInterface<T> {
    ...
}

//可以定义多个类型参数
public interface genericInterface<T, R> {
    ...
}
```

在 Java 不支持泛型之前，泛型程序设计的实现依赖于 Object 类，以及强制类型转换，这要求程序员写代码时对自己泛型中的 Object 类实际所指对象了如执掌，否则很容易发生错误的类型转换，导致程序崩溃。引入了泛型之后， 泛型的使用方可以使用 `<>` 告诉编译器，这是对哪个类型执行方法，给予了编译器检查的类型信息，更好地保障了类型转换的安全。
如下代码描述了没有引入泛型之前的时候：

``` java
// 没有泛型的时候
List list = new ArrayList();
list.add(new File());
String string = list.get(0); // 这个方法在编译阶段不会报错，但在运行时会引发类型转换错误的异常
```

引入了泛型之后：

```java
List<File> list = new ArrayList<>();
list.add(new File());
// 这里编译器知道这个 list 存放的是 File 类型的元素，因此编译器预先发现这里会发生类型转换异常，因此代码编译会失败
String list.get(0); 
```

### 泛型类

```java
public class Pair<T> {
    // ...
}
```

### 泛型方法

普通类和泛型类都可以定义泛型方法。

```java
class Test {

    public <T> T getFirst() {
        // ...
    }
    public static <T> T getSecond() {
        // ...
    }
    public static <T> T getThird(T... t) {
        // ...
    }
}
```

使用泛型方法：

```java
// 正常调用
new Test().<String>getFirst();
// 借助类型推断，省略具体类型
String str = Test.getSecond();
```

大多数情况下，类型推断都能正常工作，但偶尔也会遇到问题；

```JAVA
double middle = Test.getThird(3.14, 1729, 0);
// 在上述例子中，参数被自动装箱成包装类型，一个 Double 和两个 Integer
// 他们的共同超类型有两个， Number 和 Comparable 而 Comparable 也是个泛型类型
// 因此返回值应该是两个共同超类型中的一个，而不是 double
```

### 通配符

通配符是为了限制泛型的使用范围而设计的。

- `? extends Employee` 代表这个泛型是 Employee 的子类；
- `? super Manager` 代表这个泛型是 Manager 的父类；

这里 `extends` 和 `super` 关键字后面的不一定要是一个类，也可以是一个接口。也可以指定多个类表示 `?` 是多个类及其子（父）类：`? extends Function & Serializable` 。

在运行时阶段（JVM 所执行的代码）是不存在类型参数的，这个特性又叫做 **类型擦除** 。我们从编译器的角度考虑下面的方法：

```java
// 以下方法不是真的 Java 语法，是为了便于理解写的伪代码
void setFirst(? super Manager obj) {
    //...
}
T super Manger T getFirst() {
    //...
}
```

对于方法 `setFirst()` ：
编译器无法得知 `? super Manager` 指的是哪一个超类，因此不能接受类型 `Employee` 或 `Object` ，只能接受 `Manager` 类型及其子类型。
对于方法 `getFirst()` ：
编译器无法得知 `? super Manager` 指的是哪个超类，不能保证返回对象的类型正确，因此只能返回 `Object` 类；

```java
// 以下方法不是真的 Java 语法，是为了便于理解写的伪代码
void setFirst(Test<? extends Employee> obj) {
    //...
}
<T extends Employee> T getFirst() {
    //...
}
```

对于方法 `setFirst()` ：
编译器无法得知 `? extends Employee` 指的是哪个子类，无论传 `Employee` 或者它的哪个子类都无法保证类型安全，因为 `?` 的真实类型可能是传入类型的子类（也可能没有任何关系，只是拥有同一个父亲 `Employee`)。
对于方法 `getFirst()` ：
方法返回值为 `Employee` 的或其子类型，因此我们可以用 `Employee` 或其父类接收；

### Producer Extend Consumer Super(PECS)

> **协变**：原父子类型关系在经过复杂类型构造之后，父子类型关系被保持下来了；
> **逆变**：原父子类型经过类型构造之后，父子关系逆转；
> **不变**：上述两种不适用；

考虑 `List<? extends T> list` ：
`list.add(something)` 会报错，因为编译器只知道要存的是 `T` 的子类，但是不知道是哪个子类，不能保证类型安全，所以禁止存，只能保证取出来的是 `T` 的子类，所以可以使用 `T` 以及 `T` 的父类型的变量来接受 `list.get()` 的返回值，因为向上转换类型是安全的；
考虑 `List<? super T> list` ：
`list.get()` 只能使用 `Object` 类型来接收，因为我们不知道所存元素的上界，所以只能使用最大的上界来接收他的返回值，以保证类型安全。但编译器知道，`T` 以及 `T` 的子类都能够和 `T` 的某个父类兼容，所以可以使用 `list.add(t)` 存放 `T` 及其子类。

考虑 `List<? extends Animal>` 和 `List<? extends Cat>` ：
`Cat` 是 `Animal` 的子类，而 `List<? extends Cat>` 也是 `List<? extends Animal>` 的子类，我们称之为 *通配符类型是在 **上界协变** 的*；

考虑 `List<? super Animal>` 和 `List<? super Cat>` ：
`Animal` 是 `Cat` 的父类，而 `List<? super Animal>` 是 `List<? super Cat>` 的子类，我们称之为 *通配符类型是在 **下界逆变** 的*；

### hashcode() 与 equal()

在所有类的父类 `Object` 类中， `equal()` 方法是这样定义的：

```JAVA
public boolean equals(Object obj) {
    return (this == obj);
}
```

对于基本数据类型 `==` 进行的是值比较，对于引用数据类型 `==` 比较的是变量的地址值；

`hashCode()` 方法是这样定义的：

```JAVA
public native int hashCode();
```

可以看到是一个本地方法，其返回一个 `int` ，这个 `int` 是由对象的 **内存地址** 计算得来的。因为对于两个对象 `equal()` 方法返回 `true` ，其 `hashCode()` 必定相等。这是由哈希码的定义得到的，哈希码是一个对象的信息摘要，如果两个对象是相等的，那么他们的摘要必定相等；但是反过来，如果两个对象的 hashCode 相等，他们不一定相等，因为用 32 位长的 `int` 是无法描述世界上无穷无尽的对象的，所以必然存在 **哈希碰撞** 的情形。在哈希碰撞的情况下，对象的 hashCode 相等，但是却不是相等的对象。

基于哈希码的定义我们有以下结论：

1. 两对象 equal ， hashCode 必定一样；
2. 两对象不 equal ， hashCode 可能一样，也可能不一样；
3. 两对象 hashCode 一样， 不一定 equal ；
4. 两对象 hashCode 不一样，必定不 equal ；

进一步，我们有以下结论：

1. 重写 `equal()` 方法必须重写 `hashcode()` 方法；（因为重写 equal 之后，可能两个地址不同的对象也能 equal ，而 hashCode 返回的还是他们各自的地址，不符合上述的 **结论 1** ）
2. 重写 `hashcode()` 方法可以不重写 `equal()` 方法；（因为重写 `hashCode()` 方法要求，程序运行时，对于同一个对象无论调用多少次，返回的都是相同的结果，因此必须基于对象自身的信息计算 hashCode ，如果两个对象计算出来的 hashCode 不一样，那么他们必定不是同一个对象，地址肯定也不同， `equal()` 方法必定返回 `false` 所以不重写 `equal()` 也能满足要求；
