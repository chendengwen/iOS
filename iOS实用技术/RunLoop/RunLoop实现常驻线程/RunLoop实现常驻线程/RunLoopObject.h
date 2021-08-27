//
//  RunLoopObject.h
//  RunLoop实现常驻线程
//
//  Created by 陈登文 on 2021/8/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern BOOL runAlways;

@interface RunLoopObject : NSObject

+(NSThread *)threadDispatch;

@end

NS_ASSUME_NONNULL_END
