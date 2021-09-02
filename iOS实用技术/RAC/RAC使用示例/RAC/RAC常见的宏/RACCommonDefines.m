//
//  RACCommonDefines.m
//  RAC
//


#import "RACCommonDefines.h"
#import <ReactiveObjC.h>

@interface RACCommonDefines ()
@property (nonatomic,strong)UITextField  *textF;
@property (nonatomic,strong)UILabel  *showLab;
@end

@implementation RACCommonDefines

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textF = [[UITextField  alloc]initWithFrame:CGRectMake(20, 100, 300, 40)];
    self.textF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.textF];
    
    self.showLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, 300, 40)];
    [self.view addSubview:self.showLab];
    self.showLab.backgroundColor = [UIColor redColor];
    
    [self RAC_define];
    
    [self RAC_KVO];
    
    [self RAC_RACTuple];
}

//RAC宏
-(void)RAC_define{
    RAC(self.showLab, text) = self.textF.rac_textSignal;
    /*
    [self.textF.rac_textSignal subscribeNext:^(id x) {
        self.showLab.text = x;
    }];
     */
}

-(void)RAC_KVO{
    [RACObserve(self.showLab, text) subscribeNext:^(id x) {
        NSLog(@"KVO监听文本的变化%@", x);
     }];
}


-(void)CyclicReferences{
    /*
    @weakify(self);
    @strongify(self);
     */
}


/*
 * 元祖
 * 快速包装一个元组
 * 把包装的类型放在宏的参数里面,就会自动包装
 */
-(void)RAC_RACTuple{
    RACTuple *tuple = RACTuplePack(@1,@2,@4);
    // 宏的参数类型要和元祖中元素类型一致， 右边为要解析的元祖。
    RACTupleUnpack_(NSNumber *num1, NSNumber *num2, NSNumber * num3) = tuple;// 4.元祖
    // 快速包装一个元组
    // 把包装的类型放在宏的参数里面,就会自动包装
    NSLog(@"%@ %@ %@", num1, num2, num3);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}
@end
