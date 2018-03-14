//
//  SupermarketWaitSendController.m
//  Portal
//
//  Created by ifox on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketWaitSendController.h"

@interface SupermarketWaitSendController ()

@property(nonatomic, strong) NSArray *dataArray;

@end

@implementation SupermarketWaitSendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self chageView];
    // Do any additional setup after loading the view.
}

- (void)chageView {
    if (_dataArray.count > 0) {
        //        [self createView];
        //        _orderTableView.dataArray = _dataArray;
    } else {
        [self createEmptyView];
    }
}

- (void)createEmptyView {
    UIImageView *empty = [[UIImageView alloc] init];
    empty.bounds = CGRectMake(0, 0, APPScreenWidth/4, APPScreenWidth/4);
    empty.center = CGPointMake(self.view.center.x, self.view.center.y - 80);
    empty.backgroundColor = [UIColor whiteColor];
    empty.contentMode = UIViewContentModeScaleAspectFit;
    empty.image = [UIImage imageNamed:@"no_order"];
    [self.view addSubview:empty];
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(empty.frame)+15, APPScreenWidth, 20)];
    msg.textColor = RGB(225, 225, 225);
    msg.text = @"您还没有相关订单~";
    msg.textAlignment = NSTextAlignmentCenter;
    msg.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:msg];
    
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
