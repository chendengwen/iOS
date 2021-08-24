//
//  GChainTool.h
//  FuncGroup
//
//  Created by gary on 2017/3/8.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ChainUIProtocol.h"


@class GChainUI;

typedef void(^ToolMakeBlock)(UIView *makeView);

@interface GChainUI : NSObject

+(UIView *)tool_make:(ToolMakeBlock)make;

@end

@interface UIView (Chained)<ChainUIProtocol>
@end

@interface UILabel (Chained)<ChainUIProtocol>
@end

@interface UIButton (Chained)<ChainUIProtocol>
@end

@interface UITextField (Chained)<ChainUIProtocol>
@end
