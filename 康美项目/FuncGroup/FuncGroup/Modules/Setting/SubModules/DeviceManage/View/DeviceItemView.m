//
//  DeviceItemView.m
//  FuncGroup
//
//  Created by gary on 2017/2/17.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "DeviceItemView.h"

@interface DeviceItemView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *MACLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lockedImage;

@end

@implementation DeviceItemView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction)];
    [self addGestureRecognizer:tap];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _imageView.image = [UIImage imageNamed:self.imageName];
    _titleLabel.text = self.deviceName;
    _MACLabel.text = self.MAC;
    _timeLabel.text = self.time;
    
    if (self.locked) {
        _lockedImage.image = [UIImage imageNamed:@"lock_on.png"];
    } else {
        _lockedImage.image = [UIImage imageNamed:@"lock_off.png"];
    }
}

-(void)setLocked:(BOOL)locked{
    _locked = locked;
    
    if (_locked) {
        _lockedImage.image = [UIImage imageNamed:@"lock_on.png"];
    } else {
        _lockedImage.image = [UIImage imageNamed:@"lock_off.png"];
    }
}

- (void)tapGestureAction{
    if (self.block) {
        self.block(self.index);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
