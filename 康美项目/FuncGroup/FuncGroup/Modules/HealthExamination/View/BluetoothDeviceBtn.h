//
//  BluetoothDeviceBtn.h
//  FuncGroup
//
//  Created by zhong on 2017/2/8.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BluetoothDeviceBtn : UIButton

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, strong) UILabel *label;

- (instancetype)initWithImage:(UIImage *)image selectImage:(UIImage *)selectImage title:(NSString *)title;

- (void)didClick:(BOOL)select;

@end
