//
//  ViewController1.m
//  FYColumnsTableView
//
//  Created by laizw on 2017/9/7.
//  Copyright © 2017年 laizw. All rights reserved.
//

#import "ViewController1.h"
#import "FYColumnsTableView.h"

@interface ViewController1 () <FYColumnsTableViewDelegate>

@end

@implementation ViewController1


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    FYColumnsTableView *tableView = [[FYColumnsTableView alloc] initWithFrame:self.view.bounds];
    tableView.columns = 2;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView reloadData];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:tableView action:@selector(reloadData)];
    self.navigationItem.rightBarButtonItem = right;
}


#pragma mark - FYColumnsTableViewDelegate
- (NSInteger)tableView:(FYColumnsTableView *)tableView numberOfRowsInSection:(NSInteger)section columns:(NSUInteger)columns {
    return [[self datasForColums:columns records:tableView.selectRecords] count];
}

- (UITableViewCell *)tableView:(FYColumnsTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath inColumns:(NSUInteger)columns {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" inColumns:columns];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    NSArray *datas = [self datasForColums:columns records:tableView.selectRecords];
    cell.textLabel.text = datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(FYColumnsTableView *)tableView widthForColumns:(NSUInteger)columns {
    return columns == 0 ? 100 : 150;
}

- (void)tableView:(FYColumnsTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath inColumns:(NSUInteger)columns {
    NSLog(@"%@", [tableView.selectRecords valueForKeyPath:@"row"]);
}

#pragma mark - Private
- (NSArray *)datasForColums:(NSUInteger)columns records:(NSArray *)records {
    static NSDictionary *cityDict = nil;
    static NSArray *cityKeys = nil;
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
        cityDict = [NSDictionary dictionaryWithContentsOfFile:path];
        cityKeys =  cityDict.allKeys;
    });
    
    if (columns == 0) {
        return cityKeys;
    } else {
        NSInteger select = [records[0] row];
        NSString *key = cityKeys[select];
        return cityDict[key];
    }
}

@end
