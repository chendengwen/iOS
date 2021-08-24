//
//  NSObject+KVO.h
//  007--自定义KVO
//
//  Created by H on 2017/5/8.
//  Copyright © 2017年 TZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVO)
- (void)FF_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
@end
