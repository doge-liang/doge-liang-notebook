# @RequestBody

## 作用：

1. 该注解用于读取Request请求的body部分数据，使用系统默认配置的HttpMessageConverter进行解析，然后把相应的数据绑定到要返回的对象上；

2. 再把HttpMessageConverter返回的对象数据绑定到 controller中方法的参数上。

## 使用时机：

1. GET、POST方式提交时， 根据request header Content-Type的值来判断:

- application/x-www-form-urlencoded， 可选（即非必须，因为这种情况的数据@RequestParam, @ModelAttribute也可以处理，当然@RequestBody也能处理）；
- multipart/form-data, 不能处理（即使使用@RequestBody不能处理这种格式的数据）；
- 其他格式， 必须（其他格式包括application/json, application/xml等。这些格式的数据，必须使用@RequestBody来处理）；

2. PUT方式提交时， 根据request header Content-Type的值来判断:

- application/x-www-form-urlencoded， 必须；
- multipart/form-data, 不能处理；
- 其他格式， 必须；
说明：request的body部分的数据编码格式由header部分的Content-Type指定；

# @ResponseBody

## 作用

该注解用于将Controller的方法返回的对象，通过适当的HttpMessageConverter转换为指定格式后，写入到Response对象的body数据区。

## 使用时机

返回的数据不是html标签的页面，而是其他某种格式的数据时（如json、xml等）使用；
