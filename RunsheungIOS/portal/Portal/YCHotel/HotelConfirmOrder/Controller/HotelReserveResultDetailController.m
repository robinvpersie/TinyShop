//
//  HotelReserveResultDetailController.m
//  Portal
//
//  Created by ifox on 2017/4/14.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelReserveResultDetailController.h"
#import "UIButton+CreateButton.h"
#import "HotelReseveResultInfoTableViewCell.h"
#import "HotelProgressView.h"
#import "UILabel+CreateLabel.h"
#import "UIButton+CreateButton.h"
#import "CancelOrderViewController.h"
#import "HotelOrderDetailModel.h"
#import "CountDown.h"
#import "NSDate+HotelAddition.h"
#import "UILabel+WidthAndHeight.h"
#import "HotelQRCodeView.h"
#import "HotelCheckQRCodeCell.h"
#import "HotelPaymentController.h"
#import "HotelRoomTypeModel.h"
#import "HotelOrderDetailRoomModel.h"
#import "HotelReleaseCommentViewController.h"

@interface HotelReserveResultDetailController ()<UITableViewDelegate, UITableViewDataSource,HotelCheckQRCodeCellDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UIView *payFinishHeader;
@property(nonatomic, strong) UIView *waitPayHeader;
@property(nonatomic, strong) UIView *orderOverTimeHeader;
@property(nonatomic, strong) UIView *orderGoCommentHeader;

@property(nonatomic, strong) UIView *cancelOrderFooter;//取消订单
@property(nonatomic, strong) UIView *deleteOrderFooter;//删除订单

@property(nonatomic, strong) CountDown *countDown;
@property(nonatomic, strong) HotelQRCodeView *qrCodeView;

@property(nonatomic, strong) UILabel *min;
@property(nonatomic, strong) UILabel *sec;
@property(nonatomic, strong) UILabel *roomInfo;

@property(nonatomic, strong) UILabel *headerLabel;

@end

@implementation HotelReserveResultDetailController {
    NSArray *_reserveMsgTitle;
    NSArray *_orderMsgTitle;
    HotelOrderDetailModel *_orderDetail;
    HotelProgressView *progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGColor;
    self.title = NSLocalizedString(@"SupermarketOrderDetailTitle", nil);
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popToRootController)];
    self.navigationItem.leftBarButtonItem = back;
    
    _countDown = [[CountDown alloc] init];
    
    _reserveMsgTitle = @[NSLocalizedString(@"HotelOrderDetailTitle_0", nil),NSLocalizedString(@"HotelOrderDetailTitle_1", nil),NSLocalizedString(@"HotelOrderDetailTitle_2", nil),NSLocalizedString(@"HotelOrderDetailTitle_3", nil),NSLocalizedString(@"HotelOrderDetailTitle_4", nil),NSLocalizedString(@"HotelOrderDetailTitle_5", nil)];
    _orderMsgTitle = @[NSLocalizedString(@"HorelOrderDetailMsgTitle_0", nil),NSLocalizedString(@"HorelOrderDetailMsgTitle_1", nil),NSLocalizedString(@"HorelOrderDetailMsgTitle_2", nil),NSLocalizedString(@"HorelOrderDetailMsgTitle_3", nil),NSLocalizedString(@"HorelOrderDetailMsgTitle_4", nil),NSLocalizedString(@"HorelOrderDetailMsgTitle_5", nil),NSLocalizedString(@"HorelOrderDetailMsgTitle_6", nil)];
    
    [self requestData];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[HotelReseveResultInfoTableViewCell class] forCellReuseIdentifier:@"InfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HotelCheckQRCodeCell" bundle:nil] forCellReuseIdentifier:@"QRCodeCell"];
    
    [self createHeader];
    
    [self createFooter];
    
    _qrCodeView = [[HotelQRCodeView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight)];
    _qrCodeView.hidden = YES;
    [KEYWINDOW addSubview:_qrCodeView];
    
    // Do any additional setup after loading the view.
}

- (void)popToRootController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createHeader {
    //支付完成的头
    UIView *payheader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 140)];
    payheader.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [UILabel createLabelWithFrame:CGRectMake(70, 0, APPScreenWidth - 140, 70) textColor:PurpleColor font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"HotelOrderDetailIDMsg", nil)];
    title.numberOfLines = 0;
    [payheader addSubview:title];
    
    progressView = [[HotelProgressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame), APPScreenWidth, 60)];
    [payheader addSubview:progressView];
    self.payFinishHeader = payheader;
    
    //待支付头部
    UIView *waitPayHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 140)];
    waitPayHeader.backgroundColor = [UIColor whiteColor];
    self.waitPayHeader = waitPayHeader;
    
    UILabel *msg = [UILabel createLabelWithFrame:CGRectMake(0, 0, APPScreenWidth, 40) textColor:PurpleColor font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"HotelOrderDetailCancel", nil)];
    UILabel *dot = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth/2 - 12, CGRectGetMaxY(msg.frame), 25, 30) textColor:PurpleColor font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentCenter text:@":"];
    UILabel *min = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMinX(dot.frame)-30, dot.frame.origin.y, dot.frame.size.height, dot.frame.size.height) textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentCenter text:@""];
    self.min = min;
    min.backgroundColor = PurpleColor;
    UILabel *sec = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(dot.frame), dot.frame.origin.y, dot.frame.size.height, dot.frame.size.height) textColor:[UIColor whiteColor] font:min.font textAlignment:NSTextAlignmentCenter text:@""];
    self.sec = sec;
    sec.backgroundColor = PurpleColor;
    UIButton *pay = [UIButton createButtonWithFrame:CGRectMake(15, CGRectGetMaxY(dot.frame)+10, APPScreenWidth - 30, 30) title:NSLocalizedString(@"HotelOrderPayNow", nil) titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:14] backgroundColor:[UIColor orangeColor]];
    [pay addTarget:self action:@selector(payButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [waitPayHeader addSubview:msg];
    [waitPayHeader addSubview:dot];
    [waitPayHeader addSubview:sec];
    [waitPayHeader addSubview:min];
    [waitPayHeader addSubview:pay];
    waitPayHeader.frame = CGRectMake(0, 0, APPScreenWidth, CGRectGetMaxY(pay.frame)+10);
    
    //超时头部
    UIView *overTimeHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 45)];
    
    UILabel *overTimeMsg = [UILabel createLabelWithFrame:CGRectMake(0, 0, APPScreenWidth, 45) textColor:PurpleColor font:[UIFont boldSystemFontOfSize:14] textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"HotelOrderOverTime", nil)];
    overTimeMsg.backgroundColor = [UIColor whiteColor];
    [overTimeHeader addSubview:overTimeMsg];
    self.headerLabel = overTimeMsg;
    self.orderOverTimeHeader = overTimeHeader;
    
    //评价头部
    UIView *commentHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 0)];
    commentHeader.backgroundColor = [UIColor whiteColor];
    UILabel *commentMsg = [UILabel createLabelWithFrame:CGRectMake(0, 0, APPScreenWidth, 45) textColor:PurpleColor font:[UIFont boldSystemFontOfSize:15] textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"HotelOrderThanks", nil)];
    [commentHeader addSubview:commentMsg];
    UIButton *goComment = [UIButton createButtonWithFrame:CGRectMake(APPScreenWidth/2 - 50, CGRectGetMaxY(commentMsg.frame), 100, 25) title:NSLocalizedString(@"HotelOrderGoComment", nil) titleColor:PurpleColor titleFont:[UIFont systemFontOfSize:14] backgroundColor:[UIColor whiteColor]];
    goComment.layer.borderColor = PurpleColor.CGColor;
    goComment.layer.borderWidth = 0.7f;
    [goComment addTarget:self action:@selector(goComment) forControlEvents:UIControlEventTouchUpInside];
    [commentHeader addSubview:goComment];
    commentHeader.frame = CGRectMake(0, 0, APPScreenWidth, CGRectGetMaxY(goComment.frame)+20);
    self.orderGoCommentHeader = commentHeader;
}

- (void)createFooter {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 200)];
    footer.backgroundColor = BGColor;
    UIButton *cancelOrder = [UIButton createButtonWithFrame:CGRectMake(15, 10, APPScreenWidth - 30, 40) title:@"取消订单" titleColor:[UIColor redColor] titleFont:[UIFont systemFontOfSize:16] backgroundColor:[UIColor clearColor]];
    [cancelOrder addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    cancelOrder.layer.borderColor = [UIColor redColor].CGColor;
    cancelOrder.layer.borderWidth = 0.7f;
    cancelOrder.layer.cornerRadius = 5.0f;
    [footer addSubview:cancelOrder];
    self.cancelOrderFooter = footer;
    
    //删除订单
    UIView *deleteFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 200)];
    deleteFooter.backgroundColor = BGColor;
    UIButton *deleteOrder = [UIButton createButtonWithFrame:CGRectMake(15, 10, APPScreenWidth - 30, 40) title:@"删除订单" titleColor:[UIColor redColor] titleFont:[UIFont systemFontOfSize:16] backgroundColor:[UIColor clearColor]];
    deleteOrder.layer.cornerRadius = 5.0f;
    deleteOrder.layer.borderColor = [UIColor redColor].CGColor;
    deleteOrder.layer.borderWidth = 0.7f;
    [deleteFooter addSubview:deleteOrder];
    [deleteOrder addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchUpInside];
    self.deleteOrderFooter = deleteFooter;
}

- (void)payButtonPressed {
    HotelPaymentController *payment = [[HotelPaymentController alloc] init];
    payment.paymentMoney = _orderDetail.real_amount;
    payment.orderNum = _orderDetail.orderID;
//    payment.point = _orderDetail.point.stringValue;
    payment.point = _orderDetail.order_point;
    payment.orderMoney = _orderDetail.orderPrice;
    payment.serverTime = _orderDetail.currentTime;
    payment.overTime = _orderDetail.overTime;
    payment.startDate = _orderDetail.arriveTime;
    payment.endDate = _orderDetail.leaveTime;
    payment.hotelName = _orderDetail.hotelName;
    NSString *days = [NSDate getDaysCountWithStartDate:_orderDetail.arriveTime endDate:_orderDetail.leaveTime];
    payment.liveDays = days;
    
    
    HotelRoomTypeModel *roomType = [[HotelRoomTypeModel alloc] init];
    roomType.iconUrl = _orderDetail.imageUrl;
    roomType.roomTypeName = _orderDetail.roomTypeName;
    payment.roomModel = roomType;
    
    [self.navigationController pushViewController:payment animated:YES];
}

- (void)checkQRCode {
    _qrCodeView.hidden = NO;
}

- (void)requestData {
    [MBProgressHUD showWithView:KEYWINDOW];
    [YCHotelHttpTool hotelGetOrderDetailWithOrderID:self.orderNum success:^(id response) {
        NSLog(@"%@",response);
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
           _orderDetail = [NSDictionary getHotelOrderDetailModelWithDic:data];
            _qrCodeView.orderDetail = _orderDetail;
            
            if (_orderDetail.orderStatus == HotelOrderStatusWaitPay) {
                self.tableView.tableFooterView = self.cancelOrderFooter;
                self.tableView.tableHeaderView = _waitPayHeader;
                NSDate *start = [NSDate getDateWithString:_orderDetail.currentTime];
                NSDate *end = [NSDate getDateWithString:_orderDetail.overTime];
                
                [_countDown countDownWithStratDate:start finishDate:end completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
                    if (day > 0 || hour > 0 || minute > 0 || second > 0) {
                        self.min.text = [NSString stringWithFormat:@"%ld",(long)minute];
                        self.sec.text = [NSString stringWithFormat:@"%ld",(long)second];
                    } else {
                        self.tableView.tableHeaderView = _orderOverTimeHeader;
                    }
                }];
                
            } else if(_orderDetail.orderStatus == HotelOrderStatusPayFinish) {
                self.tableView.tableHeaderView = _payFinishHeader;
                self.tableView.tableFooterView = _deleteOrderFooter;
                self.tableView.tableFooterView = self.cancelOrderFooter;
            } else if (_orderDetail.orderStatus == HotelOrderStatusOverTime) {
                self.tableView.tableHeaderView = _orderOverTimeHeader;
                self.tableView.tableFooterView = _deleteOrderFooter;
            } else if (_orderDetail.orderStatus == HotelOrderStatusCancel) {
                self.tableView.tableHeaderView = self.orderOverTimeHeader;
                self.headerLabel.text = NSLocalizedString(@"HotelOrderDetailReOrder", nil);
                self.tableView.tableFooterView = self.deleteOrderFooter;
            }
            else if (_orderDetail.orderStatus == HotelOrderStatusLiveIn) {
                self.tableView.tableHeaderView = _payFinishHeader;
            } else if (_orderDetail.orderStatus == HotelOrderStatusLeave) {
                self.tableView.tableHeaderView = _orderGoCommentHeader;
                self.tableView.tableFooterView = _deleteOrderFooter;
            } else if (_orderDetail.orderStatus == HotelOrderStatusComment) {
                self.tableView.tableFooterView = _deleteOrderFooter;
                
            } else if (_orderDetail.orderStatus == HotelOrderStatusDelete) {
                
            }
//            else if (_orderDetail.orderStatus == HotelOrderStatusArrangedRoom) {
//                self.tableView.tableHeaderView = _payFinishHeader;
//                self.tableView.tableFooterView = self.cancelOrderFooter;
//            }
            else if (_orderDetail.orderStatus == HotelOrderStatusRoomOverTime) {
                
            } else if (_orderDetail.orderStatus == HotelOrderStatusRefuse) {
                //酒店拒绝 弹出提示
            }
            progressView.createOrderTime = _orderDetail.reserveTime;
            progressView.hotelOrderStatus = _orderDetail.orderStatus;
            [self.tableView reloadData];
        }
    
    } failure:^(NSError *err) {
        
    }];
}

- (void)cancelOrder {
    CancelOrderViewController *cancel = [[CancelOrderViewController alloc] init];
    cancel.orderDetail = _orderDetail;
    [self.navigationController pushViewController:cancel animated:YES];
}

- (void)deleteOrder {
    UIAlertAction *deleteOder = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertSureTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showWithView:KEYWINDOW];
        [YCHotelHttpTool hotelDeleteOrderWithOrderID:_orderDetail.orderID success:^(id response) {
            NSLog(@"%@",response);
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"msg"]];
                [self performSelector:@selector(popController) withObject:nil afterDelay:2];
            }
        } failure:^(NSError *err) {
            
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SMAlertTitle", nil) message:NSLocalizedString(@"HotelAlertDeleteOrderMsg", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:deleteOder];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HotelRefreshOrderListNotification object:nil];
}

- (void)goComment {
//    [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"功能暂未开放"];
//    return;
    HotelReleaseCommentViewController *releaseComment = [[HotelReleaseCommentViewController alloc] init];
    releaseComment.hotelID = _orderDetail.hotelID;
    releaseComment.orderID = _orderDetail.orderID;
    releaseComment.orderDetail = _orderDetail;
    [self.navigationController pushViewController:releaseComment animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return _reserveMsgTitle.count;
    }
    if (section == 2) {
        return _orderMsgTitle.count;
    }
    if (section == 3) {
        return _orderDetail.roomInfo.count + 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_orderDetail.orderStatus == HotelOrderStatusLiveIn) {
        return 4;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 140;
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 30;
        } else {
            return 75;
        }
    } else {
        if (indexPath.row == 0) {
            return 40;
        }
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 2) {
//        return 13.0f;
//    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 13.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HotelReseveResultInfoTableViewCell *cell = [[HotelReseveResultInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoCell"];
        cell.hotelName.text = _orderDetail.hotelName;
        cell.hotelLocation.text = _orderDetail.address;
        cell.oderDetail = _orderDetail;
        return cell;
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TitleCell"];
            cell.textLabel.text = NSLocalizedString(@"HotelOrderDetailRoomMsg", nil);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = HotelBlackColor;
            return cell;
        } else {
            HotelCheckQRCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QRCodeCell"];
            cell.delegate = self;
            if (_orderDetail != nil) {
               HotelOrderDetailRoomModel *roomInfo =  _orderDetail.roomInfo[indexPath.row - 1];
                cell.roomNum.text = roomInfo.roomNo;
                cell.roomCode.text = roomInfo.registerID;
            }
            return cell;
        }
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.textLabel.textColor = HotelBlackColor;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    } else {
        cell.textLabel.textColor = HotelLightGrayColor;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = HotelBlackColor;
    }
    if (indexPath.section == 0) {
      
    } else if(indexPath.section == 1) {
        cell.textLabel.text = _reserveMsgTitle[indexPath.row];
        switch (indexPath.row) {
            case 1:
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@,%@%@",_orderDetail.arriveTime,NSLocalizedString(@"HotelConfirm_02",nil),_orderDetail.leaveTime,NSLocalizedString(@"HotelConfirm_03", nil)];
                break;
            case 2:
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@,%@",_orderDetail.roomCount,NSLocalizedString(@"HotelConfirmJian", nil),_orderDetail.roomTypeName];
                break;
            case 3:
                cell.detailTextLabel.text = _orderDetail.userName;
                break;
            case 4:
                cell.detailTextLabel.text = _orderDetail.phoneNum;
                break;
            case 5:
                cell.detailTextLabel.text = _orderDetail.retainTime;
                break;
            default:
                break;
        }

    } else if(indexPath.section == 2) {
        cell.textLabel.text = _orderMsgTitle[indexPath.row];
        switch (indexPath.row) {
            case 1:
                cell.detailTextLabel.text = _orderDetail.orderID;
                break;
            case 2:
                cell.detailTextLabel.text = _orderDetail.reserveTime;
                break;
            case 3:
                cell.detailTextLabel.text = _orderDetail.roomCount.stringValue;
                break;
            case 4:
//                cell.detailTextLabel.text = _orderDetail.phoneNum;
                cell.detailTextLabel.text = _orderDetail.roomPrice;
                break;
            case 5:
                cell.detailTextLabel.text = _orderDetail.guestName;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 6:
                cell.detailTextLabel.text = _orderDetail.guestPhone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 7:
                
                break;
            default:
                break;
        }

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 5) {
        UIAlertController *guestName = [UIAlertController alertControllerWithTitle:@"入住人" message:_orderDetail.guestName preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [guestName addAction:cancel];
        [self presentViewController:guestName animated:YES completion:nil];
    }
    if (indexPath.section == 2 && indexPath.row == 6) {
        UIAlertController *guestPhone = [UIAlertController alertControllerWithTitle:@"入住人电话" message:_orderDetail.guestPhone preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [guestPhone addAction:cancel];
        [self presentViewController:guestPhone animated:YES completion:nil];
    }
}

- (void)checkQRCodeButtonClick:(HotelCheckQRCodeCell *)cell {
    _qrCodeView.hidden = NO;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
     HotelOrderDetailRoomModel *roomInfo =  _orderDetail.roomInfo[indexPath.row - 1];
    
//    [YCHotelHttpTool hotelGetQRTextWithRegisterID:roomInfo.registerID hotelID:_orderDetail.hotelID roomNO:roomInfo.roomNo success:^(id response) {
//        NSLog(@"%@",response);
//        NSNumber *status = response[@"status"];
//        if (status.integerValue == 1) {
//            NSDictionary *data = response[@"data"];
//            NSString *QRText = data[@"QRText"];
//            _qrCodeView.registerID = roomInfo.registerID;
//            _qrCodeView.roomNo = roomInfo.roomNo;
//            _qrCodeView.qrCodeMsg = QRText;
//        }
//    } failure:^(NSError *err) {
//
//    }];
    
    [YCHotelHttpTool hotelGetQRTextWithRegisterID:roomInfo.registerID hotelID:_orderDetail.hotelID roomNo:roomInfo.roomNo success:^(id response) {
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSString *QRText = data[@"QRText"];
            _qrCodeView.registerID = roomInfo.registerID;
            _qrCodeView.roomNo = roomInfo.roomNo;
            _qrCodeView.qrCodeMsg = QRText;
        }
    } failure:^(NSError *err) {
        
    }];
    
//    _qrCodeView.qrCodeMsg = roomInfo.registerID;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}

@end
