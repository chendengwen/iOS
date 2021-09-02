//
//  myRedView.m
//  RAC
//


#import "myRedView.h"

@implementation myRedView
-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        self.backgroundColor = [UIColor redColor];
        UIButton *btn  =  [UIButton new];
        btn.frame = CGRectMake(0, 0, 40, 40);
        [btn setBackgroundColor:[UIColor greenColor]];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)btnClick{
    NSLog(@"点击了红色view中的按钮");
    // 通知控制器做事情
}
@end
