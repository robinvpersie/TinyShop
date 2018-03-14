//
//  SupermarketLimitBuyController.m
//  Portal
//
//  Created by ifox on 2016/12/29.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketLimitBuyController.h"
#import "SupermarketLimitBuyTableView.h"

@interface SupermarketLimitBuyController ()

@property(nonatomic, strong) SupermarketLimitBuyTableView *tableview;

@end

@implementation SupermarketLimitBuyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"限量抢购";
    self.view.backgroundColor = BGColor;
    
    [self initViews];
    
    // Do any additional setup after loading the view.
}

- (void)initViews {
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, APPScreenWidth, 35)];
    msgLabel.backgroundColor = [UIColor whiteColor];
    msgLabel.text = @"     抢购中,先购先得!";
    msgLabel.font = [UIFont systemFontOfSize:15];
    msgLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:msgLabel];
    
    _tableview = [[SupermarketLimitBuyTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(msgLabel.frame), self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
