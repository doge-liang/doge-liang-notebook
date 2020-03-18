# Http 鉴权手段

http常见的鉴权手段主要有四种，HTTP Basic Authentication、Session-Cookie、Token、OAuth。

## HTTP Basic Authentication

验证步骤：  
1. client发送一个任意的http请求到server；
2. server回显一个带有WWW-Authenticate: Basic realm="Access to the staging site"的401 UnAuthorized Http 消息；
3. client的浏览器弹出登录窗口提示用户输入用户名和密码，用户提交表单之后，浏览器生成新的Http请求发送给server，新的Http包含Authorization字段；
`Authorization: <type> <credentials>`：type中有多个值可以填写(Basic, Bearer, Digest, HOBA, Mutual, AUS4-HMAC-SHA256)，credentials中包含了加密了(Base64)的用户名和密码；
4. 若server验证credentials成功则返回200 OK，若验证失败则返回403 Forbidden

注销方式：(参考)  
服务器中存有一个注销时需要提交的用户名和密码。当用户需要注销时，则修改请求头发送服务器中存的注销账号。  

缺点：  
加密方式可逆；  
密码传输包含在请求头中，容易嗅探；  

适用环境：不接触外网的内网系统；  

## Session-Cookies

认证步骤：  
1. server在client首次访问的时候建立Session并保存在内存中或redis中，然后生成唯一的Session标识字符串，然后再响应头中种下sid；
2. 签名。server加密sid；(可选)
3. client解析响应头，然后将sid保存在本地cookies中，在下次访问server的时候会从cookies中取出相应的sid发过去；
4. server根据client发送的sid查询Session，以此判断请求是否合法；

缺点：  
使用Cookies，依赖于浏览器；  
时效性长，安全性相对低，从用户登录到登出这段时间，sid一直不变；  

## Token 认证(主流)

认证步骤：  
1. client发送用户名和密码请求登录；
2. server收到请求，验证用户名和密码；
3. 验证成功，server签发Token令牌；
4. client收到Token令牌，保存在Cookies中或本地中；
5. client每次发送请求都带上Token令牌；
6. server每次收到请求都验证Token令牌，若成功则返回数据；

## OAuth 认证

OAuth(开放授权)是一个开放标准，允许用户在授权给第三方应用使用信息的同时，不需要向第三方应用提供用户名和密码。比如：使用QQ账号登录各大论坛网站。  
认证步骤：  
1. 向用户请求授权，跳转到第三方登录入口；
2. 当用户选择授权并登录之后，授权server将返回用户凭证(code)；
3. 从这步开始，所有的工作都在后台完成，不与用户产生交互。第三方应用的server收到code，使用这个code去授权server中获取Access Token；
4. 授权server验证凭证，同意授权之后，返回一个资源访问的凭证Access Token；
5. 第三方应用通过得到的Access Token向资源server获取资源；
6. 资源server验证Token成功后，返回请求的资源；

整个流程，第三方应用server没有取得过用户名和密码。
