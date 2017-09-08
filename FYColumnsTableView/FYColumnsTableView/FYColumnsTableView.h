//
//  FYColumnsTableView.h
//  FYColumnsTableView
//
//  Created by laizw on 2017/9/7.
//  Copyright © 2017年 laizw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYColumnsTableView;
@protocol FYColumnsTableViewDelegate <NSObject>

@required
// 每列包含多少行
- (NSInteger)tableView:(FYColumnsTableView *)tableView numberOfRowsInSection:(NSInteger)section columns:(NSUInteger)columns;

// 每列 tableView 需要展示的 cell
- (UITableViewCell *)tableView:(FYColumnsTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath inColumns:(NSUInteger)columns;

@optional
// 列的个数
- (NSUInteger)numberOfColumnsInColumnsTableView:(FYColumnsTableView *)tableView;

// 每列之中分组的个数
- (NSInteger)tableView:(FYColumnsTableView *)tableView numberOfSectionsInColumns:(NSUInteger)columns;

// 选中事件
- (void)tableView:(FYColumnsTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath inColumns:(NSUInteger)columns;

// 列的宽度
- (CGFloat)tableView:(FYColumnsTableView *)tableView widthForColumns:(NSUInteger)columns;
// 行的高度
- (CGFloat)tableView:(FYColumnsTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath inColumns:(NSUInteger)columns;

// header | footer 的高度
- (CGFloat)tableView:(FYColumnsTableView *)tableView heightForHeaderInSection:(NSInteger)section columns:(NSUInteger)columns;
- (CGFloat)tableView:(FYColumnsTableView *)tableView heightForFooterInSection:(NSInteger)section columns:(NSUInteger)columns;

// HeaderFooterView
- (UIView *)tableView:(FYColumnsTableView *)tableView viewForHeaderInSection:(NSInteger)section columns:(NSUInteger)columns;
- (UIView *)tableView:(FYColumnsTableView *)tableView viewForFooterInSection:(NSInteger)section columns:(NSUInteger)columns;

// 自定义 tableView (自动缓存)
- (UITableView *)tableView:(FYColumnsTableView *)tableView customTableViewForColumns:(NSUInteger)columns;

@end

@interface FYColumnsTableView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSUInteger columns;   // 设置 列的个数
@property (nonatomic, assign, getter=isRelactive) BOOL relactive;   // 是否关联滚动
@property (nonatomic, weak) id<FYColumnsTableViewDelegate> delegate;

// 选中记录，记录每级选中的 indexPath
@property (nonatomic, copy, readonly) NSArray<NSIndexPath *> *selectRecords;

// 刷新、重置所有列（取消所有选中）
- (void)reloadData;
// 刷新某一列
- (void)reloadTableViewAtColumns:(NSUInteger)columns;
// 获取某一列对应的 tableView
- (UITableView *)tableViewAtColumns:(NSUInteger)columns;

// 重用 Cell
- (__kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier inColumns:(NSUInteger)columns;
// 重用 HeaderFooterView
- (__kindof UITableViewHeaderFooterView *)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier inColumns:(NSUInteger)columns;

@end
