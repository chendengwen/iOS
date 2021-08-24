//
//  JsonResult.m
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "JsonResult.h"

@implementation JsonResult

- (NSString *)description
{
    return [@{
              @"errorCode":@(_errorCode) ? @(_errorCode) : @"no errorCode",
              @"msg":_msg ? _msg : @"msg = nil",
              @"content":_content ? _content : @"content = nil"
              } description];
}

@end
