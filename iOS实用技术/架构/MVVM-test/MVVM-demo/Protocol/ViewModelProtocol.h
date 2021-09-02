//
//  ViewModelProtocol.h
//  MVVM-demo
//
//  Created by gary on 2021/7/6.
//

@class BaseModel;
@protocol ViewModelProtocol <NSObject>

//@property (nonatomic, strong) BaseModel *model;

-(void)fetchData;

@end
