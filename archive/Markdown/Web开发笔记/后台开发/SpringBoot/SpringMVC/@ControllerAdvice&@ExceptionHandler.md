# 一、背景

通常我们会把**事务**性操作配置在Service层（BaseService+xxxService+xxxServideImpl）当数据库操作出现异常后，让Service层抛出运行时异常，Spring事务管理器就会进行回滚。

为了代码美观，我们一般不会在Service层直接处理异常，而是将其抛出。利用AOP编程，在专门的一个ExceptionHandler（拦截器）中处理众多的xxxServiceImpl中抛出的异常。

# 二、@ControllerAdivce & @ExceptionHandler

一般这两个注解配合使用，组成一个拦截器对系统抛出的运行时异常进行拦截处理并返回统一实体。  

## 2.1 @Controller 注解定义全局异常处理类

```java
@ControllerAdvice
public class GlobalExceptionHandler {
}
```

## 2.2 @ExceptionHandler 注解声明异常处理方法

```java
@ControllerAdvice
public class GlobalExceptionHandler {
	
	@ExceptionHandler(Exception.class)
	@ResponseBody
	public ResultDTO handleException(GlobalException ex) {
		//可以记录log，这样就既可以记录错误也可以不输出不友好信息
		return ResultDTO.of(ex.getCode(), ex.getMsg());
	}
```

