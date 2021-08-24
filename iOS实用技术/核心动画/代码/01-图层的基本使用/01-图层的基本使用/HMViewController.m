//
//  HMViewController.m
//  01-图层的基本使用
//
//  Created by apple on 14-9-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMViewController.h"

@interface HMViewController ()
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:1 animations:^{
        
        // 缩放
//        _imageView.layer.transform = CATransform3DMakeRotation(M_PI, 1, 1, 0);
        // 平移
//        _imageView.layer.transform = CATransform3DMakeTranslation(200, 200, 0);
        
        // 缩放
//        _imageView.layer.transform = CATransform3DMakeScale(1, 0.5, 1);
        
    // 利用KVC改变形变
        
//     NSValue *rotation = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, 1, 0)];
        
//        [_imageView.layer setValue:rotation forKeyPath:@"transform"];
        
//        [_imageView.layer setValue:@M_PI forKeyPath:@"transform.rotation"];
        
//        [_imageView.layer setValue:@0.5 forKeyPath:@"transform.scale"];
        
        // 平移x轴
        [_imageView.layer setValue:@200 forKeyPath:@"transform.translation.x"];
        
        
    }];
}

- (void)imageLayer
{
    // 圆形裁剪
    _imageView.layer.cornerRadius = 50;
    
    // 超出layer边框的全部裁剪掉
    _imageView.layer.masksToBounds = YES;
    
    _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _imageView.layer.borderWidth = 2;
}

- (void)viewLayer
{
    // 设置阴影透明度
    _redView.layer.shadowOpacity = 1;
    
    // 设置阴影颜色
    _redView.layer.shadowColor = [UIColor yellowColor].CGColor;
    
    // 设置阴影圆角半径
    _redView.layer.shadowRadius = 10;
    
    // 设置圆角半径
    _redView.layer.cornerRadius = 50;
    
    // 设置边框半径
    _redView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // 设置边框半径
    _redView.layer.borderWidth = 2;
}



@end
