//
//  ViewController.m
//  GCDDemo
//
//  Created by liweiyou on 17/3/2.
//  Copyright © 2017年 yons. All rights reserved.
//

#import "ViewController.h"
#import "WYNetTool.h"

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
    
//    [self mainQueue];
//    [self performSelectorInBackground:@selector(test) withObject:nil];
    
    
    /** 队列的创建方法
     可以使用dispatch_queue_create来创建对象，一共有两个参数 第一个参数表示队列的唯一标识符，可为空，第二个参数标记是串行队列还是并发队列 串行队列是DISPATCH_QUEUE_SERIAL， 并发队列是DISPATCH_QUEUE_CONCURRENT
     
     */
    //1.创建串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("名字", DISPATCH_QUEUE_SERIAL);
    
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
    
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
//
    dispatch_async(queue, ^{
//        [self mainQueue];
//        [self mainQueueSync];
    });
    
    //主队列 + 异步执行
//    [self mainQueueAsync];
    
    //线程之间的通讯
    [self threadCommunication];
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

- (void)testGlobalQueue {
    NSLog(@"当前的线程是 --  %@", [NSThread currentThread]);
    /** 打印为
     <NSThread: 0x6180000775c0>{number = 3, name = (null)}
     */
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(globalQueue, ^{
        NSLog(@"异步函数 任务1 -- 线程为： %@", [NSThread currentThread]);
        /** 打印信息
         异步函数 任务1 -- 线程为： <NSThread: 0x618000077ac0>{number = 4, name = (null)}
         */
    });
    
    dispatch_sync(globalQueue, ^{
        NSLog(@"同步函数 任务2 -- 线程为： %@", [NSThread currentThread]);
        /** 打印的信息
         同步函数 任务2 -- 线程为： <NSThread: 0x6180000775c0>{number = 3, name = (null)}
         
         >>可以看到 同步函数并没有开启新的线程 是在当前线程里执行任务
         */
    });
    
    
}

@end
