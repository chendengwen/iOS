//
//  ViewController.m
//  Lock-锁
//
//  Created by 陈登文 on 2021/8/26.
//

#import "ViewController.h"

@interface ViewController ()

@property(assign) int tickets;
@property(copy) NSString* name;

@property (strong, nonatomic) NSObject *myNonatomic;
@property (strong,    atomic) NSObject *myAtomic;

@end

@implementation ViewController
@synthesize myAtomic = _myAtomic;

- (void)setMyAtomic:(NSObject *)myAtomic{
      _myAtomic = myAtomic;
}
- (NSObject *)myAtomic{
    return _myAtomic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSRunLoop currentRunLoop]
    /*
     synchronized 和 NSLock 都是互斥锁
     如果其他线程正在执行锁定的代码，此线程就会进入休眠状态，等待锁打开,然后被唤醒继续执行。
     */
//    [self lock_synchronized];
//    [self lock_NSLock];
    
    /*
     
     */
//    [self lock_NSConditionLock];
    
    /*
     NSRecursiveLock 递归锁
     此锁可以在同一线程中多次被使用，但要保证加锁与解锁使用平衡，多用于递归函数，防止死锁
     */
    [self lock_NSRecursiveLock];
    
    /*
     线程安全之原子属性 atomic
     苹果系统在我们声明对象属性时默认是atomic，也就是说在读写这个属性的时候，保证同一时间内只有一个线程能够执行。
     实际上原子属性内部有一个锁，叫做“自旋锁”。自旋锁：如果线程被锁在外面，哥么就会用死循环的方式一直等待锁打开
     
     当属性声明时用的是 atomic，通常会生成 _成员变量，如果同时重写了getter&setter，_成员变量就不自动生成。
     就必须声明一个 _静态变量，否则系统在编译的时候找不到 _成员变量。
     */
}

-(void)lock_NSRecursiveLock{
    
}

-(void)lock_NSConditionLock{
    NSConditionLock* myCondition=[[NSConditionLock alloc]init];
    [[NSThread alloc] initWithTarget:nil selector:nil object:nil];
    [NSThread detachNewThreadWithBlock:^{
        for(int i=0;i<5;i++)
        {
            [myCondition lock]; //加锁（YES）
            sleep(1);
            
            //解锁并重置解锁条件
            [myCondition unlockWithCondition:i]; //解锁（YES）
            NSLog(@"解锁条件 after-set：%d",i);
            
            BOOL isLocked=[myCondition tryLockWhenCondition:2]; //根据条件加锁（i == 2，YES）
            if(isLocked)
            {
                NSLog(@"加锁成功！！！！！");
                [myCondition unlock];
            }
        }
    }];
}

/**
 不加锁之前，两个线程输出一样 hello；加锁之后，输出分辨为 hello 与 world
 分析：
    2个线程分别都先读取了字符串，再进行修改是修改的原始值，线程已读取的临时变量都是 “hello”
 */
-(void)lock_NSLock{
    NSLock *myLock=[[NSLock alloc]init];
    _name = @"hello";
    
    [NSThread detachNewThreadWithBlock:^{
        [myLock lock];
        NSLog(@"%@",self->_name);
        self->_name = @"world";
        [myLock unlock];
        NSLog(@"thread == %@", [NSThread currentThread]);
    }];
    [NSThread detachNewThreadWithBlock:^{
        [myLock lock];
        NSLog(@"%@",self->_name);
        self->_name = @"变化了";
        [myLock unlock];
        NSLog(@"thread == %@", [NSThread currentThread]);
    }];
}

-(void)lock_synchronized{
    self.tickets = 20;
    NSThread *t1 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTickets) object:nil];
    t1.name = @"售票员A";
    [t1 start];
    
    NSThread *t2 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTickets) object:nil];
    t2.name = @"售票员B";
    [t2 start];
}

- (void)saleTickets{
    while (YES) {
        [NSThread sleepForTimeInterval:1.0];
        //互斥锁 -- 保证锁内的代码在同一时间内只有一个线程在执行
        @synchronized (self){
            //1.判断是否有票
            if (self.tickets > 0) {
                //2.如果有就卖一张
                self.tickets --;
                NSLog(@"还剩%d张票  %@",self.tickets,[NSThread currentThread]);
            }else{
                //3.没有票了提示
                NSLog(@"卖完了 %@",[NSThread currentThread]);
                break;
            }
        }
    }

}



@end
