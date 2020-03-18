# 加密

## 编码/解码

shiro提供了Base64和16进制的字符串编码解码支持。
示例：
```java

String str = "hello";
String base64Encoded = Base64.encodeToString(str.getBytes());
String text = Base64.decodeToString(base64Encoded);
Assert.assertEquals(str, str2);

```

另外，CodecSupport类提供了bytes数组和String字符串之间的转换。toString(str,"utf-8)/toBytes(str, "utf-8")。

## 散列算法

散列算法(Hash Algorithm)用于生成数据的摘要信息，是一种不可逆算法。可以用于存储密码之类的数据，常见的算法有MD5、SHA等。  
为了更好地进行散列算法，我们需要提供一个盐值(salt)。如果直接对密码进行hash算法，那么便很容易通过散列值得到密码值。如果我们加入一些只有系统内部才知道的干扰数据(salt)，如用户名+ID，这样生成的散列值更难破解。  
示例：  
```java

String str = "hello";
String salt = "123";
String md5 = new Md5Hash(str, salt).toString();

```

## PasswordService/CredentialsMatcher

shiro提供了用于加密密码和验证密码的API：PasswordService/CredentialsMatcher  

shiro默认提供：PasswordService的实现DefaultPasswordService,CredentialsMatcher的实现PasswordMatcher和HashedCredentialsMatcher。

```java
//加密
public interface PasswordService {
	String encryptPassword(Object plaintextPassword) throws IllegalArgumentException;
}
```

```java
//验证
public interface CredentialsMatcher {
	String doCredentialsMatcher(AuthenticationToken token, AuthenticationInfo info);
}
```
**HashedCredentialsMatcher实现密码验证服务**  

Shiro 提供了CredentialsMatcher 的散列实现HashedCredentialsMatcher，和之前的PasswordMatcher不同的是，它只用于密码验证，且可以提供自己的盐，而不是随机生成盐，且生成密码散列值的算法需要自己写，因为能提供自己的盐。
