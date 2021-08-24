//
//  EditAMTableViewCell.m
//  FuncGroup
//
//  Created by zhong on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "EditAMTableViewCell.h"
#import "DictionarySearchTool.h"
#import "MKActionSheet.h"

//#import "UITextField+DatePicker.h"
#define SEARCH_COLOR [UIColor colorWithRed:0.69 green:0.83 blue:0.88 alpha:0.6]

@interface EditAMTableViewCell ()<UITextFieldDelegate>

@property (nonatomic,weak) UILabel *titleLab;

@property (nonatomic,strong) NSArray<UIButton *> *btnArray;

@property (nonatomic,strong) NSArray<UILabel *> *labArray;

//分割线
@property (nonatomic,weak) UIView *line;

@property (nonatomic,weak) UIView *textBackView;

@property (nonatomic,weak) UILabel *tagLab;

@property (nonatomic,weak) UIView *checkboxesView;

@property (nonatomic,weak) UITextField *otherText;

//@property (nonatomic,weak) UIDatePicker *picker;

@end

@implementation EditAMTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLab = [[UILabel alloc]init];
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
        titleLab.text = @"姓名";
        titleLab.font = [UIFont boldSystemFontOfSize:16];
        
        //        UIView *textBackView = [[UIView alloc]init];
        //        self.textBackView = textBackView;
        //        [self.contentView addSubview:textBackView];
        //        textBackView.backgroundColor = SEARCH_COLOR;
        //        textBackView.layer.borderColor = [UIColor grayColor].CGColor;
        //        textBackView.layer.cornerRadius = 4;
        //        textBackView.layer.masksToBounds = YES;
        
        //输入框
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
        
        UILabel *tagLab = [[UILabel alloc]init];
        self.tagLab = tagLab;
        [self.contentView addSubview:tagLab];
        tagLab.text = @"*";
        tagLab.textColor = [UIColor redColor];
        tagLab.font = [UIFont boldSystemFontOfSize:12];
        
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
        //复选框
        UIView *checkboxesView = [[UIView alloc]init];
        self.checkboxesView = checkboxesView;
        [self.contentView addSubview:checkboxesView];
        [self addSubboxsView:checkboxesView];
        
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab);
            make.left.equalTo(self.contentView).offset(200);
            make.width.equalTo(@(260));
        }];
        
        [self.checkboxesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab);
            make.left.equalTo(self.contentView).offset(200);
            make.right.equalTo(self.contentView).offset(20);
            make.height.equalTo(@(35));
        }];
        
        [self.alertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab);
            make.left.equalTo(self.contentView).offset(200);
            make.height.equalTo(self.textField);
            make.width.equalTo(@(260));
        }];
        
        [self.tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textField.mas_right).offset(4);
            make.centerY.equalTo(self.textField);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(1));
            make.left.right.bottom.equalTo(self.contentView);
        }];
        
        
        [[ NSNotificationCenter  defaultCenter] addObserver: self  selector: @selector(updateBirthday:) name:@"updateBirthday"  object: nil ];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //    [self.textBackView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.titleLab);
    //        make.left.equalTo(self.contentView).offset(200);
    //    }];
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


#pragma mark - Action
- (void)didClickOptionsBtn:(UIButton *)sender{
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
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

- (void)addSubboxsView:(UIView *)checkView{
    UIButton *nullBtn = [[UIButton alloc]init];
    [nullBtn setImage:[UIImage imageNamed:@"checked_default"] forState:UIControlStateNormal];
    [nullBtn setImage:[UIImage imageNamed:@"checked_selected"] forState:UIControlStateSelected];
    nullBtn.tag = 0;
    [nullBtn addTarget:self action:@selector(didClickBoxs:) forControlEvents:UIControlEventTouchUpInside];
    [checkView addSubview:nullBtn];
    [nullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.equalTo(checkView);
        make.width.height.equalTo(@(35));
    }];
    
    UILabel *nullLab = [[UILabel alloc]init];
    nullLab.text = @"无";
    nullLab.font = [UIFont boldSystemFontOfSize:16];
    [checkView addSubview:nullLab];
    [nullLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nullBtn.mas_right).offset(8);
        make.centerY.equalTo(nullBtn);
    }];
    
    UIButton *Btn_1 = [[UIButton alloc]init];
    [Btn_1 setImage:[UIImage imageNamed:@"checked_default"] forState:UIControlStateNormal];
    [Btn_1 setImage:[UIImage imageNamed:@"checked_selected"] forState:UIControlStateSelected];
    Btn_1.tag = 1;
    [Btn_1 addTarget:self action:@selector(didClickBoxs:) forControlEvents:UIControlEventTouchUpInside];
    [checkView addSubview:Btn_1];
    [Btn_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(checkView);
        make.left.equalTo(nullLab.mas_right).offset(16);
        make.width.height.equalTo(@(35));
    }];
    
    UILabel *Lab_1 = [[UILabel alloc]init];
    Lab_1.text = @"无";
    Lab_1.font = [UIFont boldSystemFontOfSize:16];
    [checkView addSubview:Lab_1];
    [Lab_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Btn_1.mas_right).offset(8);
        make.centerY.equalTo(Btn_1);
    }];
    
    UIButton *Btn_2 = [[UIButton alloc]init];
    [Btn_2 setImage:[UIImage imageNamed:@"checked_default"] forState:UIControlStateNormal];
    [Btn_2 setImage:[UIImage imageNamed:@"checked_selected"] forState:UIControlStateSelected];
    Btn_2.tag = 2;
    [Btn_2 addTarget:self action:@selector(didClickBoxs:) forControlEvents:UIControlEventTouchUpInside];
    [checkView addSubview:Btn_2];
    [Btn_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(checkView);
        make.left.equalTo(Lab_1.mas_right).offset(16);
        make.width.height.equalTo(@(35));
    }];
    
    UILabel *Lab_2 = [[UILabel alloc]init];
    Lab_2.text = @"无";
    Lab_2.font = [UIFont boldSystemFontOfSize:16];
    [checkView addSubview:Lab_2];
    [Lab_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Btn_2.mas_right).offset(8);
        make.centerY.equalTo(Btn_2);
    }];
    
    UIButton *Btn_3 = [[UIButton alloc]init];
    [Btn_3 setImage:[UIImage imageNamed:@"checked_default"] forState:UIControlStateNormal];
    [Btn_3 setImage:[UIImage imageNamed:@"checked_selected"] forState:UIControlStateSelected];
    Btn_3.tag = 3;
    [Btn_3 addTarget:self action:@selector(didClickBoxs:) forControlEvents:UIControlEventTouchUpInside];
    [checkView addSubview:Btn_3];
    [Btn_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(checkView);
        make.left.equalTo(Lab_2.mas_right).offset(16);
        make.width.height.equalTo(@(35));
    }];
    
    UILabel *Lab_3 = [[UILabel alloc]init];
    Lab_3.text = @"无";
    Lab_3.font = [UIFont boldSystemFontOfSize:16];
    [checkView addSubview:Lab_3];
    [Lab_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Btn_3.mas_right).offset(8);
        make.centerY.equalTo(Btn_3);
    }];
    
    UIButton *Btn_4 = [[UIButton alloc]init];
    [Btn_4 setImage:[UIImage imageNamed:@"checked_default"] forState:UIControlStateNormal];
    [Btn_4 setImage:[UIImage imageNamed:@"checked_selected"] forState:UIControlStateSelected];
    Btn_4.tag = 4;
    [Btn_4 addTarget:self action:@selector(didClickBoxs:) forControlEvents:UIControlEventTouchUpInside];
    [checkView addSubview:Btn_4];
    [Btn_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(checkView);
        make.left.equalTo(Lab_3.mas_right).offset(16);
        make.width.height.equalTo(@(35));
    }];
    
    UILabel *Lab_4 = [[UILabel alloc]init];
    Lab_4.text = @"无";
    Lab_4.font = [UIFont boldSystemFontOfSize:16];
    [checkView addSubview:Lab_4];
    [Lab_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Btn_4.mas_right).offset(8);
        make.centerY.equalTo(Btn_4);
    }];
    
    self.btnArray = @[nullBtn,Btn_1,Btn_2,Btn_3,Btn_4];
    self.labArray = @[nullLab,Lab_1,Lab_2,Lab_3,Lab_4];
    
    UITextField *otherText = [[UITextField alloc]init];
    self.otherText = otherText;
    [checkView addSubview:otherText];
    otherText.placeholder = @"其他";
    otherText.enabled = NO;
    otherText.borderStyle = UITextBorderStyleRoundedRect;
    otherText.layer.borderColor = [UIColor blackColor].CGColor;
    otherText.layer.masksToBounds = YES;
    otherText.clearButtonMode = UITextFieldViewModeAlways;
    otherText.delegate = self;
    [otherText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Lab_4.mas_right).offset(16);
        make.centerY.equalTo(Lab_4);
        make.width.equalTo(@(200));
    }];
    
    
}


- (void)didClickBoxs:(UIButton *)sender{
    
    if (self.btnArray[0].isSelected && sender.tag != 0) {
        self.btnArray[0].selected = NO;
    }
    
    sender.selected = !sender.isSelected;
    switch (sender.tag) {
        case 0:
        {
            if (sender.isSelected) {
                for (int i = 1; i < self.model.options.count; i++) {
                    self.btnArray[i].selected = NO;
                }
                self.otherText.text = @"";
                self.otherText.enabled = NO;
                self.model.otherStr = self.otherText.text;
            }
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            if (!sender.isSelected) {
                self.otherText.text = @"";
            }
            self.otherText.enabled = sender.isSelected;
            
        }
            break;
            
        default:
            break;
    }
    
    NSMutableArray *numArray = [[NSMutableArray alloc]initWithCapacity:3];
    for (int i = 0; i < self.btnArray.count; i++) {
        if (self.btnArray[i].isSelected) {
            [numArray addObject:[[DictionarySearchTool sharedInstance]searchDictionary:self.model.title andKey:self.labArray[i].text]];
        }
    }
    if (numArray.count == 0) {
        self.model.currentValue = @"";
    }else{
        self.model.currentValue = [numArray componentsJoinedByString:@";"];
    }
    
    if ([self.delegate respondsToSelector:@selector(setUserValue:)])
    {
        [self.delegate setUserValue:self.model];
    }
}

- (void)pickerValueChanged:(UIDatePicker *)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.textField.text = [formatter stringFromDate:sender.date];
    self.model.currentValue = self.textField.text;
    if ([self.delegate respondsToSelector:@selector(setUserValue:)])
    {
        [self.delegate setUserValue:self.model];
    }
}


#pragma mark - Setter & Getter

- (void)setModel:(CellModel *)model{
    _model = model;
    self.titleLab.text = model.title;
    switch (model.state) {
        case CellState_sortTextField:
        {
            self.alertBtn.hidden = YES;
            self.checkboxesView.hidden = YES;
            self.textField.hidden = NO;
            
//            self.textField.datePickerInput = [model.title isEqualToString:@"出生日期"];
            if ([model.title isEqualToString:@"出生日期"]) {
                UIDatePicker *picker = [[UIDatePicker alloc] init];
//                self.picker = picker;
                picker.datePickerMode = UIDatePickerModeDate;
                picker.maximumDate = [NSDate date];
                picker.date = [NSDate dateWithTimeIntervalSince1970:0];
                [picker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];
                self.textField.inputView = picker;
                self.textField.clearButtonMode = UITextFieldViewModeNever;
//                self.textField.clearButtonMode = UITextFieldViewModeAlways;
            }
            
            self.textField.placeholder = model.placeholder;
            self.textField.text = model.currentValue;
            self.tagLab.hidden = !model.isMust;
            
            [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(260));
            }];
            
        }
            break;
        case CellState_Alert:
        {
            self.alertBtn.titleLab.text = model.currentValue;
            self.tagLab.hidden = !model.isMust;
            
            self.alertBtn.hidden = NO;
            self.textField.hidden = YES;
            self.checkboxesView.hidden = YES;
            [self.tagLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.alertBtn.mas_right).offset(4);
                //                make.centerY.equalTo(self.textField);
            }];
        }
            break;
        case CellState_TextField:
        {
            self.alertBtn.hidden = YES;
            self.checkboxesView.hidden = YES;
            self.textField.hidden = NO;
            
            self.textField.placeholder = model.placeholder;
            
//            self.textField.datePickerInput = NO;
            
            self.textField.text = model.currentValue;
            self.tagLab.hidden = !model.isMust;
            
            [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(500));
            }];
        }
            break;
        case CellState_Checkboxes:
        {
            self.alertBtn.hidden = YES;
            self.checkboxesView.hidden = NO;
            self.textField.hidden = YES;
            
            self.tagLab.hidden = !model.isMust;
            
            for (int i = 0; i < 5; i++) {
                self.labArray[i].text = model.options[i];
            }
            
            NSMutableArray *numArray = [[NSMutableArray alloc]initWithCapacity:3];
            NSArray *valueArray = [model.currentValue componentsSeparatedByString:@";"];
            if (valueArray == nil || valueArray.count == 0) {
                return;
            }
            
            for (NSString *str in valueArray) {
                if ([str isEqualToString:@""]) {
                    continue;
                }
                [numArray addObject:[[DictionarySearchTool sharedInstance]searchKeyWithTitle:model.title andValue:str]];
            }
            
            for (int i = 0; i < self.labArray.count; i++) {
                UILabel *lab = self.labArray[i];
                for (NSString *str in numArray) {
                    if ([str isEqualToString:lab.text]) {
                        self.btnArray[i].selected = YES;
                    }
                }
            }
            
            if (self.btnArray.lastObject.isSelected) {
                self.otherText.enabled = YES;
                self.otherText.text = model.otherStr;
            }
        }
            
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if ([textField.placeholder isEqualToString:@"其他"]) {
        self.model.otherStr = textField.text;
    }else{
        self.model.currentValue = textField.text;
    }
    
    if ([self.delegate respondsToSelector:@selector(setUserValue:)])
    {
        [self.delegate setUserValue:self.model];
    }
    
    if ([self.model.title isEqualToString:@"身份证号"] && [self CheckIsIdentityCard:textField.text]) {
        NSString *Birthday = [self birthdayStrFromIdentityCard:textField.text];
        NSNotification  * subjectMessage = [ NSNotification  notificationWithName:@"updateBirthday"  object:Birthday];
        [[NSNotificationCenter  defaultCenter] postNotification:subjectMessage];
        
    }
    
    return YES;
}

#pragma mark - CheckAction
//身份证号
- (BOOL)CheckIsIdentityCard: (NSString *)identityCard
{
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(identityCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}

//根据身份证号获取生日
-(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr
{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    NSString *day = nil;
    if([numberStr length]<14)
        return result;
    
    //**截取前14位
    NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];
    
    //**检测前14位否全都是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }
    if(!isAllNumber)
        return result;
    
    year = [numberStr substringWithRange:NSMakeRange(6, 4)];
    month = [numberStr substringWithRange:NSMakeRange(10, 2)];
    day = [numberStr substringWithRange:NSMakeRange(12,2)];
    
    [result appendString:year];
    [result appendString:@"-"];
    [result appendString:month];
    [result appendString:@"-"];
    [result appendString:day];
    return result;
}

- (void)updateBirthday:(NSNotification*)notification{
    
    if ([[notification name] isEqualToString:@"updateBirthday"] && [self.model.title isEqualToString:@"出生日期"]) {

        self.textField.text = (NSString *)notification.object;
        self.model.currentValue = self.textField.text;
        if ([self.delegate respondsToSelector:@selector(setUserValue:)])
        {
            [self.delegate setUserValue:self.model];
        }

    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
