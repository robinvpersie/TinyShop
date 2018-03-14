//
//  HotelPaymentController.m
//  Portal
//
//  Created by ifox on 2017/4/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelPaymentController.h"
#import "HotelPaymentRoomCell.h"
#import "UIButton+CreateButton.h"
#import "CYPasswordView.h"
#import "YCShareAddress.h"
#import "PaymentWay.h"
#import "HotelReserveResultDetailController.h"
#import "UILabel+CreateLabel.h"
#import "CountDown.h"

@interface HotelPaymentController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *payIcons;
@property(nonatomic, strong) NSArray *payTitles;
@property(nonatomic, strong) UIImageView *chooseIcon;
@property (nonatomic, strong) CYPasswordView *passwordView;
@property (strong, nonatomic)  CountDown *countDown;

@end

@implementation HotelPaymentController

- (void)dealloc {
    [_countDown destoryTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"HotelPaymentTitle", nil);
    self.view.backgroundColor = BGColor;
    _payIcons = @[@"icon_yuchengpay",@"icon_alipay",@"icon_bank"];
    _payTitles = @[NSLocalizedString(@"WechatPay", nil),NSLocalizedString(@"AliPay", nil),NSLocalizedString(@"UnionPay", nil)];
    _chooseIcon = [[UIImageView alloc] initWithFrame:CGRectMake(APPScreenWidth - 10 - 20, 12, 20, 20)];
    _chooseIcon.image = [UIImage imageNamed:@"icon_selected"];
    
    if (_countDown == nil) {
        self.countDown = [[CountDown alloc] init];
    }
    
    [self.view addSubview:self.tableView];
    
    [self createTableViewFooter];
    
    [self createTableHeaderView];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popToRootController)];
    back.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = back;
    
    // Do any additional setup after loading the view.
}

- (void)popToRootController {
    if (self.isCreate == YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:4.0f text:NSLocalizedString(@"SMOrderWillCancelMsg", nil)];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createTableViewFooter {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 300)];
    footer.backgroundColor = BGColor;
    
    NSString *buttonTitle = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"HotelConfirmPay", nil),self.paymentMoney];
    
    UIButton *pay = [UIButton createButtonWithFrame:CGRectMake(15, 20, APPScreenWidth - 30, 40) title:buttonTitle titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:14] backgroundColor:HotelYellowColor];
    [pay addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:pay];
    pay.layer.cornerRadius = 5.0f;
    self.tableView.tableFooterView = footer;
}

- (void)createTableHeaderView {
    
    NSDate *startDate = [self getDateWithString:self.serverTime];
    NSDate *endDate = [self getDateWithString:self.overTime];
    
     UILabel *header = [UILabel createLabelWithFrame:CGRectMake(0, 0, APPScreenWidth, 45) textColor:PurpleColor font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentCenter text:@""];
    header.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 45)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:header];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, APPScreenWidth, 0.7f)];
    line.backgroundColor = BorderColor;
    [headerView addSubview:line];
    
    self.tableView.tableHeaderView = headerView;
    
     [_countDown countDownWithStratDate:startDate finishDate:endDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        if (day > 0 || hour > 0 || minute > 0 || second > 0) {
            header.text = [NSString stringWithFormat:@"%@%ld:%ld",NSLocalizedString(@"HotelPayRemainTime", nil),minute,second];
        } else {
            header.text = NSLocalizedString(@"SMOrderUseless", nil);
        }
     }];
}

- (void)payAction:(UIButton *)button {
    UIView *view = _chooseIcon.superview.superview;
    if ([view isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)view;
        NSIndexPath *indexpath = [_tableView indexPathForCell:cell];
        if (indexpath.row == 1) {//宇成支付
            __weak HotelPaymentController *weakSelf = self;
            if (self.passwordView == nil) {
                self.passwordView = [[CYPasswordView alloc] init];
            }
            self.passwordView.title = NSLocalizedString(@"PaymentHint", nil);
            self.passwordView.loadingText = NSLocalizedString(@"PaymentLoadingMsg", nil);
            [self.passwordView showInView:KEYWINDOW];
            
            self.passwordView.finish = ^(NSString *password) {
                [weakSelf.passwordView hideKeyboard];
                [weakSelf.passwordView startLoading];
                
                NSString *en512 = [YCShareAddress sha512:password];
                
                YCAccountModel *model = [YCAccountModel getAccount];
                
                [KLHttpTool supermarketPayWithUserID:model.memid orderNumber:weakSelf.orderNum orderMoney:weakSelf.orderMoney actualMoney:weakSelf.paymentMoney point:weakSelf.point couponCode:nil password:en512 success:^(id response) {
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
        
        if (indexpath.row == 2) {//支付宝支付
            [KLHttpTool supermarketGetAlipayStrWithOrderNum:self.orderNum payAmount:self.paymentMoney success:^(id response) {
                NSLog(@"%@",response);
                NSNumber *status = response[@"status"];
                if (status.integerValue == 1) {
                    NSString *data = response[@"data"];
                    //                        [self alipay:data];
                    [PaymentWay alipay:data];
                }
            } failure:^(NSError *err) {
                
            }];
        }
        
        if (indexpath.row == 3) {//银联支付
            [KLHttpTool supermarketGetUnionPayStrWithOrderNum:self.orderNum payAmount:self.paymentMoney success:^(id response) {
                NSString *data = response[@"data"];
                [PaymentWay unionpay:data viewController:self];
                
            } failure:^(NSError *err) {
                
            }];
        }
    }
}

- (void)hidePassWordView {
    [self.passwordView hide];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    HotelReserveResultDetailController *orderDetail = [[HotelReserveResultDetailController alloc] init];
    orderDetail.orderNum = self.orderNum;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = BGColor;
        UINib *nib = [UINib nibWithNibName:@"HotelPaymentRoomCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"RoomCell"];
    }
    return _tableView;
}

#pragma mark -- UITableViewDataSource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 12.0f;
    } else {
        return 0.1f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    }
    else {
        return 45;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HotelPaymentRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomCell"];
        [UIImageView hotelSetImageWithImageView:cell.roomIcon UrlString:_roomModel.iconUrl imageVersion:nil];
        cell.hotelNameLabel.text = self.hotelName;;
        cell.roomTypeName.text = _roomModel.roomTypeName;
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",_paymentMoney];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@,%@%@%@",self.startDate,NSLocalizedString(@"HotelZhi",nil),self.endDate,NSLocalizedString(@"HotelTotal",nil),self.liveDays,NSLocalizedString(@"HotelDay", nil)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = HotelBlackColor;
            cell.textLabel.text = NSLocalizedString(@"SMPaymentway", nil);
        }
        if (indexPath.row > 0) {
            if (indexPath.row == 1) {
                [cell.contentView addSubview:_chooseIcon];
            }
            UIImage *icon = [UIImage imageNamed:_payIcons[indexPath.row - 1]];
            CGSize itemSize = CGSizeMake(20, 20);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
            CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
            [icon drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = HotelLightGrayColor;
            cell.textLabel.text = _payTitles[indexPath.row - 1];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row > 0) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell.contentView addSubview:_chooseIcon];
        }
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


@end
