//
//  ViewController.m
//  FYColumnsTableView
//
//  Created by laizw on 2017/9/7.
//  Copyright © 2017年 laizw. All rights reserved.
//

#import "ViewController.h"
#import "ViewController1.h"
#import "ViewController2.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonAction:(UIButton *)sender {
    if (sender.tag == 0) {
        ViewController1 *vc = [[ViewController1 alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ViewController2 *vc = [[ViewController2 alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
