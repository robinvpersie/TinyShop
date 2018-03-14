//
//  HotelCancelTableView.m
//  Portal
//
//  Created by ifox on 2017/4/15.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelCancelTableView.h"
#import "YYTextView.h"
#import "UIButton+CreateButton.h"
#import "UIView+ViewController.h"

@interface HotelCancelTableView() <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) YYTextView *textView;

@end

@implementation HotelCancelTableView {
    NSArray *_cancelInfo;
    NSArray *_refundWay;
    NSArray *_cancelReason;
    UIImageView *_checkImageView;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _cancelInfo = @[NSLocalizedString(@"HotelCancelOrderInfo_0", nil),NSLocalizedString(@"HotelCancelOrderInfo_1", nil),NSLocalizedString(@"HotelCancelOrderInfo_2", nil)];
        _refundWay = @[NSLocalizedString(@"HotelCancelOrderRefund_01", nil),NSLocalizedString(@"HotelCancelOrderRefund_02", nil)];
        _cancelReason = @[NSLocalizedString(@"HotelCancelOrderReason_0", nil),NSLocalizedString(@"HotelCancelOrderReason_1", nil),NSLocalizedString(@"HotelCancelOrderReason_2", nil),NSLocalizedString(@"HotelCancelOrderReason_3", nil),NSLocalizedString(@"HotelCancelOrderReason_4", nil),NSLocalizedString(@"HotelCancelOrderReason_5", nil),NSLocalizedString(@"HotelCancelOrderReason_6", nil)];
        self.backgroundColor = BGColor;
        self.dataSource = self;
        self.delegate = self;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 80)];
        footer.backgroundColor = BGColor;
        
        _checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(APPScreenWidth - 10 - 20, 10, 20, 20)];
        _checkImageView.image = [UIImage imageNamed:@"icon_selected"];
        
        UIButton *confirmCancel = [UIButton createButtonWithFrame:CGRectMake(0, 0, APPScreenWidth, 40) title:NSLocalizedString(@"HotelCancelOrderTitle", nil) titleColor:[UIColor redColor] titleFont:[UIFont systemFontOfSize:14] backgroundColor:[UIColor whiteColor]];
//        confirmCancel.layer.borderWidth = 1.0f;
//        confirmCancel.layer.borderColor = RGB(235, 235, 235).CGColor;
        [confirmCancel addTarget:self action:@selector(confirmCancelOrder) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:confirmCancel];
        self.tableFooterView = footer;
    }
    return self;
}

- (void)confirmCancelOrder {
    UIView *view = _checkImageView.superview.superview;
    NSString *reason;
    if ([view isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)view;
        reason = cell.textLabel.text;
    }
    NSString *context = self.textView.text;
    if (context.length == 0) {
        context = @"";
    }
    [YCHotelHttpTool hotelCancelOrderWithOrderID:_orderDetail.orderID cancelReason:reason cancelContext:context success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"msg"]];
            [self performSelector:@selector(popToRootController) withObject:nil afterDelay:2];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)popToRootController {
    [self.viewController.navigationController popToRootViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 1) {
        return 105;
    }
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 7;
    } else if (section == 3) {
        return 2;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.textColor = HotelBlackColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    } else {
        cell.textLabel.textColor = HotelLightGrayColor;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = _cancelInfo[indexPath.row];
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",self.refundMoney];
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        }
        if (indexPath.row == 2) {
            cell.detailTextLabel.text = self.detail;
            cell.detailTextLabel.textColor = [UIColor darkGrayColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        }
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = _refundWay[indexPath.row];
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = NSLocalizedString(@"HotelCancelMsg_0", nil);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = _cancelReason[indexPath.row];
        if (indexPath.row == 1) {
            [cell.contentView addSubview:_checkImageView];
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"HotelCancelMsg_1", nil);
        } else {
            YYTextView *textView = [[YYTextView alloc] initWithFrame:CGRectMake(10, 5, APPScreenWidth - 20, 100)];
            textView.placeholderText = NSLocalizedString(@"HotelCancelMsg_2", nil);
            textView.placeholderFont = [UIFont systemFontOfSize:14];
            textView.font = [UIFont systemFontOfSize:14];
            textView.layer.borderColor = RGB(235, 235, 235).CGColor;
            textView.layer.borderWidth = 0.7f;
            self.textView = textView;
            [cell.contentView addSubview:textView];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row != 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.contentView addSubview:_checkImageView];
    }
}

- (void)setRefundMoney:(NSString *)refundMoney {
    _refundMoney = refundMoney;
    [self reloadData];
}

- (void)setDetail:(NSString *)detail {
    _detail = detail;
    [self reloadData];
}

@end
