# List

List<?> 转换成 ?[]

``` JAVA
int[] array = list.stream().mapToInt(i -> i).toArray();
```

注意 `list.toArray()` 返回的是 `Object[]` 或者 `T[]`
