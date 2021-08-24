//
//  KMMatchResult.h
//  YiYangCloud
//
//  Created by gary on 2017/4/12.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMMatchResult : NSObject

@property(nonatomic,assign,getter=isMatched) BOOL matched;

@property(nonatomic,strong) NSDictionary *paramProperties;

@end
