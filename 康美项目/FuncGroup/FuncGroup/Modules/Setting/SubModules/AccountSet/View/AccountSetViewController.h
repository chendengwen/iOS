//
//  AccountSetViewController.h
//  FuncGroup
//
//  Created by gary on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountSetVCProtocol <NSObject>

-(void)accountSet:(NSDictionary *)name password:(NSDictionary *)psd newName:(NSDictionary *)newName newPassword:(NSDictionary *)newPSD rePSD:(NSDictionary *)rePSD realName:(NSDictionary *)realName cardIDNum:(NSDictionary *)idNum telephoneNum:(NSDictionary *)telephoneNum;

@end

@interface AccountSetViewController : UIViewController

@property (nonatomic,strong) id<AccountSetVCProtocol> presenter;


@end
