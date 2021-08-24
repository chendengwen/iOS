//
//  EditAMTableViewCell.h
//  FuncGroup
//
//  Created by zhong on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"
#import "KMAlertBtn.h"

@protocol EditAMTableViewCellDelegate <NSObject>

- (void)setUserValue:(CellModel *)model;

@end
@interface EditAMTableViewCell : UITableViewCell

@property (nonatomic,strong) CellModel *model;
@property (nonatomic,weak) UITextField *textField;
@property (nonatomic,weak) KMAlertBtn *alertBtn;

//@property (nonatomic,weak) EditArchivesManagementVC *VC;

@property (nonatomic,weak) id<EditAMTableViewCellDelegate> delegate;

@end
