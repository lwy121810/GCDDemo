//
//  ViewController.m
//  GCDDemo
//
//  Created by liweiyou on 17/3/2.
//  Copyright © 2017年 yons. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/**
 GCD好处具体如下：
 GCD可用于多核的并行运算
 GCD会自动利用更多的CPU内核（比如双核、四核）
 GCD会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
 程序员只需要告诉GCD想要执行什么任务，不需要编写任何线程管理代码
 
 */
/** 任务和队列的概念
 任务：就是执行操作的意思，就是在线程中执行的代码， GCD是放在block中的， 执行任务有两种方法: 1.异步执行 2.同步执行 两者的主要区别就是是否有开新线程的能力 
 队列：这里的队列指的是任务队列，就是存放任务的队列，队列是一种特殊的线性表，按照FIFO（先进先出）的原则，即新任务总是被插在队列的末尾，读取任务的时候总是从队列的头部开始读取， 每读取一个任务，就从队列中释放一个任务， GCD有两种队列 ： 1.串行队列 2.并发队列
 1. 并发队列 (Concurrent Dispatch Queue):可以让多个任务并发(同时)的执行(自动开启多个线程同时执行任务)
    1.1.并发功能只有在异步函数下才有效 因为在同步函数中并不会开启新的线程
 
 2. 串行队列(Serial Dispatch Queue):让任务一个接一个的执行（一个任务执行完毕后再执行下一个任务）
 */




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    /**
     
     |                  | 是否开启新线程     |	任务执行顺序|	任务执行时间|
     | 并发队列+ 同步执行  | 在当前线程执行任务	 | 顺序执行（执行完一个任务再执行下一个任务）|	马上执行|
     | 并发队列 + 异步执行 | 开启新线程执行任务	 | 交替执行	|所有任务都添加到队列之后才开始执行|
     | 串行队列+ 同步执行  |	在当前线程执行任务  |	顺序执行	|马上执行|
     | 串行队列 + 异步执行 |	开启新线程执行（只开启一个新线程）|	顺序执行	|所有任务添加到队列之后才开始执行|
     | 主队列+同步执行     |在主线程执行       |	顺序执行|	马上执行|
     
     | 主队列+异步执行     |在主线程执行       |	顺序执行|	所有任务添加之后再执行|
     
     主队列+同步执行（必须在其他线程调用，不能在主线程调用）
     */
    
    
    
    
    
    

//    [self mainQueue];
//    [self performSelectorInBackground:@selector(test) withObject:nil];
    
    
    /** 队列的创建方法
     可以使用dispatch_queue_create来创建对象，一共有两个参数 第一个参数表示队列的唯一标识符，可为空，第二个参数标记是串行队列还是并发队列 串行队列是DISPATCH_QUEUE_SERIAL， 并发队列是DISPATCH_QUEUE_CONCURRENT
     
     */
    //1.创建串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("唯一标识符", DISPATCH_QUEUE_SERIAL);
    
    //2.创建并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    //2.创建全局并发队列
    //2.1 第一个参数表示队列优先级 一般用DISPATCH_QUEUE_PRIORITY_DEFAULT， 第二个参数暂时没用 用0就行
//    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_async(globalQueue, ^{
//        NSLog(@"任务1 --  %@", [NSThread currentThread]);
//    });
//    
//    dispatch_async(globalQueue, ^{
//        NSLog(@"任务2 --  %@", [NSThread currentThread]);
//    });
//    dispatch_async(globalQueue, ^{
//        NSLog(@"任务3 --  %@", [NSThread currentThread]);
//    });
//    dispatch_async(globalQueue, ^{
//        NSLog(@"任务4 --  %@", [NSThread currentThread]);
//    });
    /**
     任务3 --  <NSThread: 0x6080000697c0>{number = 5, name = (null)}
     任务2 --  <NSThread: 0x608000068cc0>{number = 4, name = (null)}
     任务1 --  <NSThread: 0x61800006a940>{number = 3, name = (null)}
     任务4 --  <NSThread: 0x61800006ab80>{number = 6, name = (null)}
     */
    
    //并发队列 + 同步执行
//    [self concurrentSync];
//    
//    //并发队列 + 异步执行
//    [self concurrentAsync];
    
    //串行队列 + 同步执行
//    [self serialSync];
    
    //串行队列 + 异步执行
//    [self serialAsync];
    
    //主队列
//    [self mainQueue];
    
//    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
////
//    //异步执行任务
//    dispatch_async(queue, ^{
//        NSLog(@"%@", [NSThread currentThread]);//这里防止任务代码
//    });
//    //同步执行任务
//    dispatch_sync(queue, ^{
//        NSLog(@"%@", [NSThread currentThread]);//这里防止任务代码
//    });
    
    //主队列 + 异步执行
//    [self mainQueueAsync];
    
    //线程之间的通讯
//    [self threadCommunication];
    
    //栅栏
//    [self barrierAsync];
    
    
    //延时
//    [self dispatchAfter];
    
    //快速迭代
//    [self dispatchApply];
    
    //队列组
//    [self dispatchGroup];
    
    
//    [self globalQueue];
    
    [self groupEnterAndLeave];
}

#pragma mark - 并发队列 + 同步执行
//不会开启新线程 执行完一个任务 在执行下一个任务 任务添加到队列中之后马上执行
- (void)concurrentSync {
    //1.创建并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"concurrentSync begin ------------- %@", [NSThread currentThread]);
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"任务1 --  %@", [NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"任务2 --  %@", [NSThread currentThread]);
    });
    
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"任务3 --  %@", [NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"任务4 --  %@", [NSThread currentThread]);
    });
    NSLog(@"concurrentSync end ------------- %@", [NSThread currentThread]);
    
    /** 打印信息
     concurrentSync begin ------------- <NSThread: 0x618000260fc0>{number = 1, name = main}
     任务1 --  <NSThread: 0x618000260fc0>{number = 1, name = main}
     任务2 --  <NSThread: 0x618000260fc0>{number = 1, name = main}
     任务3 --  <NSThread: 0x618000260fc0>{number = 1, name = main}
     任务4 --  <NSThread: 0x618000260fc0>{number = 1, name = main}
     concurrentSync end ------------- <NSThread: 0x618000260fc0>{number = 1, name = main}
     
     >> 可以看出 并没有开启新的线程 所有的任务都是在主线程中执行的 由于只有一个线程 所以任务只能一个一个的执行 即并发队列只有在异步函数中有效
     >> 所有的任务都是在concurrentSync begin 和concurrentSync end之间，这说明任务添加到队列中之后马上执行
     */
}
#pragma mark - 并发队列 + 异步执行
//同时开启多线程 任务交替执行 所有的任务都添加到队列中之后才异步执行 任务是交替执行的
- (void)concurrentAsync {
    //创建并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"concurrentAsync begin ------- %@", [NSThread currentThread]);
    dispatch_async(concurrentQueue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"任务1.%d --  %@",i, [NSThread currentThread]);
        }
        NSLog(@"任务1 --  %@", [NSThread currentThread]);
    });
    
    dispatch_async(concurrentQueue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"任务2.%d --  %@",i, [NSThread currentThread]);
        }
        NSLog(@"任务2 --  %@", [NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"任务3.%d --  %@",i, [NSThread currentThread]);
        }
        NSLog(@"任务3 --  %@", [NSThread currentThread]);
    });
    
    NSLog(@"concurrentAsync end ------- %@", [NSThread currentThread]);
    
    /** 打印信息
     concurrentAsync begin ------- <NSThread: 0x600000072040>{number = 1, name = main}
     concurrentAsync end ------- <NSThread: 0x600000072040>{number = 1, name = main}
     任务1.0 --  <NSThread: 0x6100000768c0>{number = 3, name = (null)}
     任务3.0 --  <NSThread: 0x610000076900>{number = 5, name = (null)}
     任务2.0 --  <NSThread: 0x60000007e240>{number = 4, name = (null)}
     任务1.1 --  <NSThread: 0x6100000768c0>{number = 3, name = (null)}
     任务3.1 --  <NSThread: 0x610000076900>{number = 5, name = (null)}
     任务2.1 --  <NSThread: 0x60000007e240>{number = 4, name = (null)}
     任务1 --  <NSThread: 0x6100000768c0>{number = 3, name = (null)}
     任务3 --  <NSThread: 0x610000076900>{number = 5, name = (null)}
     任务2 --  <NSThread: 0x60000007e240>{number = 4, name = (null)}

     
     >> 可以看出 在并发队列 + 异步执行中，除了主线程，又开辟了3个新的线程 并且任务是交替执行的 即3个线程里的任务执行顺序是不一定的，但是在同一个线程里的任务的执行是顺序的
     >> 而且所有的任务都是在打印concurrentAsync begin 和concurrentAsync end之后才开始执行，说明任务不是马上执行，而是将所有任务添加到队列之后才开始异步执行
     */
}
#pragma mark - 串行队列 + 同步执行
//不会开启新线程 在当前线程执行任务 执行完一个任务再执行下一个任务 任务添加到队列中之后马上执行
- (void)serialSync {
    
    dispatch_queue_t serialQueue = dispatch_queue_create("名字", DISPATCH_QUEUE_SERIAL);
    NSLog(@"serialSync begin ------------- %@", [NSThread currentThread]);
    dispatch_sync(serialQueue, ^{
        NSLog(@"serialSync任务1 --  %@", [NSThread currentThread]);
    });
    
    dispatch_sync(serialQueue, ^{
        NSLog(@"serialSync任务2 --  %@", [NSThread currentThread]);
    });
    dispatch_sync(serialQueue, ^{
        NSLog(@"serialSync任务3 --  %@", [NSThread currentThread]);
    });
    dispatch_sync(serialQueue, ^{
        NSLog(@"serialSync任务4 --  %@", [NSThread currentThread]);
    });
    NSLog(@"serialSync end ------------- %@", [NSThread currentThread]);
    /** 打印信息
     serialSync begin ------------- <NSThread: 0x610000076980>{number = 1, name = main}
     serialSync任务1 --  <NSThread: 0x610000076980>{number = 1, name = main}
     serialSync任务2 --  <NSThread: 0x610000076980>{number = 1, name = main}
     serialSync任务3 --  <NSThread: 0x610000076980>{number = 1, name = main}
     serialSync任务4 --  <NSThread: 0x610000076980>{number = 1, name = main}
     serialSync end ------------- <NSThread: 0x610000076980>{number = 1, name = main}
     
     >> 可以看出 所有的任务都是在主线程中执行（当前线程就是主线程）并且由于是串行队列 所以任务是按照顺序一个一个执行的
     >> 另外 所有的任务都是在serialSync begin 和serialSync end 之间打印的 说明任务添加到队列中之后马上就执行了
     */
}

#pragma mark - 串行队列 + 异步执行
//会开启新的线程 但因为是串行队列 所以只会开启一条新的线程 执行完一个任务再执行下一个任务 所有的任务都添加到队列中之后才异步执行
- (void)serialAsync {
    
    dispatch_queue_t serialQueue = dispatch_queue_create("名字", DISPATCH_QUEUE_SERIAL);
    NSLog(@"begin ------------- %@", [NSThread currentThread]);
    dispatch_async(serialQueue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"任务1.%d --  %@", i,[NSThread currentThread]);
        }
        NSLog(@"任务1 --  %@", [NSThread currentThread]);
    });
    
    dispatch_async(serialQueue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"任务2.%d --  %@", i,[NSThread currentThread]);
        }
        NSLog(@"任务2 --  %@", [NSThread currentThread]);
        
    });
    dispatch_async(serialQueue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"任务3.%d --  %@", i,[NSThread currentThread]);
        }
        NSLog(@"任务3 --  %@", [NSThread currentThread]);
    });
    
    NSLog(@"end ------------- %@", [NSThread currentThread]);
    /** 打印信息
     begin ------------- <NSThread: 0x60800007e0c0>{number = 1, name = main}
     end ------------- <NSThread: 0x60800007e0c0>{number = 1, name = main}
     任务1.0 --  <NSThread: 0x61800007d140>{number = 3, name = (null)}
     任务1.1 --  <NSThread: 0x61800007d140>{number = 3, name = (null)}
     任务1 --  <NSThread: 0x61800007d140>{number = 3, name = (null)}
     任务2.0 --  <NSThread: 0x61800007d140>{number = 3, name = (null)}
     任务2.1 --  <NSThread: 0x61800007d140>{number = 3, name = (null)}
     任务2 --  <NSThread: 0x61800007d140>{number = 3, name = (null)}
     任务3.0 --  <NSThread: 0x61800007d140>{number = 3, name = (null)}
     任务3.1 --  <NSThread: 0x61800007d140>{number = 3, name = (null)}
     任务3 --  <NSThread: 0x61800007d140>{number = 3, name = (null)}
     
     >> 可以看出 异步执行串行队列的时候会开启新线程 但是只会开启一个线程 所有任务在同一个线程里串行执行任务 即任务的执行时有顺序的 执行完一个任务之后再执行下一个任务
     >> 所有的任务都是在打印begin -------------和end -------------之后才开始执行 说明任务不是马上执行  而是所有任务都添加到队列之后才开始执行
     */
}
#pragma mark - 主队列 
//主队列是一种特殊的串行队列 放在主队列中的任务都会在主线程执行
#pragma mark - 主队列 + 同步执行
/** 主队列+同步执行的形式不能在主线程中被调用 必须在其他线程调用 否则会崩溃*/
//在其他线程里调用 主队列 + 同步执行 可以看到 所有的任务都是在主线程执行的 并且由于主队列是串行队列 所以任务都是一个一个执行的 而且由于是同步执行 所有任务再加入到主队列之后就马上执行
- (void)mainQueueSync {
    //1.获取主队列的方式
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    NSLog(@"begin ------------- %@", [NSThread currentThread]);
    dispatch_sync(mainQueue, ^{
        NSLog(@"主队列中同步执行任务1 -- %@", [NSThread currentThread]);
    });
    dispatch_sync(mainQueue, ^{
        NSLog(@"主队列中同步执行任务2 -- %@", [NSThread currentThread]);
    });
    dispatch_sync(mainQueue, ^{
        NSLog(@"主队列中同步执行任务3 -- %@", [NSThread currentThread]);
    });
    NSLog(@"end ------------- %@", [NSThread currentThread]);
    
    /** 打印信息
     begin ------------- <NSThread: 0x60000006bd40>{number = 3, name = (null)}
     主队列中同步执行任务1 -- <NSThread: 0x610000064b80>{number = 1, name = main}
     主队列中同步执行任务2 -- <NSThread: 0x610000064b80>{number = 1, name = main}
     主队列中同步执行任务3 -- <NSThread: 0x610000064b80>{number = 1, name = main}
     end ------------- <NSThread: 0x60000006bd40>{number = 3, name = (null)}
     
     >> 在其他线程里调用 主队列 + 同步执行 可以看到 所有的任务都是在主线程执行的 并且由于主队列是串行队列 所以任务都是一个一个执行的 而且由于是同步执行 所以任务加入到主队列之后就马上执行
     */
    
    /**
     如果在主线程调用 主队列+同步执行 会崩溃 因为在执行这段代码的时候 我们把任务放在了主队列中 也就是主线程的队列中 而同步执行有个特点 就是对于任务是立马执行的，当我们把任务1 放到主队列中，任务1就会马上执行（在主线程中执行） 但是主线程正在处理- (void)mainQueueSync方法，所以任务1 需要等到- (void)mainQueueSync执行完毕之后才能执行 但是- (void)mainQueueSync方法执行完毕又需要执行任务2 任务3 但是任务1没有执行完毕又不能够再往下执行 所以任务就卡着了
     
     */
}
#pragma mark - 主队列 + 异步执行
- (void)mainQueueAsync {
    /**
     主队列：是和主线程相关联的队列，主队列是GCD自带的一种特殊的串行队列，放在主队列的任务都会在主线程中执行
     >.如果把任务放在主队列中， 无论是异步还是同步 都不会开启新的线程
     
     */
    //1.获取主队列的方式
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    NSLog(@"begin ------------- %@", [NSThread currentThread]);
    dispatch_async(mainQueue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"任务1.%d ------ %@", i, [NSThread currentThread]);
        }
        NSLog(@"任务1 --  %@", [NSThread currentThread]);
    });
    
    dispatch_async(mainQueue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"任务2.%d ------ %@", i, [NSThread currentThread]);
        }
        NSLog(@"任务2 --  %@", [NSThread currentThread]);
    });
    
    dispatch_async(mainQueue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"任务3.%d ------ %@", i, [NSThread currentThread]);
        }
        NSLog(@"任务3 --  %@", [NSThread currentThread]);
    });
    NSLog(@"end ------------- %@", [NSThread currentThread]);
    
    
    /** 打印信息
     begin ------------- <NSThread: 0x600000065880>{number = 1, name = main}
     end ------------- <NSThread: 0x600000065880>{number = 1, name = main}
     任务1.0 ------ <NSThread: 0x600000065880>{number = 1, name = main}
     任务1.1 ------ <NSThread: 0x600000065880>{number = 1, name = main}
     任务1 --  <NSThread: 0x600000065880>{number = 1, name = main}
     任务2.0 ------ <NSThread: 0x600000065880>{number = 1, name = main}
     任务2.1 ------ <NSThread: 0x600000065880>{number = 1, name = main}
     任务2 --  <NSThread: 0x600000065880>{number = 1, name = main}
     任务3.0 ------ <NSThread: 0x600000065880>{number = 1, name = main}
     任务3.1 ------ <NSThread: 0x600000065880>{number = 1, name = main}
     任务3 --  <NSThread: 0x600000065880>{number = 1, name = main}
     
     >> 可以看出 任务都是在主线程中执行的 并且由于主队列是串行队列 所以任务是顺序执行的 一个任务完成之后再执行下一个任务
     >> 由于是异步执行 所以是所有的任务都添加到主队列之后才开始执行任务
     */
}

#pragma mark - 线程之间的通讯
- (void)threadCommunication {
    /**
     iOS开发过程中，我们一般在主线程里边进行UI刷新，例如：点击、滚动、拖拽等事件。我们通常把一些耗时的操作放在其他线程，比如说图片下载、文件上传等耗时操作。而当我们有时候在其他线程完成了耗时操作时，需要回到主线程，那么就用到了线程之间的通讯
     */
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1.%d------%@",i,[NSThread currentThread]);
        }
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"2-------%@",[NSThread currentThread]);
        });
    });
    /** 执行结果
     1.0------<NSThread: 0x608000069840>{number = 3, name = (null)}
     1.1------<NSThread: 0x608000069840>{number = 3, name = (null)}
     2-------<NSThread: 0x600000066900>{number = 1, name = main}
     
     >> 可以看到在其他线程中先执行操作，执行完了之后回到主线程执行主线程的相应操作
     */
    
}
#pragma mark - 栅栏
/**
 当我们异步执行多组操作的时候，有的时候会需要当第一组的操作执行完毕之后再执行第二组异步操作，这时候我们就需要一个相当于栅栏一样的方法将这几组操作分割开来，这里的操作组可以分为一个或者多个任务
 使用dispatch_barrier_async函数形成栅栏
 */
- (void)barrierAsync {
    dispatch_queue_t queue = dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"1---------- %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2---------- %@",[NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier ---------- %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"3---------- %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"4---------- %@",[NSThread currentThread]);
    });
    
    /**
     2---------- <NSThread: 0x600000071880>{number = 3, name = (null)}
     1---------- <NSThread: 0x61800006e0c0>{number = 4, name = (null)}
     barrier ---------- <NSThread: 0x61800006e0c0>{number = 4, name = (null)}
     3---------- <NSThread: 0x61800006e0c0>{number = 4, name = (null)}
     4---------- <NSThread: 0x600000071880>{number = 3, name = (null)}
     
     >> 可以看出 总是在执行完栅栏前面的操作之后才开始执行栅栏的操作，然后在执行栅栏之后的操作
     */
}
#pragma mark - GCD延时
- (void)dispatchAfter {
    NSLog(@"bengin ---------- %@",[NSThread currentThread]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"1 ---------- %@",[NSThread currentThread]);
    });
    
    NSLog(@"end ---------- %@",[NSThread currentThread]);
    
    /** 输出信息
     
     2017-03-03 13:16:37.316 GCDDemo[1037:77501] bengin ---------- <NSThread: 0x610000076600>{number = 1, name = main}
     2017-03-03 13:16:37.316 GCDDemo[1037:77501] end ---------- <NSThread: 0x610000076600>{number = 1, name = main}
     2017-03-03 13:16:42.316 GCDDemo[1037:77501] 1 ---------- <NSThread: 0x610000076600>{number = 1, name = main}
     
     */
}
#pragma mark - 快速迭代
/**
 通常我们会用for循环遍历，但是GCD给我们提供了快速迭代的方法dispatch_apply，使我们可以同时遍历。比如说遍历0~5这6个数字，for循环的做法是每次取出一个元素，逐个遍历。dispatch_apply可以同时遍历多个数字。
 */
- (void)dispatchApply {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (int i = 0; i < 5; i++) {
        NSLog(@" for循环 %d------%@",i, [NSThread currentThread]);
    }
    
    dispatch_apply(5, queue, ^(size_t index) {
        NSLog(@"Apply -- %zd------%@",index, [NSThread currentThread]);
    });
    
    /**
     
     2017-03-03 13:25:03.836 GCDDemo[1113:82201] Apply -- 1------<NSThread: 0x618000077400>{number = 3, name = (null)}
     2017-03-03 13:25:03.836 GCDDemo[1113:82148] Apply -- 0------<NSThread: 0x600000073d80>{number = 1, name = main}
     2017-03-03 13:25:03.836 GCDDemo[1113:82209] Apply -- 2------<NSThread: 0x60000007bf80>{number = 4, name = (null)}
     2017-03-03 13:25:03.836 GCDDemo[1113:82200] Apply -- 3------<NSThread: 0x6180000781c0>{number = 5, name = (null)}
     2017-03-03 13:25:03.836 GCDDemo[1113:82148] Apply -- 5------<NSThread: 0x600000073d80>{number = 1, name = main}
     2017-03-03 13:25:03.836 GCDDemo[1113:82201] Apply -- 4------<NSThread: 0x618000077400>{number = 3, name = (null)}
     2017-03-03 13:25:03.836 GCDDemo[1113:82148]  for循环 0------<NSThread: 0x600000073d80>{number = 1, name = main}
     2017-03-03 13:25:03.836 GCDDemo[1113:82148]  for循环 1------<NSThread: 0x600000073d80>{number = 1, name = main}
     2017-03-03 13:25:03.836 GCDDemo[1113:82148]  for循环 2------<NSThread: 0x600000073d80>{number = 1, name = main}
     2017-03-03 13:25:03.836 GCDDemo[1113:82148]  for循环 3------<NSThread: 0x600000073d80>{number = 1, name = main}
     2017-03-03 13:25:03.836 GCDDemo[1113:82148]  for循环 4------<NSThread: 0x600000073d80>{number = 1, name = main}
     2017-03-03 13:25:03.837 GCDDemo[1113:82148]  for循环 5------<NSThread: 0x600000073d80>{number = 1, name = main}

     
     >> 从输出结果中前边的时间中可以看出，apply几乎是同时遍历的,for循环的话要比apply稍慢一些，如果循环次数再大一些的话会更明显， for循环是在当前线程顺序的执行，而apply会开启新的线程同时执行，所以for循环是有顺序的，apply是没有顺序的
     */
   
}

#pragma mark - 队列组
/**
 有的时候我们需要分别执行多个异步操作，等所有的异步操作都执行完毕之后再回到主线程执行操作，这时候我们可以使用队列组
 
 1.先把任务放到队列中，然后把队列放到队列组中
 2.然后调用dispatch_group_notify 进行回到主线程操作
 
 */
- (void)dispatchGroup {
    // 1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 2.获得全局队列
    // 第一个参数是设置队列的优先级，这里设置为default，第二个参数暂时没用到，可以先写作0
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_enter(group);
    
    NSLog(@" begin -----------  %@", [NSThread currentThread]);
    dispatch_group_async(group, queue, ^{
        NSLog(@" 1 -----------  %@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@" 2 -----------  %@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@" 3 -----------  %@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@" 4 -----------  %@", [NSThread currentThread]);
    });
    //c
    dispatch_group_notify(group, queue, ^{
        NSLog(@" 最后的任务 -----------  %@", [NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{//回到主线程
            NSLog(@"回到主线程进行操作 --- %@", [NSThread currentThread]);
        });
    });
    
    NSLog(@" end  -----------  %@", [NSThread currentThread]);
    
    /** 打印信息为
     begin -----------  <NSThread: 0x618000068ac0>{number = 1, name = main}
     end  -----------  <NSThread: 0x618000068ac0>{number = 1, name = main}
     1 -----------  <NSThread: 0x60000006d5c0>{number = 3, name = (null)}
     2 -----------  <NSThread: 0x61800006f5c0>{number = 4, name = (null)}
     4 -----------  <NSThread: 0x60000006d580>{number = 6, name = (null)}
     3 -----------  <NSThread: 0x61000006d080>{number = 5, name = (null)}
     最后的任务 -----------  <NSThread: 0x61000006d080>{number = 5, name = (null)}
     回到主线程进行操作 --- <NSThread: 0x618000068ac0>{number = 1, name = main}
     
     >>.可以看到前面的四个任务的执行时没有顺序的， 但总是在四个任务执行之后才会执行dispatch_group_notify的代码
     */
}

- (void)groupEnterAndLeave {
    /**
     dispatch_enter的作用：创建好任务组后，执行加入任务组的操作代码。dispatch_enter和dispatch_leave要成对出现，否则奔溃。
     
     */
    // 1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 2.获得全局队列
    // 第一个参数是设置队列的优先级，这里设置为default，第二个参数暂时没用到，可以先写作0
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@" begin -----------  %@", [NSThread currentThread]);
    //进入组
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"任务  1 -----------  %@", [NSThread currentThread]);
        //离开组
        dispatch_group_leave(group);
    });
    
    //进入组
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"任务  2 -----------  %@", [NSThread currentThread]);
        //离开组
        dispatch_group_leave(group);
    });
    //进入组
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"任务  3 -----------  %@", [NSThread currentThread]);
        //离开组
        dispatch_group_leave(group);
    });
    
    /* 因为队列queue里所有的任务执行完毕之后才会执行`dispatch_group_notify`里的代码块 所以即使dispatch_group_notify放在任务 4 前面，也是先执行任务 4的代码 在执行这里的代码 不过为了好看，还是把dispatch_group_notify放在任务 4 后面
    dispatch_group_notify(group, queue, ^{
        NSLog(@" 最后的任务 -----------  %@", [NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{//回到主线程
            NSLog(@"回到主线程进行操作 --- %@", [NSThread currentThread]);
        });
    });
    */
    //进入组
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"任务  4 -----------  %@", [NSThread currentThread]);
        //离开组
        dispatch_group_leave(group);
    });
    
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@" 最后的任务 -----------  %@", [NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{//回到主线程
            NSLog(@"回到主线程进行操作 --- %@", [NSThread currentThread]);
        });
    });
    
    
    NSLog(@" end  -----------  %@", [NSThread currentThread]);
    
    /**
     begin -----------  <NSThread: 0x618000077b00>{number = 1, name = main}
     end  -----------  <NSThread: 0x618000077b00>{number = 1, name = main}
     任务  1 -----------  <NSThread: 0x61800007fbc0>{number = 3, name = (null)}
     任务  2 -----------  <NSThread: 0x600000076540>{number = 4, name = (null)}
     任务  3 -----------  <NSThread: 0x608000077fc0>{number = 5, name = (null)}
     任务  4 -----------  <NSThread: 0x61800007fb80>{number = 6, name = (null)}
     最后的任务 -----------  <NSThread: 0x61800007fb80>{number = 6, name = (null)}
     回到主线程进行操作 --- <NSThread: 0x618000077b00>{number = 1, name = main}
     */
    
}

#pragma mark -全局队列
//GCD默认已经提供了全局的并发队列供整个应用使用，所以可以不用手动创建。
- (void)globalQueue {
    NSLog(@"begin --  %@", [NSThread currentThread]);
    //
    /**
     dispatch_get_global_queue需要两个参数(long identifier, unsigned long flags)
     long identifier可以理解为队列任务的优先级
     unsigned long flags：苹果官方文档是这样解释的： Flags that are reserved for future use。标记是为了未来使用保留的！所以这个参数应该永远指定为0
     */
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        NSLog(@"异步函数 任务1 -- %@", [NSThread currentThread]);
    });
    
    dispatch_async(globalQueue, ^{
        NSLog(@"异步函数 任务2 --  %@", [NSThread currentThread]);
    });
    dispatch_async(globalQueue, ^{
        NSLog(@"异步函数 任务3 --  %@", [NSThread currentThread]);
    });
    dispatch_async(globalQueue, ^{
        NSLog(@"异步函数 任务4 --  %@", [NSThread currentThread]);
    });
    
    NSLog(@"end --  %@", [NSThread currentThread]);
    
    /**
     2017-03-03 14:47:31.840 GCDDemo[1408:120406] begin --  <NSThread: 0x61800007cd00>{number = 1, name = main}
     2017-03-03 14:47:31.840 GCDDemo[1408:120406] end --  <NSThread: 0x61800007cd00>{number = 1, name = main}
     2017-03-03 14:47:31.841 GCDDemo[1408:120450] 异步函数 任务2 --  <NSThread: 0x61000007ffc0>{number = 4, name = (null)}
     2017-03-03 14:47:31.841 GCDDemo[1408:120457] 异步函数 任务3 --  <NSThread: 0x610000260080>{number = 5, name = (null)}
     2017-03-03 14:47:31.841 GCDDemo[1408:120468] 异步函数 任务4 --  <NSThread: 0x6180002666c0>{number = 6, name = (null)}
     2017-03-03 14:47:31.841 GCDDemo[1408:120458] 异步函数 任务1 -- <NSThread: 0x618000266a00>{number = 3, name = (null)}

     * 由于是异步执行，所以开启了新的线程，且是把所有的任务都添加到队列中之后才开始执行
     * 任务执行是没有顺序的，可以看出全局队列也是并发队列，（串行队列的任务无论是异步执行还是同步执行都是有顺序的）
     */
}

@end
