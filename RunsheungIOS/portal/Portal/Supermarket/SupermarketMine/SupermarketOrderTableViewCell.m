//
//  SupermarketOrderTableViewCell.m
//  Portal
//
//  Created by ifox on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketOrderTableViewCell.h"
#import "SupermarketMyOrderGoodListView.h"
#import "SupermarketOrderData.h"
#import "SupermarketChekRefundProgressController.h"
#import "SupermarketReleaseCommentController.h"
#import "CountDown.h"
#import "CYPasswordView.h"
#include <CommonCrypto/CommonDigest.h>
#import "SupermarketApplyRefundController.h"
#import "NSDate+YCAddtion.h"
#import "SupermarketOrderWaitPayDetailController.h"
#import "SupermarketConfrimOrderByNumbersController.h"

#define ButtonWidth 80
#define CellHeight  110

@interface SupermarketOrderTableViewCell ()

@property (nonatomic, strong) CYPasswordView *passwordView;

@end

@implementation SupermarketOrderTableViewCell {
    UILabel  *_timeLabel;
    UILabel  *_statusLabel;//订单状态显示,包括卖家已发货,已完成等
    UILabel  *_countAmountLabel;//总计商品数量和总价格
    
    UIButton *_pay;//付款
    UIButton *_cancelOrder;//取消订单
    
    UIButton *_remindSend;//提醒发货
    
    UIButton *_pickConfirmReceive;//待自提确认收货
    
    UIButton *_checklogistics;//查看物流(此处改为退款)
    UIButton *_confirmReceive;//确认收货
    
    UIButton *_editComment;//修改评价
    UIButton *_comment;//评价
    
    UIButton *_checkProgress;//查看退款进程
    
    UIButton *_deleteOrder;//删除订单
    
    UIButton *_buyAgain;//再次购买
    
    UIView *upLine;
    
    UIView *line;
    
    SupermarketMyOrderGoodListView *_goodListView;
    
    CountDown *_countDown;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    if (_countDown == nil) {
        _countDown = [[CountDown alloc] init];
    }
    
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, APPScreenWidth, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [UIColor darkGrayColor];
    }
    [self.contentView addSubview:_timeLabel];
    
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(APPScreenWidth - 15 - 200, _timeLabel.frame.origin.y, 200, _timeLabel.frame.size.height)];
        _statusLabel.textColor = [UIColor redColor];
        _statusLabel.font = [UIFont systemFontOfSize:16];
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    [self.contentView addSubview:_statusLabel];
    
    if (_goodListView == nil) {
        _goodListView = [[SupermarketMyOrderGoodListView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_statusLabel.frame)+10, APPScreenWidth, 0)];
    }
    [self.contentView addSubview:_goodListView];
    
    if (_countAmountLabel == nil) {
        _countAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_goodListView.frame)+10, APPScreenWidth - 15, 20)];
        _countAmountLabel.font = [UIFont systemFontOfSize:14];
        _countAmountLabel.textColor = [UIColor darkGrayColor];
        _countAmountLabel.textAlignment = NSTextAlignmentRight;
    }
    [self.contentView addSubview:_countAmountLabel];
    
    if (line == nil) {
        line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_countAmountLabel.frame)+10, APPScreenWidth, 1.0f)];
        line.backgroundColor = BGColor;
    }
        [self.contentView addSubview:line];
    
    if (_checklogistics == nil) {
        
        _checklogistics = [self createButtonWithFrame:CGRectMake(APPScreenWidth - ButtonWidth*2 - 30,CGRectGetMaxY(line.frame) + 15, ButtonWidth, 25) title:@"退款/退货" layerColor:[UIColor darkGrayColor]];
        _checklogistics.hidden = YES;
        [_checklogistics addTarget:self action:@selector(goRefund) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (_confirmReceive == nil) {
        _confirmReceive = [self createButtonWithFrame:CGRectMake(APPScreenWidth - ButtonWidth - 15, _checklogistics.frame.origin.y, ButtonWidth, _checklogistics.frame.size.height) title:NSLocalizedString(@"SupermarketConfirmReceiveButtonTitle", nil) layerColor:[UIColor redColor]];
        [_confirmReceive addTarget:self action:@selector(confirmReciveGoods) forControlEvents:UIControlEventTouchUpInside];
        _confirmReceive.hidden = YES;
    }
    [self.contentView addSubview:_confirmReceive];
    
    if (_pay == nil) {
        _pay = [self createButtonWithFrame:CGRectMake(APPScreenWidth - ButtonWidth - 15, _checklogistics.frame.origin.y, ButtonWidth, _checklogistics.frame.size.height) title:@"付款" layerColor:[UIColor redColor]];
        [_pay addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        _pay.hidden = YES;
    }
    [self.contentView addSubview:_pay];
    
    if (_cancelOrder == nil) {
        _cancelOrder = [self createButtonWithFrame:CGRectMake(CGRectGetMinX(_pay.frame) - 15 - ButtonWidth, _pay.frame.origin.y, ButtonWidth, _pay.frame.size.height) title:NSLocalizedString(@"SMCancelOrderButtonTitle", nil) layerColor:[UIColor darkGrayColor]];
        [_cancelOrder addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
        _cancelOrder.hidden = YES;
    }
    [self.contentView addSubview:_cancelOrder];
    
    if (_remindSend == nil) {
        _remindSend = [self createButtonWithFrame:CGRectMake(APPScreenWidth - ButtonWidth - 15, _checklogistics.frame.origin.y, ButtonWidth, _checklogistics.frame.size.height) title:@"提醒发货" layerColor:[UIColor darkGrayColor]];
        [_remindSend addTarget:self action:@selector(remindSend:) forControlEvents:UIControlEventTouchUpInside];
        _remindSend.hidden = YES;
    }
    [self.contentView addSubview:_remindSend];
    
    if (_pickConfirmReceive == nil) {
        _pickConfirmReceive = [self createButtonWithFrame:CGRectMake(APPScreenWidth - ButtonWidth - 15, _checklogistics.frame.origin.y, ButtonWidth, _checklogistics.frame.size.height) title:NSLocalizedString(@"SupermarketConfirmReceiveButtonTitle", nil) layerColor:[UIColor darkGrayColor]];
        _pickConfirmReceive.hidden = YES;
        
    }
    [self.contentView addSubview:_pickConfirmReceive];
    
    if (_editComment == nil) {
        _editComment = [self createButtonWithFrame:CGRectMake(APPScreenWidth - ButtonWidth*2 - 30,CGRectGetMaxY(line.frame) + 15, ButtonWidth, 25) title:@"修改评价" layerColor:[UIColor darkGrayColor]];
        _editComment.hidden = YES;
    }
    
    if (_comment == nil) {
        _comment = [self createButtonWithFrame:CGRectMake(APPScreenWidth - ButtonWidth - 15, _checklogistics.frame.origin.y, ButtonWidth, _checklogistics.frame.size.height) title:NSLocalizedString(@"SMCommentButtonTitle", nil) layerColor:[UIColor redColor]];
        [_comment addTarget:self action:@selector(newComment) forControlEvents:UIControlEventTouchUpInside];
        _comment.hidden = YES;
    }
    [self.contentView addSubview:_comment];
    
    if (_buyAgain == nil) {
        _buyAgain = [self createButtonWithFrame:CGRectMake(0, 0, ButtonWidth, _checklogistics.frame.size.height) title:@"再次购买" layerColor:[UIColor redColor]];
        [_buyAgain addTarget:self action:@selector(buyAgain) forControlEvents:UIControlEventTouchUpInside];
        _buyAgain.hidden = YES;
    }
    [self.contentView addSubview:_buyAgain];
    
    if (_checkProgress == nil) {
        _checkProgress = [self createButtonWithFrame:CGRectMake(APPScreenWidth - ButtonWidth - 15, _checklogistics.frame.origin.y, ButtonWidth, _checklogistics.frame.size.height) title:@"查看进程" layerColor:[UIColor darkGrayColor]];
        [_checkProgress addTarget:self action:@selector(goCheckRefund) forControlEvents:UIControlEventTouchUpInside];
        _checkProgress.hidden = YES;
    }
    [self.contentView addSubview:_checkProgress];
    
    if (_deleteOrder == nil) {
        _deleteOrder = [self createButtonWithFrame:CGRectMake(APPScreenWidth - ButtonWidth - 15, _checklogistics.frame.origin.y, ButtonWidth, _checklogistics.frame.size.height) title:@"删除订单" layerColor:[UIColor darkGrayColor]];
        [_deleteOrder addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchUpInside];
        _deleteOrder.hidden = YES;
    }
    [self.contentView addSubview:_deleteOrder];
    
    if (upLine == nil) {
        upLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_timeLabel.frame) + 5, APPScreenWidth, 1.0f)];
        upLine.backgroundColor = BGColor;
    }
    [self.contentView addSubview:upLine];
    
}

- (void)setData:(SupermarketOrderData *)data {
    _data = data;
    NSArray *list = data.goodList;
    
    _goodListView.goodsListArray = list;
    
    _timeLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"SMOrderTime", nil),data.time];
    _countAmountLabel.text = [NSString stringWithFormat:@"%@ %ld %@ %.2f",NSLocalizedString(@"SMOderCountTotal_0", nil),data.goodsCount,NSLocalizedString(@"SMOrderCountTotal_1", nil),data.totalPrice];

    
    CGRect listFrame = _goodListView.frame;
    listFrame.size.height = list.count *  CellHeight + (list.count - 1)*5;
    _goodListView.frame = listFrame;
    
    _countAmountLabel.frame = CGRectMake(0, CGRectGetMaxY(_goodListView.frame)+10, APPScreenWidth - 15, 20);
    line.frame = CGRectMake(0, CGRectGetMaxY(_countAmountLabel.frame)+10, APPScreenWidth, 1.0f);
    
    _checklogistics.frame = CGRectMake(APPScreenWidth - ButtonWidth*2 - 30,CGRectGetMaxY(line.frame) + 15, ButtonWidth, 25);
    _confirmReceive.frame = CGRectMake(APPScreenWidth - ButtonWidth - 15, _checklogistics.frame.origin.y, ButtonWidth, _checklogistics.frame.size.height);
    _pay.frame = _confirmReceive.frame;
    _pickConfirmReceive.frame = _pay.frame;
    _editComment.frame = _checklogistics.frame;
    _comment.frame = _confirmReceive.frame;
    _remindSend.frame = _pay.frame;
    _checkProgress.frame = _pay.frame;
    
    if (data.canDeleteOrder.integerValue == 1) {
        _deleteOrder.hidden = NO;
    }
    
    if (data.canBuyAgain.integerValue == 1) {
        _buyAgain.hidden = NO;
    }
    
    __weak __typeof(self) weakSelf= self;
//    NSString *invalidDate = [self getNowTimeWithString:_data.invalid_date];
    switch (data.status) {
        case OrderWaitPay:
            
            if (data.syncPaymentStatus.integerValue == 1) {
                _statusLabel.text = NSLocalizedString(@"SMOrderPayedStatus", nil);
                _cancelOrder.frame = CGRectMake(APPScreenWidth - ButtonWidth - 15, _checklogistics.frame.origin.y, ButtonWidth, _checklogistics.frame.size.height);
                [_cancelOrder setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                _cancelOrder.layer.borderColor = [UIColor redColor].CGColor;
                 _cancelOrder.hidden = NO;
                _deleteOrder.frame = CGRectMake(CGRectGetMinX(_cancelOrder.frame)-15 - ButtonWidth, _cancelOrder.frame.origin.y, ButtonWidth, _cancelOrder.frame.size.height);
            } else
            
            ///每秒回调一次
        {
            NSMutableString *date = [NSMutableString stringWithString:data.invalid_date];
           NSString *str3 = [date stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            
            NSDate *startDate = [self getDateWithString:_data.severTime];
            NSDate *endDate = [self getDateWithString:_data.invalid_date];
            
            [_countDown countDownWithStratDate:startDate finishDate:endDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
                if (day > 0 || hour > 0 || minute > 0 || second > 0) {
                    [_pay setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    _pay.frame = CGRectMake(APPScreenWidth - 160 - 15, _checklogistics.frame.origin.y, 160, _checklogistics.frame.size.height);
                    [_pay setTitle:[NSString stringWithFormat:@"%@%ld分%ld秒)",NSLocalizedString(@"SMGoPayMsg", nil),minute,second] forState:UIControlStateNormal];
                    _statusLabel.text = NSLocalizedString(@"SMOrderWaitPayStatus", nil);
                    _deleteOrder.frame = CGRectMake(CGRectGetMinX(_pay.frame)-15 - ButtonWidth, _pay.frame.origin.y, ButtonWidth, _pay.frame.size.height);

                    if (data.paymentStatus == PaymentStatusNO /*&& data.expressStatus == ExpressWaitSend*/) {
                        _cancelOrder.frame = CGRectMake(CGRectGetMinX(_pay.frame) - 15 - ButtonWidth, _pay.frame.origin.y, ButtonWidth, _pay.frame.size.height);
                        _cancelOrder.hidden = NO;
                    }
                } else {
                    [_pay setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [_pay setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [_pay setTitle:@"再次购买" forState:UIControlStateNormal];
                    _pay.hidden = YES;
                    _buyAgain.frame = _pay.frame;
                    [_pay removeTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
                    _statusLabel.text = NSLocalizedString(@"SMOrderOverTimeStatus", nil);
                    [_pay addTarget:self action:@selector(buyAgain) forControlEvents:UIControlEventTouchUpInside];
                    _deleteOrder.frame = CGRectMake(CGRectGetMinX(_pay.frame)- 15 - ButtonWidth, _pay.frame.origin.y, ButtonWidth, _pay.frame.size.height);
                }
            }];
            
            _pay.hidden = NO;
        }
            
            break;

        case OrderWaitReceive:
//            if (data.paymentStatus == PaymentStatusYES && data.expressStatus == ExpressWaitSend) {
//                _statusLabel.text = @"买家已付款";
//                _cancelOrder.frame = CGRectMake(APPScreenWidth - ButtonWidth - 15, _checklogistics.frame.origin.y, ButtonWidth, _checklogistics.frame.size.height);
//                [_cancelOrder setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//                _cancelOrder.layer.borderColor = [UIColor redColor].CGColor;
//                _cancelOrder.hidden = NO;
//            }
//            if (data.paymentStatus == PaymentStatusYES && data.expressStatus == ExpressHaveSend) {
//                _statusLabel.text = @"等待买家收货";
//                _confirmReceive.hidden = NO;
//                _checklogistics.hidden = NO;
//            }
            _statusLabel.text = NSLocalizedString(@"SMOrderPayedStatus", nil);
            _cancelOrder.frame = CGRectMake(APPScreenWidth - ButtonWidth - 15, _checklogistics.frame.origin.y, ButtonWidth, _checklogistics.frame.size.height);
            [_cancelOrder setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _cancelOrder.layer.borderColor = [UIColor redColor].CGColor;
            _cancelOrder.hidden = NO;
            
            if (_buyAgain.hidden == NO) {
                _buyAgain.frame = CGRectMake(CGRectGetMinX(_cancelOrder.frame)- 15 - ButtonWidth, _cancelOrder.frame.origin.y, ButtonWidth, _cancelOrder.frame.size.height);
                _deleteOrder.frame = CGRectMake(CGRectGetMinX(_buyAgain.frame)- 15 - ButtonWidth, _cancelOrder.frame.origin.y, ButtonWidth, _cancelOrder.frame.size.height);
            } else {
                 _deleteOrder.frame = CGRectMake(CGRectGetMinX(_cancelOrder.frame)- 15 - ButtonWidth, _cancelOrder.frame.origin.y, ButtonWidth, _cancelOrder.frame.size.height);
            }
            break;
            
        case OrderWaitComment:
            _statusLabel.text = NSLocalizedString(@"SMOrderWaitReceiveStatus", nil);
            _confirmReceive.hidden = NO;
            if (_buyAgain.hidden == NO) {
                _buyAgain.frame = CGRectMake(CGRectGetMinX(_confirmReceive.frame) - 15 - ButtonWidth, _confirmReceive.frame.origin.y, ButtonWidth, _confirmReceive.frame.size.height);
                 _deleteOrder.frame = CGRectMake(CGRectGetMinX(_buyAgain.frame) - 15 - ButtonWidth, _confirmReceive.frame.origin.y, ButtonWidth, _confirmReceive.frame.size.height);
            } else {
                 _deleteOrder.frame = CGRectMake(CGRectGetMinX(_confirmReceive.frame) - 15 - ButtonWidth, _confirmReceive.frame.origin.y, ButtonWidth, _confirmReceive.frame.size.height);
            }
            break;
            
        case OrderCancel:
            _statusLabel.text = NSLocalizedString(@"SMOrderCanceledStatus", nil);
            if (_buyAgain.hidden == NO) {
                _buyAgain.frame = _comment.frame;
                _deleteOrder.frame = CGRectMake(CGRectGetMinX(_buyAgain.frame) - 15 - ButtonWidth, _comment.frame.origin.y, ButtonWidth, _comment.frame.size.height);
            } else {
                _deleteOrder.frame = _comment.frame;
            }
            
            break;
            
        case OrderFinished:
            if (data.assessStatus == AssessStatusNO) {
//                _statusLabel.text = NSLocalizedString(@"SMOrderWaitCommentStatus", nil);
                _statusLabel.text = @"交易完成";
                _comment.hidden = NO;
                if (_buyAgain.hidden == NO) {
                    _buyAgain.frame = CGRectMake(CGRectGetMinX(_comment.frame) - 15 - ButtonWidth, _comment.frame.origin.y, ButtonWidth, _comment.frame.size.height);
                    _deleteOrder.frame = CGRectMake(CGRectGetMinX(_buyAgain.frame) - 15 - ButtonWidth, _comment.frame.origin.y, ButtonWidth, _comment.frame.size.height);
                } else {
                    _deleteOrder.frame = CGRectMake(CGRectGetMinX(_comment.frame) - 15 - ButtonWidth, _comment.frame.origin.y, ButtonWidth, _comment.frame.size.height);
                }
            } else {
                _statusLabel.text = NSLocalizedString(@"SMOrderFinishStatus", nil);
                if (_buyAgain.hidden == NO) {
                    _buyAgain.frame = _comment.frame;
                    _deleteOrder.frame = CGRectMake(CGRectGetMinX(_buyAgain.frame) - 15 - ButtonWidth, _comment.frame.origin.y, ButtonWidth, _comment.frame.size.height);
                } else {
                    _deleteOrder.frame = _comment.frame;
                }
            }
            
            break;
            
        case OrderClosed:
            _statusLabel.text = @"交易关闭";
            if (_buyAgain.hidden == NO) {
                _buyAgain.frame = _comment.frame;
                _deleteOrder.frame = CGRectMake(CGRectGetMinX(_buyAgain.frame) - 15 - ButtonWidth, _comment.frame.origin.y, ButtonWidth, _comment.frame.size.height);
            } else {
                _deleteOrder.frame = _comment.frame;
            }
            
            break;
        default:
            break;
    }
}

- (void)buyAgain {
    NSLog(@"再次购买");
    [[NSNotificationCenter defaultCenter] postNotificationName:BuyAgainNotification object:_data];
//    SupermarketConfrimOrderByNumbersController *confirmOrder = [[SupermarketConfrimOrderByNumbersController alloc] init];
//    [self.viewController.navigationController pushViewController:confirmOrder animated:YES];
}

- (void)payAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickOrder" object:_data];

//    SupermarketOrderWaitPayDetailController *detail = [[SupermarketOrderWaitPayDetailController alloc] init];
//    detail.controllerType = self.controllerType;
//    detail.data = self.data;
//    [self.viewController.navigationController pushViewController:detail animated:YES];
//    __weak SupermarketOrderTableViewCell *weakSelf = self;
//    if (self.passwordView == nil) {
//        self.passwordView = [[CYPasswordView alloc] init];
//    }
//    self.passwordView.title = NSLocalizedString(@"PaymentHint", nil);
//    self.passwordView.loadingText = NSLocalizedString(@"PaymentLoadingMsg", nil);
//    [self.passwordView showInView:KEYWINDOW];
//
//    NSString *order_num = _data.order_code;
    
//    OrderDetailModel *orderDetail = _orderDetailData;
    
//    self.passwordView.finish = ^(NSString *password) {
//        [weakSelf.passwordView hideKeyboard];
//        [weakSelf.passwordView startLoading];
//
//        YCAccountModel *model = [YCAccountModel getAccount];
//
//        NSString *en512 = [weakSelf sha512:password];
//
//        [KLHttpTool supermarketPayWithUserID:model.memid orderNumber:order_num orderMoney:[NSString stringWithFormat:@"%.2f", weakSelf.data.totalPrice]  actualMoney:weakSelf.data.actualMoney point:weakSelf.data.point couponCode:nil  password:en512 success:^(id response) {
//            NSLog(@"%@",response);
//            NSNumber *status = response[@"status"];
//
//            if (status.integerValue == 1) {
//                [weakSelf.passwordView requestComplete:YES message:@"支付成功"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:SupermarketSelectTabBar object:nil];
//                NSDictionary *data = response[@"data"];
//                [KLHttpTool supermarketPaymentSuccessWithOrderNum:data[@"order_no"] success:^(id response) {
//                    [weakSelf performSelector:@selector(hidePassWordView) withObject:nil afterDelay:2.0];
//                } failure:^(NSError *err) {
//
//                }];
//
//            }
//            else {
//                [weakSelf.passwordView requestComplete:NO message:response[@"msg"]];
//                [weakSelf performSelector:@selector(hidePassWordView) withObject:nil afterDelay:2.0];
//            }
//
//        } failure:^(NSError *err) {
//
//        }];
//    };

}

- (void)goWallet {
    [self.passwordView hide];
    YCAccountModel *model = [YCAccountModel getAccount];
    NSString * UrlStr = [NSString stringWithFormat:@"ycapp://wallet$%@$%@$%@",model.memid,model.password,model.token];
    [YCShareAddress shareWithString:UrlStr];
}

- (void)hidePassWordView {
    [self.passwordView hide];
    [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGoodsSucNotification object:nil];
}

- (NSDate *)getDateWithString:(NSString *)dateString {
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}


- (UIButton *)createButtonWithFrame:(CGRect)frame
                              title:(NSString *)title
                         layerColor:(UIColor *)layerColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.layer.cornerRadius = 2.0f;
    button.layer.borderWidth = 0.7f;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderColor = layerColor.CGColor;
    [button setTitleColor:layerColor forState:UIControlStateNormal];
    button.hidden = YES;
    return button;
}

- (void)goRefund {
    [[NSNotificationCenter defaultCenter] postNotificationName:GoApplyRefund object:_data];
    
}

//提醒发货
- (void)remindSend:(UIButton *)button {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已提醒发货" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

//查看退款进度
- (void)goCheckRefund {
    SupermarketChekRefundProgressController *vc = [[SupermarketChekRefundProgressController alloc] init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

//发表评价
- (void)newComment {
//    if (_isPageView) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SendGoodsCommentsNotification object:_data];
//    } else {
//    SupermarketReleaseCommentController *vc = [[SupermarketReleaseCommentController alloc] init];
//    vc.orderData = _data;
//    [self.viewController.navigationController pushViewController:vc animated:YES];
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:SendGoodsCommentsNotification object:_data];
}


/**
 取消订单
 */
- (void)cancelOrder {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SMAlertTitle", nil) message:NSLocalizedString(@"SMAlertCancelOrderMsg", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertSureTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.controllerType == ControllerTypeDepartmentStores) {

            [KLHttpTool supermarketCancelOrderWithOrderID:_data.order_code success:^(id response) {
                NSNumber *status = response[@"status"];
                if (status.integerValue == 1) {

                    [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGoodsSucNotification object:nil];
                }
                
            } failure:^(NSError *err) {
                
            }];

        } else {            
            [KLHttpTool supermarketCancelOrderWithOrderID:_data.order_code success:^(id response) {
                NSNumber *status = response[@"status"];
                if (status.integerValue == 1) {

                    [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGoodsSucNotification object:nil];
                }
                
            } failure:^(NSError *err) {
                
            }];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancel];
    
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

/**
 删除订单
 */
- (void)deleteOrder {
    UIAlertController *delteAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除订单?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [KLHttpTool supermarketDeleteOrderWithOrderID:self.data.order_code success:^(id response) {
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                [MBProgressHUD hideHUDForView:KEYWINDOW animated:false];
//                [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:1.5 text:response[@"message"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGoodsSucNotification object:nil];
            }
        } failure:^(NSError *err) {
            
        }];
    }];
    [delteAlert addAction:cancel];
    [delteAlert addAction:delete];
    [self.viewController presentViewController:delteAlert animated:YES completion:nil];
}

/**
 确认收货
 */
- (void)confirmReciveGoods {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SMAlertTitle", nil) message:NSLocalizedString(@"SMAlertConfirmReceiveMsg", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertSureTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            [KLHttpTool supermarketConfirmReceiveGoodsWithOrderID:_data.order_code hasConfirm:0 success:^(id response) {
                NSLog(@"%@",response);
                NSNumber *status = response[@"status"];
                if (status.integerValue == 1) {
//                    [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGoodsSucNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:SupermarketSelectTabBar object:nil];
                }
                else if (status.integerValue == -16421) {
                    UIAlertController *forceReceiveAlert = [UIAlertController alertControllerWithTitle:@"提示" message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *forceOK = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [KLHttpTool supermarketConfirmReceiveGoodsWithOrderID:_data.order_code hasConfirm:1 success:^(id response) {
                            NSNumber *status = response[@"status"];
                            if (status.integerValue == 1) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGoodsSucNotification object:nil];
                                [[NSNotificationCenter defaultCenter] postNotificationName:SupermarketSelectTabBar object:nil];
                                [self.viewController.navigationController popViewControllerAnimated:YES];
                            }
                        } failure:^(NSError *err) {
                            
                        }];
                    }];
                    
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [forceReceiveAlert addAction:forceOK];
                    [forceReceiveAlert addAction:cancel];
                    [self.viewController presentViewController:forceReceiveAlert animated:YES completion:nil];
                }

            } failure:^(NSError *err) {
                
            }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancel];
    
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

- (NSString*)sha512:(NSString*)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

- (void)dealloc {
    [_countDown destoryTimer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
