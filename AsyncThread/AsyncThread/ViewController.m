//
//  ViewController.m
//  AsyncThread
//
//  Created by JianRongCao on 15/12/2.
//  Copyright © 2015年 JianRongCao. All rights reserved.
//

#import "ViewController.h"
#import "HorizontalViewController.h"

@interface ViewController ()
{
    NSMutableArray *smart;
    int i;
}
@end

@implementation ViewController

- (BOOL)isValidString:(id)object
{
    return object && [object isKindOfClass:[NSString class]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:0.18 green:0.71 blue:0.92 alpha:1];
    
    NSString *array = @"";
    if ([self isValidString:array] && [array length] > 0) {
        NSLog(@"1111");
        return;
    }
    
//    dispatch_barrier_async 作用是在并行队列中，等待前面两个操作并行操作完成，这里是并行
//    dispatch_barrier_async中的操作，(现在就只会执行这一个操作)执行完成后，即输出
//    最后该并行队列恢复原有执行状态，继续并行执行
//    2015-12-03 09:59:51.237 AsyncThread[2977:58570] queue2
//    2015-12-03 09:59:51.237 AsyncThread[2977:58571] 1
//    2015-12-03 09:59:53.241 AsyncThread[2977:58571] 2
//    2015-12-03 09:59:53.241 AsyncThread[2977:58570] queue2 - 1
//    2015-12-03 09:59:55.242 AsyncThread[2977:58570] queue2 - 2
//    2015-12-03 09:59:55.242 AsyncThread[2977:58571] 3
//    2015-12-03 09:59:57.243 AsyncThread[2977:58571] 4
//    由结果可以看到，dispatch_barrier_async 线程内部是逐一执行的，而线程之间是异步执行的
//    而dispatch_barrier_sync 是所有的线程同一同步执行
//    dispatch_queue_t queue1 = dispatch_queue_create("com.suning.smart", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t queue2 = dispatch_queue_create("com.suning.smart", DISPATCH_QUEUE_SERIAL);
//    dispatch_barrier_async(queue1, ^{
//        sleep(2);
//        NSLog(@"1");
//    });
//    
//    dispatch_barrier_async(queue1, ^{
//        sleep(2);
//        NSLog(@"2");
//    });
//    
//    dispatch_barrier_async(queue1, ^{
//        sleep(2);
//        NSLog(@"3");
//    });
//    
//    dispatch_barrier_async(queue1, ^{
//        sleep(2);
//        NSLog(@"4");
//    });
//    
//    dispatch_barrier_async(queue2, ^{
//        sleep(2);
//        NSLog(@"queue2");
//    });
//    
//    dispatch_barrier_async(queue2, ^{
//        sleep(2);
//        NSLog(@"queue2 - 1");
//    });
//    
//    dispatch_barrier_async(queue2, ^{
//        sleep(2);
//        NSLog(@"queue2 - 2");
//    });
    
    
    
    
//    GCD  dispatch_apply, 作用是把指定次数指定的block添加到queue中, 第一个参数是迭代次数，第二个是所在的队列，第三个是当前索引，
//    dispatch_apply可以利用多核的优势，所以输出的index顺序不是一定的
//    dispatch_apply 和 dispatch_apply_f 是 '同步'函数,会'阻塞'当前线程直到所有循环迭代执行完成。 *****  重要。
//    当提交到并发queue时,循环迭代的执行顺序是不确定的
//    dispatch_apply(5, queue1, ^(size_t index) {
//        NSLog(@"apply %zu",index);
//    });
//    NSLog(@"apply done");
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"%@",NSStringFromCGPoint([touch locationInView:self.view]));
    
    HorizontalViewController *hori = [[HorizontalViewController alloc] init];
    hori.title = @"很胖";
    [self.navigationController pushViewController:hori animated:YES];
    
}

- (IBAction)queryMainThread:(UIButton *)sender
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_queue_create("com.suning.sepahore", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_t queue = dispatch_queue_create("com.suning.sepahore", DISPATCH_QUEUE_SERIAL);

    dispatch_async(queue, ^{
        NSLog(@"car 1 here");
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        int sum = 0;
        for (int idx = 0; idx < 50; idx++) {
            sum += idx;
            NSLog(@"sum1 -- > %d",idx);
        }
        dispatch_semaphore_signal(semaphore);
        NSLog(@"car 1 go");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"car 2 here");
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        int sum = 0;
        for (int idx = 0; idx < 50; idx++) {
            sum += idx;
            NSLog(@"sum2 -- > %d",idx);
        }
        dispatch_semaphore_signal(semaphore);
        NSLog(@"car 2 go");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"car 3 here");
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        int sum = 0;
        for (int idx = 0; idx < 50; idx++) {
            sum += idx;
            NSLog(@"sum3 -- > %d",idx);
        }
        dispatch_semaphore_signal(semaphore);
        NSLog(@"car 3 go");
    });

//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    for (int idx = 0; idx < 50; idx++) {
        NSLog(@"sum4 idx = %d",idx);
    }
    
    
    
    
    
    
//    dispatch_queue_t queue1 = dispatch_queue_create("com.suning.smart", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t queue2 = dispatch_queue_create("com.suning.smart", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t queue3 = dispatch_queue_create("com.suning.smart", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t queue4 = dispatch_queue_create("com.suning.smart", DISPATCH_QUEUE_SERIAL);
    
//    dispatch_barrier_async(queue1, ^{
//        NSLog(@"1");
//        sleep(2);
//    });
//    
//    dispatch_barrier_sync(queue2, ^{
//        NSLog(@"2");
//        sleep(2);
//    });
//    
//    dispatch_barrier_async(queue1, ^{
//        NSLog(@"5");
//        sleep(2);
//    });
//    
//    dispatch_barrier_sync(queue3, ^{
//        NSLog(@"3");
//        sleep(2);
//    });
//    
//    dispatch_barrier_sync(queue4, ^{
//        NSLog(@"4");
//        sleep(2);
//    });
    


    
//    dispatch_group_t 的使用。
//    dispatch_group_enter(<#dispatch_group_t group#>)
//    dispatch_group_leave(<#dispatch_group_t group#>) 成对出现。   进入组开始执行和离开组
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_async(group, queue1, ^{
//        NSLog(@"queue1");
//    });
//    
//    dispatch_group_async(group, queue2, ^{
//        NSLog(@"queue2");
//    });
//    
//    dispatch_group_async(group, queue3, ^{
//        NSLog(@"queue3");
//    });
//    
//    dispatch_group_async(group, queue4, ^{
//        NSLog(@"queue4");
//    });
//    
//    dispatch_queue_t main = dispatch_queue_create("com.suning.main", DISPATCH_QUEUE_SERIAL);
//    group里面所有的线程执行完成之后可以获取完成回调 dispatch_group_notify
//    dispatch_group_notify(group, main, ^{
//        NSLog(@"group finished");
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
