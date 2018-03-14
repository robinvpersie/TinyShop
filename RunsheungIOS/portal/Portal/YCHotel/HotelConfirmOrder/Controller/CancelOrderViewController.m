//
//  CancelOrderViewController.m
//  Portal
//
//  Created by ifox on 2017/4/15.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "CancelOrderViewController.h"
#import "HotelCancelTableView.h"

@interface CancelOrderViewController ()

@end

@implementation CancelOrderViewController {
    HotelCancelTableView *cancel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"SMCancelOrderButtonTitle", nil);
    
    cancel = [[HotelCancelTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    cancel.orderDetail = self.orderDetail;
    [self.view addSubview:cancel];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)requestData {
        [YCHotelHttpTool hotelGetRefundMoneyWithOrderID:_orderDetail.orderID success:^(id response) {
            NSLog(@"%@",response);
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSDictionary *data = response[@"data"];
                NSString *detail = data[@"Detailed"];
                NSString *money = data[@"refund_amount"];
                cancel.detail = detail;
                cancel.refundMoney = money;
            }
        } failure:^(NSError *err) {
            
        }];
}



@end
