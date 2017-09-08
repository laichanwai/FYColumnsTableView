//
//  FYColumnsTableView.m
//  FYColumnsTableView
//
//  Created by laizw on 2017/9/7.
//  Copyright © 2017年 laizw. All rights reserved.
//

#import "FYColumnsTableView.h"

@interface FYColumnsTableView ()
@property (nonatomic, strong) NSMutableArray<UITableView *> *tableViews;
@property (nonatomic, strong) NSMutableArray *records;
@end

@implementation FYColumnsTableView

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self reloadData];
}

#pragma mark - Public
- (void)reloadTableViewAtColumns:(NSUInteger)columns {
    if (columns < self.tableViews.count) {
        UITableView *tableView = self.tableViews[columns];
        if (!tableView.superview) {
            [self addSubview:tableView];
        }
        [tableView reloadData];
    }
}

- (void)reloadData {
    if ([self.delegate respondsToSelector:@selector(numberOfColumnsInColumnsTableView:)]) {
        self.columns = [self.delegate numberOfColumnsInColumnsTableView:self];
    }
    [self resetTableViews];
    if (self.isRelactive) {
        UITableView *tableView = [self tableViewAtColumns:0];
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (UITableView *)tableViewAtColumns:(NSUInteger)columns {
    if (columns < self.tableViews.count) {
        return self.tableViews[columns];
    }
    return nil;
}

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier inColumns:(NSUInteger)columns {
    if (columns < self.tableViews.count) {
        return [self.tableViews[0] dequeueReusableCellWithIdentifier:identifier];
    }
    return nil;
}

- (UITableViewHeaderFooterView *)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier inColumns:(NSUInteger)columns {
    if (columns < self.tableViews.count) {
        return [self.tableViews[0] dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    }
    return nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.delegate respondsToSelector:@selector(tableView:numberOfSectionsInColumns:)]) {
        return [self.delegate tableView:self numberOfSectionsInColumns:tableView.tag];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:numberOfRowsInSection:columns:)]) {
        return [self.delegate tableView:self numberOfRowsInSection:section columns:tableView.tag];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:inColumns:)]) {
        return [self.delegate tableView:self cellForRowAtIndexPath:indexPath inColumns:tableView.tag];
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    while (self.records.count > tableView.tag) {
        [self.records removeLastObject];
    }
    [self.records addObject:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:inColumns:)]) {
        [self.delegate tableView:self didSelectRowAtIndexPath:indexPath inColumns:tableView.tag];
    }
    
    if (self.isRelactive) {
        if (tableView.tag != self.columns - 1) {
            UITableView *next = [self tableViewAtColumns:tableView.tag + 1];
            [next scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    } else {
        // 展开下一级
        [self reloadTableViewAtColumns:tableView.tag + 1];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:inColumns:)]) {
        return [self.delegate tableView:self heightForRowAtIndexPath:indexPath inColumns:tableView.tag];
    } else {
        return 44.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:columns:)]) {
        return [self.delegate tableView:self heightForHeaderInSection:section columns:tableView.tag];
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:columns:)]) {
        return [self.delegate tableView:self heightForFooterInSection:section columns:tableView.tag];
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:columns:)]) {
        return [self.delegate tableView:self viewForHeaderInSection:section columns:tableView.tag];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:columns:)]) {
        return [self.delegate tableView:self viewForFooterInSection:section columns:tableView.tag];
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 0) return;
    if (!scrollView.dragging) return;
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)scrollView;
        UITableView *prevTable = [self tableViewAtColumns:tableView.tag - 1];
        
        NSIndexPath *cur = [tableView indexPathsForVisibleRows].firstObject;
        NSIndexPath *prev = [prevTable indexPathsForVisibleRows].firstObject;
        NSIndexPath *select = [NSIndexPath indexPathForRow:cur.section inSection:prev.section];
        [prevTable selectRowAtIndexPath:select animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

#pragma mark - Private
- (void)resetTableViews {
    if (self.columns > 0) {
        CGFloat width = self.frame.size.width / self.columns;
        CGFloat left = 0;
        for (int i = 0; i < self.columns; i++) {
            if ([self.delegate respondsToSelector:@selector(tableView:widthForColumns:)]) {
                width = [self.delegate tableView:self widthForColumns:i];
            }
            
            UITableView *tableView = [self buildTableViewForColumns:i];
            tableView.frame = CGRectMake(left, 0, width, self.frame.size.height);
            left = left + width;
            tableView.tag = i;
            
            if (tableView.superview) {
                [tableView removeFromSuperview];
            }
            if (self.isRelactive) {
                [self reloadTableViewAtColumns:i];
            }
        }
        if (!self.isRelactive) {
            [self reloadTableViewAtColumns:0];
        }
    } else {
        for (UITableView *tableView in self.tableViews) {
            [tableView removeFromSuperview];
        }
        [self.tableViews removeAllObjects];
    }
}

- (UITableView *)buildTableViewForColumns:(NSUInteger)columns {
    UITableView *tableView = nil;
    if (self.tableViews.count <= columns) {
        if ([self.delegate respondsToSelector:@selector(tableView:customTableViewForColumns:)]) {
            tableView = [self.delegate tableView:self customTableViewForColumns:columns];
        } else {
            tableView = [[UITableView alloc] initWithFrame:CGRectZero];
            tableView.tableFooterView = [UIView new];
        }
        [self registerTableView:tableView];
        [self.tableViews addObject:tableView];
    } else {
        tableView = self.tableViews[columns];
    }
    return tableView;
}

- (void)registerTableView:(UITableView *)tableView {
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
}

#pragma mark - Getter && Setter
- (NSArray *)selectRecords {
    return [self.records copy];
}

- (NSMutableArray *)records {
    if (!_records) {
        _records = @[].mutableCopy;
    }
    return _records;
}

- (NSMutableArray *)tableViews {
    if (!_tableViews) {
        _tableViews = @[].mutableCopy;
    }
    return _tableViews;
}

@end
