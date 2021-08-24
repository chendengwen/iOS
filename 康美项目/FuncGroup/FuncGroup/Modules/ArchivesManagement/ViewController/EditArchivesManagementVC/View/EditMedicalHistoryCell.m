//
//  EditMedicalHistoryCell.m
//  FuncGroup
//
//  Created by zhong on 2017/2/27.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "EditMedicalHistoryCell.h"
#import "MKActionSheet.h"
#import "UITextField+DatePicker.h"
//#import "UITextField+DatePicker.h"
#define SEARCH_COLOR [UIColor colorWithRed:0.69 green:0.83 blue:0.88 alpha:0.6]

@interface EditMedicalHistoryCell ()<UITextFieldDelegate>
@property (nonatomic,weak) UILabel *titleLab;
//分割线
@property (nonatomic,weak) UIView *line;
//添加按钮
@property (nonatomic,weak) UIButton *addBtn;
//开关
@property (nonatomic,weak) UISwitch *editSwitch;
//日期框
@property (nonatomic,weak) UITextField *dateTextField;
//文本框
@property (nonatomic,weak) UITextField *textField;
@end

@implementation EditMedicalHistoryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLab = [[UILabel alloc]init];
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
        titleLab.text = @"姓名";
        titleLab.font = [UIFont boldSystemFontOfSize:16];
        
        //选项按钮
        KMAlertBtn *alertBtn = [[KMAlertBtn alloc]init];
        self.alertBtn = alertBtn;
        alertBtn.layer.borderWidth = 1;
        alertBtn.layer.cornerRadius = 4;
        alertBtn.layer.masksToBounds = YES;
        alertBtn.layer.borderColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00].CGColor;
        [alertBtn addTarget:self action:@selector(didClickOptionsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:alertBtn];
        
        //分割线
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor lightGrayColor];
        self.line = line;
        [self.contentView addSubview:line];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(60);
        }];
        
        //日期输入框
        UITextField *dateTextField = [[UITextField alloc]init];
        [self.contentView addSubview:dateTextField];
        self.dateTextField = dateTextField;
        dateTextField.text = @"1990-01-01";
        dateTextField.placeholder = @"请选择日期";
        dateTextField.tag = 1001;
        //        textField.backgroundColor = SEARCH_COLOR;
        dateTextField.borderStyle = UITextBorderStyleRoundedRect;
        dateTextField.layer.borderColor = [UIColor blackColor].CGColor;
        //        textField.layer.cornerRadius = 4;
        dateTextField.layer.masksToBounds = YES;
        //        textField.clearButtonMode = UITextFieldViewModeAlways;
        dateTextField.delegate = self;
        
        //文本输入框
        UITextField *textField = [[UITextField alloc]init];
        [self.contentView addSubview:textField];
        self.textField = textField;
        textField.placeholder = @"请输入您的姓名";
        //        textField.backgroundColor = SEARCH_COLOR;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.layer.borderColor = [UIColor blackColor].CGColor;
        //        textField.layer.cornerRadius = 4;
        textField.layer.masksToBounds = YES;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.delegate = self;
        
        
        UIDatePicker *picker = [[UIDatePicker alloc] init];
        //                self.picker = picker;
        picker.datePickerMode = UIDatePickerModeDate;
        picker.maximumDate = [NSDate date];
        picker.date = [NSDate dateWithTimeIntervalSince1970:0];
        [picker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.dateTextField.inputView = picker;
        
        UIButton *addBtn = [[UIButton alloc]init];
        self.addBtn = addBtn;
        addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(didClickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addBtn];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(60);
        }];
        
        UISwitch *editSwitch = [[UISwitch alloc]init];
        self.editSwitch = editSwitch;
        [self.contentView addSubview:editSwitch];
        [editSwitch addTarget:self action:@selector(changeEditSwitch:) forControlEvents:UIControlEventValueChanged];
        
        [self.alertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab);
            make.left.equalTo(self.contentView).offset(200);
            make.height.equalTo(self.dateTextField);
            make.width.equalTo(@(260));
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab);
            make.left.equalTo(self.contentView).offset(200);
            make.height.equalTo(self.dateTextField);
            make.width.equalTo(@(260));
        }];
        
        [self.dateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab);
            make.left.equalTo(self.alertBtn.mas_right).offset(20);
            make.width.equalTo(@(150));
        }];
        
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab);
            make.left.equalTo(self.dateTextField.mas_right).offset(20);
            make.width.height.equalTo(@(44));
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(1));
            make.left.right.bottom.equalTo(self.contentView);
        }];
        
        [self.editSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab);
            make.right.equalTo(self.contentView).offset(-20);
        }];
        
       
    }
    
    return self;
    
}

#pragma mark - Setter & Getter

- (void)setModel:(CellModel *)model{
    _model = model;
    
    self.addBtn.tag = model.title == nil ? 0 : 1 ;
    self.titleLab.text = model.title;
    self.textField.placeholder = model.placeholder;
    
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(260));
    }];
    
    switch (model.state) {
        case CellState_Hit_1:
        {
            [self.addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
            self.dateTextField.hidden = NO;
            self.addBtn.hidden = NO;
            self.titleLab.hidden = NO;
            self.editSwitch.hidden = NO;
            self.dateTextField.text = model.hitDate;
            self.editSwitch.on = model.isOn;
            if (model.options == nil) {
                self.alertBtn.hidden = YES;
                self.textField.hidden = NO;
                self.textField.text = model.currentValue;
                
                
            }else{
                self.alertBtn.hidden = NO;
                self.textField.hidden = YES;
                self.alertBtn.titleLab.text = model.currentValue;
            }
            
            self.textField.enabled = model.isOn;
            self.alertBtn.enabled = model.isOn;
            self.dateTextField.enabled = model.isOn;
            self.addBtn.enabled = model.isOn;
        }
            break;
        case CellState_Hit_2:
        {
            self.dateTextField.text = model.hitDate;
            self.dateTextField.hidden = NO;
            self.addBtn.hidden = NO;
            self.titleLab.hidden = YES;
            self.editSwitch.hidden = YES;
            
            [self.addBtn setImage:[UIImage imageNamed:@"delete_am"] forState:UIControlStateNormal];
            if (model.options == nil) {
                self.alertBtn.hidden = YES;
                self.textField.hidden = NO;
                self.textField.text = model.currentValue;
            }else{
                self.alertBtn.hidden = NO;
                self.textField.hidden = YES;
                self.alertBtn.titleLab.text = model.currentValue;
            }
            self.textField.enabled = YES;
            self.alertBtn.enabled = YES;
            self.dateTextField.enabled = YES;
            self.addBtn.enabled = YES;
            
        }
            break;
        case CellState_LongTextField:
        {
            [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(500));
            }];
            self.textField.text = model.currentValue;
            self.editSwitch.hidden = NO;;
            self.titleLab.hidden = NO;
            self.alertBtn.hidden = YES;
            self.dateTextField.hidden = YES;
            self.addBtn.hidden = YES;
            
            self.editSwitch.on = model.isOn;
            self.textField.enabled = model.isOn;
            
            self.alertBtn.enabled = YES;
            self.dateTextField.enabled = YES;
            self.addBtn.enabled = YES;
        }
            break;
        default:
            break;
    }

}

#pragma mark - Action
- (void)didClickOptionsBtn:(UIButton *)sender{
    
    
    MKActionSheet *sheet = [[MKActionSheet alloc] initWithTitle:self.titleLab.text buttonTitleArray:self.model.options];
    sheet.currentVC = (UIViewController *)self.delegate;
    sheet.destructiveButtonIndex = self.model.optionIndex;
    sheet.willPresentBlock = ^(MKActionSheet *sheet){
        NSLog(@"willPresentBlock");
    };
    sheet.didPresentBlock = ^(MKActionSheet *sheet){
        NSLog(@"didPresentBlock");
    };
    sheet.willDismissBlock = ^(MKActionSheet* actionSheet, NSInteger buttonIndex){
        NSLog(@"willDismissBlock");
    };
    sheet.didDismissBlock = ^(MKActionSheet* actionSheet, NSInteger buttonIndex){
        NSLog(@"didDismissBlock");
    };
    [sheet showWithBlock:^(MKActionSheet *actionSheet, NSInteger buttonIndex) {
        NSLog(@"buttonIndex:%ld",(long)buttonIndex);
        if (buttonIndex >= self.model.options.count) {
            return ;
        }
        self.model.optionIndex = buttonIndex;
        self.model.currentValue = self.model.options[buttonIndex];
        self.alertBtn.titleLab.text = self.model.currentValue;
        if ([self.delegate respondsToSelector:@selector(setUserValue:)])
        {
            [self.delegate setUserValue:self.model];
        }
    }];
}

//点击添加按钮
- (void)didClickAddBtn:(UIButton *)sender{
    //    - (void)didClickAddBtn:(CellModel *)model;
    if (sender.tag == 1) {
        if ([self.model.title isEqualToString:@"既往病史"] && self.model.subCount >= 2) {
            //            SVProgressHUD setBackgroundColor:[UIColor]
            [SVProgressHUD showInfoWithStatus:@"最多只能记录3类病史"];
            return;
        }
        if ([self.model.title isEqualToString:@"手术"] && self.model.subCount >= 1) {
            [SVProgressHUD showInfoWithStatus:@"最多只能记录2类手术历史"];
            return;
        }
        if ([self.model.title isEqualToString:@"外伤"] && self.model.subCount >= 1) {
            [SVProgressHUD showInfoWithStatus:@"最多只能记录2次外伤历史"];
            return;
        }
        if ([self.model.title isEqualToString:@"输血"] && self.model.subCount >= 1) {
            [SVProgressHUD showInfoWithStatus:@"最多只能记录2次输血历史"];
            return;
        }
    }
    
    
    
    if ([self.delegate respondsToSelector:@selector(didClickAddBtn:)] && self.addBtn.tag == 1)
    {
        self.model.subCount += 1;
        //添加
        [self.delegate didClickAddBtn:self.model];
    }else if ([self.delegate respondsToSelector:@selector(didClickDeleteBtn:)] && self.addBtn.tag == 0){
        //删除
        [self.delegate didClickDeleteBtn:self.model];
    }
}

//开关按钮
- (void)changeEditSwitch:(UISwitch *)sender{
    NSLog(@"%zd",sender.isOn);
    self.model.isOn = sender.isOn;
    if (!sender.isOn) {
        self.textField.text = @"";
        self.alertBtn.titleLab.text = @"无";
        if (self.model.options != nil) {
            self.model.currentValue = @"无";
        }else{
            self.model.currentValue = @"";
        }
        self.model.optionIndex = 0;
    }
    self.model.hitDate = @"1990-01-01";
    self.dateTextField.text = @"1990-01-01";
    
    if ([self.delegate respondsToSelector:@selector(setUserValue:)])
    {
        [self.delegate setUserValue:self.model];
    }
    
    self.textField.enabled = sender.isOn;
    self.alertBtn.enabled = sender.isOn;
    self.dateTextField.enabled = sender.isOn;
    self.addBtn.enabled = sender.isOn;
    
}

- (void)pickerValueChanged:(UIDatePicker *)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.dateTextField.text = [formatter stringFromDate:sender.date];
//    self.model.currentValue = self.dateTextField.text;
    self.model.hitDate = self.dateTextField.text;
    if ([self.delegate respondsToSelector:@selector(setUserValue:)])
    {
        [self.delegate setUserValue:self.model];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag == 1001) {
        return YES;
    }
    self.model.currentValue = textField.text;
    if ([self.delegate respondsToSelector:@selector(setUserValue:)])
    {
        [self.delegate setUserValue:self.model];
    }
    
    return YES;
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
