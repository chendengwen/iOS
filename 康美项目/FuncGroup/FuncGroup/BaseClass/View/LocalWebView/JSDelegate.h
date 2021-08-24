//
//  JSDelegate.h
//  FuncGroup
//
//  Created by gary on 2017/3/2.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSDelegate <NSObject>

-(void)controllerDidReceiveScriptMessage:(WKScriptMessage *)message;

@end
