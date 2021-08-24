//
//  HelpViewController.m
//  FuncGroup
//
//  Created by gary on 2017/3/1.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "HelpViewController.h"
#import "RunLoop.h"

@interface HelpViewController ()<UIScrollViewDelegate>
{
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
// 图片名称数组
@property (nonatomic,strong) NSArray *imageArray;

// 任务数组
@property (nonatomic,strong) NSMutableArray *taskArray;
// timer
@property (nonatomic,strong) NSTimer *timer;
// 最大任务数
@property (nonatomic,assign) NSUInteger maxQueueLength;

@end

@implementation HelpViewController

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

-(void)timerMethod{}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self layoutNaviBarViewWithTitle:@"帮助"];
    
    _taskArray = [NSMutableArray array];
    _maxQueueLength = 8;
    
    // 启动当前runloop 默认是默认模式
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    
    [self getImageNameArray];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_imageArray.count, 0);
    
    [self layoutImages];
    AddRunLoopObserver((__bridge void *)self);
}

-(void)getImageNameArray{
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:8];
    for (int i = 0; i< 8; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"guid_%d",i+1];
        [imageArray addObject:imageName];
    }
    
    _imageArray = [NSArray arrayWithArray:imageArray];
}

-(void)layoutImages{
    
    
    kWeakSelf(self)
    for (int index = 0; index < _imageArray.count; index ++) {
        // 添加任务
        if ([_scrollView viewWithTag:1200 + index] || index >= _imageArray.count)  continue;
        [self addTask:^BOOL{
            [HelpViewController addImageWith:weakself.imageArray[index] atIndex:index toView:weakself.scrollView];
            return YES;
        }];
    }
}

+(void)addImageWith:(NSString *)imgName atIndex:(int)index toView:(UIView *)view{
    float spaceX = 15.0, width = SCREEN_WIDTH - spaceX*2;
    
    UIImage *image = [Resource imageWithImageName:imgName type:@"jpg"];
    CGSize size = image.size;  // 1210, 740
    float height = width*size.height/size.width;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(spaceX + SCREEN_WIDTH*index, (SCREEN_HEIGHT-height - NavHeight)/2, width, height)];
    imgView.image = image;
    imgView.tag = 1200 + index;
    
    [view addSubview:imgView];
}

#pragma mark ===
-(void)addTask:(RunLoopBlock)unit{
    
    // 添加任务到任务数组
    [self.taskArray addObject:unit];
    
    // 保证只会渲染到主屏幕
    if (self.taskArray.count > self.maxQueueLength) {
        [self.taskArray removeObjectAtIndex:0];
    }
}

#pragma mark === 实现的RunLoop里的方法
void CallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    // 往任务数组里添加任务
    HelpViewController *ctl = (__bridge HelpViewController *)info;
    if (ctl.taskArray.count == 0) {
        return;
    }
    
    BOOL result = NO;
    while (result == NO && ctl.taskArray.count) {
        // 取出任务
        RunLoopBlock unit = ctl.taskArray.firstObject;
        // 执行任务
        result = unit();
        // 执行完去除任务
        [ctl.taskArray removeObjectAtIndex:0];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
