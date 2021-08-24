//
//  TableDataSource.h
//  FuncGroup
//
//  Created by gary on 2017/3/27.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TableViewCellConfigureBlock)(UITableViewCell *a, id b);

@interface TableDataSource : NSObject<UITableViewDelegate,UITableViewDataSource>

-(instancetype)initWithItems:(NSArray *)arr CellIdentifier:(NSString *)identifier ConfigureCellBlock:(TableViewCellConfigureBlock)block;

@end
