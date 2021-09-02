//
//  BaseModel.h
//  MVVM-demo
//
//  Created by gary on 2021/7/6.
//

#import <Foundation/Foundation.h>
#import "NetWorkProtocol.h"
#import "DBProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject<NetWorkProtocol, DBProtocol>

@property(assign) NSUInteger code;
@property(copy) NSString *message;

@end

NS_ASSUME_NONNULL_END
