//
//  RegistViewController.h
//  FuncGroup
//
//  Created by gary on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegistVCProtocol <NSObject>

-(void)viewDidAppear;

-(void)beginRegist:(NSString *)phoneNum password:(NSString *)psd rePsd:(NSString *)rePsd verifyNum:(NSString *)verifyNum;

-(void)registSegmentControlClick;

-(void)getVerifyCodeClicked:(NSString *)phoneNum;

/*
 * @prama data:登录结束需要返回的数据（成功、失败等）
 */
//-(void)endLogin:(NSDictionary *)data;


@optional
-(void)registProtocolAgreed:(BOOL)agreed;
-(void)registProtocol;

@end

@interface RegistViewController : UIViewController

@property (nonatomic,strong) id<RegistVCProtocol> presenter;

@end
