//
//  XYAlertView.m
//  FuncGroup
//
//  Created by zhong on 2017/2/17.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "XYAlertView.h"
#define BTN_COLOR [UIColor colorWithRed:0.43 green:0.44 blue:0.44 alpha:1.00]

@interface XYAlertView ()<UITextFieldDelegate>

@property (nonatomic, strong) NSArray *realButtons;

@property (nonatomic, weak) UIView *alertView;

@property (nonatomic, weak) UIView *bottonView;

@property (nonatomic, assign) BOOL isHaveDian;
@end

@implementation XYAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    
    return self;
}

- (void)configView {
    
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    shadowView.backgroundColor = [UIColor colorWithRed:0.23 green:0.24 blue:0.24 alpha:0.8];
    UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleTap:)];
    [shadowView addGestureRecognizer:tap];
    [self addSubview:shadowView];
    //512 253
    UIView *alertView = [[UIView alloc]init];
    self.alertView = alertView;
    alertView.backgroundColor = [UIColor whiteColor];
    [self addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.height.equalTo(@(254));
        make.width.equalTo(@(523));
    }];
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1.00];
    [alertView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(alertView);
        make.height.equalTo(@(50));
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    self.bottonView = bottomView;
    bottomView.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1.00];
    [alertView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(alertView);
        make.height.equalTo(@(55));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    [alertView addSubview:titleLabel];
    [topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
    }];
    titleLabel.textColor = BTN_COLOR;
    titleLabel.font = [UIFont systemFontOfSize:20];
    
    UIView *customerView = [[UIView alloc]init];
    self.customerView = customerView;
    customerView.backgroundColor = [UIColor whiteColor];
    [alertView addSubview:customerView];
    [customerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(alertView);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.00];
    [alertView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(alertView);
        make.top.equalTo(topView.mas_bottom);
        make.height.equalTo(@(1));
    }];
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.00];
    [alertView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(alertView);
        make.top.equalTo(bottomView.mas_top);
        make.height.equalTo(@(1));
    }];
    
    UILabel *msgLabel = [[UILabel alloc]init];
    self.msgLabel = msgLabel;
    msgLabel.font = [UIFont systemFontOfSize:18];
    msgLabel.textColor = BTN_COLOR;
    msgLabel.numberOfLines = 0;
    msgLabel.textAlignment = NSTextAlignmentCenter;
    [customerView addSubview:msgLabel];
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(customerView);
        make.left.equalTo(customerView).offset(80);
        make.right.equalTo(customerView).offset(-80);
    }];
    
}

#pragma mark - Setter && Getter
- (void)setHeight:(CGFloat)height{
    _height = height;
    
    [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];

}

- (void)setTextsArray:(NSArray *)textsArray{
    if (textsArray.count != 1 && textsArray.count != 2) {
        return;
    }
    for (XYAlertView *alert in self.realTexts) {
        [alert removeFromSuperview];
    }
    _textsArray = textsArray;
    if (textsArray.count == 1) {
        
        [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(204));
        }];
        
        UILabel *subTitleLab = [[UILabel alloc]init];
        subTitleLab.text = self.textsTitleArray[0];
        subTitleLab.font = [UIFont systemFontOfSize:16];
        [self.customerView addSubview:subTitleLab];
        [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.customerView);
            make.left.equalTo(self.customerView).offset(20);
        }];
        
        UITextField *subTitleText = [[UITextField alloc]init];
//        subTitleText.tintColor = [UIColor colorWithRed:0.29 green:0.95 blue:0.63 alpha:1.00];
        subTitleText.placeholder = self.textsArray[0];
        subTitleText.keyboardType = UIKeyboardTypeNumberPad;
        subTitleText.font = [UIFont systemFontOfSize:16];
        [self.customerView addSubview:subTitleText];
        [subTitleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.customerView);
            make.left.equalTo(subTitleLab.mas_right).offset(16);
            make.right.equalTo(self.customerView).offset(-16);
        }];
        
        UIImageView *textLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
        [self.customerView addSubview:textLine];
        [textLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(subTitleText);
        }];
        
        self.realTexts = @[subTitleText];
        subTitleText.delegate = self;
    }else if (textsArray.count == 2){
        UILabel *subTitleLab1 = [[UILabel alloc]init];
        subTitleLab1.text = self.textsTitleArray[0];
        subTitleLab1.font = [UIFont systemFontOfSize:16];
        [self.customerView addSubview:subTitleLab1];
        [subTitleLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.customerView).offset(-25);
            make.left.equalTo(self.customerView).offset(20);
        }];
        
        UITextField *subTitleText1 = [[UITextField alloc]init];
//        subTitleText1.tintColor = [UIColor colorWithRed:0.69 green:0.83 blue:0.88 alpha:1.00];
        subTitleText1.placeholder = self.textsArray[0];
        subTitleText1.keyboardType = UIKeyboardTypeNumberPad;
        subTitleText1.font = [UIFont systemFontOfSize:16];
        [self.customerView addSubview:subTitleText1];
        [subTitleText1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(subTitleLab1);
            make.left.equalTo(subTitleLab1.mas_right).offset(16);
            make.right.equalTo(self.customerView).offset(-16);
        }];
        
        UIImageView *textLine1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
        [self.customerView addSubview:textLine1];
        [textLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(subTitleText1);
        }];
        
        UILabel *subTitleLab = [[UILabel alloc]init];
        subTitleLab.text = self.textsTitleArray[1];
        subTitleLab.font = [UIFont systemFontOfSize:16];
        [self.customerView addSubview:subTitleLab];
        [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.customerView).offset(25);
            make.left.equalTo(self.customerView).offset(20);
        }];
        
        UITextField *subTitleText = [[UITextField alloc]init];
//        subTitleText.tintColor = [UIColor colorWithRed:0.69 green:0.83 blue:0.88 alpha:1.00];
        subTitleText.placeholder = self.textsArray[1];
        subTitleText.keyboardType = UIKeyboardTypeNumberPad;
        subTitleText.font = [UIFont systemFontOfSize:16];
        [self.customerView addSubview:subTitleText];
        [subTitleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(subTitleLab);
            make.left.equalTo(subTitleLab.mas_right).offset(16);
            make.right.equalTo(self.customerView).offset(-16);
        }];
        
        UIImageView *textLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
        [self.customerView addSubview:textLine];
        [textLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(subTitleText);
        }];
        self.realTexts = @[subTitleText1,subTitleText];
        
        subTitleText1.delegate = self;
        subTitleText.delegate = self;
    }
}

- (void)setButtonsArray:(NSArray *)buttonsArray{
    if (buttonsArray.count != 1 && buttonsArray.count != 2) {
        return;
    }
    
    for (UIButton *button in self.realButtons) {
        [button removeFromSuperview];
    }
    
    _buttonsArray = buttonsArray;
    if (buttonsArray.count == 1) {
        //        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //        button.layer.borderWidth = 1;
        //        button.layer.borderColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.00].CGColor;
        //        [button setTitle:buttonsArray[0] forState:UIControlStateNormal];
        //        [button setTitleColor:kMainColor forState:UIControlStateNormal];
        //        [button setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]] forState:UIControlStateHighlighted];
        //
        //        [self.bottonView addSubview:button];
        //        [button mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.right.equalTo(self);
        //            make.bottom.equalTo(self).offset(1);
        //            make.height.equalTo(@(50));
        //        }];
        //        self.realButtons = @[button];
    } else if (buttonsArray.count == 2) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 4;
        button.layer.borderWidth = 1;
        button.layer.borderColor = BTN_COLOR.CGColor;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:buttonsArray[0] forState:UIControlStateNormal];
        [button setTitleColor:BTN_COLOR forState:UIControlStateNormal];
        [self.bottonView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bottonView);
            make.centerX.equalTo(self).offset(-85);
            make.width.equalTo(@(130));
            make.top.equalTo(self.bottonView).offset(8);
            make.bottom.equalTo(self.bottonView).offset(-8);
        }];
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.layer.cornerRadius = 4;
        button2.layer.borderWidth = 1;
        button2.layer.borderColor = BTN_COLOR.CGColor;
        button2.layer.masksToBounds = YES;
        button2.backgroundColor = kNavyBlueColor;
        [button2 setTitle:buttonsArray[1] forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.bottonView addSubview:button2];
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bottonView);
            make.centerX.equalTo(self).offset(85);
            make.width.equalTo(@(130));
            make.top.equalTo(self.bottonView).offset(8);
            make.bottom.equalTo(self.bottonView).offset(-8);
        }];
        
        self.realButtons = @[button, button2];
    }
}

#pragma mark - Action
- (void)handleTap:(UITapGestureRecognizer *)sender{
    [self removeFromSuperview];
}


#pragma mark --- 颜色生成图片
- (UIImage *)buttonImageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0,30,30);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    if ([textField.text rangeOfString:@"."].location == NSNotFound)
    {
        _isHaveDian = NO;
    }
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length] == 0)
            {
                
                if(single == '.')
                {
                    
                    //[self showMyMessage:@"亲，第一个数字不能为小数点!"];
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                    return NO;
                    
                }
                
//                if (single == '0')
//                {
//                    
//                    //[self showMyMessage:@"亲，第一个数字不能为0!"];
//                    
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    
//                    return NO;
//                    
//                }
                
            }
            
            //输入的字符是否是小数点
            
            if (single == '.')
            {
                
                if(!_isHaveDian)//text中还没有小数点
                {
                    
                    _isHaveDian = YES;
                    
                    return YES;
                    
                }else{
                    
                    //[self showMyMessage:@"亲，您已经输入过小数点了!"];
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                    return NO;
                    
                }
                
            }else{
                
                if (_isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    
                    NSRange ran = [textField.text rangeOfString:@"."];
                    
                    if (range.location - ran.location <= 2) {
                        
                        return YES;
                        
                    }else{
                        
                        //[self showMyMessage:@"亲，您最多输入两位小数!"];
                        
                        return NO;
                        
                    }
                    
                }else{
                    
                    return YES;
                    
                }
                
            }
            
        }else{//输入的数据格式不正确
            
            //[self showMyMessage:@"亲，您输入的格式不正确!"];
            
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            
            return NO;
            
        }
        
    }
    
    else
        
    {
        
        return YES;
        
    }
    
}

- (void)dismiss{
    [self removeFromSuperview];
}

-(void)showMyMessage:(NSString*)aInfo {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:aInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertView show];
    
}
@end
