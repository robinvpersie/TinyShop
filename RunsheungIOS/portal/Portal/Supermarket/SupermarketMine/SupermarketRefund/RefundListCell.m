//
//  RefundListCell.m
//  Portal
//
//  Created by ifox on 2017/3/20.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "RefundListCell.h"
#import "UILabel+CreateLabel.h"
#import "UIButton+CreateButton.h"
#import "UIView+ViewController.h"
#import "SupermarketRefundDetailController.h"
#import "AddExpressController.h"

#define ButtonWidth 80

@implementation RefundListCell {
    UILabel     *_timeLabel;
    UILabel     *_statusLabel;
    UIButton    *_cancelRefund;
    UIButton    *_checkProgress;
    UIButton    *_addExpress;
    UIButton    *_checkExpress;//查看物流
    UIImageView *_goodsImage;
    UILabel     *_titleLabel;
    
    UIView *_upLine;
    UIView *_downLine;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    if (_timeLabel == nil) {
        _timeLabel = [UILabel createLabelWithFrame:CGRectMake(15, 0, 250, 35) textColor:[UIColor darkcolor] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:@"订单时间: 2016-06-25"];
    }
    [self.contentView addSubview:_timeLabel];
    
    if (_statusLabel == nil) {
        _statusLabel = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth - 15 - 100, _timeLabel.frame.origin.y, 100, _timeLabel.frame.size.height) textColor:[UIColor redColor] font:_timeLabel.font textAlignment:NSTextAlignmentRight text:@"已申请"];
    }
    [self.contentView addSubview:_statusLabel];
    
    if (_upLine == nil) {
        _upLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_statusLabel.frame), APPScreenWidth, 0.7f)];
        _upLine.backgroundColor = RGB(225, 225, 225);
    }
    [self.contentView addSubview:_upLine];
    
    if (_goodsImage == nil) {
        _goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_upLine.frame)+5, 80, 80)];
        _goodsImage.backgroundColor = [UIColor orangeColor];
    }
    [self.contentView addSubview:_goodsImage];
    
    if (_titleLabel == nil) {
        _titleLabel = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(_goodsImage.frame)+10, _goodsImage.frame.origin.y, APPScreenWidth - 10 - 15 - CGRectGetMaxX(_goodsImage.frame), 40) textColor:[UIColor darkcolor] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:@"这是一个商品商品商品商品商品还是一个商品"];
        _titleLabel.numberOfLines = 0;
    }
    [self.contentView addSubview:_titleLabel];
    
    if (_downLine == nil) {
        _downLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_goodsImage.frame)+5, APPScreenWidth, 0.7f)];
        _downLine.backgroundColor = _upLine.backgroundColor;
    }
    [self.contentView addSubview:_downLine];
    
    if (_cancelRefund == nil) {
        _cancelRefund = [UIButton createButtonWithFrame:CGRectMake(APPScreenWidth - 15 - ButtonWidth, CGRectGetMaxY(_downLine.frame)+10 , ButtonWidth, 20) title:@"取消退款" titleColor:[UIColor darkcolor] titleFont:[UIFont systemFontOfSize:15] backgroundColor:[UIColor whiteColor]];
        _cancelRefund.hidden = YES;
        _cancelRefund.layer.borderWidth = 0.7f;
        [_cancelRefund addTarget:self action:@selector(cancelRefund) forControlEvents:UIControlEventTouchUpInside];
        _cancelRefund.layer.borderColor = [UIColor darkcolor].CGColor;
    }
    [self.contentView addSubview:_cancelRefund];
    
    if (_checkProgress == nil) {
        _checkProgress = [UIButton createButtonWithFrame:CGRectMake(CGRectGetMinX(_cancelRefund.frame) - 10 - 80, _cancelRefund.frame.origin.y, 80, _cancelRefund.frame.size.height) title:@"查看进程" titleColor:[UIColor darkcolor] titleFont:[UIFont systemFontOfSize:15] backgroundColor:[UIColor whiteColor]];
//        _checkProgress.hidden = YES;
        _checkProgress.layer.borderWidth = 0.7f;
        _checkProgress.layer.borderColor = [UIColor darkcolor].CGColor;
        [_checkProgress addTarget:self action:@selector(checkRefundProgress) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contentView addSubview:_checkProgress];
    
    if (_addExpress == nil) {
        _addExpress = [UIButton createButtonWithFrame:_cancelRefund.frame title:@"填写物流" titleColor:[UIColor darkcolor] titleFont:[UIFont systemFontOfSize:15] backgroundColor:[UIColor whiteColor]];
        _addExpress.hidden = YES;
        _addExpress.layer.borderWidth = 0.7f;
        _addExpress.layer.borderColor = [UIColor darkcolor].CGColor;
        [_addExpress addTarget:self action:@selector(addExpress) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contentView addSubview:_addExpress];
    
    if (_checkExpress == nil) {
        _checkExpress = [UIButton createButtonWithFrame:_cancelRefund.frame title:@"查看物流" titleColor:[UIColor darkcolor] titleFont:[UIFont systemFontOfSize:15] backgroundColor:[UIColor whiteColor]];
        _checkExpress.hidden = YES;
        _checkExpress.layer.borderWidth = 0.7f;
        _checkExpress.layer.borderColor = [UIColor darkcolor].CGColor;
    }
    [self.contentView addSubview:_checkExpress];
    
}

- (void)setData:(RefundListData *)data {
    _data = data;
    [UIImageView setimageWithImageView:_goodsImage UrlString:data.imageURl imageVersion:nil];
    _titleLabel.text = data.item_name;
    _timeLabel.text = [NSString stringWithFormat:@"申请时间: %@",data.applyTime];
    
    switch (data.status) {
        case 0:
            break;
        case 1:
            _statusLabel.text = NSLocalizedString(@"SMRefundStatus_1", nil);
            _cancelRefund.hidden = NO;
            break;
        case 2:
            _statusLabel.text = NSLocalizedString(@"SMRefundStatus_2", nil);
            _checkProgress.frame = _cancelRefund.frame;
            break;
        case 3:
            _statusLabel.text = NSLocalizedString(@"SMRefundStatus_3", nil);
            _addExpress.hidden = NO;
            break;
        case 4:
            _statusLabel.text = NSLocalizedString(@"SMRefundStatus_4", nil);
            _checkExpress.hidden = NO;
            break;
        case 5:
            _statusLabel.text = NSLocalizedString(@"SMRefundStatus_5", nil);
            _checkProgress.frame = _cancelRefund.frame;
            break;
        case 6:
            _statusLabel.text = NSLocalizedString(@"SMRefundStatus_6", nil);
            _checkProgress.frame = _cancelRefund.frame;
            break;
        case 7:
            _statusLabel.text = NSLocalizedString(@"SMRefundStatus_7", nil);
            _checkProgress.frame = _cancelRefund.frame;
            break;
        default:
            break;
    }
}

- (void)cancelRefund {
    [KLHttpTool supermarketApplayRefundWithOrderNumber:_data.orderNum itemCode:_data.itemCode reason:@"" refundNo:_data.refundNo isCancel:YES success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ReloadRefundListNotification object:nil];
            [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2.0 text:response[@"message"]];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)checkRefundProgress {
    SupermarketRefundDetailController *vc = [[SupermarketRefundDetailController alloc] init];
    vc.refundNo = _data.refundNo;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)addExpress {
    AddExpressController *vc = [[AddExpressController alloc] init];
    vc.refundNo = _data.refundNo;
    vc.itemCode = _data.itemCode;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
