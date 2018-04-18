//
//  SupermarketOrderWaitPayDetailController.m
//  Portal
//
//  Created by ifox on 2017/2/14.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketOrderWaitPayDetailController.h"
#import "UILabel+WidthAndHeight.h"
#import "SupermarketConfirmOrderGoodsCell.h"
#import "UILabel+CreateLabel.h"
#import "CountDown.h"
#import "OrderDetailModel.h"
#import "CYPasswordView.h"
#include <CommonCrypto/CommonDigest.h>
#import "UIButton+CreateButton.h"
#import "PaymentWay.h"

#define BottomHeight 45.0f

@interface SupermarketOrderWaitPayDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic)  CountDown *countDown;
@property (nonatomic, strong) CYPasswordView *passwordView;
@property(nonatomic, strong) UIButton *gigaPay;
@property (nonatomic, strong)UIButton *lgplusPay;
@property(nonatomic, strong) UIButton *wechatPay;
@property(nonatomic, strong) UIButton *unionPay;
@property(nonatomic, strong) UIButton *aliPay;

@end

@implementation SupermarketOrderWaitPayDetailController {
    OrderDetailModel *_orderDetailData;
    NSArray *_payWayTitles;
    NSArray *_payWayImageNames;
}

- (void)dealloc {
    [_countDown destoryTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _payWayTitles = @[@"LG U+",NSLocalizedString(@"气加支付", nil),NSLocalizedString(@"WechatPay", nil),NSLocalizedString(@"AliPay", nil),NSLocalizedString(@"UnionPay", nil)];
    _payWayImageNames = @[@"uplus",@"ico_gigapay",@"icon_weichatpay",@"icon_alipay",@"icon_bank"];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:AliPayCancleNotification object:nil];
    
    self.view.backgroundColor = BGColor;
    self.title = NSLocalizedString(@"SupermarketOrderDetailTitle", nil);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess) name:WeChatPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess) name:AliPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:UnionPaySuccessNotification object:nil];
    if (_countDown == nil) {
        self.countDown = [[CountDown alloc] init];
    }
    [self createView];
    [self requestData];

}

- (void)paySuccess {
	
	// 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
    hud.label.text = NSLocalizedString(@"PaySucMsg", nil);
    hud.label.textColor = [UIColor whiteColor];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payOK"]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:2.0];
    
    [self performSelector:@selector(popController) withObject:nil afterDelay:2.0f];

}


- (void)popController {
	
	[self.navigationController popViewControllerAnimated:YES];
	
    [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGoodsSucNotification object:nil];//刷新数据
}


- (void)createView {
    [self.view addSubview:self.tableView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - BottomHeight, APPScreenWidth, BottomHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, 0, APPScreenWidth/5*2, BottomHeight);
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel setTitle:@"取消订单" forState:UIControlStateNormal];
    cancel.hidden = YES;
    [cancel addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitleColor:[UIColor darkcolor] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:cancel];
    
    UIButton *goPay = [UIButton buttonWithType:UIButtonTypeCustom];
    goPay.frame = CGRectMake(CGRectGetMaxX(cancel.frame), 0, APPScreenWidth/5*3, BottomHeight);
    goPay.backgroundColor = RGB(248, 53, 53);
    [goPay setTitle:@"去结算" forState:UIControlStateNormal];
    goPay.titleLabel.font = [UIFont systemFontOfSize:17];
    [goPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgView addSubview:goPay];
    
    NSMutableString *date = [NSMutableString stringWithString:_data.invalid_date];
    NSString *str3 = [date stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    if (_data.expressStatus == ExpressWaitSend && _data.paymentStatus == OrderWaitPay) {
        cancel.hidden = NO;
    }
    
    NSDate *startDate = [self getDateWithString:_data.severTime];
    NSDate *endDate = [self getDateWithString:_data.invalid_date];

    
    ///每秒回调一次
    [_countDown countDownWithStratDate:startDate finishDate:endDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        if (day > 0 || hour > 0 || minute > 0 || second > 0) {
            [goPay setTitle:[NSString stringWithFormat:@"%@%ld분%ld초",NSLocalizedString(@"SMGoPayMsg", nil),minute,second] forState:UIControlStateNormal];
            [goPay addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [goPay setTitle:NSLocalizedString(@"SMOrderUseless", nil) forState:UIControlStateNormal];
            goPay.backgroundColor = [UIColor lightGrayColor];
            [goPay setTitleColor:[UIColor darkcolor] forState:UIControlStateNormal];
        }
    }];


}

- (void)payAction {
    NSString *payType;
	if (_lgplusPay.selected == YES) {
		payType = @"1";
	}else if (_gigaPay.selected == YES) {
		payType = @"2";
	}else if (_wechatPay.selected == YES) {
        payType = @"3";
    }else if (_aliPay.selected == YES) {
        payType = @"4";
    }else if (_unionPay.selected == YES) {
        payType = @"5";
    }
    MBProgressHUD *payshow = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    payshow.mode = MBProgressHUDModeText;
//    payshow.label.text = @"正在进入支付...";
    [payshow showAnimated:YES];
	NSString *order_num = _data.order_code;
	
	OrderDetailModel *orderDetail = _orderDetailData;
	
	if ([payType isEqualToString:@"2"]) {
		__weak SupermarketOrderWaitPayDetailController *weakSelf = self;
		if (self.passwordView == nil) {
			self.passwordView = [[CYPasswordView alloc] init];
		}
		self.passwordView.title = NSLocalizedString(@"PaymentHint", nil);
		self.passwordView.loadingText = NSLocalizedString(@"PaymentLoadingMsg", nil);
		[self.passwordView showInView:KEYWINDOW];
		
		
		self.passwordView.finish = ^(NSString *password) {
			[weakSelf.passwordView hideKeyboard];
			[weakSelf.passwordView startLoading];
			
			YCAccountModel *model = [YCAccountModel getAccount];
			
			NSString *en512 = [weakSelf sha512:password];
			
			[KLHttpTool supermarketPayWithUserID:model.customCode orderNumber:order_num orderMoney:[NSString stringWithFormat:@"%.2f", weakSelf.data.totalPrice]  actualMoney:orderDetail.realPrice point:weakSelf.data.point couponCode:nil  password:en512 success:^(id response) {
				NSLog(@"%@",response);
				NSNumber *status = response[@"status"];
				
				if (status.integerValue == 1) {
					[weakSelf.passwordView requestComplete:YES message:NSLocalizedString(@"결제 완료", nil)];
					[[NSNotificationCenter defaultCenter] postNotificationName:SupermarketSelectTabBar object:nil];
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
		
	}else if ([payType isEqualToString:@"1"]){
		LGwebViewController *lgupay = [LGwebViewController new];
		lgupay.hidesBottomBarWhenPushed = YES;
		[lgupay loadRequestUrlWithOrderNumber:order_num OrderMoney:orderDetail.realPrice OrderUserName:@"%EA%B9%80%EB%8F%84%EC%84%B1" GiftInfo:@"api%EC%83%88%EB%A1%9C%20%EB%B0%9B%EC%9D%84%EA%B2%83"];
		[self.navigationController pushViewController:lgupay animated:YES];
		
	}

//    [KLHttpTool rsdrugstoreCreateOrderWithPayorderno:_data.order_code withPayorderamount:[NSString stringWithFormat:@"%@",_data.actualMoney] withPaymenttype:payType withPayOrderType:@"1" success:^(id response) {
//        NSString *OrderS = response[@"Data"];
//        if ([payType isEqualToString:@"1"]) {
//            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData: [OrderS dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: nil];
//
//            [PaymentWay wechatpay:dic1 viewController:self];
//        } else if ([payType isEqualToString:@"2"]) {
//
//            [PaymentWay alipay:OrderS];
//        }else if ([payType isEqualToString:@"3"]){
//
//            [PaymentWay unionpay:OrderS viewController:self];
//        }
//        [payshow hideAnimated:YES];
//    } failure:^(NSError *err) {
//
//    }];
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
    [self.navigationController popViewControllerAnimated:YES];
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



- (void)cancelOrder {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认取消订单?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertSureTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [KLHttpTool supermarketCancelOrderWithOrderID:_data.order_code success:^(id response) {
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveGoodsSucNotification object:nil];
            }
            
        } failure:^(NSError *err) {
            
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)requestData {
    if (self.controllerType == ControllerTypeDepartmentStores) {

        [KLHttpTool getSupermarketOrderDetailWithOrderID:_data.order_code appType:8 success:^(id response) {
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSDictionary *data = response[@"data"];
                _orderDetailData = [NSDictionary getOrderDetailModelWithDic:data];
                [self.tableView reloadData];
                NSLog(@"%@",_orderDetailData);
            }
        } failure:^(NSError *err) {
            
        }];
    } else {
        [KLHttpTool getSupermarketOrderDetailWithOrderID:_data.order_code appType:6 success:^(id response) {
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSDictionary *data = response[@"data"];
                _orderDetailData = [NSDictionary getOrderDetailModelWithDic:data];
                [self.tableView reloadData];
                NSLog(@"%@",_orderDetailData);
            }
        } failure:^(NSError *err) {
            
        }];

    }   
}

- (NSDate *)getDateWithString:(NSString *)dateString {
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}


- (NSString *)getNowTimeWithString:(NSString *)aTimeString{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [formater dateFromString:aTimeString];
    NSDate  *nowDate = [NSDate date];
    // 当前时间字符串格式
    NSString *nowDateStr = [formater stringFromDate:nowDate];
    // 当前时间date格式
    nowDate = [formater dateFromString:nowDateStr];
    
    NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];
    
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        return @"订单被取消";
    }
    if (days) {
        return [NSString stringWithFormat:@"%@天 %@小时 %@分 %@秒", dayStr,hoursStr, minutesStr,secondsStr];
    }
    if (hours) {
        return [NSString stringWithFormat:@"%@小时 %@分 %@秒",hoursStr , minutesStr,secondsStr];;
    }
    return [NSString stringWithFormat:@"%@分 %@秒",minutesStr,secondsStr];
}



- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height - BottomHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BGColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[SupermarketConfirmOrderGoodsCell class] forCellReuseIdentifier:@"goodsCell"];
    }
    return _tableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row != 0 && indexPath.row != 1 && indexPath.row != 2) {
            GoodsDetailController *goodsDetail = [[GoodsDetailController alloc] init];
            SupermarketOrderGoodsData *goods = _orderDetailData.goodList[indexPath.row - 3];
            goodsDetail.item_code = goods.item_code;
            goodsDetail.controllerType = self.controllerType;
            goodsDetail.divCode = self.data.divCode;
            [self.navigationController pushViewController:goodsDetail animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30;
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 55;
    }
    return 0.1f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3+_data.goodList.count;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            return 45;
        }
        if (indexPath.row == 0 || indexPath.row == 1) {
            return 75;
        }
        return 110;
    } else {
        return 45;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 40)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        [header addSubview:bgView];
        
        UILabel *shouldPay = [UILabel createLabelWithFrame:CGRectMake(15, 10, 0, 25) textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"SMOrderDetailShouldPay", nil)];
        CGFloat shouldPayWidth = [UILabel getWidthWithTitle:shouldPay.text font:shouldPay.font];
        shouldPay.frame = CGRectMake(15, 5, shouldPayWidth, 25);
//        [bgView addSubview:shouldPay];
		
        UILabel *shouldPayMoney = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(shouldPay.frame)+5, shouldPay.frame.origin.y, 100, CGRectGetHeight(shouldPay.frame)) textColor:[UIColor darkcolor] font:shouldPay.font textAlignment:NSTextAlignmentLeft text:@"15.800"];
        shouldPayMoney.text = [NSString stringWithFormat:@"%.f",[_orderDetailData.order_price doubleValue]];
//        [bgView addSubview:shouldPayMoney];
		
        UILabel *actuallyPayMoney = [UILabel createLabelWithFrame:CGRectMake(0, shouldPayMoney.frame.origin.y, 0, shouldPayMoney.frame.size.height) textColor:[UIColor darkcolor] font:shouldPayMoney.font textAlignment:NSTextAlignmentRight text:@"15.800"];
        actuallyPayMoney.text = [NSString stringWithFormat:@"%.f",[_orderDetailData.realPrice doubleValue]];
        CGFloat actuallyPayMoneyWidth = [UILabel getWidthWithTitle:actuallyPayMoney.text font:actuallyPayMoney.font];
        actuallyPayMoney.frame = CGRectMake(APPScreenWidth - 10 - actuallyPayMoneyWidth, shouldPayMoney.frame.origin.y, actuallyPayMoneyWidth, shouldPayMoney.frame.size.height);
//        [bgView addSubview:actuallyPayMoney];
		
//        UILabel *actuallyPay = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMinX(actuallyPayMoney.frame)-50, actuallyPayMoney.frame.origin.y, 50, actuallyPayMoney.frame.size.height) textColor:[UIColor grayColor] font:actuallyPayMoney.font textAlignment:NSTextAlignmentRight text:NSLocalizedString(@"SMOrderDetailActualPay", nil)];
//        [bgView addSubview:actuallyPay];
		
		UILabel *actuallyPay = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth - 208, actuallyPayMoney.frame.origin.y, 200, actuallyPayMoney.frame.size.height) textColor:[UIColor grayColor] font:actuallyPayMoney.font textAlignment:NSTextAlignmentRight text:[NSString stringWithFormat:@"%@:%.f",NSLocalizedString(@"SMOrderDetailActualPay", nil),[_orderDetailData.realPrice doubleValue]]];
		[bgView addSubview:actuallyPay];

		
        return header;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UILabel *choosePayway = [UILabel createLabelWithFrame:CGRectMake(0, 0, APPScreenWidth, 30) textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"ChoosePaymentWay", nil)];
        return choosePayway;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableViewCell"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, (70 - 22)/2, 22, 22)];
            icon.image = [UIImage imageNamed:@"money"];
            icon.contentMode = UIViewContentModeScaleAspectFit;
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, 5, 200, 20)];
            title.text = NSLocalizedString(@"SMOrderDetailWaitPayTitle", nil);
            title.font = [UIFont systemFontOfSize:15];
            
            UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x, CGRectGetMaxY(title.frame), APPScreenWidth - 10 - title.frame.origin.x, 35)];
            msg.numberOfLines = 0;
            msg.text = NSLocalizedString(@"SMOrderDetailWaitPayMsg", nil);
            msg.font = [UIFont systemFontOfSize:14];
            msg.textColor = [UIColor grayColor];
            
            UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(APPScreenWidth - 10 - 200, title.frame.origin.y, 200, 20)];
            time.textColor = [UIColor grayColor];
            time.font = [UIFont systemFontOfSize:13];
            time.text = _data.createTime;
            time.textAlignment = NSTextAlignmentRight;
            
            [cell.contentView addSubview:icon];
            [cell.contentView addSubview:title];
            [cell.contentView addSubview:msg];
            [cell.contentView addSubview:time];
        }
        else if (indexPath.row == 1) {
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

        }
        else if (indexPath.row == 2) {
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor darkcolor];
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"SMOrderCode", nil),_orderDetailData.order_code];
        } else {
            SupermarketConfirmOrderGoodsCell *cell = [[SupermarketConfirmOrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodsCell"];
                cell.goods = _data.goodList[indexPath.row - 3];
            return cell;
        }
    }
    if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = cell.textLabel.font;
        cell.detailTextLabel.textColor = [UIColor darkcolor];
        if (indexPath.row < 2) {
			cell.textLabel.text = _payWayTitles[indexPath.row];
			UIImage *icon = [UIImage imageNamed:_payWayImageNames[indexPath.row]];
			CGSize itemSize = CGSizeMake(20, 20);
			UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
			CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
			[icon drawInRect:imageRect];
			cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			UIButton *check = [UIButton buttonWithType:UIButtonTypeCustom];
			check.frame = CGRectMake(APPScreenWidth - 10 - 35, 5, 35, 35);
			[check setImage:[UIImage imageNamed:@"icon_unselected"] forState:UIControlStateNormal];
			[check setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateSelected];
			
			[cell.contentView addSubview:check];
			
			if (indexPath.row == 0) {
				
				
				self.lgplusPay = check;
				self.lgplusPay.selected = YES;
			}else if (indexPath.row == 1) {
				self.gigaPay = check;
			}
			[check addTarget:self action:@selector(checkPayWay:) forControlEvents:UIControlEventTouchUpInside];


			

		}
//		if (indexPath.row == 2) {
//			self.wechatPay = check;
//		}
//		if (indexPath.row == 3) {
//			self.aliPay = check;
//		}
//		if (indexPath.row == 4) {
//
//			self.unionPay = check;
//		}

//        if (indexPath.row == 1) {
//            cell.textLabel.text = NSLocalizedString(@"WechatPay", nil);
//        }
//        if(indexPath.row == 2){
//           cell.textLabel.text = @"支付宝支付";
//        }
//        if (indexPath.row == 3) {
//
//             cell.textLabel.text = @"银联支付";
//        }
       else if (indexPath.row == 2) {
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.text = NSLocalizedString(@"SMExpressMsg", nil);
            
            if (_orderDetailData.freight.floatValue > 0) {
             cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",_orderDetailData.freight,NSLocalizedString(@"SMYuan", nil)];
            } else {
                cell.detailTextLabel.text = NSLocalizedString(@"SMExpressFree", nil);
            }
        }
    }
    return cell;
}

- (void)checkPayWay:(UIButton *)button {
    button.selected = YES;
	if (button == self.gigaPay) {
		_unionPay.selected = NO;
		_aliPay.selected = NO;
		_wechatPay.selected = NO;
		_lgplusPay.selected = NO;
	}
	if (button == self.lgplusPay) {
		_unionPay.selected = NO;
		_aliPay.selected = NO;
		_wechatPay.selected = NO;
		_gigaPay.selected = NO;
	}


    if (button == self.wechatPay) {
        _unionPay.selected = NO;
        _aliPay.selected = NO;
		_gigaPay.selected = NO;
		_lgplusPay.selected = NO;
		
    }
    if (button == self.unionPay) {
        _wechatPay.selected = NO;
        _aliPay.selected = NO;
		_gigaPay.selected = NO;
		_lgplusPay.selected = NO;
    }
    if (button == self.aliPay) {
        _unionPay.selected = NO;
        _wechatPay.selected = NO;
		_gigaPay.selected = NO;
		_lgplusPay.selected = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
