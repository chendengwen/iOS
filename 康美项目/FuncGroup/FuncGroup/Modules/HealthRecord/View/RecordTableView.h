//
//  RecordTableView.h
//  FuncGroup
//
//  Created by gary on 2017/2/20.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "HealthRecordInteractor.h"

@class RecordTableView;
@class DBHealthRecordController;

@protocol RecordTableViewDelegate <NSObject>

@optional
-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(RecordTableView *)aView;

-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(RecordTableView *)aView;

-(void)refreshData:(void(^)())complete FromView:(RecordTableView *)aView;

@end

@protocol RecordTableViewDataSource <NSObject>

@required
-(CGFloat)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(RecordTableView *)aView;
-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(RecordTableView *)aView;

@optional
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(RecordTableView *)aView;

@end

@interface RecordTableView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataArray;

@property (nonatomic,assign) id<RecordTableViewDataSource> dataSource;
@property (nonatomic,assign) id<RecordTableViewDelegate>  delegate;
@property (nonatomic, strong) DBHealthRecordController *dbController;

//@property (assign) HealthRecordType type;

/**
 *  是否第一次加载
 */
@property (nonatomic,assign) BOOL secondLoading;

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) NSMutableDictionary *paramsDic;

/*!
 @property  NSInteger tag
 @brief     用来标示 operation 的 key
 */
@property (nonatomic, assign) NSInteger operationTag;

/*!
 @property  NSInteger pageIndex
 @brief     页码
 */
@property (nonatomic, assign) NSInteger pageIndex;

/*!
 @property  BOOL pullDown
 @brief     上拉还是下拉
 */
@property (nonatomic, assign) BOOL pullDown;

/*!
 @property  BOOL isLoading
 @brief     是否正在刷新
 */
@property (nonatomic, assign) BOOL isLoading;

/*!
 @property  BOOL isShowing
 @brief     是否是当前显示页
 */
@property (nonatomic, assign) BOOL isShowing;

/*!
 @property  BOOL canLoadMore
 @brief     能否加载更多
 */
@property (nonatomic, assign) BOOL canLoadMore;

/*!
 @brief     无数据的文字提示
 */
@property (nonatomic,copy) NSString *noDataMsg;

/*!
 @brief     按钮的文字
 */
@property (nonatomic,copy) NSString *btnMsg;

- (id)initWithFrame:(CGRect)frame headView:(BOOL)withHeader footView:(BOOL)withFooter;

// 下拉刷新
- (void)addHeader;

// 上拉刷新
- (void)addFooter;

/**
 *  加载数据，没有刷新的UI效果
 */
-(void)loadData;

/**
 *  重新请求，重载数据
 */
-(void)reloadData;

/**
 *  封装所需的参数
 *
 *  @return <#return value description#>
 */
-(NSDictionary *)fetchParams;

/*
 *  结束请求
 */
-(void)endRefresh;

@end
