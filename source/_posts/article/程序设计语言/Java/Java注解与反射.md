---
title: Java注解与反射
date: 2021-03-07
tags: [Java]
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

## Java 注解与反射

### 注解

#### 入门

注解（Annotation），注解不是程序本身，但可以被别的程序解释。

例如：

```JAVA
@Override //这就是注解
public void example() {
    ...
}
```

注解还可以有参数值，比如

```JAVA
@SupperssWarnings(value="unchecked")
```

注解可以附加在 package,class,method,field 上面，相当于增加了额外的辅助信息，我们可以通过反射机制实现对这些元数据的访问。

一些内置注解：

- `@Override` ：重写修辞；

```JAVA
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
public @interface Override {
}
```

- `@Deprecated` ：过时方法提醒；

```JAVA
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(value={CONSTRUCTOR, FIELD, LOCAL_VARIABLE, METHOD, PACKAGE, PARAMETER, TYPE})
public @interface Deprecated {
}
```

- `@SuppressWarning("all")` ：去除警告

元注解：

- `@Target` ：描述注解的使用范围；
- `@Retention` ：表示注释的保存级别，描述注解的生命周期（source < class < runtime）；
- `@Document` ：说明注解将被包含在 javadoc 中；
- `@Inherited` ：说明子类可以继承父类中的该注解；

### 定义一个简单注解

```JAVA
@Target(value = {ElementType.METHOD, ElementType.CLASS})
@Retention(value = RetentionPolicy.RUNTIME)
@Inherited
public @interface MyAnnotaion {
    String value() default ""; // 参数名，如果没有默认值，使用时又不写值，就会报错
}
```

### 反射

反射机制允许 Java 在运行时借助 Reflection API 取得任何类的内部信息，并能直接操作任意对象的内部属性及方法。

正常方式：引入需要的包类名称 -- 通过 `new` 实例化 -- 取得实例化对象；
反射方式：实例化对象 -- `getClass()` 方法 -- 得到完整的包类名称；

#### 功能

- 在运行时判断任意对象所属的类
- 在运行时构造任意类的对象
- 在运行时判断任意类所具有的所有成员变量和方法
- 在运行时调用任意对象的成员变量和方法
- 在运行时处理注解
- 生成**动态代理**

#### 优缺点

优点：动态创建对象和编译，有很大的灵活性；
缺点：对性能有影响，反射基本上是一个解释操作，总是慢于直接执行操作；

#### 获取 Class 类的实例

```JAVA
Test test = new Test();
Class c1 = Class.forName("com.example.Test");
Class c2 = test.getClass();
Class c3 = Test.class();
Class c4 = Integer.TYPE;
Class c5 = c1.getSuperClass();
// 得到的 c1 对象，其实就是 com.example.Test 这个类，并且在包含了这个类的所有属性
// 一个加载的类只能有一个 Class 对象，同一个类不管通过反射取得了多少个 Class 对象，其 hashCode 都是同一个值
Class c6 = int[].class;
Class c7 = int[][].class;
// c6 != c7
Class c8 = String[].class;
Class c9 = int[].class;
// c8 != c9
int[] a = new int[5];
int[] b = new int[10];
Class c8 = a.getClass();
Class c9 = a.getClass();
// c10 == c11
// 只要元素类型和维度一样，都是同一个 Class 对象还是
```

#### Class 类的常用方法

- `static Class forName(String name)` ：返回指定类名的 `Class` 对象；
- `Object newInstance()` ：返回 `Class` 对象的一个实例；
- `getName()` ：返回 `Class` 对象的实体（类、接口、数组类或 `void`）名称；
- `Class getSuperClass()` ：返回当前 `Class` 对象的父类的 `Class` 对象；
- `Class[] getinterfaces()` ：返回当前 `Class` 对象的接口；
- `ClassLoader getClassLoader()` ：返回该类的类加载器；
- `Constructor[] getConstructors()` ：返回一个包含某些 `Constructor` 对象的数组；
- `Method getMethod(String name, Class.. T)` ：返回一个 `Method` 对象，此对象的形参类型为 `paramType`；
- `Field[] getDeclaredFields()` ：返回 `Field` 对象的一个数组；
