//
//  AlertButtonView.m
//  FuncGroup
//
//  Created by gary on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "AlertButtonView.h"

@implementation AlertButton

@end


@interface AlertButtonView()

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) UIViewController *rootViewController;

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;

@end

@interface AlertButtonView ()

@end

@implementation AlertButtonView

CGFloat kWindowHeight;
CGFloat kWindowWidth;
CGFloat kWindowHeight;
NSString *kButtonFont = @"HelveticaNeue-Bold";

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        kWindowWidth = 270.0f;
        kWindowHeight = 20.0f * 2 - 9.f;
        _buttons = [[NSMutableArray alloc] init];
        
        // Shadow View
        _shadowView = [[UIView alloc] init];
        self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.shadowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.shadowView.backgroundColor = [UIColor blackColor];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10.0f;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        [self.view addSubview:_contentView];
    }
    return self;
}

#pragma mark - View Cycle

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize sz = [UIScreen mainScreen].bounds.size;
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] < 8.0f)
    {
        // iOS versions before 7.0 did not switch the width and height on device roration
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        {
            CGSize ssz = sz;
            sz = CGSizeMake(ssz.height, ssz.width);
        }
    }
    
    // Set background frame
    CGRect newFrame = self.shadowView.frame;
    newFrame.size = sz;
    self.shadowView.frame = newFrame;
    
    // Set frames
    CGRect r;
    if (self.view.superview != nil)
    {
        // View is showing, position at center of screen
        r = CGRectMake((sz.width-kWindowWidth)/2, (sz.height-kWindowHeight)/2, kWindowWidth, kWindowHeight);
    }
    else
    {
        // View is not visible, position outside screen bounds
        r = CGRectMake((sz.width-kWindowWidth)/2, -kWindowHeight, kWindowWidth, kWindowHeight);
    }
    
    self.view.frame = r;
    _contentView.frame = CGRectMake(0.f, 0.f, kWindowWidth, kWindowHeight);
    
    // Buttons
    CGFloat y = 20.0f;
    for (AlertButton *btn in _buttons)
    {
        btn.frame = CGRectMake(44.0f, y, kWindowWidth - 88.f, 34.0f);
        btn.layer.cornerRadius = 17;
        btn.backgroundColor = [Resource blueColor];
        y += 43.0;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Handle gesture

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (_shouldDismissOnTapOutside)
    {
        [self hideView];
    }
}

- (void)setShouldDismissOnTapOutside:(BOOL)shouldDismissOnTapOutside
{
    _shouldDismissOnTapOutside = shouldDismissOnTapOutside;
    
    if(_shouldDismissOnTapOutside)
    {
        self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.shadowView addGestureRecognizer:_gestureRecognizer];
    }
}

/** Show DDGAlertView
 *
 * TODO
 */
- (void)showAlertView:(UIViewController *)vc duration:(NSTimeInterval)duration{
    self.view.alpha = 0;
    self.rootViewController = vc;
    
    // Add subviews
    [self.rootViewController addChildViewController:self];
    self.shadowView.frame = vc.view.bounds;
    [self.rootViewController.view addSubview:self.shadowView];
    [self.rootViewController.view addSubview:self.view];
    
    // Animate in the alert view
    [UIView animateWithDuration:0.2f animations:^{
        self.shadowView.alpha = 0.5f;
        
        //New Frame
        CGRect frame = self.view.frame;
        frame.origin.y = self.rootViewController.view.center.y - 100.0f;
        self.view.frame = frame;
        
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = self.rootViewController.view.center;
        }];
    }];
}

-(void)addTitle:(NSString *)title{
    CGSize size = [title boundingRectWithSize:CGSizeMake(215, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size;
//    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:13.f] constrainedToSize:CGSizeMake(215, 60)];
    
    kWindowHeight = size.height + 28.f;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kWindowWidth - 215.f)/2, 14.f, 215.f, size.height)];
    _titleLabel.text = title;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [Resource lightGrayColor];
    _titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_contentView addSubview:_titleLabel];
}

#pragma mark - Buttons

- (AlertButton *)addButton:(NSString *)title
{
    // Update view height
    kWindowHeight += 43.0;
    
    // Add button
    AlertButton *btn = [[AlertButton alloc] init];
    btn.layer.masksToBounds = YES;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kButtonFont size:14.0f];
    
    [_contentView addSubview:btn];
    [_buttons addObject:btn];
    
    return btn;
}

- (AlertButton *)addButton:(NSString *)title actionBlock:(ActionBlock)action
{
    AlertButton *btn = [self addButton:title];
    btn.actionType = Block;
    btn.actionBlock = action;
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}


- (AlertButton *)addButton:(NSString *)title target:(id)target selector:(SEL)selector
{
    AlertButton *btn = [self addButton:title];
    btn.actionType = Selector;
    btn.target = target;
    btn.selector = selector;
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)buttonTapped:(AlertButton *)btn
{
    if (btn.actionType == Block)
    {
        if (btn.actionBlock)
            btn.actionBlock();
    }
    else if (btn.actionType == Selector)
    {
        UIControl *ctrl = [[UIControl alloc] init];
        [ctrl sendAction:btn.selector to:btn.target forEvent:nil];
    }
    else
    {
        NSLog(@"Unknown action type for button");
    }
    [self hideView];
}

#pragma mark - Hide Alert

// Close SCLAlertView
- (void)hideView
{
    [UIView animateWithDuration:0.2f animations:^{
        self.shadowView.alpha = 0;
        self.view.alpha = 0;
    } completion:^(BOOL completed) {
        [self.shadowView removeFromSuperview];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
