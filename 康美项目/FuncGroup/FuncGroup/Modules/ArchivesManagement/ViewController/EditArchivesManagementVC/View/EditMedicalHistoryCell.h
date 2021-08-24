//
//  EditMedicalHistoryCell.h
//  FuncGroup
//
//  Created by zhong on 2017/2/27.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"
#import "KMAlertBtn.h"
#import "EditAMTableViewCell.h"
@protocol EditMedicalHistoryCellDelegate <NSObject>

- (void)didClickAddBtn:(CellModel *)model;
- (void)didClickDeleteBtn:(CellModel *)model;

@end

@interface EditMedicalHistoryCell : UITableViewCell
@property (nonatomic,strong) CellModel *model;

@property (nonatomic,weak) KMAlertBtn *alertBtn;

//@property (nonatomic,weak) EditArchivesManagementVC *VC;

@property (nonatomic,weak) id<EditAMTableViewCellDelegate,EditMedicalHistoryCellDelegate> delegate;
@end
