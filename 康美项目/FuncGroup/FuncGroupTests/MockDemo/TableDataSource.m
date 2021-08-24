//
//  TableDataSource.m
//  FuncGroup
//
//  Created by gary on 2017/3/27.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "TableDataSource.h"

@interface TableDataSource()
{
    NSMutableArray *_dataArray;
    NSString *_cellID;
    TableViewCellConfigureBlock _block;
}

@end

@implementation TableDataSource

-(instancetype)initWithItems:(NSArray *)arr CellIdentifier:(NSString *)identifier ConfigureCellBlock:(TableViewCellConfigureBlock)block{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
        _cellID = identifier;
        _block = block;
    }
    
    return self;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellID];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellID];
    }
    
    _block(cell,self);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

@end
