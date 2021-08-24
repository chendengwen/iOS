//
//  UIImageView+Addtions.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "UIImageView+Addtions.h"

@implementation UIImageView (Addtions)

- (void)setImage:(UIImage *)image animated:(BOOL)animated
{
    [self setImage:image duration:(animated ? 0.25 : 0.)];
}

- (void)setImage:(UIImage *)image duration:(NSTimeInterval)duration
{
    if (duration > 0.)
    {
        CATransition *transition = [CATransition animation];
        
        transition.duration = duration;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        
        [self.layer addAnimation:transition forKey:nil];
    }
    
    self.image = image;
}


@end
