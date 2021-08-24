//
//  HMWheelButton.m
//  转盘
//
//  Created by yz on 14-9-5.
//  Copyright (c) 2014年 iThinker. All rights reserved.
//

#import "HMWheelButton.h"

@implementation HMWheelButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    CGFloat imageW = 40;
    CGFloat imageH = 47;
    CGFloat imageX = (contentRect.size.width - imageW) * 0.5;
    CGFloat imageY = 20;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (void)setHighlighted:(BOOL)highlighted{}
@end
