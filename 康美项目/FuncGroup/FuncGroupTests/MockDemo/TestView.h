//
//  TestView.h
//  FuncGroup
//
//  Created by gary on 2017/3/27.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestModel.h"

@interface TestView : UIView
{
    NSMutableArray *_dataArray;
}

-(void)addModel:(TestModel *)model;

@end
