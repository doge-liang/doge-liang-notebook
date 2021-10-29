## Java Stream API

### 创建流

- 有限流
 - 	`collectionInst.stream()`
 - `Stream.of(T...)`
 - `Stream.empty()`
 - `collectionInst.parallelStream()` 并行处理流中的元素；
- 无限流	
 - `Stream.generate(Supplier<T> s)` 返回调用 Supplier 函数产生流；
 - `Stream.iterate(T seek, UnaryOperator<T> f)` ；

- 其他创建流的方法
- `PatternInst.splitAsStream(CharSequence input)` 根据正则结果生成流；
- `Files.lines(Path path, Charset cs)` 按行读取文件产生流；

### 流转换

- `filter(Predicate<T> conditions)` 通过条件过滤流，并产生新流；
- `map(Function<? super T, ? extends R> mapper)` 对流中的每一个元素传入 mapper 函数中，将返回值生成新的流；
- `flatMap(Function<? super T, ? extends Stream<? extends R>> mapper)` 将多个流通过 mapper 汇总成一个流输出；

- 裁剪子流 
	- `streamInst.limit(n)` 抽取流的前 n 个元素组成新流；如果流提前结束则新流一起结束；
	- `streamInst.skip(n)` 跳过 n 个元素，产生新流；
	- `Stream.concat(stream1, stream2)` 连接 stream1 和 stream2 ，产生新流；

