//
//  HMWheelButton.m
//  11-转盘
//
//  Created by apple on 14-9-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMWheelButton.h"

@implementation HMWheelButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 40;
    CGFloat imageH = 47;
    CGFloat imageX = (contentRect.size.width - imageW) * 0.5;
    CGFloat imageY = 20;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (void)setHighlighted:(BOOL)highlighted
{

}

@end
