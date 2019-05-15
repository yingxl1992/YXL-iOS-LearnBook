#### YYCache学习笔记

#####1、疑问点：

1. 为什么使用CFMutableDictionaryRef，而不是直接使用NSMutableDictionary？

https://github.com/ibireme/YYModel/issues/200

> 最主要的是 kCFTypeDictionaryKeyCallBacks 能避免 key 的 copy。
> 而 NSMutableDictionary 的 key 会强制进行 copy，性能会有些损耗。

2. 为什么使用__unsafe_unretained 修饰node？

https://blog.ibireme.com/2015/10/26/yycache/

> 在 ARC 条件下，默认声明的对象是 __strong 类型的，赋值时有可能会产生 retain/release 调用，如果一个变量在其生命周期内不会被释放，则使用 __unsafe_unretained 会节省很大的开销。
>
> 访问具有 __weak 属性的变量时，实际上会调用 objc_loadWeak() 和 objc_storeWeak() 来完成，这也会带来很大的开销，所以要避免使用 __weak 属性。
>
> 创建和使用对象时，要尽量避免对象进入 autoreleasepool，以避免额外的资源开销。

3. `removeObjectForKey`方法中用来释放node的`[node class]`是什么意思？

https://github.com/ibireme/YYCache/issues/4

> node 会被 block 捕获，随后会在 block 结束后，在对应的 queue 里得到释放。
> [node class]; 这条语句，只是为了让 node 捕获到 block 去，所以随便发了个消息以避免被编译器优化掉。

4. pthread_mutex_trylock 失败后执行usleep的用意？

https://www.jianshu.com/p/408d4d37bcbd

> 避免优先级反转
>
> `pthread_mutex_t`是互斥锁，它有一个特性：当多个线程出现数据竞争时，除了“竞争成功”的那个线程外，其他线程都会进入被动挂起状态，而当“竞争成功”的那个线程解锁时，会主动去将其他线程激活，这个过程包含了上下文的切换，cpu抢占，信号发送等开销，很明显，互斥锁的起始开销有些大，效率低于自旋锁。
>  所以作者使用了`pthread_mutex_trylock ()`尝试解锁，若解锁失败该方法会立即返回，让当前线程不会进入被动的挂起状态（也可以说阻塞），在下一次循环时又继续尝试获取锁。这个过程很有意思，感觉是手动实现了一个自旋锁。而自旋锁有个需要注意的问题是：死循环等待的时间越长，对 cpu 的消耗越大。所以作者做了一个很短的睡眠 `usleep(10 * 1000)`，有效的减小了循环的调用次数，至于这个睡眠时间的长度为什么是 10ms， 作者应该做了测试。

5. 为什么内存缓存使用pthread_mutex，而不是dispatch_semaphore，这两个作为锁的原理差不多呀？

> dispatch_semaphore vs. pthread_mutex
>
> 信号量的加锁、释放锁可以在不同线程；而锁的加解锁必须在同一个线程。dispatch_semaphore也不是严格意义上的锁，且不支持递归。

原因可能是pthread_mutex更具有锁的特性，支持递归，并且优化后，性能更接近于OSSpinLock。



##### 2、学习点总结

1. LRU算法的实现：双向链表的使用
2. 在指定线程释放对象，如上疑问点3

3. 数据库和文件存储读写效率：iPhone 6 64G 下，SQLite 写入性能比直接写文件要高，但读取性能取决于数据大小：当单条数据小于 20K 时，数据越小 SQLite 读取性能越高；单条数据大于 20K 时，直接写为文件速度会更快一些。（https://blog.ibireme.com/2015/10/26/yycache/）
4. 加锁的选择：内存缓存使用OSSpinLock，后替换为pthread_mutex；磁盘缓存忙等时间较长，选择dispatch_semaphore。



#####3、扩展知识点

1. 锁：https://bestswifter.com/ios-lock/

https://blog.ibireme.com/2015/10/26/yycache/

http://blog.chinaunix.net/uid-26885237-id-3207962.html



锁的类型：

**效率比较：OSSpinLock >  信号量 > pthread_mutex > NSLock > NSCondition > pthread_mutex(recursive) > NSRecursiveLock > NSConditionLock > @synchronized**

* 自旋锁 = OSSpinLock

自旋锁就是对临界区的资源进行加锁，保证只有一个线程可以访问。*但是由于操作系统是遵循时间片轮转算法的，如果当前线程的任务过长，超过被分配的时间片的话，会被系统强制抢占，从而导致线程处于忙等状态，白白浪费了CPU时间。*

>  时间片轮转算法：每个线程会被分配一段时间片，当时间片到期以后，就会被系统挂起，放入等待队列中，直到下一次被分配。

* 信号量

信号量和自旋锁的差别在于，若线程没有获得资源时，会调用系统调用，进入睡眠状态，并主动让出时间片。不会出现忙等，消耗CPU时间的情况。但是让出时间片会导致操作系统进行线程切换，一般需要10微秒，且需要切换两次，所以如果忙等时间较短，忙等会比线程睡眠更高效。

* 互斥锁 = pthread_mutex

http://blog.chinaunix.net/uid-26885237-id-3207962.html

类似于信号量，未获得资源时，会阻塞线程并睡眠，同时需要进行上下文切换。

实现可能是由信号量实现的，但是效率较低的原因是需要进行锁类型的比较。

* NSLock

封装了PTHREAD_MUTEX_ERRORCHECK 属性的pthread_mutex。

* NSCondition

* NSRecursiveLock

* NSConditionLock



2. 数据库（sqlite）


#####3、参考资料

源码分析：https://juejin.im/post/5a657a946fb9a01cb64ee761

https://wangdetong.github.io/2017/05/08/20170508%E8%81%8A%E4%B8%80%E8%81%8AYYCache/