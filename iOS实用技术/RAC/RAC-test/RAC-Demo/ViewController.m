//
//  ViewController.m
//  RAC-Demo
//
//  Created by gary on 2021/7/8.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>
#import "PlayerViewModel.h"

@interface ViewController ()

@property(nonatomic,retain) PlayerViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *scoreField;
@property (weak, nonatomic) IBOutlet UIStepper *scoreStepper;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property(assign) NSUInteger scoreUpdates;
@end

static NSUInteger const kMaxUploads = 5;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Create the View Model
    self.viewModel = [PlayerViewModel new];
    
    //using with @strongify(self) this makes sure that self isn't retained in the blocks
    //this is declared in RACEXTScope.h
    @weakify(self);
    
    
    // Player Name //////////////////////////////////////////////////////////////////////////////////////
    //绑定 nameField 与 viewModel 的属性
    //把 viewModel.playerName 赋值给 self.nameField.text
    RAC(self.nameField,text) = [RACObserve(self.viewModel, playerName) distinctUntilChanged];
    //监听 self.nameField.text 的变化，变化时将值传给 viewModel.playerName
    [[self.nameField.rac_textSignal distinctUntilChanged] subscribeNext:^(NSString *x) {
        @strongify(self);
        self.viewModel.playerName = x;
    }];
    
    //this signal should only trigger if we have "bad words" in our name
    [self.viewModel.forbiddenNameSignal subscribeNext:^(NSString *name) {
        @strongify(self);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forbidden Name!"
                                                        message:[NSString stringWithFormat:@"The name %@ has been forbidden!",name]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        self.viewModel.playerName = @"";
    }];
    // Player Name //////////////////////////////////////////////////////////////////////////////////////
    
    
    // Points Score //////////////////////////////////////////////////////////////////////////////////////
    //the score property is a double, RC gives us updates as NSNumber which we just call
    //stringValue on and bind that to the scorefield text
    RAC(self.scoreField,text) = [RACObserve(self.viewModel,points) map:^id(NSNumber *value) {
        return [value stringValue];
    }];
    
    
    //Setup bind the steppers values
    self.scoreStepper.value = self.viewModel.points;
    RAC(self.scoreStepper,stepValue) = RACObserve(self.viewModel,stepAmount);
    RAC(self.scoreStepper,maximumValue) = RACObserve(self.viewModel,maxPoints);
    RAC(self.scoreStepper,minimumValue) = RACObserve(self.viewModel,minPoints);
    //bind the hidden field to a signal keeping track if
    //we've updated less than a certain number times as the view model specifies
    RAC(self.scoreStepper,hidden) = [RACObserve(self,scoreUpdates) map:^id(NSNumber *x) {
        @strongify(self);
        return @(x.intValue >= self.viewModel.maxPointUpdates);
    }];
    
    //only take the maxPointUpdates number of score updates
    //skip 1 because we don't want the 1st value provided, only changes
//    [[[RACObserve(self.scoreStepper,value) skip:1] take:self.viewModel.maxPointUpdates] subscribeNext:^(id newPoints) {
//        @strongify(self);
//        self.viewModel.points = [newPoints doubleValue];
//        self.scoreUpdates++;
//    }];
    
    //上面的写法不执行 -- ？
    [[self.scoreStepper rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"scoreStepper.value == %.f", ((UIStepper *)x).value);
        @strongify(self);
        self.viewModel.points = ((UIStepper *)x).value;
        self.scoreUpdates++;
    }];
    // Points Score //////////////////////////////////////////////////////////////////////////////////////
    
    
    //let the upload(save) button only be enabled when the view model says its valid
    RAC(self.uploadButton,enabled) = self.viewModel.modelIsValidSignal;
    
    //set the control action for our button to be the ViewModels action method
    [self.uploadButton addTarget:self.viewModel
                          action:@selector(uploadData:)
                forControlEvents:UIControlEventTouchUpInside];
    
    //we can subscribe to the same thing in multiple locations
    //here we skip the first 4 signals and take only 1 update
    //and then disable/hide certain UI elements as our app
    //only allows 5 updates
    [[[[self.uploadButton rac_signalForControlEvents:UIControlEventTouchUpInside]
       skip:(kMaxUploads - 1)] take:1] subscribeNext:^(id x) {
        @strongify(self);
        self.nameField.enabled = NO;
        self.scoreStepper.hidden = YES;
        self.uploadButton.hidden = YES;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
