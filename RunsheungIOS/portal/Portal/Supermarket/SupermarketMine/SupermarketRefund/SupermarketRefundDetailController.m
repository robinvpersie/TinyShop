//
//  SupermarketRefundDetailController.m
//  Portal
//
//  Created by ifox on 2017/3/17.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketRefundDetailController.h"
#import "RefundDetailTableView.h"
#import "RefundDetailModel.h"

@interface SupermarketRefundDetailController ()

@property(nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation SupermarketRefundDetailController {
    RefundDetailTableView *tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = @[].mutableCopy;
    
    self.title = NSLocalizedString(@"SMRefundDetailTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    tableView = [[RefundDetailTableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    [self requestData];
}

- (void)requestData {
    [KLHttpTool supermarketgetRefundDetailWithRefundNo:_refundNo success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *data = response[@"data"];
            if (data.count > 0) {
                for (NSDictionary *dic in data) {
                    RefundDetailModel *model = [NSDictionary getRefundDetailModelWithDic:dic];
                    [_dataArr addObject:model];
                }
            }
            tableView.dataArr = _dataArr;
        }
    } failure:^(NSError *err) {
        
    }];
}
@end
