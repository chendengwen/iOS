//
//  RecordCell.m
//  FuncGroup
//
//  Created by gary on 2017/2/20.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "RecordCell.h"
#import "HealthRecordPublic.h"
NSString *const  RecordCell_ID = @"RecordCell_ID";

@interface RecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation RecordCell

-(void)setModel:(NSObject<HealthModelProtocol> *)model{
    _model = model;
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.timelabel.text = _model.date;
    NSString *itemStr,*text = [_model errorString];
    
    if ([_model respondsToSelector:@selector(intValue_1)] && [_model respondsToSelector:@selector(floatValue)]) {
        switch (_model.type) {
            case HealthRecordXueYa:
                itemStr = @"血压";
                if (_model.intValue_1 > 1 || _model.intValue_2 > 1) {
                    text = [NSString stringWithFormat:@"%lu/%lummHg",(unsigned long)_model.intValue_1,(unsigned long)_model
                            .intValue_2];
                }
                break;
            case HealthRecordXueTang:
                itemStr = @"血糖";
                if (_model.floatValue > 0.001) {
                    text = [NSString stringWithFormat:@"%.2fmmol/L",_model.floatValue];
                }
                break;
            case HealthRecordTiWen:
                itemStr = @"体温";
                if (_model.floatValue > 0.001) {
                    text = [NSString stringWithFormat:@"%.1fºC",_model.floatValue];
                }
                break;
            default:
                break;
        }
    }else if ([_model respondsToSelector:@selector(T_hit)]) {
        itemStr = @"体温";
        if (_model.floatValue > 0.001) {
            text = [NSString stringWithFormat:@"%.1fºC",_model.floatValue];
        }
    }else if ([_model respondsToSelector:@selector(floatValue)]) {
        itemStr = @"血糖";
        if (_model.floatValue > 0.001) {
            text = [NSString stringWithFormat:@"%.2fmmol/L",_model.floatValue];
        }
    }else if ([_model respondsToSelector:@selector(intValue_1)]){
        itemStr = @"血压";
        if (_model.intValue_1 > 1 || _model.intValue_2 > 1) {
            text = [NSString stringWithFormat:@"%lu/%lummHg",(unsigned long)_model.intValue_1,(unsigned long)_model
                    .intValue_2];
        }
    }else {
        
    }
    
    self.resultLabel.text = text;
    self.itemLabel.text = itemStr;
    self.timelabel.text = _model.date;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
