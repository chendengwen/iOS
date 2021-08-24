//
//  TableViewSelectedDelegate.h
//  FuncGroup
//
//  Created by gary on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TableViewSelectedDelegate <NSObject>

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)RindexPath;

@end
