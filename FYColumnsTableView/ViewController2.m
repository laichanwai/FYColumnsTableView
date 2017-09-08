//
//  ViewController2.m
//  FYColumnsTableView
//
//  Created by laizw on 2017/9/7.
//  Copyright © 2017年 laizw. All rights reserved.
//

#import "ViewController2.h"
#import "FYColumnsTableView.h"

@interface ViewController2 () <FYColumnsTableViewDelegate>
@property (nonatomic, copy) NSDictionary *citys;
@property (nonatomic, copy) NSArray *allkeys;
@property (nonatomic, strong) NSNumber *total;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    FYColumnsTableView *tableView = [[FYColumnsTableView alloc] initWithFrame:frame];
    tableView.columns = 2;
    tableView.delegate = self;
    tableView.relactive = YES;
    [self.view addSubview:tableView];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:tableView action:@selector(reloadData)];
    self.navigationItem.rightBarButtonItem = right;
}


#pragma mark - FYColumnsTableViewDelegate
- (NSInteger)tableView:(FYColumnsTableView *)tableView numberOfSectionsInColumns:(NSUInteger)columns {
    if (columns == 0) {
        return 1;
    } else {
        return self.allkeys.count;
    }
}

- (NSInteger)tableView:(FYColumnsTableView *)tableView numberOfRowsInSection:(NSInteger)section columns:(NSUInteger)columns {
    if (columns == 0) {
        return self.allkeys.count;
    } else {
        NSString *key = self.allkeys[section];
        return [self.citys[key] count];
    }
}

- (UITableViewCell *)tableView:(FYColumnsTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath inColumns:(NSUInteger)columns {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" inColumns:columns];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    NSArray *datas;
    if (columns != 0) {
        NSString *key = self.allkeys[indexPath.section];
        datas = self.citys[key];
    } else {
        datas = self.allkeys;
    }
    cell.textLabel.text = datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(FYColumnsTableView *)tableView heightForHeaderInSection:(NSInteger)section columns:(NSUInteger)columns {
    return columns == 0 ? 0 : 20;
}

- (CGFloat)tableView:(FYColumnsTableView *)tableView widthForColumns:(NSUInteger)columns {
    return columns == 0 ? 100 : 150;
}

- (void)tableView:(FYColumnsTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath inColumns:(NSUInteger)columns {
    NSLog(@"%@", [tableView.selectRecords valueForKeyPath:@"row"]);
}

#pragma mark - Private
- (void)loadData {
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
        self.citys = [NSDictionary dictionaryWithContentsOfFile:path];
        self.allkeys = [self.citys.allKeys sortedArrayUsingSelector:@selector(compare:)];
    });
}

@end
