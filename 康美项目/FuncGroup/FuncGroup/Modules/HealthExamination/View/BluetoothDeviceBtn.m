//
//  BluetoothDeviceBtn.m
//  FuncGroup
//
//  Created by zhong on 2017/2/8.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BluetoothDeviceBtn.h"
#import "UIImage+Extension.h"

@implementation BluetoothDeviceBtn

- (instancetype)initWithImage:(UIImage *)image selectImage:(UIImage *)selectImage title:(NSString *)title{
    self = [super init];
    if (self) {
        self.image = image;
        self.selectImage = selectImage;
        
        UIImage *imag_nor = [UIImage imageWithColor:kMainColor];
        [self setBackgroundImage:[UIImage imageNamed:@"blue_bg"] forState:UIControlStateSelected];
        [self setBackgroundImage:imag_nor forState:UIControlStateNormal];
        
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
        
        self.iconView = [[UIImageView alloc] init];
        self.iconView.image = image;
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(4);
            make.height.width.equalTo(self.mas_height).multipliedBy(0.6);
        }];
        
        self.label = [[UILabel alloc] init];
        self.label.textColor = [UIColor colorWithRed:0.05 green:0.17 blue:0.36 alpha:1.00];
        //        self.label.font = [UIFont systemFontOfSize:16];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize:17];
        self.label.text = title;
        self.label.numberOfLines = 0;
        [view addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.mas_bottom);
            make.right.left.equalTo(view);
        }];
        
        self.iconView.userInteractionEnabled = NO;
        self.label.userInteractionEnabled = NO;
        view.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)didClick:(BOOL)select{
    if (select) {
        self.iconView.image = self.selectImage;
        self.label.textColor = [UIColor whiteColor];
    }else{
        self.iconView.image = self.image;
        self.label.textColor = [UIColor colorWithRed:0.05 green:0.17 blue:0.36 alpha:1.00];
    }
}
@end
