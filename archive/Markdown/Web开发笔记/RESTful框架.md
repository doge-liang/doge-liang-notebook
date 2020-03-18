# RESTful 架构

2000年，由Fielding提出。  
REST源于Representational State Transfer的缩写，译作表现层状态转换。  

## 资源(Resource)

REST(表现层状态转换)意指资源的表现层。  

资源代表了网络中的一个实体。包括图片、声音、文本、服务等等。

## 表现层(Representation)

资源有多种表现形式，比方说，文本有html、txt；图片有jpg、png格式，一个User实体，有json、xml、yml等描述格式；

## 状态转换(State Transfer)

客户端和服务端的互动中必然存在着数据和状态的变化。  

互联网通信协议(HTTP协议)，http协议是无状态协议，这意味着，所有的实体状态转换都在服务器端完成，所有的状态都在服务器端完成；  

客户端能用的手段只有HTTP协议中定义的GET、POST、PUT、DELETE等基本操作；

## 综合

以上综合起来就是：
- 每一个URI(Universal Resource Indentifier，全球资源标识符)代表了一种资源；
- 客户端和服务器之间，传递这种资源的表现层，各种形式的文件；
- 客户端通过HTTP动词，对服务器中的资源进行操作，实现表现层的状态转化；

## 常见误区

URI中包含动词，比如：`/user/delete/1`  

delete这个动作，应当有HTTP请求完成，不应该放在URI中，正确为`/user/1`；  

有些时候遇到无法用HTTP请求标识表示的动词只需要把他转化为名词，变成一种服务的意思即可：

错误示范：`/a/transfer/to/b/500`  

纠正：
```

　　POST /transaction HTTP/1.1
　　Host: 127.0.0.1
　　
　　from=a&to=b&amount=500.00
```

