//
//  AMTableViewCell.m
//  FuncGroup
//
//  Created by zhong on 2017/2/21.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "AMTableViewCell.h"

@interface AMTableViewCell ()

//姓名
@property (nonatomic,weak) UILabel *nameLab;
//sex
@property (nonatomic,weak) UILabel *sexLab;
//身份证
@property (nonatomic,weak) UILabel *IDCardLab;
//档案创建日期
@property (nonatomic,weak) UILabel *dateLab;
//选择档案按钮
@property (nonatomic,weak) UIButton *selectBtn;
//删除档案按钮
@property (nonatomic,weak) UIButton *delectBtn;
//分割线
@property (nonatomic,weak) UIView *line;



@end

@implementation AMTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIButton *photoIcon = [[UIButton alloc]init];
        [photoIcon setImage:[UIImage imageNamed:@"avatar"] forState:UIControlStateNormal];
        photoIcon.tag = 103;
        [photoIcon addTarget:self action:@selector(didClickArchivesBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.photoIcon.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoIcon = photoIcon;
        self.photoIcon.layer.cornerRadius = 45;
        self.photoIcon.layer.masksToBounds = YES;
        [self.contentView addSubview:photoIcon];

        
        UILabel *nameLab = [[UILabel alloc]init];
        nameLab.text = @"Han";
        nameLab.font = [UIFont systemFontOfSize:18];
        self.nameLab = nameLab;
        [self.contentView addSubview:nameLab];
        
        UILabel *sexLab = [[UILabel alloc]init];
        sexLab.text = @"男";
        sexLab.font = [UIFont systemFontOfSize:14];
        self.sexLab = sexLab;
        [self.contentView addSubview:sexLab];
        
        UILabel *IDCardLab = [[UILabel alloc]init];
        IDCardLab.text = @"530322198410150736";
        IDCardLab.font = [UIFont systemFontOfSize:13];
        self.IDCardLab = IDCardLab;
        [self.contentView addSubview:IDCardLab];
        
        UILabel *dateLab = [[UILabel alloc]init];
        dateLab.text = @"2016-05-24 06:09:02";
        dateLab.font = [UIFont systemFontOfSize:13];
        self.dateLab = dateLab;
        [self.contentView addSubview:dateLab];
        
        UIButton *selectBtn = [[UIButton alloc]init];
        selectBtn.backgroundColor = [UIColor redColor];
        [selectBtn setTitle:@"选择档案" forState:UIControlStateNormal];
        selectBtn.tag = 101;
        [selectBtn addTarget:self action:@selector(didClickArchivesBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.selectBtn = selectBtn;
        [self.contentView addSubview:selectBtn];
        
        UIButton *delectBtn = [[UIButton alloc]init];
        delectBtn.backgroundColor = [UIColor redColor];
        [delectBtn setTitle:@"删除档案" forState:UIControlStateNormal];
        delectBtn.tag = 102;
        self.delectBtn = delectBtn;
        [delectBtn addTarget:self action:@selector(didClickArchivesBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:delectBtn];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor whiteColor];
        self.line = line;
        [self.contentView addSubview:line];
        
    }
    
    return self;
}

- (void)didClickArchivesBtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didClickArchives:andTag:)])
    {
        [self.delegate didClickArchives:self andTag:sender.tag];
    }
}

- (void)setupUI{
    [self.photoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.top.equalTo(self.contentView).offset(5);
        make.height.width.equalTo(@(90));
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoIcon).offset(16);
        make.left.equalTo(self.photoIcon.mas_right).offset(16);
    }];
    
    [self.sexLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nameLab.mas_bottom);
        make.left.equalTo(self.nameLab.mas_right).offset(16);
    }];
    
    [self.IDCardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab);
        make.top.equalTo(self.nameLab.mas_bottom).offset(8);
    }];
    
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab);
        make.top.equalTo(self.IDCardLab.mas_bottom).offset(8);
    }];
    
    [self.delectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.width.height.equalTo(@(100));
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.delectBtn.mas_left).offset(-1);
        make.centerY.equalTo(self.delectBtn);
        make.width.height.equalTo(@(100));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(10));
        make.left.right.bottom.equalTo(self.contentView);
    }];
}

- (void)setModel:(ArchivesModel *)model{
    _model = model;
    
    self.nameLab.text = model.Name;
    self.IDCardLab.text = model.IdCard;
    self.dateLab.text = model.ExamTime;
    self.sexLab.text = [model.Sex isEqualToString:@"1"] ? @"男": @"女";
//     UIImage *image = [UIImage imageWithData: imageData];
    if (model.Photo != nil && model.Photo.length != 0) {
        [self.photoIcon setImage:[UIImage imageWithData:model.Photo] forState:UIControlStateNormal];
    }else {
        [self.photoIcon setImage:[UIImage imageNamed:@"avatar"] forState:UIControlStateNormal];
    }
    
    
}

//设置头像
- (void)didClickPhotoImgV:(UIButton *)sender{
    NSLog(@"设置头像");
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setupUI];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
