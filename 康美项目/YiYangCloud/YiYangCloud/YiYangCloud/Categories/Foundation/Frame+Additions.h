//
//  Frame+Additions.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#ifndef Frame_Additions_h
#define Frame_Additions_h

#pragma mark -
#pragma mark ==== inlineFunctions ====
#pragma mark -

CF_INLINE CGSize CGSizeAdd(CGSize s1, CGSize s2)
{
    CGSize size; size.width = s1.width + s2.width; size.height = s1.height + s2.height; return size;
}

CF_INLINE CGSize CGSizeSubstract(CGSize s1, CGSize s2)
{
    CGSize size; size.width = s1.width - s2.width; size.height = s1.height - s2.height; return size;
}

CF_INLINE CGPoint CGRectGetCenter(CGRect rect)
{
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

CF_INLINE CGPoint CGPointAdd(CGPoint p1, CGPoint p2)
{
    CGPoint point; point.x = p1.x + p2.x; point.y = p1.y + p2.y; return point;
}

CF_INLINE CGPoint CGPointSubstract(CGPoint p1, CGPoint p2)
{
    CGPoint point; point.x = p1.x - p2.x; point.y = p1.y - p2.y; return point;
}

CF_INLINE CGFloat CGPointDistance(CGPoint p1, CGPoint p2)
{
    return sqrtf(powf(p1.x-p2.x, 2)+powf(p1.y-p2.y, 2));
}



#endif /* Frame_Additions_h */
