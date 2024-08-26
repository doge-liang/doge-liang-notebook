---
title: Java IO
tags: []
categories:
  - article
  - 计算机
  - 程序设计语言
  - Java
date: 2022-06-22 00:00:00
---

## Java IO

Java 提供了庞大的输入/输出 API 供开发者使用。在程序看来，所有的数据来源（磁盘 IO 、内存 IO 、网络 IO 、 ……）都可以看作是字节序列的读写，这个序列被称为 **流** 。具体来说，各种流的实现五花八门，所以 Java 提供了大量的流 IO 类给开发者。

按流的出入方向分，有两个抽象类： `InputStream` 和 `OutputStream` ；
另外，为了方便读写 Unicode 文本（`char`），Java API 定义了 `Reader` 和 `Writer` ，从出入参可以看出，这些类是用于操作字符 `char` 的；

![picture 2](../../../../assets/%E7%A8%8B%E5%BA%8F%E8%AE%BE%E8%AE%A1%E8%AF%AD%E8%A8%80/Java/Java%20IO/156ab2410fcc549381cc37ac73843db03da780428721b26b7fd80e5bfc17f84b.png)

上述的每个抽象类都实现了 `AutoCloseable` 接口，因此都支持 `try-with-resource` 语法，即 `try(InputStream ...){}` 的写法，可以在 `try` 块中自动调用关闭流的 `close()` 方法。

> 为什么 `Closeable` 和 `AutoCloseable` 都有 `close()` 方法？
> 因为 `Closeable` 方法的 `close()` 方法只抛出 `IOException` 但是 `AutoCloseable` 会抛出任何 `Exception` 。

而 `OutputStream` 和 `Writer` 还实现了 `Flushable` 接口，接口中的 `flush()` 方法用于冲刷流中处于缓冲区的数据；

### 读写字节

`InputStream`/`OutputStream` 家族（ `FileInputStream` 、 `FileOutputStream` ...）

`InputStream` 和 `OutputStream` 的 `read()` 和 `write()` 方法都是阻塞的，执行时都会阻塞该线程到字节确实被读写，期间流如果暂时无法访问，则其他线程有机会抢占位置执行别的项目。
如果使用 `avavilable()` 方法便可以判断此时可以获取多少个字节，下面的读取方式不可能被阻塞；

```JAVA
int bytesAvailable  = in.available();
if (bytesAvailable > 0) {
    var data = new byte[bytesAvailable];
    in.read(data);
}
```

Java 9 开始可以使用如下 API 读入流终端的所有字节；

```JAVA
byte[] bytes = in.readAllBytes(); // 一次读取所有的字节，其他的读取给定字节数的方法，都是调用 read() 方法，所以每个 InputStream 的子类都只需要重写 read() 方法即可

in.transferTo(out); // 可以将所有字节从 InputStream 传递到 OutputStream 中
long m = in.skip(n); // 用于跳过指定的字节数，返回实际被跳过的字节数
in.mark(readlimit); // 在字节流的 readlimit 处
```

对每个流操作完毕后都需要调用 `close()` 方法将其关闭，如果不关闭可能会有耗尽系统资源的风险。随着输出流的关闭，其输出缓冲区也会被关闭，缓冲区中的内容也会被冲刷出，如果不关闭流，那么流中的内容永远得不到传递。

实践中，我们会使用更具体的实现类来完成 IO 工作。比如 `FileInputStream` 读入文件流……

`CharBuffer` 类表示内存中的缓冲区，拥有按顺序和随机读写访问的方法；

![picture 3](../../../../assets/%E7%A8%8B%E5%BA%8F%E8%AE%BE%E8%AE%A1%E8%AF%AD%E8%A8%80/Java/Java%20IO/24808671026264201c60003800b569f61fd30b7f3d742b0dbe9ff57aa08eb103.png)

`CharSequence` 接口描述一个 `char` 值序列的基本属性，`String` 、 `CharBuffer` 、 `StringBuilder` 和 `StringBuffer` 类都实现了他。

### 流的嵌套和组合

`FileInputStream` 和 `FileOutputStream` 提供了对磁盘文件的读写方法。但他们与父类 `InputStream` 和 `OutputStream` 一样，都只能读写字节，如果需要读写具体的类型，需要借助 `DataInputStream` 和 `DataOutputStream` 。这是 Java 提供的一种职责分离设计， `FileInputStream` / `FileOutputStream` 等类负责从外部的介质中读取字节流（控制台输入、内存、磁盘、网络等），`DataInputStream` `DataOutputStream` 和 `FilterInputStream` `FilterOutputStream` 负责将字节流解析成需要的类型。

我们通过嵌套使用这些流完成复杂的 IO 操作，比如我们想利用缓冲区完成更高效的 IO ，我们需要嵌套一个 `BufferedInputStream` `BufferedOutputStream` ：

```JAVA
var din = new DataInputStream(
    new BufferedInputStream(
        new FileInputStream("employee.dat")
    )
);
```

有时我们需要预览即将读入的下一个字节是否我们想要的，这时我们需要嵌套 `PushbackInputStream` ：

```JAVA
var pbin = new PushbackInputStream(
    new BufferedInputStream(
        new FileInputStream("employee.dat")
    )
);
int b = pbin.read();
if (b != '<') // 如果不是自己期望的结果，可以使用 unread() 方法将其推回到流中
    pbin.unread(b);
```

从流中读取一个字节时，使用 `int` 接收，**不可以**用 `byte` 和 `char` 接收：

- 使用 `byte` 接收，可能流中返回 `0xFF` ，转换为 `byte` 后会变为 `-1` 导致误判为到达流的末尾；
- 使用 `char` 接收，当流到达末尾返回 `0xFFFFFFFF` ，转换为 `char` 被截断成 `0xFFFF` ，此时的 `char` 也是不等于 `-1` 的，程序无法正常退出；

```JAVA
public static void main(String[] args) {
    char eof = (char) 0xFFFF;
    byte beof = (byte) 0xFF;
    System.out.println(eof == -1); // fasle
    System.out.println(beof == -1); // true
}
```

正确写法如下：

```JAVA
// 字节流
public static void main(String args) {
    FileInputStream in = getReadableStream();
    byte data;
    int result;
    while((result = in.read()) != -1) {
        data = (byte) result;
        // 使用 data
    }
}

// 字符流
public static void main(String args) {
    InputStreamReader in = getReader();
    char data;
    int result;
    while ((result = in.read()) != -1) {
        data = (char)result;
        // 使用 data
    }
}
```
