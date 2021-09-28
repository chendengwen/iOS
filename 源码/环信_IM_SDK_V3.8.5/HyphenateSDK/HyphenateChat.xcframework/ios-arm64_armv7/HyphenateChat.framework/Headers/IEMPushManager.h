//
//  IEMPushManager.h
//  HyphenateSDK
//
//  Created by 杜洁鹏 on 2020/10/26.
//  Copyright © 2020 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMCommonDefs.h"
#import "EMPushOptions.h"
#import "EMError.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 *  \~chinese
 *  @header IEMPushManager.h
 *  @abstract 推送相关的管理协议类
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMPushManager.h
 *  @abstract Push related management protocol class
 *  @author Hyphenate
 *  @version 3.00
 */

@protocol IEMPushManager <NSObject>

/*!
 *  \~chinese
 *  消息推送配置选项
 *
 *  \~english
 *  Message push configuration options
 *
 */
@property (nonatomic, strong, readonly) EMPushOptions *pushOptions;

/*!
 *  \~chinese
 *  从内存中获取屏蔽了推送的用户ID列表
 *
 *
 *  \~english
 *  Get the list of uids which have disabled Apple Push Notification Service
 */
@property (nonatomic, strong, readonly) NSArray *noPushUIds;

/*!
 *  \~chinese
 *  从内存中获取屏蔽了推送的群组ID列表
 *
 *
 *  \~english
 *  Get the list of groups which have disabled Apple Push Notification Service
 */
@property (nonatomic, strong, readonly) NSArray *noPushGroups;

/*!
 *  \~chinese
 *  开启离线推送
 *
 *  同步方法，会阻塞当前线程
 *
 *  @result EMError 错误信息
 *
 *  \~english
 *  Enable APNS
 *
 *  Synchronization method will block the current thread
 *
 *  @result EMError error
 */
- (EMError *)enableOfflinePush;


/*!
 *  \~chinese
 *  关闭离线推送
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aStartHour    开始时间
 *  @param aEndHour      结束时间
 *
 *  @result EMError  错误信息
 *
 *  \~english
 *  Disable Apns
 *
 *  Synchronization method will block the current thread
 *
 *  @param aStartHour    start time
 *  @param aEndHour      end time
 *
 *  @result EMError error
 */
- (EMError *)disableOfflinePushStart:(int)aStartHour end:(int)aEndHour;

/*!
 *  \~chinese
 *  设置群组是否接收推送
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupIds    群组id
 *  @param disable      是否接收推送
 *
 *  @result  EMError    错误信息
 *
 *  \~english
 *  Disable groups APNS
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupIds    group ids
 *  @param disable      disable
 *
 *  @result EMError  error
 */
- (EMError *)updatePushServiceForGroups:(NSArray *)aGroupIds
                            disablePush:(BOOL)disable;


/*!
 *  \~chinese
 *  设置群组是否接收推送
 *
 *  @param aGroupIds            群组id
 *  @param disable              是否接收推送
 *  @param aCompletionBlock     完成的回调
 *
 *  \~english
 *  Set display style for the push notification
 *
 *  @param aGroupIds            group ids
 *  @param disable              disable
 *  @param aCompletionBlock     The callback block of completion
 */
- (void)updatePushServiceForGroups:(NSArray *)aGroupIds
                       disablePush:(BOOL)disable
                        completion:(nonnull void (^)(EMError * _Nonnull aError))aCompletionBlock;

/*!
  *  \~chinese
  *  设置是否接收联系人消息推送
  *
  *  同步方法，会阻塞当前线程
  *
  *  @param aUIds        用户环信id
  *  @param disable      是否接收推送
  *
  *  @result             错误信息
  *
  *  \~english
  *  Disable uids Apns
  *
  *  Synchronization method will block the current thread
  *
  *  @param aUIds        user ids
  *  @param disable      disable
  *
  *  @result Error
  */
- (EMError *)updatePushServiceForUsers:(NSArray *)aUIds
                            disablePush:(BOOL)disable;

 /*!
  *  \~chinese
  *  设置是否接收联系人消息推送
  *
  *  @param aUIds                用户环信id
  *  @param disable              是否接收推送
  *  @param aCompletionBlock     完成的回调
  *
  *  \~english
  *  Set display style for the push notification
  *
  *  @param aUIds                user ids
  *  @param disable              disable
  *  @param aCompletionBlock     The callback block of completion
  */
- (void)updatePushServiceForUsers:(NSArray *)aUIds
                        disablePush:(BOOL)disable
                        completion:(nonnull void (^)(EMError * _Nonnull aError))aCompletionBlock;

/*!
 *  \~chinese
 *  设置推送消息显示的样式
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pushDisplayStyle  要设置的推送样式
 *
 *  @result EMError 错误信息
 *
 *  \~english
 *  Set display style for Apple Push Notification message
 *
 *  Synchronization method will block the current thread
 *
 *  @param pushDisplayStyle  Display style
 *
 *  @result EMError error
 */
- (EMError *)updatePushDisplayStyle:(EMPushDisplayStyle)pushDisplayStyle;


/*!
 *  \~chinese
 *  设置推送的显示名
 *
 *  @param pushDisplayStyle     推送显示样式
 *  @param aCompletionBlock     完成的回调
 *
 *  \~english
 *  Set display style for the push notification
 *
 *  @param pushDisplayStyle     Display style of push
 *  @param aCompletionBlock     The callback block of completion
 */
- (void)updatePushDisplayStyle:(EMPushDisplayStyle)pushDisplayStyle
                    completion:(nonnull void (^)(EMError * _Nonnull))aCompletionBlock;


/*!
 *  \~chinese
 *  设置推送消息显示的昵称
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aNickname  要设置的昵称
 *
 *  @result EMError 错误信息
 *
 *  \~english
 *  Set display name for Apple Push Notification message
 *
 *  Synchronization method will block the current thread
 *
 *  @param aNickname  Display name
 *
 *  @result EMError error
 */
- (EMError *)updatePushDisplayName:(NSString *)aDisplayName;

/*!
 *  \~chinese
 *  设置推送的显示的昵称
 *
 *  @param aDisplayName     推送显示的昵称
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Set display name for the push notification
 *
 *  @param aDisplayName     Display name of push
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)updatePushDisplayName:(NSString *)aDisplayName
                   completion:(void (^)(NSString *aDisplayName, EMError *aError))aCompletionBlock;



/*!
 *  \~chinese
 *  从服务器获取推送属性
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError  错误信息
 *
 *  @result EMPushOptions 推送属性
 *
 *  \~english
 *  Get Apple Push Notification Service options from the server
 *
 *  Synchronization method will block the current thread
 *
 *  @param pError  error
 *
 *  @result EMPushOptions  Apple Push Notification Service options
 */
- (EMPushOptions *)getPushOptionsFromServerWithError:(EMError *_Nullable *_Nullable)pError;

/*!
 *  \~chinese
 *  从服务器获取推送属性
 *
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Get Apple Push Notification Service options from the server
 *
 *  @param aCompletionBlock The callback of completion block
 */
- (void)getPushNotificationOptionsFromServerWithCompletion:(void (^)(EMPushOptions *aOptions, EMError *aError))aCompletionBlock;



@end

NS_ASSUME_NONNULL_END
