//
//  HMWheelView.m
//  11-转盘
//
//  Created by apple on 14-9-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMWheelView.h"

#import "HMWheelButton.h"

#define angle2radian(x) ((x) / 180.0 * M_PI)

@interface HMWheelView ()
@property (weak, nonatomic) IBOutlet UIImageView *rotationView;

@property (nonatomic, weak) UIButton *selectedButton;


@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation HMWheelView

+ (instancetype)wheelView
{
    return [[NSBundle mainBundle] loadNibNamed:@"HMWheelView" owner:nil options:nil][0];
}


// 还有没连号线
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        NSLog(@"initWithCoder----%@",_rotationView);
        
    }
    return self;
}

// 连好线
#warning 添加按钮
- (void)awakeFromNib
{
    
    _rotationView.userInteractionEnabled = YES;
    
    
    // 裁剪的大图片
    UIImage *bigImage = [UIImage imageNamed:@"LuckyAstrology"];
    UIImage *selectedImage = [UIImage imageNamed:@"LuckyAstrologyPressed"];
    
    // 图片的尺寸
    CGFloat imageW = 40 * [UIScreen mainScreen].scale;
    CGFloat imageH = 47 * [UIScreen mainScreen].scale;
    
    for (int i = 0; i < 12; i++) {
        // 创建按钮
        HMWheelButton *button = [HMWheelButton buttonWithType:UIButtonTypeCustom];
        
        
        // 锚点
        button.layer.anchorPoint = CGPointMake(0.5, 1);
        // 位置
        button.layer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        
        // 旋转按钮
        button.layer.transform = CATransform3DMakeRotation(angle2radian(i * 30), 0, 0, 1);
        
        // 尺寸
        button.bounds = CGRectMake(0, 0, 68, 143);
        
        
        // 设置选中时候的背景图片
        [button setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        
        // 设置按钮的图片
        // image:裁剪的图片
        // rect:裁剪的尺寸
       CGRect clipRect = CGRectMake(i * imageW, 0, imageW, imageH);
       CGImageRef smallImage = CGImageCreateWithImageInRect(bigImage.CGImage, clipRect);
        [button setImage:[UIImage imageWithCGImage:smallImage] forState:UIControlStateNormal];
        
        // 设置选中的图片
        CGImageRef selectedSmallImage = CGImageCreateWithImageInRect(selectedImage.CGImage, clipRect);
        [button setImage:[UIImage imageWithCGImage:selectedSmallImage] forState:UIControlStateSelected];
        
        // 监听点击事件
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        if (i == 0) {
            [self btnClick:button];
        }
        
        
        [_rotationView addSubview:button];
        
        
    }
}

#warning 监听按钮点击
- (void)btnClick:(UIButton *)button
{
    _selectedButton.selected = NO;
    button.selected = YES;
    _selectedButton = button;
}

#warning 开始旋转
- (void)startRotating
{
    self.link.paused = NO;

}

- (void)stopRotating
{
    _link.paused = YES;
}


- (CADisplayLink *)link
{

    if (_link == nil) {
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _link = link;
    }
    return _link;
}
// 60  45 / 60.0
- (void)update
{
    _rotationView.transform = CGAffineTransformRotate(_rotationView.transform, angle2radian(45 / 60.0));
}

- (IBAction)start:(id)sender {
    
    // 1.不要和用户交互
    _rotationView.userInteractionEnabled = NO;
    
    // 2.取消慢慢的旋转
    [self stopRotating];
    
    CABasicAnimation *anim = [CABasicAnimation animation];

    anim.keyPath = @"transform.rotation";

    anim.toValue = @(M_PI * 2 * 3);

    anim.duration = 0.5;
    
    anim.delegate = self;


    [_rotationView.layer addAnimation:anim forKey:nil];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _rotationView.userInteractionEnabled = YES;
    
    
    // 让选中按钮回到最在上面的中间位置:
    CGFloat angle = atan2(_selectedButton.transform.b, _selectedButton.transform.a);
    
    NSLog(@"%f",angle);
    
    // 把我们的转盘反向旋转这么多°
    _rotationView.transform = CGAffineTransformMakeRotation(-angle);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startRotating];
    });
}

@end
