//
//  AMTableViewCell.h
//  FuncGroup
//
//  Created by zhong on 2017/2/21.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchivesModel.h"
@class AMTableViewCell;
@protocol AMTableViewCellDelegate <NSObject>

- (void)didClickArchives:(AMTableViewCell *)cell andTag:(NSInteger)tag;

@end
@interface AMTableViewCell : UITableViewCell

@property (nonatomic,strong) ArchivesModel *model;

@property (nonatomic,weak) id<AMTableViewCellDelegate> delegate;
//头像
@property (nonatomic,weak) UIButton *photoIcon;
@end
