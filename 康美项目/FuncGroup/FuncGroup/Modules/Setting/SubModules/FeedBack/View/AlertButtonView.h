//
//  AlertButtonView.h
//  FuncGroup
//
//  Created by gary on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertButton : UIButton

typedef void (^ActionBlock)(void);

// Action Types
typedef NS_ENUM(NSInteger, ActionType)
{
    None,
    Selector,
    Block
};


@property ActionType actionType;

@property (nonatomic, copy) ActionBlock actionBlock;

@property id target;

@property SEL selector;

@end


@interface AlertButtonView : UIViewController

/** Dismiss on tap outside
 *
 * A boolean value that determines whether to dismiss when tapping outside the SCLAlertView.
 * (Default = NO)
 */
@property (nonatomic, assign) BOOL shouldDismissOnTapOutside;

/** Hide SCLAlertView
 *
 * TODO
 */
- (void)hideView;

/** Add Button
 *
 * TODO
 */
- (AlertButton *)addButton:(NSString *)title actionBlock:(ActionBlock)action;

/** Add Button
 *
 * TODO
 */
- (AlertButton *)addButton:(NSString *)title target:(id)target selector:(SEL)selector;

/** Show DDGAlertView
 *
 * TODO
 */
- (void)showAlertView:(UIViewController *)vc duration:(NSTimeInterval)duration;

-(void)addTitle:(NSString *)title;

@end
