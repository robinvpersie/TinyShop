//
//  SupermarketConfirmOrderController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/14.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketConfirmOrderController.h"
#import "SupermarketMyAddressViewController.h"
#import "SupermarketAddressModel.h"
#import "UILabel+WidthAndHeight.h"
#import "GoodsDetailController.h"
#import "SupermarketGoodsViewController.h"
#import "GoodsDetailController.h"
#import "SupermarketReceiveTimeController.h"
#import "SupermarketChoseAddressViewController.h"
#import "SupermarketMyAddressViewController.h"
#import "CYPasswordView.h"
#include <CommonCrypto/CommonDigest.h>
#import "SupermarketMyAddressViewController.h"
#import "SupermarketMyOrderController.h"
#import "SupermarketCouponController.h"
#import "CheckOrderModel.h"
#import "PaymentWay.h"
#import "UPPaymentControl.h"
#import "UILabel+CreateLabel.h"
#import "UILabel+WidthAndHeight.h"

#define BottomHeight 45

@interface SupermarketConfirmOrderController ()<UITableViewDelegate, UITableViewDataSource, MyAddressDelegete>

@property(nonatomic, strong) UIButton *addButton;
@property(nonatomic, strong) UIButton *cutButton;
@property( nonatomic, strong) UILabel *buyAmount;
@property(nonatomic, strong) UILabel *amount;//商品清单旁的x1 x2
@property(nonatomic, strong) NSMutableArray *selectedCoupons;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy) NSString *guid;
@property(nonatomic, strong) NSArray *payWayIcons;
@property(nonatomic, strong) NSArray *payWayTitle;
@property(nonatomic, strong) UIButton *wechatPay;
@property(nonatomic, strong) UIButton *aliPay;
@property(nonatomic, strong) UIButton *unionPay;
@property(nonatomic, strong) UISwitch *canUsePoint;
@property(nonatomic, strong) SupermarketAddressModel *address;
@property (nonatomic, strong) CYPasswordView *passwordView;
@end

@implementation SupermarketConfirmOrderController {
    UILabel *price;
    CheckOrderModel *_checkOrderModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(241, 242, 243);
    
    /** 注册取消按钮点击的通知 */
    [CYNotificationCenter addObserver:self selector:@selector(cancelInputPWD) name:CYPasswordViewCancleButtonClickNotification object:nil];
    [CYNotificationCenter addObserver:self selector:@selector(forgetPWD) name:CYPasswordViewForgetPWDButtonClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedCoupons:) name:CouponSureButtonClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popController) name:TokenWrong object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelInputPWD) name:AliPayCancleNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelInputPWD) name:UnionPayCancelNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:AliPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:WeChatPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:UnionPaySuccessNotification object:nil];

    
    
    self.title = NSLocalizedString(@"SMConfirmOrderTitle", nil);
    
    _payWayTitle =  @[NSLocalizedString(@"WechatPay", nil),NSLocalizedString(@"AliPay", nil),NSLocalizedString(@"UnionPay", nil)];
    _payWayIcons = @[@"icon_weichatpay",@"icon_alipay",@"icon_bank"];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popController2)];
    back.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = back;
    
    [self createTableView];
    
    [self createBottomView];
    
    [self checkOrder];
    
    // Do any additional setup after loading the view.
}

- (void)popController2 {
    NSArray *array = self.navigationController.viewControllers;
    UIViewController *vc = array[1];
    if ([vc isKindOfClass:[GoodsDetailController class]]) {
        GoodsDetailController *detailVC = (GoodsDetailController*)vc;
        NSArray *chidrenVC = detailVC.childViewControllers;
        for (UIViewController *controller in chidrenVC) {
            if ([controller isKindOfClass:[SupermarketGoodsViewController class]]) {
                SupermarketGoodsViewController *goodsVC = (SupermarketGoodsViewController*)controller;
                goodsVC.bottom.hidden = NO;
            }
        }
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)selectedCoupons:(NSNotification *)notification {
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
    
    if (_canUsePoint.isOn) {
            price.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue - _checkOrderModel.canMaxUsePoint.floatValue - totalDecentMoney];
    } else {
            price.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue - totalDecentMoney];
    }
    

}

- (void)cancelInputPWD {
    [self.navigationController popViewControllerAnimated:YES];
    [self performSelector:@selector(showMsg) withObject:nil afterDelay:1.0];
    
}

- (void)forgetPWD {
    
}

- (void)showMsg {
    [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:4 text:NSLocalizedString(@"SMOrderWillCancelMsg", nil)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)getAddressList {
    [MBProgressHUD showWithView:KEYWINDOW];

    NSString *divCode;
    if (self.controllerType == ControllerTypeDepartmentStores) {
        divCode = @"0";
    } else {
        divCode = _checkOrderModel.divCode;
    }
    
    [KLHttpTool getSupermarketUserAddressListWithDivCode:divCode success:^(id response) {
        NSLog(@"%@",response);
        NSMutableArray *array = @[].mutableCopy;
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *data = response[@"data"];
            if (data.count > 0) {
                for (NSDictionary *dic in data) {
                    SupermarketAddressModel *model = [NSDictionary getAddressDataWithDic:dic];
                    [array addObject:model];
                }
                NSInteger hasDefault = 0;
                
                for (SupermarketAddressModel *addressModel in array) {
                    if (addressModel.isdefault.integerValue == 1) {
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

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height-BottomHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];
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
    
    price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sumMoney.frame)+10, 0, 100, BottomHeight)];
    price.font = [UIFont systemFontOfSize:15];
    price.textColor = [UIColor redColor];
//    price.text = @"¥45";
   
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(APPScreenWidth - 107, 7, 100, BottomHeight - 14);
    submitBtn.layer.cornerRadius = 2.0f;
    submitBtn.backgroundColor = RGB(33, 192, 67);

    [submitBtn setTitle:NSLocalizedString(@"SMConfirmOrderSubmitButtonTitle", nil) forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [submitBtn addTarget:self action:@selector(createOrder) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [bottomView addSubview:sumMoney];
    [bottomView addSubview:price];
    [bottomView addSubview:submitBtn];
    
    [self.view addSubview:bottomView];
}

- (void)checkOrder {
    NSMutableDictionary *parmas = @{}.mutableCopy;
    NSMutableArray *goods = @[].mutableCopy;
    NSMutableDictionary *good = @{}.mutableCopy;
    [good setObject:self.goodsModel.supplier_code forKey:@"custom_code"];
    [good setObject:self.goodsModel.itemCode forKey:@"item_code"];
    [good setObject:@(self.amout) forKey:@"count"];
    [good setObject:self.goodsModel.price forKey:@"unit_price"];
    [good setObject:self.goodsModel.business_code forKey:@"DIV_CODE"];
    [goods addObject:good];
    [parmas setObject:goods forKey:@"goods"];
    NSMutableArray *attchments = @[].mutableCopy;
    for (GoodsOptionModel *option in self.attachGoods) {
        NSMutableDictionary *attch = [NSMutableDictionary dictionary];
        [attch setObject:self.goodsModel.supplier_code forKey:@"custom_code"];
        [attch setObject:option.item_code forKey:@"item_code"];
        [attch setObject:option.item_price forKey:@"unit_price"];
        [attch setObject:self.goodsModel.business_code forKey:@"div_code"];
        [attchments addObject:attch];
    }
    [parmas setObject:attchments forKey:@"attachment"];
    [MBProgressHUD showWithView:KEYWINDOW];
    
    if (self.controllerType == ControllerTypeDepartmentStores) {

        [KLHttpTool supermarketCheckBeforeCreateOrder:parmas isShoppingCart:false appType:8 success:^(id response) {
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSDictionary *data = response[@"data"];
                _checkOrderModel = [NSDictionary getSupermarketCheckOrderModelWithDic:data];
                [_tableView reloadData];
                [self getAddressList];
                float totalMoney = self.goodsModel.price.floatValue * _amout;
                self.totalPrice = totalMoney;
                if (_canUsePoint.isOn == YES) {
                    price.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue - _checkOrderModel.canMaxUsePoint.floatValue];
                } else {
                    price.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue];
                }
                
            }
        } failure:^(NSError *err) {
            
        }];

    } else {
        [KLHttpTool supermarketCheckBeforeCreateOrder:parmas isShoppingCart:false appType:6 success:^(id response) {
            NSLog(@"%@",response);
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSDictionary *data = response[@"data"];
                _checkOrderModel = [NSDictionary getSupermarketCheckOrderModelWithDic:data];
                [_tableView reloadData];
                [self getAddressList];
                float totalMoney = self.goodsModel.price.floatValue * _amout;
                self.totalPrice = totalMoney;
                if (_canUsePoint.isOn == YES) {
                    price.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue - _checkOrderModel.canMaxUsePoint.floatValue];
                } else {
                    price.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue];
                }
                
            }
        } failure:^(NSError *err) {
            
        }];
    }
    
}

-(void)doAutoMatchingAPI {
    [MBProgressHUD showWithView:self.view];
    __weak typeof(self) weakself = self;
    [KLHttpTool autoMatching:^(id response) {
        [MBProgressHUD hideHUDForView:weakself.view animated:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"status"] isEqualToString:@"1"]) {
            [MBProgressHUD hideAfterDelayWithView:weakself.view interval:1.5 text:@"自动匹配成功"];
        }else {
            [MBProgressHUD hideAfterDelayWithView:weakself.view interval:1.5 text:@"自动匹配失败"];
        }
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:weakself.view animated:true];
        [MBProgressHUD hideAfterDelayWithView:weakself.view interval:1.5 text:@"自动匹配失败"];
    }];
}

-(void)doAutoMatching {
    UIAlertAction *matchAction = [UIAlertAction actionWithTitle:@"匹配" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RecommendMatchController *matchController = [[RecommendMatchController alloc]init];
        matchController.from = 1;
        [self.navigationController pushViewController:matchController animated:true];
    }];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"继续进行" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self doAutoMatchingAPI];
    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"如果需要进行购买的话需要先进行推荐人匹配，需要继续进行吗？(如果选择继续进行的话，则自动进行匹配)" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:matchAction];
    [alertController addAction:continueAction];
    [self presentViewController:alertController animated:YES completion:^{ }];
}

- (void)createOrder {
    if (_checkOrderModel.guid.length == 0) {
        return;
    }
    
    if (self.address.hasDelivery.integerValue == 0) {
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2.0f text:NSLocalizedString(@"SMConfirmOrderAddressOverRange", nil)];
        return;
    }
    
    YCAccountModel *account = [YCAccountModel getAccount];
    if (account.parentId == nil && account.parentId.length > 0) {
        [self doAutoMatching];
        return;
    }
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:self.address.addressID forKey:@"locationId"];
    
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
    if (self.canUsePoint.isOn == YES) {
        point = [_checkOrderModel.canMaxUsePoint stringValue];
    } else {
        point = @"0";
    }
    
    if (self.controllerType == ControllerTypeDepartmentStores) {
        __weak typeof(self) weakself = self;
        [KLHttpTool supermarketCreateOrderWithGUID:_checkOrderModel.guid points:point coupons:couponIDs validateInfo:info success:^(id response) {
            NSLog(@"%@",response);
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSString *orderCode = response[@"order_code"];
                NSString *money = response[@"amount"];
                NSString *point = response[@"pointAmount"];
                NSString *actualMoney = response[@"real_amount"];
                
                if (_wechatPay.selected == YES) {//微信支付
                    __weak SupermarketConfirmOrderController *weakSelf = self;
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
                              
                                [PaymentWay wechatpay:data viewController:weakself];
                            }
                            else {
                                [weakSelf.passwordView requestComplete:NO message:response[@"msg"]];
                                [weakSelf performSelector:@selector(hidePassWordView) withObject:nil afterDelay:2.0];
                            }
                            
                        } failure:^(NSError *err) {
                            
                        }];
                        
                    };
                    
                } else if (_aliPay.selected == YES) {
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
                    
                } else if (_wechatPay.selected == YES) {
                    [KLHttpTool supermarketGetUnionPayStrWithOrderNum:orderCode payAmount:actualMoney success:^(id response) {
                        if (status.integerValue == 1) {
                            NSString *data = response[@"data"];
                            //                        [self unionpay:data];
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
        __weak typeof(self) weakself = self;
        NSString *paytype;
         if (_wechatPay.selected == YES) {//微信支付
             paytype = @"1";
         }else if (_aliPay.selected == YES){//支付宝
              paytype = @"2";
         }else if (_unionPay.selected == YES){//银联
              paytype = @"3";
         }
        MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud1 showAnimated:YES];
           
        [KLHttpTool supermarketCreateOrderWithGUID:_checkOrderModel.guid points:point coupons:couponIDs validateInfo:info success:^(id response) {
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSString *orderCode = response[@"order_code"];
                NSString *money = response[@"amount"];
                NSString *point = response[@"pointAmount"];
                NSString *actualMoney = response[@"real_amount"];
                [KLHttpTool rsdrugstoreCreateOrderWithPayorderno:orderCode withPayorderamount:actualMoney withPaymenttype:paytype withPayOrderType:@"1" success:^(id response) {
                    if ([response[@"Status"] intValue] == 0) {//生成订单成功
                        NSString *dataS = response[@"Data"];
                        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData: [dataS dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: nil];
                       
                            if ([paytype isEqualToString:@"1"]) {
                                [PaymentWay wechatpay:dic1 viewController:weakself];
                               
                            }
                            if ([paytype isEqualToString:@"2"]) {
                                [PaymentWay alipay:dataS];
                            }
                            if ([paytype isEqualToString:@"3"]) {
                                [PaymentWay unionpay:dataS viewController:weakself];
                            }
                            [hud1 hideAnimated:YES];
                        
           
                    }
                } failure:^(NSError *err) {
                    
                }];
               
                
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
    hud.label.text = @"支付成功";
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

- (void)checkPassword {
    [self.passwordView requestComplete:YES message:NSLocalizedString(@"PaySucMsg", nil)];
    
    [self performSelector:@selector(hidePassWordView) withObject:nil afterDelay:2.0];
}

- (void)popControllerAndHide {
    [self.passwordView hide];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)hidePassWordView {
    [self.passwordView hide];

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
    } else if (section == 2) {
        return 2;
    } else if (section == 1) {
        return _payWayTitle.count;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
//        phone.text = @"18300000000";
        
        UILabel *receivePlace = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(receivePerson.frame), CGRectGetMaxY(receivePerson.frame), 0, 20)];
        receivePlace.font = [UIFont systemFontOfSize:13];
        receivePlace.text = NSLocalizedString(@"SMReceiveAdress", nil);
        receivePlace.textColor = [UIColor darkGrayColor];
        
        CGFloat labelWidth = [UILabel getWidthWithTitle:receivePlace.text font:receivePlace.font];
        receivePlace.frame = CGRectMake(CGRectGetMinX(receivePerson.frame), CGRectGetMaxY(receivePerson.frame), labelWidth, 20);
        
        UILabel *place = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(receivePlace.frame), CGRectGetMinY(receivePlace.frame), APPScreenWidth - 140, 40)];
        place.numberOfLines = 2;
//        place.text = @"湖南省长沙市芙蓉区人民东路139号宇成国际酒店";
        place.font = receivePlace.font;
        place.textColor = receivePlace.textColor;
        
        [cell.contentView addSubview:icon];
        [cell.contentView addSubview:receivePerson];
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:phone];
        [cell.contentView addSubview:receivePlace];
        [cell.contentView addSubview:place];
        
        CGFloat maskWidth = [UILabel getWidthWithTitle:@"地址超出配送范围" font:[UIFont systemFontOfSize:12]];
        
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
            name.text = _address.realname;
            phone.text = _address.mobile;
            place.text = [NSString stringWithFormat:@"%@%@",_address.location,_address.address];
            [place sizeToFit];
            
            if (_address.hasDelivery.integerValue == 0) {
                maskLabal.hidden = NO;
                maskImageView.hidden = NO;
            }
        }
    }
    else if (indexPath.section == 1) {
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
            self.wechatPay = check;
            self.wechatPay.selected = YES;
        }
        if (indexPath.row == 1) {
            self.aliPay = check;
           
        }
        if (indexPath.row == 2) {
           self.unionPay = check;
        }
        
        [check addTarget:self action:@selector(checkPayWay:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
            icon.image = [UIImage imageNamed:@"icon_commoditylist"];
            [cell.contentView addSubview:icon];
            
            UILabel *goodsList = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, icon.frame.origin.y, 120, icon.frame.size.height)];
            goodsList.text = NSLocalizedString(@"SMConfirmOrderHeaderTitle", nil);
            goodsList.textColor = [UIColor darkGrayColor];
            goodsList.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:goodsList];
            
            UIButton *down = [UIButton buttonWithType:UIButtonTypeCustom];
            down.frame = CGRectMake(APPScreenWidth - 25 - 10, icon.frame.origin.y, 20, 20);
            [down setImage:[UIImage imageNamed:@"icon-_down"] forState:UIControlStateNormal];
            [cell.contentView addSubview:down];
            
        } else {
            UIImageView *goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 100, 100)];
            goodsImage.image = [UIImage imageNamed:@"img_001"];
            goodsImage.contentMode = UIViewContentModeScaleAspectFit;
            goodsImage.clipsToBounds = YES;
            [cell.contentView addSubview:goodsImage];
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImage.frame)+10, goodsImage.frame.origin.y, APPScreenWidth - 100 - 10 - 15 - 10, 40)];
            title.textColor = [UIColor darkGrayColor];
            title.text = @"挪威新鲜无公害精选无公害果干无公害果干";
            title.numberOfLines = 2;
            title.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:title];
            
            //单价
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(title.frame), 110 - 10 - 20, 120, 20)];
            priceLabel.textColor = [UIColor redColor];
            priceLabel.font = [UIFont systemFontOfSize:14];
            priceLabel.text = @"￥8.9/kg";
            [cell.contentView addSubview:priceLabel];
            
            UILabel *amount = [[UILabel alloc] initWithFrame:CGRectMake(APPScreenWidth - 10 - 80, priceLabel.frame.origin.y, 80, 20)];
            amount.textAlignment = NSTextAlignmentRight;
            amount.textColor = [UIColor darkGrayColor];
            amount.text = @"x1";
            amount.font = [UIFont systemFontOfSize:12];
            self.amount = amount;
            [cell.contentView addSubview:amount];
            
            if (self.goodsModel != nil) {
                NSDictionary *urlDic = self.goodsModel.images[0];
                NSString *url = urlDic[@"url"];
                [UIImageView setimageWithImageView:goodsImage UrlString:url imageVersion:nil];
                title.text = self.goodsModel.title;
                priceLabel.text = [NSString stringWithFormat:@"￥%@",self.goodsModel.price];
                amount.text = [NSString stringWithFormat:@"X%ld",self.amout];
            }
        }
    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0) {

            cell.textLabel.text = NSLocalizedString(@"SMConfirmOrderSendWay", nil);
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@%@",NSLocalizedString(@"SMConfirmOrderExpressTitle", nil),_checkOrderModel.expressPrice,NSLocalizedString(@"SMYuan", nil)];
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
            cell.detailTextLabel.textColor = [UIColor grayColor];
            
        }
        else if (indexPath.row == 1) {
            if (_checkOrderModel.canUsePoint) {
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
        }
        else if (indexPath.row == 2) {
            if (_checkOrderModel.canUseCoupons) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"可用%ld张优惠券",_checkOrderModel.coupons.count];
            } else {
                cell.detailTextLabel.text = @"无可用";
            }
            cell.textLabel.text = @"使用奢厨优惠券";
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
            cell.detailTextLabel.font = cell.textLabel.font;
            cell.detailTextLabel.textColor = [UIColor grayColor];

        }
        else if (indexPath.row == 3) {

        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 75;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 45;
        } else {
            return 110;
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            return 45;
        } else {
            return 45;
        }
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    }
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {

//        SupermarketChoseAddressViewController *address = [[SupermarketChoseAddressViewController alloc] init];
//        [self.navigationController pushViewController:address animated:YES];
        SupermarketMyAddressViewController *address = [[SupermarketMyAddressViewController alloc] init];
        address.isPageView = NO;
        address.delegate = self;
        if (self.controllerType == ControllerTypeSupermarket) {
            address.isCreateOrder  = YES;
            address.divCode = _checkOrderModel.divCode;
        }
        [self.navigationController pushViewController:address animated:YES];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            SupermarketReceiveTimeController *vc = [[SupermarketReceiveTimeController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 2) {
            if (_checkOrderModel.cantUseCoupons) {
                SupermarketCouponController *vc = [[SupermarketCouponController alloc] init];
                vc.canUseCoupons = _checkOrderModel.coupons;
                vc.cantUseCoupons = _checkOrderModel.cantUseCoupons;
                [self.navigationController pushViewController:vc animated:YES];

            } 
        }
    }
    
    
}

#pragma mark - ButtonAction

- (void)addButtonPress:(UIButton *)button {
    NSInteger amount = self.buyAmount.text.integerValue;
    
    amount++;
    
    if (amount > self.goodsModel.stock.integerValue) {
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:3 text:@"商品库存不足"];
        return;
    }
    
    self.buyAmount.text = [NSString stringWithFormat:@"%ld",amount];
    self.amount.text = [NSString stringWithFormat:@"x %@",self.buyAmount.text];
    
    float money = self.buyAmount.text.integerValue * self.goodsModel.price.floatValue;
    
    price.text = [NSString stringWithFormat:@"￥%.2f",money+8];
}

- (void)cutButtonPress:(UIButton *)button {
    NSInteger amount = self.buyAmount.text.integerValue;
    
    if (amount == 1) {
        return;
    }
    
    amount--;
    
    self.buyAmount.text = [NSString stringWithFormat:@"%ld",amount];
    self.amount.text = [NSString stringWithFormat:@"x %@",self.buyAmount.text];
    
    float money = self.buyAmount.text.integerValue * self.goodsModel.price.floatValue;
    
    price.text = [NSString stringWithFormat:@"￥%.2f",money+8];
}

- (void)switchChange:(UISwitch *)switchButton {
    if (_canUsePoint.isOn == YES) {
       price.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue - _checkOrderModel.canMaxUsePoint.floatValue];
    } else {
       price.text = [NSString stringWithFormat:@"¥%.2f",self.totalPrice+_checkOrderModel.expressPrice.floatValue];
    }
}


- (void)checkPayWay:(UIButton *)button {
    button.selected = YES;
   
    if (button == self.wechatPay) {
        _unionPay.selected = NO;
        _aliPay.selected = NO;
    }
    if (button == self.aliPay) {
        _wechatPay.selected = NO;
        _unionPay.selected = NO;
    }
    if (button == self.unionPay) {
        _wechatPay.selected = NO;
        _aliPay.selected = NO;
    }
}


- (void)selectedAddress:(SupermarketAddressModel *)address {
    self.address = address;
    
    [self.tableView reloadData];
    
//    [self checkOrder];
}

- (void)popController {
    NSArray *array = self.navigationController.viewControllers;
    UIViewController *vc = array[1];
    if ([vc isKindOfClass:[GoodsDetailController class]]) {
        GoodsDetailController *detailVC = (GoodsDetailController*)vc;
        NSArray *chidrenVC = detailVC.childViewControllers;
        for (UIViewController *controller in chidrenVC) {
            if ([controller isKindOfClass:[SupermarketGoodsViewController class]]) {
                SupermarketGoodsViewController *goodsVC = (SupermarketGoodsViewController*)controller;
                goodsVC.bottom.hidden = NO;
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
