//
//  RSMineController.m
//  Portal
//
//  Created by zhengzeyou on 2017/12/29.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "RSMineController.h"

@interface RSMineController ()

@end

@implementation RSMineController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNav];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    
}
- (void)setNav{
    

    [self.tabBarController.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleView.textColor = RGB(16, 16, 16);
    titleView.text = @"我";
    titleView.textAlignment = NSTextAlignmentCenter;
    self.tabBarController.navigationItem.titleView = titleView;
	
    
}
@end
