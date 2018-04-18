//
//  SupermarketOrderDetaiController.m
//  Portal
//
//  Created by ifox on 2017/1/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketOrderDetaiController.h"
#import "OrderDetailModel.h"
#import "SupermarketConfirmOrderGoodsCell.h"
#import "UILabel+WidthAndHeight.h"
#import "SupermarketCheckExpressController.h"
#import "SupermarketApplyRefundController.h"
#import "SupermarketReleaseCommentController.h"
#import "UILabel+CreateLabel.h"
#import "CustomerServiceController.h"
#import "GoodsDetailController.h"
#import "SupermarketReleaseCommentsController.h"

#define BottomHeight 45

#define ButtonWidth 80

#define ButtonSpace 10

@interface SupermarketOrderDetaiController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIButton *confirmReceive;
@property(nonatomic, strong) UIButton *refund;
@property(nonatomic, strong) UIButton *cancelOrder;
@property(nonatomic, strong) UIButton *check;
@property(nonatomic, strong) UIButton *comment;

@end

@implementation SupermarketOrderDetaiController {
    OrderDetailModel *_orderDetailData;
    
    
    UIButton *_checkLogistical;//查看物流
    UIButton *_refund;//退款/退货
    UIButton *_confirmReceive;//确认收货
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SupermarketOrderDetailTitle", nil);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:SubmitRefundReloadDataNotification object:nil];
    
    self.view.backgroundColor = BGColor;
    
    [self createView];
    
    [self requestData];
    
    // Do any additional setup after loading the view.
}

- (void)createView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - BottomHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[SupermarketConfirmOrderGoodsCell class] forCellReuseIdentifier:@"goodsCell"];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - BottomHeight, APPScreenWidth, BottomHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIButton *confirmReceive = [self createButtonWithTitle:NSLocalizedString(@"SupermarketConfirmReceiveButtonTitle", nil) frame:CGRectMake(APPScreenWidth - ButtonWidth - ButtonSpace, 10, ButtonWidth, 25) color:[UIColor redColor]];
    confirmReceive.hidden = YES;
    [confirmReceive addTarget:self action:@selector(confirmReceive) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmReceive];
    self.confirmReceive = confirmReceive;
    
    UIButton *refund = [self createButtonWithTitle:NSLocalizedString(@"SupermarketRefundButtonTitle", nil) frame:CGRectMake(APPScreenWidth - 2*ButtonWidth - 2*ButtonSpace, 10, ButtonWidth, 25) color:[UIColor darkGrayColor]];
    [refund addTarget:self action:@selector(refundAction) forControlEvents:UIControlEventTouchUpInside];
    refund.hidden = YES;
//  [bottomView addSubview:refund];
    self.refund = refund;
    
    UIButton *cancelOrder = [self createButtonWithTitle:NSLocalizedString(@"SMCancelOrderButtonTitle", nil) frame:CGRectMake(APPScreenWidth - 2*ButtonWidth - 2*ButtonSpace, 10, ButtonWidth, 25) color:[UIColor darkGrayColor]];
    [cancelOrder addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    cancelOrder.hidden = YES;
    cancelOrder.frame = confirmReceive.frame;
    [bottomView addSubview:cancelOrder];
    self.cancelOrder = cancelOrder;
    
    UIButton *check = [self createButtonWithTitle:NSLocalizedString(@"SMCheckExpressButtonTitle", nil) frame:CGRectMake(APPScreenWidth - 3*ButtonWidth - 3*ButtonSpace, 10, ButtonWidth, 25) color:[UIColor darkGrayColor]];
    check.hidden = YES;
    [check addTarget:self action:@selector(checkExpress) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:check];
    self.check = check;
    
    UIButton *comment = [self createButtonWithTitle:NSLocalizedString(@"SMCommentButtonTitle", nil) frame:confirmReceive.frame color:[UIColor redColor]];
    [comment addTarget:self action:@selector(newComment) forControlEvents:UIControlEventTouchUpInside];
    comment.hidden = YES;
    [bottomView addSubview:comment];
    self.comment = comment;
    
    UIButton *deleteOrder = [self createButtonWithTitle:NSLocalizedString(@"SMDeleteOrder", nil) frame:CGRectMake(APPScreenWidth - 2*ButtonWidth - 2*ButtonSpace, 10, ButtonWidth, 25) color:[UIColor darkGrayColor]];
    deleteOrder.hidden = YES;
    [deleteOrder addTarget:self action:@selector(delteOrder) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:deleteOrder];
    
    if (_data.canDeleteOrder.integerValue == 1) {
        deleteOrder.hidden = NO;
    }
    
    CGRect delteFrame = deleteOrder.frame;
    
    if (_data.status == 2 && _data.paymentStatus == 2 && _data.expressStatus == 1) {
        cancelOrder.hidden = NO;
        delteFrame.origin.x = CGRectGetMinX(cancelOrder.frame) - ButtonWidth - 15;
        deleteOrder.frame = delteFrame;
    }
    if (_data.status == 3) {
        confirmReceive.hidden = NO;
        delteFrame.origin.x = CGRectGetMinX(confirmReceive.frame) - ButtonWidth - 15;
        deleteOrder.frame = delteFrame;
    }
    if (_data.status == 4) {
        if (deleteOrder.hidden == NO) {
            deleteOrder.frame = cancelOrder.frame;
        } else {
            bottomView.hidden = YES;
            _tableView.frame = self.view.frame;
        }
    }
    if (_data.status == 5 && _data.assessStatus == 1) {
        comment.hidden = NO;
        delteFrame.origin.x = CGRectGetMinX(comment.frame) - ButtonWidth - 15;
        deleteOrder.frame = delteFrame;
    }
    if (_data.status == 5 && _data.assessStatus == 2) {
        if (deleteOrder.hidden == NO) {
            deleteOrder.frame = cancelOrder.frame;
        } else {
            bottomView.hidden = YES;
            _tableView.frame = self.view.frame;
        }
    }
}

- (void)delteOrder {
	UIAlertController *delteAlert = [UIAlertController alertControllerWithTitle:@"제시" message:@"주문을 삭제하시겠습니까?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [KLHttpTool supermarketDeleteOrderWithOrderID:self.data.order_code success:^(id response) {
            NSLog(@"%@",response);
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
//                [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:1.5 text:response[@"message"]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGoodsSucNotification object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *err) {
            
        }];
    }];
    [delteAlert addAction:cancel];
    [delteAlert addAction:delete];
    [self presentViewController:delteAlert animated:YES completion:nil];
}

- (void)goComment {
    SupermarketReleaseCommentController *vc = [[SupermarketReleaseCommentController alloc] init];
    vc.orderData = _data;
    vc.isOrderDetail = YES;
    vc.controllerType = self.controllerType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestData {
    if (self.controllerType == ControllerTypeDepartmentStores) {
        [KLHttpTool getSupermarketOrderDetailWithOrderID:self.orderID appType:8 success:^(id response) {
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSDictionary *data = response[@"data"];
                _orderDetailData = [NSDictionary getOrderDetailModelWithDic:data];
                [self.tableView reloadData];
                NSNumber *orderStatus = data[@"ONLINE_ORDER_STATUS"];
                _orderStatus = orderStatus.integerValue;
                NSLog(@"%@",_orderDetailData);
                //            [self refreshUI];
            }
        } failure:^(NSError *err) {
            
        }];
    } else {
        [KLHttpTool getSupermarketOrderDetailWithOrderID:self.orderID appType:6 success:^(id response) {
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSDictionary *data = response[@"data"];
                _orderDetailData = [NSDictionary getOrderDetailModelWithDic:data];
                [self.tableView reloadData];
                NSNumber *orderStatus = data[@"ONLINE_ORDER_STATUS"];
                _orderStatus = orderStatus.integerValue;
                NSLog(@"%@",_orderDetailData);
                //            [self refreshUI];
            }
        } failure:^(NSError *err) {
            
        }];
    }
}

- (void)refreshUI {
    if (_orderStatus == 2) {
        _confirmReceive.hidden = NO;
        _refund.hidden = NO;
        _check.hidden = NO;
        _comment.hidden = YES;
    }
    if (_orderStatus == 3) {
        _comment.hidden = NO;
        _confirmReceive.hidden = YES;
        _refund.hidden = YES;
        _check.hidden = YES;
    }
    if (_orderStatus == 4) {
        _bottomView.hidden = YES;
        _tableView.frame = self.view.frame;
    }

}

//查看物流
- (void)checkExpress {
    SupermarketCheckExpressController *checkExpress = [[SupermarketCheckExpressController alloc] init];
    [self.navigationController pushViewController:checkExpress animated:YES];
}

//发表评价
- (void)newComment {
    
    if (_data.goodList.count == 1) {
        SupermarketReleaseCommentController *vc = [[SupermarketReleaseCommentController alloc] init];
        vc.orderData = _data;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        SupermarketReleaseCommentsController *vc = [[SupermarketReleaseCommentsController alloc] init];
        vc.data = _data;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
   
    
}

//退货退款
- (void)refundAction {
    SupermarketApplyRefundController *refund = [[SupermarketApplyRefundController alloc] init];
    refund.orderDetail = _orderDetailData;
    refund.orderNum = _orderID;
    [self.navigationController pushViewController:refund animated:YES];
}

//取消订单
- (void)cancelOrder {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SMAlertTitle", nil) message:NSLocalizedString(@"SMAlertCancelOrderMsg", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertSureTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [KLHttpTool supermarketCancelOrderWithOrderID:_data.order_code success:^(id response) {
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {

                [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGoodsSucNotification object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *err) {
            
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//确认收货
- (void)confirmReceive {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SMAlertTitle", nil) message:NSLocalizedString(@"SMAlertConfirmReceiveMsg", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertSureTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [KLHttpTool supermarketConfirmReceiveGoodsWithOrderID:_orderID hasConfirm:0 success:^(id response) {
            NSLog(@"%@",response);
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGoodsSucNotification object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:SupermarketSelectTabBar object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else if (status.integerValue == -16421) {
                UIAlertController *forceReceiveAlert = [UIAlertController alertControllerWithTitle:@"提示" message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *forceOK = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [KLHttpTool supermarketConfirmReceiveGoodsWithOrderID:_orderID hasConfirm:1 success:^(id response) {
                        NSNumber *status = response[@"status"];
                        if (status.integerValue == 1) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGoodsSucNotification object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:SupermarketSelectTabBar object:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    } failure:^(NSError *err) {
                        
                    }];
                }];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [forceReceiveAlert addAction:forceOK];
                [forceReceiveAlert addAction:cancel];
                [self presentViewController:forceReceiveAlert animated:YES completion:nil];
            }
        } failure:^(NSError *err) {
            
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)contactCustomerService {
	YCAccountModel *accountmodel = [YCAccountModel getAccount];
	NSString *UrlStr = [NSString stringWithFormat:@"ycapp://Customer$%@$%@$%@",accountmodel.customCode,@"12099999999",accountmodel.token] ;
	
	dispatch_async(dispatch_get_main_queue(), ^{

		if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UrlStr]]) {

			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UrlStr]];

		}else{
			UIAlertController* _alters = [UIAlertController alertControllerWithTitle:@"메신저를 다운로드 하시겠습니까？" message:nil preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

			}];

			UIAlertAction *okaction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

				NSString *str =  @"itms-apps:https://itunes.apple.com/us/app/%E9%BE%99%E8%81%8A/id1225896079?l=zh&ls=1&mt=8";
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

			}];


			[_alters addAction:cancel];
			[_alters addAction:okaction];
			[self presentViewController:_alters animated:YES completion:nil];

		}

	});
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
        header.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *orderNumber = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, APPScreenWidth, 40)];
        orderNumber.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"SMOrderCode", nil),_orderID];
        orderNumber.textColor = [UIColor darkcolor];
        orderNumber.font = [UIFont systemFontOfSize:15];
        [header addSubview:orderNumber];
        return header;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UITableViewHeaderFooterView *footer = [[UITableViewHeaderFooterView alloc] init];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, APPScreenWidth, 40);
        [button setTitle:NSLocalizedString(@"SMContactServiceButtonTitle", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(contactCustomerService) forControlEvents:UIControlEventTouchUpInside];
        
        [footer addSubview:button];
        return footer;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
       SupermarketConfirmOrderGoodsCell *cell = [[SupermarketConfirmOrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellType = 1;
        cell.orderStatus = _orderStatus;
        cell.goods = _orderDetailData.goodList[indexPath.row];
        cell.order_num = _orderDetailData.order_code;
        return cell;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, (70 - 22)/2, 22, 22)];
            icon.image = [UIImage imageNamed:@"icon_positioning"];
            icon.contentMode = UIViewContentModeScaleAspectFit;
            
            UILabel *receivePerson = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, 10, 0, 20)];
            receivePerson.text = NSLocalizedString(@"SMReceiveName", nil);
            receivePerson.font = [UIFont systemFontOfSize:15];
            receivePerson.textColor = [UIColor darkGrayColor];
            
            CGFloat width = [UILabel getWidthWithTitle:receivePerson.text font:receivePerson.font];
            receivePerson.frame = CGRectMake(CGRectGetMaxX(icon.frame)+10, 10, width, 20);
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(receivePerson.frame), CGRectGetMinY(receivePerson.frame), 100, receivePerson.frame.size.height)];
            name.text = _orderDetailData.user_name;
            name.textColor = receivePerson.textColor;
            name.font = receivePerson.font;
            
            UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(APPScreenWidth - 35 - 120, CGRectGetMinY(receivePerson.frame), 120, receivePerson.frame.size.height)];
            phone.textAlignment = NSTextAlignmentRight;
            phone.textColor = receivePerson.textColor;
            phone.font = receivePerson.font;
            phone.text = _orderDetailData.mobile;
            
            UILabel *receivePlace = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(receivePerson.frame), CGRectGetMaxY(receivePerson.frame), 0, 20)];
            receivePlace.font = [UIFont systemFontOfSize:13];
            receivePlace.text = NSLocalizedString(@"SMReceiveAdress", nil);
            receivePlace.textColor = [UIColor darkGrayColor];
            [receivePlace sizeToFit];
            
            CGFloat labelWidth = [UILabel getWidthWithTitle:receivePlace.text font:receivePlace.font];
            receivePlace.frame = CGRectMake(CGRectGetMinX(receivePerson.frame), CGRectGetMaxY(receivePerson.frame), labelWidth, 20);
            
            UILabel *place = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(receivePlace.frame), CGRectGetMinY(receivePlace.frame), APPScreenWidth - 140, 40)];
            place.numberOfLines = 2;
            place.font = receivePlace.font;
            place.textColor = receivePlace.textColor;
            place.text = _orderDetailData.address;
            [place sizeToFit];
            
            [cell.contentView addSubview:icon];
            [cell.contentView addSubview:receivePerson];
            [cell.contentView addSubview:name];
            [cell.contentView addSubview:phone];
            [cell.contentView addSubview:receivePlace];
            [cell.contentView addSubview:place];
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, (55 - 22)/2-3, 22, 22)];
            icon.contentMode = UIViewContentModeScaleAspectFit;
            icon.image = [UIImage imageNamed:@"l"];
            
            UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, 10, 250, 15)];
            time.textColor = GreenColor;
            time.font = [UIFont systemFontOfSize:12];
            time.text = _orderDetailData.expDate;
            
            UILabel *logistical = [[UILabel alloc] initWithFrame:CGRectMake(time.frame.origin.x, CGRectGetMaxY(time.frame), APPScreenWidth - 79, 25)];
            logistical.textColor = GreenColor;
            logistical.font = [UIFont systemFontOfSize:15];
            logistical.text = _orderDetailData.expLocation;
            
            [cell.contentView addSubview:icon];
            [cell.contentView addSubview:time];
            [cell.contentView addSubview:logistical];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"气加支付", nil);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.detailTextLabel.text = _orderDetailData.payment;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.textColor = [UIColor darkcolor];
        } else if (indexPath.row == 1) {

        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 40)];
            price.textColor = [UIColor grayColor];
            price.font = [UIFont systemFontOfSize:12];
            price.text = NSLocalizedString(@"SMOrderTotalMoney", nil);
            
            UILabel *expPrice = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(price.frame) - 10, 100, 40)];
            expPrice.textColor = [UIColor grayColor];
            expPrice.font = [UIFont systemFontOfSize:12];
            expPrice.text = NSLocalizedString(@"SMExpressMoney", nil);
            
            UILabel *preference = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(expPrice.frame) - 10, 100, 40)];
            preference.textColor = [UIColor grayColor];
            preference.font = [UIFont systemFontOfSize:12];
            preference.text = NSLocalizedString(@"SMCouponMoney", nil);
            
            UILabel *bean = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(preference.frame) - 10, 100, 40)];
            bean.textColor = [UIColor grayColor];
            bean.font = [UIFont systemFontOfSize:12];
            bean.text = NSLocalizedString(@"SMPointMoney", nil);
            
            [cell.contentView addSubview:price];
            [cell.contentView addSubview:expPrice];
            [cell.contentView addSubview:preference];
            [cell.contentView addSubview:bean];
            
            UILabel *priceR = [[UILabel alloc] initWithFrame:CGRectMake(APPScreenWidth - 150 - 15, price.frame.origin.y, 150, price.frame.size.height)];
            priceR.textAlignment = NSTextAlignmentRight;
            priceR.font = price.font;
            priceR.textColor = [UIColor redColor];
            priceR.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.f",[_orderDetailData.order_price doubleValue]] ],NSLocalizedString(@"SMYuan", nil)];
            [cell.contentView addSubview:priceR];
            
            UILabel *expPriceR = [[UILabel alloc] initWithFrame:CGRectMake(APPScreenWidth - 15 - 150, expPrice.frame.origin.y, 150, expPrice.frame.size.height)];
            expPriceR.textColor = priceR.textColor;
            expPriceR.textAlignment = NSTextAlignmentRight;
            expPriceR.font = expPrice.font;
            expPriceR.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.f",[_orderDetailData.freight doubleValue]] ],NSLocalizedString(@"SMYuan", nil)];
            [cell.contentView addSubview:expPriceR];
            
            UILabel *preferenceR = [[UILabel alloc] initWithFrame:CGRectMake(APPScreenWidth - 15 - 150, preference.frame.origin.y, 150, expPrice.frame.size.height)];
            preferenceR.textColor = priceR.textColor;
            preferenceR.textAlignment = NSTextAlignmentRight;
            preferenceR.font = expPrice.font;
            preferenceR.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.f",[_orderDetailData.couponAmout doubleValue]] ],NSLocalizedString(@"SMYuan", nil)];
            [cell.contentView addSubview:preferenceR];
            
            UILabel *beanR = [[UILabel alloc] initWithFrame:CGRectMake(APPScreenWidth - 15 - 150, bean.frame.origin.y, 150, expPrice.frame.size.height)];
            beanR.textColor = priceR.textColor;
            beanR.textAlignment = NSTextAlignmentRight;
            beanR.font = expPrice.font;
            beanR.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.f",[_orderDetailData.point doubleValue]] ],NSLocalizedString(@"SMYuan", nil)];
            [cell.contentView addSubview:beanR];

        } else if (indexPath.row == 1) {

            
            UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(APPScreenWidth - 15, 10, 0, 25)];
            money.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.f",[_orderDetailData.realPrice doubleValue]] ],NSLocalizedString(@"SMYuan", nil)];
            CGFloat width = [UILabel getWidthWithTitle:money.text font:[UIFont systemFontOfSize:25]];
            money.frame = CGRectMake(APPScreenWidth - 15 - width, 10, width, 25);
            money.font = [UIFont systemFontOfSize:25];
            money.textColor = [UIColor redColor];
            [cell.contentView addSubview:money];
            
            UILabel *moneyTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(money.frame)-200, money.frame.origin.y, 200, money.frame.size.height)];
            moneyTitle.textColor = [UIColor grayColor];
            moneyTitle.font = [UIFont systemFontOfSize:20];
            moneyTitle.textAlignment = NSTextAlignmentRight;
            moneyTitle.text = NSLocalizedString(@"SMActualPay", nil);
            [cell.contentView addSubview:moneyTitle];
            
            UILabel *time = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth - 10 - 300, CGRectGetMaxY(money.frame), 300, 15) textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentRight text:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"SMOrderTime", nil),_data.createTime]];
            [cell.contentView addSubview:time];
            
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        if (_orderDetailData != nil) {
            return _orderDetailData.goodList.count;
        }
        return 0;
    } else if (section == 2) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 50;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 75;
        }
        return 55;
    }
    if (indexPath.section == 1) {
        return 110;
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 140;
        } else {
            return 60;
        }
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0  && indexPath.row == 1) {
        SupermarketCheckExpressController *vc = [[SupermarketCheckExpressController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        GoodsDetailController *goodsDetail = [[GoodsDetailController alloc] init];
        SupermarketOrderGoodsData *goods = _orderDetailData.goodList[indexPath.row];
        goodsDetail.item_code = goods.item_code;
        goodsDetail.controllerType = self.controllerType;
        goodsDetail.divCode = self.data.divCode;
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }
}

- (UIButton *)createButtonWithTitle:(NSString *)title
                              frame:(CGRect)frame
                              color:(UIColor *)color {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = 0.7f;
    button.layer.cornerRadius = 2.0f;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    return button;
}


@end
