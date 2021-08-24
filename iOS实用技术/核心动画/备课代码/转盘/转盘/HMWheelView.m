//
//  HMWheelView.m
//  转盘
//
//  Created by yz on 14-9-4.
//  Copyright (c) 2014年 iThinker. All rights reserved.
//

#import "HMWheelView.h"

#import "HMWheelButton.h"

#define angle2radian(x) ((x) / 180.0 * M_PI)

@interface HMWheelView()

@property (weak, nonatomic) IBOutlet UIImageView *centerView;

@property (nonatomic, weak) UIButton *selectedBtn;

@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation HMWheelView

- (IBAction)start:(id)sender {
    
    // 1.不需要于用户交互
    // 2.快速旋转过程中，应该把转盘停止旋转，两个一起旋转有问题
    
    _centerView.userInteractionEnabled = NO;
    [self stopRotation];
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    anim.keyPath = @"transform.rotation";
    anim.toValue = @(M_PI * 2 * 3);
    anim.duration = 0.5;
    anim.delegate = self;
    [_centerView.layer addAnimation:anim forKey:nil];
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // 允许用户交互
    _centerView.userInteractionEnabled = YES;
    // 让选中按钮回到最上面中间的位置
    CGFloat angle = atan2(_selectedBtn.transform.b, _selectedBtn.transform.a);
    
    _centerView.transform = CGAffineTransformMakeRotation(-angle);
    // 旋转转盘
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startRotation];
    });
}

+ (instancetype)wheelView
{
    return [[NSBundle mainBundle] loadNibNamed:@"HMWheelView" owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    // 允许交互
    _centerView.userInteractionEnabled = YES;
    
    // 加载大图片
    UIImage *bigImage = [UIImage imageNamed:@"LuckyAstrology"];
    UIImage *selectedBigImage = [UIImage imageNamed:@"LuckyAstrologyPressed"];
    
    
    CGFloat smallW = bigImage.size.width / 12 * [UIScreen mainScreen].scale;
    CGFloat smallH = bigImage.size.height * [UIScreen mainScreen].scale;
    
    for (int i = 0; i < 12; i++) {
        
        // 1.创建按钮
        HMWheelButton *button = [HMWheelButton buttonWithType:UIButtonTypeCustom];
        
        // 2.设置锚点
        button.layer.anchorPoint = CGPointMake(0.5, 1);
        
        // 3.设置位置
        button.layer.position = CGPointMake(_centerView.bounds.size.width * 0.5, _centerView.bounds.size.height * 0.5);
        
        // 4.设置尺寸
        button.bounds = CGRectMake(0, 0, 68, 143);
        
        // 5.旋转按钮
        button.transform = CGAffineTransformMakeRotation(angle2radian(i * 30));
        
        // 6.设置按钮选中图片
        [button setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        
        // 7.添加监听器
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 裁剪图片
        CGImageRef smallImage = CGImageCreateWithImageInRect(bigImage.CGImage, CGRectMake(i * smallW, 0, smallW, smallH));
        // 裁剪高亮图片
        CGImageRef selectedSmallImage = CGImageCreateWithImageInRect(selectedBigImage.CGImage, CGRectMake(i * smallW, 0, smallW, smallH));
        
        // 8.设置image图片
        [button setImage:[UIImage imageWithCGImage:smallImage] forState:UIControlStateNormal];
        
        // 9.设置高亮image图片
        [button setImage:[UIImage imageWithCGImage:selectedSmallImage] forState:UIControlStateSelected];
        
        [_centerView addSubview:button];
        
        // 默认选中第一个
        if (i == 0) {
            [self btnClick:button];
        }
    }
}

- (void)btnClick:(UIButton *)button
{
    _selectedBtn.selected = NO;
    button.selected = YES;
    _selectedBtn = button;
}

- (CADisplayLink *)link
{
    if (_link == nil) {
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotation)];
        
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
        _link = link;

    }
    return _link;
}

- (void)startRotation
{
    self.link.paused = NO;
}

- (void)stopRotation
{
    _link.paused = YES;
}

// 每秒调用60次,一秒转45°，每次转45 / 60
- (void)rotation
{
    _centerView.transform = CGAffineTransformRotate(_centerView.transform, angle2radian(45 / 60.0));
}

@end
