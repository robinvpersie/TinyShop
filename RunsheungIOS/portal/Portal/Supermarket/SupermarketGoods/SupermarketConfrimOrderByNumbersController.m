//
//  SupermarketConfrimOrderByNumbersController.m
//  Portal
//
//  Created by ifox on 2016/12/26.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketConfrimOrderByNumbersController.h"
#import "ConfirmOrderheaderView.h"
#import "UILabel+WidthAndHeight.h"
#import "SupermarketConfirmOrderGoodsCell.h"
#import "SupermarketMyAddressViewController.h"
#import "LZCartModel.h"
#import "CYPasswordView.h"
#include <CommonCrypto/CommonDigest.h>
#import "SupermarketMyOrderController.h"
#import "CheckOrderModel.h"
#import "SupermarketCouponController.h"
#import "CouponModel.h"
#import "CheckOrderGoodsRange.h"
#import "PaymentWay.h"
#import "LZShopModel.h"
#import "UILabel+CreateLabel.h"

#define BottomHeight 45

@interface SupermarketConfrimOrderByNumbersController ()<UITableViewDelegate, UITableViewDataSource, MyAddressDelegete>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) SupermarketAddressModel *address;
@property(nonatomic, copy) NSString *guid;
@property(nonatomic, strong) NSArray *payWayIcons;
@property(nonatomic, strong) NSArray *payWayTitle;

@property(nonatomic, strong) NSMutableArray *selectedCoupons;

@property(nonatomic, strong) UILabel *priceLabel;
//三种支付方式
@property(nonatomic, strong) UIButton *gigaPay;
@property(nonatomic, strong) UIButton *wechatPay;
@property(nonatomic, strong) UIButton *aliPay;
@property(nonatomic, strong) UIButton *unionPay;

@property(nonatomic, strong) UISwitch *canUsePoint;

@property (nonatomic, strong) CYPasswordView *passwordView;

@end

@implementation SupermarketConfrimOrderByNumbersController {
    CheckOrderModel *_checkOrderModel;
}


- (void)getAddressList {
//    [MBProgressHUD showWithView:KEYWINDOW];
    NSString *divCode;
    if (self.controllerType == ControllerTypeDepartmentStores) {
        divCode = @"0";
    } else {
        divCode = _checkOrderModel.divCode;
    }
    
    [KLHttpTool getSupermarketUserAddressListWithOffset:@"1" success:^(id response) {
        NSMutableArray *array = [NSMutableArray array];
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *data = response[@"bcm100ts"];
            if (data.count > 0) {
                for (NSDictionary *dic in data) {
                    SupermarketAddressModel *model = [NSDictionary getAddressDataWithDic:dic];
                    [array addObject:model];
                }
                NSInteger hasDefault = 0;
                
                for (SupermarketAddressModel *addressModel in array) {
                    if (addressModel.default_add) {
                        self.address = addressModel;
                        [self.tableView reloadData];
                        
                        hasDefault = 1;
                    }
                }
                if (hasDefault == 0) {
                    //有地址但是没有默认地址
                    UIAlertController *noDefaultAddress = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SMAlertTitle", nil) message:NSLocalizedString(@"SMAlertNoDefaultAdressMsg", nil) preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *goAddNew = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertGoSetAddressTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        SupermarketMyAddressViewController *address = [SupermarketMyAddressViewController new];
                        address.isPageView = NO;
                        address.delegate = self;
                        [self.navigationController pushViewController:address animated:YES];
                    }];
                    [noDefaultAddress addAction:goAddNew];
                    [self presentViewController:noDefaultAddress animated:YES completion:nil];
                }

            } else {
                //没有地址情况
                UIAlertController *noAddress = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SMAlertTitle", nil) message:NSLocalizedString(@"SMAlertNoAddressMsg", nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *goAddNew = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertAddNewAddressTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    SupermarketMyAddressViewController *address = [SupermarketMyAddressViewController new];
                    address.isPageView = NO;
                    address.delegate = self;
                    [self.navigationController pushViewController:address animated:YES];
                }];
                [noAddress addAction:goAddNew];
                [self presentViewController:noAddress animated:YES completion:nil];
            }
            
        }

    } failure:^(NSError *err) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	_payWayTitle =  @[NSLocalizedString(@"GIGA支付", nil),NSLocalizedString(@"WechatPay", nil),NSLocalizedString(@"AliPay", nil),NSLocalizedString(@"UnionPay", nil)];
	_payWayIcons = @[@"icon_weichatpay",@"icon_weichatpay",@"icon_alipay",@"icon_bank"];
	
	/** 注册取消按钮点击的通知 */
    [CYNotificationCenter addObserver:self selector:@selector(cancelInputPWD) name:CYPasswordViewCancleButtonClickNotification object:nil];
    [CYNotificationCenter addObserver:self selector:@selector(forgetPWD) name:CYPasswordViewForgetPWDButtonClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCoupons:) name:CouponSureButtonClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelInputPWD) name:AliPayCancleNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelInputPWD) name:UnionPayCancelNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:AliPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:WeChatPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:UnionPaySuccessNotification object:nil];
    
    self.title = NSLocalizedString(@"SMConfirmOrderTitle", nil);

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - BottomHeight) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[ConfirmOrderheaderView class] forHeaderFooterViewReuseIdentifier:@"tableHeaderView"];
    [self.tableView registerClass:[SupermarketConfirmOrderGoodsCell class] forCellReuseIdentifier:@"goodsCell"];

    
    
    [self createBottomView];
    
    [self checkOrder];
    // Do any additional setup after loading the view.
}

- (void)cancelInputPWD {
    [self.navigationController popViewControllerAnimated:YES];
    [self performSelector:@selector(showMsg) withObject:nil afterDelay:1.0];
    
}

- (void)getCoupons:(NSNotification *)notification {
    
    if (self.selectedCoupons != nil) {
        [_selectedCoupons removeAllObjects];
    }
    
    NSArray *coupons = notification.object;
    CouponModel *first = coupons.firstObject;
    _selectedCoupons = coupons.mutableCopy;
    NSArray *goodsRanges = _checkOrderModel.goodsRanges;
    
    float totalDecentMoney = 0;//优惠券总共减去的金额
    
    if (coupons.count == 1 && first.couponRange.integerValue == 0) {
        if (first.couponType == CouponOverSale) {
            if (self.totalPrice * first.decent.floatValue > first.upLimitMoney.floatValue) {
                totalDecentMoney = first.upLimitMoney.floatValue;
            } else {
                totalDecentMoney = self.totalPrice * first.decent.floatValue;
            }
        }
        else {
            totalDecentMoney = first.decent.floatValue;
        }
    } else {
        for (CouponModel *coupon in coupons) {
            for (CheckOrderGoodsRange *range in goodsRanges) {
                if (coupon.couponRange.integerValue == range.range.integerValue) {
                    if (coupon.couponType == CouponOverSale) {
                        if (range.totalPrice.floatValue * coupon.decent.floatValue > coupon.upLimitMoney.floatValue) {
                            totalDecentMoney = totalDecentMoney + coupon.upLimitMoney.floatValue;
                        } else {
                            totalDecentMoney = totalDecentMoney + range.totalPrice.floatValue * coupon.decent.floatValue;
                        }
                    } else {
                        totalDecentMoney = totalDecentMoney + coupon.decent.floatValue;
                    }
                }
            }
        }
    }
    
    if (_canUsePoint.isOn == YES) {
        _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue - _checkOrderModel.canMaxUsePoint.floatValue - totalDecentMoney];
    } else {
         _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue - totalDecentMoney];
    }
    
    
}

- (void)forgetPWD {
    
}

- (void)showMsg {
    [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:4 text:NSLocalizedString(@"SMOrderWillCancelMsg", nil)];
}

- (void)checkOrder {
	

    NSMutableDictionary *parmas = @{}.mutableCopy;
    NSMutableArray *goods = @[].mutableCopy;
    
    for (int i = 0; i < self.dataArray.count; i++) {
        NSMutableDictionary *good = @{}.mutableCopy;
        
        LZCartModel *cartModel = _dataArray[i];
        
        [good setObject:cartModel.sale_custom_code forKey:@"custom_code"];
        [good setObject:cartModel.item_code forKey:@"item_code"];
        [good setObject:@(cartModel.number) forKey:@"count"];
        [good setObject:@(cartModel.price.floatValue) forKey:@"unit_price"];
        [good setObject:cartModel.divCode forKey:@"div_code"];
		
        [goods addObject:good];
        
    }
    
    [parmas setObject:goods forKey:@"goods"];
	NSMutableArray *attchments = @[].mutableCopy;
	[parmas setObject:attchments forKey:@"attachment"];

    [MBProgressHUD showWithView:KEYWINDOW];
    
    if (self.controllerType == ControllerTypeDepartmentStores) {

        [KLHttpTool supermarketCheckBeforeCreateOrder:parmas isShoppingCart:true appType:8 success:^(id response) {
            NSLog(@"%@",response);
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSDictionary *data = response[@"data"];
                _checkOrderModel = [NSDictionary getSupermarketCheckOrderModelWithDic:data];
                [_tableView reloadData];
                [self getAddressList];
                if (_canUsePoint.isOn == YES) {
                    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue - _checkOrderModel.canMaxUsePoint.floatValue];
                } else {
                    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue];
                }
                
            }else {
				
				 [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
				 [self.navigationController popViewControllerAnimated:YES];
				
            }

            
        } failure:^(NSError *err) {
            
        }];

    } else {
        [KLHttpTool supermarketCheckBeforeCreateOrder:parmas isShoppingCart:true appType:6 success:^(id response) {
            NSLog(@"%@",response);
			[MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];

            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSDictionary *data = response[@"data"];
                _checkOrderModel = [NSDictionary getSupermarketCheckOrderModelWithDic:data];
                [_tableView reloadData];
                [self getAddressList];
                if (_canUsePoint.isOn == YES) {
                    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue - _checkOrderModel.canMaxUsePoint.floatValue];
                } else {
                    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue];
                }
                
            } else {
				 [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
				 [self.navigationController popViewControllerAnimated:YES];
				
            }
            
        } failure:^(NSError *err) {
            
        }];
    }

}

- (void)createOrder {
    if (_checkOrderModel.guid.length == 0) {
        return;
    }
    
//    if (self.address.hasDelivery.integerValue == 0) {
//        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2.0f text:NSLocalizedString(@"SMConfirmOrderAddressOverRange", nil)];
//        return;
//    }

    
    NSMutableDictionary *info = @{}.mutableCopy;
    [info setObject:self.address.seq_num forKey:@"locationId"];
    
    NSMutableString *couponIDs = [[NSMutableString alloc] init];
    for (int i = 0; i < _selectedCoupons.count; i++) {
        CouponModel *coupon = _selectedCoupons[i];
        if (i == _selectedCoupons.count - 1) {
            [couponIDs appendString:coupon.couponID.stringValue];
        } else {
            [couponIDs appendFormat:@"%@,",coupon.couponID.stringValue];
        }
    }
    
    NSString *point;
    if (_canUsePoint.isOn == YES) {
        point = [NSString stringWithFormat:@"%d",_checkOrderModel.canMaxUsePoint ] ;
    } else {
        point = @"0";
    }
    
//    [info setObject:couponIDs forKey:@"useCouponsIds"];
    
    if (self.controllerType == ControllerTypeDepartmentStores) {
     
        [KLHttpTool supermarketCreateOrderWithGUID:_checkOrderModel.guid points:point coupons:couponIDs validateInfo:info success:^(id response) {
            NSLog(@"%@",response);
            NSLog(@"%@",response);
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ReloadShoppingCartNotification object:nil];
                NSString *orderCode = response[@"order_code"];
                NSString *money = response[@"amount"];
                NSString *point = response[@"pointAmount"];
                NSString *actualMoney = response[@"real_amount"];
                
                if (_aliPay.selected == YES) {
					
                    [KLHttpTool supermarketGetAlipayStrWithOrderNum:orderCode payAmount:actualMoney success:^(id response) {
                        NSLog(@"%@",response);
                        NSNumber *status = response[@"status"];
                        if (status.integerValue == 1) {
                            NSString *data = response[@"data"];
                            //                        [self alipay:data];
                            [PaymentWay alipay:data];
                        }
                    } failure:^(NSError *err) {
                        
                    }];
                    
                } else if (_gigaPay.selected == YES) {
					
                    __weak SupermarketConfrimOrderByNumbersController *weakSelf = self;
                    if (self.passwordView == nil) {
                        self.passwordView = [[CYPasswordView alloc] init];
                    }
                    
                    self.passwordView.title = NSLocalizedString(@"PaymentHint", nil);
                    self.passwordView.loadingText = NSLocalizedString(@"PaymentLoadingMsg", nil);
                    [self.passwordView showInView:self.view.window];
					
                    self.passwordView.finish = ^(NSString *password) {
                        [weakSelf.passwordView hideKeyboard];
                        [weakSelf.passwordView startLoading];
                        
                        YCAccountModel *model = [YCAccountModel getAccount];
                        
                        NSString *en512 = [weakSelf sha512:password];
                        
                        
                        [KLHttpTool supermarketPayWithUserID:model.memid orderNumber:orderCode orderMoney:money actualMoney:actualMoney point:point couponCode:nil password:en512 success:^(id response) {
                            NSLog(@"%@",response);
                            NSNumber *status = response[@"status"];
                            
                            if (status.integerValue == 1) {
                                [weakSelf.passwordView requestComplete:YES message:NSLocalizedString(@"PaySucMsg", nil)];
                                NSDictionary *data = response[@"data"];
                                [KLHttpTool supermarketPaymentSuccessWithOrderNum:data[@"order_no"] success:^(id response) {
                                    [weakSelf performSelector:@selector(hidePassWordView) withObject:nil afterDelay:2.0];
                                } failure:^(NSError *err) {
                                    
                                }];
                                
                            }
                            else {
                                [weakSelf.passwordView requestComplete:NO message:response[@"msg"]];
                                [weakSelf performSelector:@selector(hidePassWordView) withObject:nil afterDelay:2.0];
                            }
                            
                        } failure:^(NSError *err) {
                            
                        }];
                        
                    };
                    
                } else if (_wechatPay.selected == YES) {
                    [KLHttpTool supermarketGetUnionPayStrWithOrderNum:orderCode payAmount:actualMoney success:^(id response) {
                        if (status.integerValue == 1) {
                            NSString *data = response[@"data"];
                            //                        [self unionpay:data];
                            [PaymentWay unionpay:data viewController:self];
                        }
                        
                    } failure:^(NSError *err) {
                        
                    }];
                }
            } else {
                [MBProgressHUD hideAfterDelayWithView:self.view interval:4 text:response[@"message"]];
            }
            
        } failure:^(NSError *err) {
            
        }];


    } else {//人生药业的支付
        
        NSString *paytype;
		if (_gigaPay.selected == YES) {//giga支付
			paytype = @"1";
		}else if (_wechatPay.selected == YES) {//微信支付
            paytype = @"2";
        }else if (_aliPay.selected == YES){//支付宝
            paytype = @"3";
        }else if (_unionPay.selected == YES){//银联
            paytype = @"4";
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"正在生成订单...";
        [hud showAnimated:YES];
        
        [KLHttpTool supermarketCreateOrderWithGUID:_checkOrderModel.guid points:point coupons:couponIDs validateInfo:info success:^(id response) {
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSString *orderCode = response[@"order_code"];
                NSString *money = response[@"amount"];
                NSString *point = response[@"pointAmount"];
                NSString *actualMoney = response[@"real_amount"];
				if ([paytype isEqualToString:@"1"]) {

					__weak SupermarketConfrimOrderByNumbersController *weakSelf = self;
					if (self.passwordView == nil) {
						self.passwordView = [[CYPasswordView alloc] init];
					}
					
					self.passwordView.title = NSLocalizedString(@"PaymentHint", nil);
					self.passwordView.loadingText = NSLocalizedString(@"PaymentLoadingMsg", nil);
					[self.passwordView showInView:self.view.window];
					
					self.passwordView.finish = ^(NSString *password) {
						[weakSelf.passwordView hideKeyboard];
						[weakSelf.passwordView startLoading];
						
						YCAccountModel *model = [YCAccountModel getAccount];
						
						NSString *en512 = [weakSelf sha512:password];
						
						
						[KLHttpTool supermarketPayWithUserID:model.customCode orderNumber:orderCode orderMoney:money actualMoney:actualMoney point:point couponCode:nil password:en512 success:^(id response) {
							NSLog(@"%@",response);
							NSNumber *status = response[@"status"];
							
							if (status.integerValue == 1) {
								[weakSelf.passwordView requestComplete:YES message:NSLocalizedString(@"PaySucMsg", nil)];
								NSDictionary *data = response[@"data"];
								[KLHttpTool supermarketPaymentSuccessWithOrderNum:data[@"order_no"] success:^(id response) {
									[weakSelf performSelector:@selector(hidePassWordView) withObject:nil afterDelay:2.0];
								} failure:^(NSError *err) {
									
								}];
								
							}
							else {
								[weakSelf.passwordView requestComplete:NO message:response[@"msg"]];
								[weakSelf performSelector:@selector(hidePassWordView) withObject:nil afterDelay:2.0];
							}
							
						} failure:^(NSError *err) {
							
						}];
						
					};
					
				}

//				if ([paytype isEqualToString:@"2"]) {
//					[PaymentWay wechatpay:dic1 viewController:self];
//				}
//				if ([paytype isEqualToString:@"3"]) {
//					[PaymentWay alipay:dataS];
//				}
//				if ([paytype isEqualToString:@"4"]) {
//					[PaymentWay unionpay:dataS viewController:self];
//				}
				[hud hideAnimated:YES];

            } else {
                [MBProgressHUD hideAfterDelayWithView:self.view interval:4 text:response[@"message"]];
            }
            
        } failure:^(NSError *err) {
            
        }];
        
    }

}


- (void)paySuccess {
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
    hud.label.text = NSLocalizedString(@"支付成功", nil) ;
    hud.label.textColor = [UIColor whiteColor];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payOK"]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:2.0];
    
    [self performSelector:@selector(goOrderList) withObject:nil afterDelay:2.0f];
    
}

- (void)goOrderList {
    SupermarketMyOrderController *myOrder = [[SupermarketMyOrderController alloc] init];
    [self.navigationController pushViewController:myOrder animated:YES];
    
}




- (void)createBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - BottomHeight, APPScreenWidth, BottomHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UILabel *sumMoney = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, BottomHeight)];
    sumMoney.text = NSLocalizedString(@"SMConfirmOrderTotalMoney", nil);
    sumMoney.textColor = [UIColor darkGrayColor];
    sumMoney.font = [UIFont systemFontOfSize:17];
    
    CGFloat width = [UILabel getWidthWithTitle:sumMoney.text font:sumMoney.font];
    sumMoney.frame = CGRectMake(15, 0, width, BottomHeight);
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sumMoney.frame)+10, 0, 100, BottomHeight)];
    price.font = [UIFont systemFontOfSize:15];
    price.textColor = [UIColor redColor];

    self.priceLabel = price;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(APPScreenWidth - 107, 7, 100, BottomHeight - 14);
    submitBtn.layer.cornerRadius = 2.0f;
    submitBtn.backgroundColor =  RGB(33, 192, 67);
    [submitBtn setTitle:NSLocalizedString(@"SMConfirmOrderSubmitButtonTitle", nil) forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(createOrder) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [bottomView addSubview:sumMoney];
    [bottomView addSubview:price];
    [bottomView addSubview:submitBtn];
    
    [self.view addSubview:bottomView];
    
    NSLog(@"%f",bottomView.frame.origin.y);
}


- (NSString*) sha512:(NSString*)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}


- (void)checkPassword {
    [self.passwordView requestComplete:YES message:NSLocalizedString(@"PaySucMsg", nil)];
    
    [self performSelector:@selector(hidePassWordView) withObject:nil afterDelay:2.0];
}

- (void)hidePassWordView {
    [self.passwordView hide];
//    [self.navigationController popViewControllerAnimated:YES];
    SupermarketMyOrderController *myOrder = [[SupermarketMyOrderController alloc] init];
    myOrder.controllerType = self.controllerType;
    [self.navigationController pushViewController:myOrder animated:YES];

}

- (void)goWallet {
    [self.passwordView hide];
    YCAccountModel *model = [YCAccountModel getAccount];
    NSString * UrlStr = [NSString stringWithFormat:@"ycapp://wallet$%@$%@$%@",model.memid,model.password,model.token];
    [YCShareAddress shareWithString:UrlStr];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    }
    else if (section == 2) {
        return self.dataArray.count;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 2) {
       SupermarketConfirmOrderGoodsCell *cell = [[SupermarketConfirmOrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodsCell"];
        
        LZCartModel *model = self.dataArray[indexPath.row];
        
        SupermarketOrderGoodsData *data = [[SupermarketOrderGoodsData alloc] init];
        data.item_code = [NSString stringWithFormat:@"%@",model.item_code];
        data.amount = @(model.number);
        data.price = @(model.price.floatValue);
        data.title = model.nameStr;
        data.stockUnit = model.stock_unit;
        data.image_url = model.image_url;
        data.ver = model.ver;
        
        cell.goods = data;
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        cell.imageView.image = [UIImage imageNamed:_payWayIcons[indexPath.row]];
        cell.textLabel.text = _payWayTitle[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkcolor];
        
        UIButton *check = [UIButton buttonWithType:UIButtonTypeCustom];
        check.frame = CGRectMake(APPScreenWidth - 15 - 15, 15, 15, 15);
        [check setImage:[UIImage imageNamed:@"icon_unselected"] forState:UIControlStateNormal];
        [check setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateSelected];
        [cell.contentView addSubview:check];
		if (indexPath.row == 0) {
			self.gigaPay = check;
			self.gigaPay.selected = YES;
		}
		if (indexPath.row == 1) {
            self.wechatPay = check;
        }
        if (indexPath.row == 2) {
            self.aliPay = check;
        }
        if (indexPath.row == 3) {
            self.unionPay = check;
        }
        
        [check addTarget:self action:@selector(checkPayWay:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        name.textColor = receivePerson.textColor;
        name.font = receivePerson.font;
        
        UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(APPScreenWidth - 35 - 120, CGRectGetMinY(receivePerson.frame), 120, receivePerson.frame.size.height)];
        phone.textAlignment = NSTextAlignmentRight;
        phone.textColor = receivePerson.textColor;
        phone.font = receivePerson.font;
        
        UILabel *receivePlace = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(receivePerson.frame), CGRectGetMaxY(receivePerson.frame), 0, 20)];
        receivePlace.font = [UIFont systemFontOfSize:13];
        receivePlace.text = NSLocalizedString(@"SMReceiveAdress", nil);
        receivePlace.textColor = [UIColor darkGrayColor];
        
        CGFloat labelWidth = [UILabel getWidthWithTitle:receivePlace.text font:receivePlace.font];
        receivePlace.frame = CGRectMake(CGRectGetMinX(receivePerson.frame), CGRectGetMaxY(receivePerson.frame), labelWidth, 20);
        
        UILabel *place = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(receivePlace.frame), CGRectGetMinY(receivePlace.frame)+3, APPScreenWidth - 140, 40)];
        place.numberOfLines = 2;
        place.font = receivePlace.font;
        place.textColor = receivePlace.textColor;
        
        [cell.contentView addSubview:icon];
        [cell.contentView addSubview:receivePerson];
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:phone];
        [cell.contentView addSubview:receivePlace];
        [cell.contentView addSubview:place];
        
        CGFloat maskWidth = [UILabel getWidthWithTitle:NSLocalizedString(@"SMConfirmOrderAddressOverRangeMsg", nil) font:[UIFont systemFontOfSize:12]];
        
        UILabel *maskLabal = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth - maskWidth - 10, 50, maskWidth, 20) textColor:[UIColor redColor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"SMConfirmOrderAddressOverRangeMsg", nil)];
        maskLabal.numberOfLines = 0;
        maskLabal.hidden = YES;
        maskLabal.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        [cell.contentView addSubview:maskLabal];
        
        UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(maskLabal.frame)-15, maskLabal.frame.origin.y+4, 12, 12)];
        maskImageView.image = [UIImage imageNamed:@"icon_warning"];
        maskImageView.hidden = YES;
        maskImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:maskImageView];
        
        if (self.address != nil) {
            name.text = self.address.delivery_name;
            phone.text = self.address.mobilepho;
            place.text = [NSString stringWithFormat:@"%@%@",self.address.zip_name,self.address.to_address];
            [place sizeToFit];
            
            if (_address.hasDelivery.integerValue == 0) {
                maskLabal.hidden = NO;
                maskImageView.hidden = NO;
            }
        }

    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"SMConfirmOrderSendWay", nil);
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.detailTextLabel.textColor = [UIColor grayColor];
            cell.detailTextLabel.font = cell.textLabel.font;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@%@",NSLocalizedString(@"SMConfirmOrderExpressTitle",nil),_checkOrderModel.expressPrice,NSLocalizedString(@"SMYuan", nil)];
        } else if (indexPath.row == 1) {
            if (_checkOrderModel.canUseCoupons) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"SMConfirmOrderCanUsePoint", nil),_checkOrderModel.canMaxUsePoint];
            } else {
                cell.textLabel.text = NSLocalizedString(@"SMConfirmOrderCannotUsePoint", nil);
            }
            
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            
            UISwitch *usePoint = [[UISwitch alloc] initWithFrame:CGRectMake(APPScreenWidth - 10 - 50, 8, 25, 25)];
            [cell.contentView addSubview:usePoint];
            
            self.canUsePoint = usePoint;
            [self.canUsePoint addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"使用奢厨优惠券";
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (_checkOrderModel.canUseCoupons) {
                 cell.detailTextLabel.text = [NSString stringWithFormat:@"可用%ld张优惠券",_checkOrderModel.coupons.count];
            } else {
                cell.detailTextLabel.text = @"无可用";
            }
            
            cell.detailTextLabel.font = cell.textLabel.font;
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        else {
            UILabel *payWay = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
            payWay.textColor = [UIColor darkGrayColor];
            payWay.text = NSLocalizedString(@"SMPaymentway", nil);
            payWay.font = [UIFont systemFontOfSize:14];
            
            UILabel *remain = [[UILabel alloc] initWithFrame:CGRectMake(payWay.frame.origin.x, CGRectGetMinY(payWay.frame), 0, 20)];
            remain.textColor = [UIColor darkGrayColor];
            remain.text = @"账户余额:";
            remain.font = [UIFont systemFontOfSize:13];
            
            CGFloat width = [UILabel getWidthWithTitle:remain.text font:remain.font];
            remain.frame = CGRectMake(payWay.frame.origin.x, CGRectGetMaxY(payWay.frame), width, 20);
            
            UILabel *remianMoney = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(remain.frame)+10, remain.frame.origin.y, 100, remain.frame.size.height)];
            remianMoney.textColor = [UIColor redColor];
            remianMoney.font = remain.font;
            remianMoney.text = @"887元";
            
            UIButton *recharge = [UIButton buttonWithType:UIButtonTypeCustom];
            recharge.frame = CGRectMake(APPScreenWidth - 10 - 70, remain.frame.origin.y, 70, remain.frame.size.height);
            [recharge setTitle:@"立即充值" forState:UIControlStateNormal];
            [recharge setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            recharge.titleLabel.font = remain.font;
            
            [cell.contentView addSubview:payWay];
            [cell.contentView addSubview:remain];
            [cell.contentView addSubview:remianMoney];
            [cell.contentView addSubview:recharge];
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        ConfirmOrderheaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"tableHeaderView"];
        return view;
    }
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 40)];
    
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, APPScreenWidth, 40)];
        title.text = NSLocalizedString(@"ChoosePaymentWay_01", nil);
        title.font = [UIFont systemFontOfSize:15];
        title.textColor = [UIColor grayColor];
        
        [view addSubview:title];
        
        return view;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 40;
    }
    if (section == 1) {
        return 40;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return  0.1;
    }
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 110;
    }
    if (indexPath.row == 1) {
        return 45;
    }
    if (indexPath.section == 0) {
        return 75;
    }
    if (indexPath.section == 3) {
        return 45;
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        SupermarketMyAddressViewController *myAddess = [[SupermarketMyAddressViewController alloc] init];
        myAddess.isPageView = NO;
        myAddess.delegate = self;
        if (self.controllerType == ControllerTypeSupermarket) {
            myAddess.isCreateOrder  = YES;
            myAddess.divCode = _checkOrderModel.divCode;
        }

        [self.navigationController pushViewController:myAddess animated:YES];
    }
    
    if (indexPath.section == 3 && indexPath.row == 2) {
        if (_checkOrderModel.cantUseCoupons) {
            SupermarketCouponController *vc = [[SupermarketCouponController alloc] init];
            vc.canUseCoupons = _checkOrderModel.coupons;
            vc.cantUseCoupons = _checkOrderModel.cantUseCoupons;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)switchChange:(UISwitch *)switchButton {
    if (_canUsePoint.isOn == YES) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue - _checkOrderModel.canMaxUsePoint.floatValue];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue];
    }
}

- (void)checkPayWay:(UIButton *)button {
    button.selected = YES;
	if (button == self.gigaPay) {
		_aliPay.selected = NO;
		_unionPay.selected = NO;
		_wechatPay.selected = NO;
	}

    if (button == self.wechatPay) {
        _aliPay.selected = NO;
        _unionPay.selected = NO;
		_gigaPay.selected = NO;
    }
    if (button == self.aliPay) {
        _wechatPay.selected = NO;
        _unionPay.selected = NO;
		_gigaPay.selected = NO;
    }
    if (button == self.unionPay) {
        _wechatPay.selected = NO;
        _aliPay.selected = NO;
		_gigaPay.selected = NO;
    }
}

- (void)selectedAddress:(SupermarketAddressModel *)address {
    NSLog(@"%@",address);
    self.address = address;
    [self.tableView reloadData];
//    [self checkOrder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
