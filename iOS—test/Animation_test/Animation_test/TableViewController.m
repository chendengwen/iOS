//
//  TableViewController.m
//  UI_test
//
//  Created by gary on 2021/10/20.
//

#import "TableViewController.h"


@interface CellModel : NSObject

+(CellModel *)modelWith:(NSString *)title class:(NSString *)clasName;

@end

@interface CellModel ()

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *className;

@end

@implementation CellModel

+(CellModel *)modelWith:(nonnull NSString *)title class:(nonnull NSString *)clasName {
    CellModel *model = [[CellModel alloc] init];
    model.title = title;
    model.className = clasName;
    return  model;
}

@end


@interface TableViewController ()
{
    NSArray<NSArray<CellModel *> *> *_titleArr;
}
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    _titleArr = @[
        @[
            [CellModel modelWith:@"UIView-transitionWithView" class:@"transitionWithView"],
            
        ],
        @[
            
            [CellModel modelWith:@"asyncAnimation-异步动画" class:@"asyncAnimation"],
        ]
    ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArr.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section == 0 ? @"UIView animation" : @"Core Animation";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _titleArr[section];
    return array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 36;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    CellModel *model = _titleArr[indexPath.section][indexPath.row];
    cell.textLabel.text = model.title;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CellModel *model = _titleArr[indexPath.section][indexPath.row];
    Class cls = NSClassFromString(model.className);
    UIViewController *ctl = [[cls alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

@end

