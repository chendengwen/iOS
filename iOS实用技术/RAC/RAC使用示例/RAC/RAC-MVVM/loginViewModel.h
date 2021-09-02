//
//  loginViewModel.h
//  RAC
//


#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface loginViewModel : NSObject
// 处理按钮是否允许点击
@property(nonatomic, strong, readonly) RACSignal *loginEnableSignal;
/**保存登录界面的账号和密码*/
@property(nonatomic, strong) NSString *account;
@property(nonatomic, strong) NSString *pwd;
//登录按钮的命令
@property(nonatomic, strong, readonly) RACCommand *loginCommand;
@end

NS_ASSUME_NONNULL_END
