//
//  SupermarketMineViewController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketMineViewController.h"
#import "SupermarketAddressModel.h"
#import "SupermarketMyOrderController.h"
#import "SupermarketMineHeaderView.h"
#import "SupermarketCheckExpressController.h"
#import "UIButton+Badge.h"
#import "SupermarketRefundController.h"
#import "SupermarketMineData.h"
#import "SupermarketApplyRefundController.h"
#import "SupermarketAboutViewController.h"
#import "SupermarketMyOrderController.h"
#import "SupermarketWaitPayController.h"
#import "SupermarketWaitReceiveController.h"
#import "SupermarketWaitCommentController.h"
#import "SupermarketMyAddressViewController.h"
#import "SupermarketRefundDetailController.h"
#import "SupermarketMyOrderController.h"
#import "SupermarketMyCommentController.h"
#import "SupermarketMyCollectionViewController.h"

#define ItemWidth APPScreenWidth/3.0

@interface SupermarketMineViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *navBG;

@end

@implementation SupermarketMineViewController {
    NSArray *_imageNames;
    NSArray *_titles;
    NSArray *_footerImageNames;

    SupermarketMineHeaderView *headerView;

    UIButton *_waitPay;
    UIButton *_waitSend;
    UIButton *_waitPick;
    UIButton *_waitReceive;
    UIButton *_waitCommet;

    SupermarketMineData *mineData;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;
}

- (void)checkLogStatus {
//    [KLHttpTool getToken:^(id token) {
//        if (token) {
//            [self performSelector:@selector(requestData) withObject:nil afterDelay:0];
//        }
//    } failure:^(NSError *errToken) {
//
//    }];
    [self requestData];

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

//    NSArray *array = self.navigationController.navigationBar.subviews;
//    UIView *view = array.firstObject;
//    view.alpha = 1;
//
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;

}


-(void)setDivCode:(NSString *)divCode{
    _divCode = [divCode copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkLogStatus) name:SupermarketSelectTabBar object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUIWithNotLogin) name:TokenWrong object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logInNotification:) name:@"YCAccountIsLogin" object:nil];


    self.navigationItem.title = @"我的";
    self.view.backgroundColor = [UIColor redColor];

      [self checkLogStatus];

    _imageNames = @[@"icon_myaddress",@"icon_mylive",@"icon_coupon",@"icon_notice",@"icon_setting2",@"icon_collection2"];
    _titles = @[NSLocalizedString(@"SupermarketMyOrderWaitPay", nil),/*@"待发货",@"待自提",*/NSLocalizedString(@"SupermarketMyOrderWaitReceive", nil),NSLocalizedString(@"SupermarketMyOrderWaitComment", nil)];
//    _titles = @[@"我的地址",@"我的直播",@"优惠券",@"我的消息",@"系统设置",@"我的收藏"];
    _footerImageNames = @[@"Icon_stay",/*@"Iocn_fh",@"Iocn_zt",*/@"Iocn_sh",@"Iocn_evaluate"];



    [self createSubViews];

//    [self requestData];

    // Do any additional setup after loading the view.
}

- (void)logInNotification:(NSNotification *)notification {
    BOOL isLogin = [YCAccountModel islogin];

    if (isLogin) {
        [self requestData];
    }

}

- (void)createSubViews {
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.contentInset = UIEdgeInsetsMake(-45, 0, 0, 0);


    headerView = [[SupermarketMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 250.0 * 2.0/3.0)];
//    headerView.controllerType = self.controllerType;
//    headerView.divCode = _divCode;
    _tableView.tableHeaderView = headerView;

}

- (void)requestData {

    [KLHttpTool getSupermarketMineDataWithappType:8 success:^(id response) {
        NSString * status = response[@"status"];
        if ([status isEqualToString:@"1"]) {
            NSString *nickname = response[@"nick_name"];
            NSString *phone = response[@"custom_id"];
            NSString *avatarUrl = response[@"img_path"];
            [headerView refreshUIWithPhone:phone nickName:nickname avatarUrlString:avatarUrl];
        }
    } failure:^(NSError *err) {

    }];
//    if (self.controllerType == ControllerTypeDepartmentStores) {
//       [KLHttpTool getSupermarketMineDataWithappType:8 success:^(id response) {
//            NSNumber *status = response[@"status"];
//            if (status.integerValue == 1) {
//                NSDictionary *data = response[@"data"];
//                mineData = [NSDictionary getMineDataWithDic:data];
//                [self reloadUI];
//            }
//        } failure:^(NSError *err) {
//
//        }];
//
//    } else {
//        [KLHttpTool getSupermarketMineDataWithappType:6 success:^(id response) {
//            NSNumber *status = response[@"status"];
//            if (status.integerValue == 1) {
//                NSDictionary *data = response[@"data"];
//                mineData = [NSDictionary getMineDataWithDic:data];
//                [self reloadUI];
//            }
//        } failure:^(NSError *err) {
//
//        }];
//    }
}

- (void)reloadUI {
     headerView.data = mineData;
    if (mineData.waitPayCount.integerValue > 0) {
        NSString *waitPay = mineData.waitPayCount.stringValue;
        _waitPay.badgeValue = waitPay;
    }

    if (mineData.waitSendCount.integerValue > 0) {
        NSString *waitSend = mineData.waitSendCount.stringValue;
        _waitSend.badgeValue = waitSend;
    }

//    _waitPick.badgeValue = mineData.waitPickCount.stringValue;
    if (mineData.waitReceiveCount.integerValue > 0) {
        _waitReceive.badgeValue = mineData.waitReceiveCount.stringValue;
    }

    if (mineData.waitCommentCount.integerValue > 0) {
        _waitCommet.badgeValue = mineData.waitCommentCount.stringValue;
    }
}

- (void)refreshUIWithNotLogin {
    _waitPay.badgeValue = nil;
    _waitSend.badgeValue = nil;
    _waitReceive.badgeValue = nil;
    _waitCommet.badgeValue = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        return 80;
//    }
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"minecell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor darkcolor];
    cell.textLabel.font = [UIFont systemFontOfSize:17];

    if (indexPath.section == 0) {
        cell.textLabel.text = NSLocalizedString(@"SupermarketHomeMyOrder", nil);
    } else if (indexPath.section == 1) {
        UIImage *icon = [UIImage imageNamed:_imageNames[indexPath.row]];
        CGSize itemSize = CGSizeMake(18, 20);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (indexPath.row == 0) {
           // cell.textLabel.text = @"我的地址";
            cell.textLabel.text = @"주소관리";
            //cell.textLabel.text = NSLocalizedString(@"SupermaketHomeMyAddress", nil);
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"나의방송";
            //cell.textLabel.text = @"我的直播";
            //cell.textLabel.text = NSLocalizedString(@"SMOrderRefundTitle", nil);
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"공고";
            //cell.textLabel.text = @"优惠券";
            //cell.textLabel.text = @"할인권";
            //cell.textLabel.text = NSLocalizedString(@"SMMineAboutUs", nil);
        } else if (indexPath.row == 3) {
            //cell.textLabel.text = @"我的消息";
            cell.textLabel.text = @"리뷰관린";
           // cell.textLabel.text = NSLocalizedString(@"SMMineMyComment", nil);
        } else if (indexPath.row == 4) {
            //cell.textLabel.text = @"系统设置";
            cell.textLabel.text = @"환경설정";
        } else {
//            cell.textLabel.text = @"我的收藏";
            cell.textLabel.text = @"찜하기";
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 80)];
//        bgView.backgroundColor = [UIColor whiteColor];
//        for (int i = 0; i < 3; i++) {
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ItemWidth*i, 0, ItemWidth, 80)];
//            [bgView addSubview:view];
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = CGRectMake(ItemWidth/2 - 15, view.center.y-25, 30, 30);
//            [button setImage:[UIImage imageNamed:_footerImageNames[i]] forState:UIControlStateNormal];
//            button.badgeBGColor = [UIColor whiteColor];
//            [view addSubview:button];
//
//            if (i == 0) {
//                _waitPay = button;
//                [_waitPay addTarget:self action:@selector(goWaitPay) forControlEvents:UIControlEventTouchUpInside];
//            }
//            if (i == 1) {
//                _waitReceive = button;
//                [_waitReceive addTarget:self action:@selector(goWaitReceive) forControlEvents:UIControlEventTouchUpInside];
//            }
//            if (i == 2) {
//                _waitCommet = button;
//                [_waitCommet addTarget:self action:@selector(goWaitComment) forControlEvents:UIControlEventTouchUpInside];
//            }
//            if (i == 3) {
//                _waitReceive = button;
//                [_waitReceive addTarget:self action:@selector(goWaitReceive) forControlEvents:UIControlEventTouchUpInside];
//            }
//            if (i == 4) {
//                _waitCommet = button;
//                [_waitCommet addTarget:self action:@selector(goWaitComment) forControlEvents:UIControlEventTouchUpInside];
//            }
//
//            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame), view.frame.size.width, 20)];
//            title.textAlignment = NSTextAlignmentCenter;
//            title.text = _titles[i];
//            title.font = [UIFont systemFontOfSize:14];
//            title.textColor = [UIColor darkcolor];
//            [view addSubview:title];
//
//        }
//        return bgView;
//    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    BOOL islogIn = [YCAccountModel islogin];
    if (!islogIn) {
        [self goToLogin:^{ }];
        return;
    }

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            SupermarketMyAddressViewController *vc = [[SupermarketMyAddressViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.isPageView = NO;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            SupermarketRefundController *vc = [[SupermarketRefundController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.controllerType = self.controllerType;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
//            [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"暂未开放"];
//            SupermarketAboutViewController *vc = [[SupermarketAboutViewController alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
            YCWebViewController *web = [[YCWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.gigawon.co.kr:1314/QnA/sub_01"]];
            web.title = @"공고";
//            AllCouponViewController *vc = [[AllCouponViewController alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        } else if (indexPath.row == 3) {
//            return;
//            SupermarketAboutViewController *vc = [[SupermarketAboutViewController alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
            SupermarketMyCommentController *myComment = [[SupermarketMyCommentController alloc] init];
            myComment.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myComment animated:YES];
        } else if (indexPath.row == 4) {
            PersinalSetController *personal = [[PersinalSetController alloc] init];
            personal.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personal animated:YES];
        } else {
            SupermarketMyCollectionViewController *mycollection = [[SupermarketMyCollectionViewController alloc] init];
            mycollection.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mycollection animated:YES];
        }
    } else {
        SupermarketMyOrderController *vc = [[SupermarketMyOrderController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.controllerType = self.controllerType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)goWaitPay {
//    [self checkLoginStatus];
    BOOL islogIn = [YCAccountModel islogin];
    if (!islogIn) {
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"您还未登录,请先登录!"];
        return;
    }


//    SupermarketWaitPayController *vc = [[SupermarketWaitPayController alloc] init];
    SupermarketMyOrderController *vc = [[SupermarketMyOrderController alloc] init];
    vc.title = @"待付款";
    vc.pageIndex = 1;
    vc.controllerType = self.controllerType;
    __weak typeof(self) weakself = self;
    vc.refresh = ^{
        __strong typeof(weakself) strongself = weakself;
        [strongself checkLogStatus];
    };

    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goWaitSend {
//    [self checkLoginStatus];
    BOOL islogIn = [YCAccountModel islogin];
    if (!islogIn) {
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"您还未登录,请先登录!"];
        return;
    }


//    SupermarketWaitSendController *vc = [[SupermarketWaitSendController alloc] init];
    SupermarketMyOrderController *vc = [[SupermarketMyOrderController alloc] init];
    vc.title = @"待发货";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goWaitSelfPick {
//    [self checkLoginStatus];
    BOOL islogIn = [YCAccountModel islogin];
    if (!islogIn) {
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"您还未登录,请先登录!"];
        return;
    }


//    SupermarketWaitPickController *vc = [[SupermarketWaitPickController alloc] init];
//    vc.title = @"待自提";
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];

}

- (void)goWaitReceive {
//    [self checkLoginStatus];
    BOOL islogIn = [YCAccountModel islogin];
    if (!islogIn) {
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"您还未登录,请先登录!"];
        return;

    }


//    SupermarketWaitReceiveController *vc = [[SupermarketWaitReceiveController alloc] init];
    SupermarketMyOrderController *vc = [[SupermarketMyOrderController alloc] init];
    vc.title = @"待收货";
    vc.pageIndex = 3;
    vc.controllerType = self.controllerType;
    __weak typeof(self) weakself = self;
    vc.refresh = ^{
        __strong typeof(weakself) strongself = weakself;
        [strongself checkLogStatus];
    };

    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)goWaitComment {
//    [self checkLoginStatus];


    BOOL islogIn = [YCAccountModel islogin];
    if (!islogIn) {
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"您还未登录,请先登录!"];
        return;
    }


//    SupermarketWaitCommentController *vc = [[SupermarketWaitCommentController alloc] init];
    SupermarketMyOrderController *vc = [[SupermarketMyOrderController alloc] init];
    vc.title = @"待评价";
    vc.pageIndex = 4;
    vc.controllerType = self.controllerType;
    __weak typeof(self) weakself = self;
    vc.refresh = ^{
        __strong typeof(weakself) strongself = weakself;
        [strongself checkLogStatus];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)checkLoginStatus {
    BOOL islogIn = [YCAccountModel islogin];
    if (!islogIn) {
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"您还未登录,请先登录!"];
        return;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SupermarketMyOrderController *vc = [SupermarketMyOrderController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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

//#import "SupermarketMineViewController.h"
//#import "SupermarketAddressModel.h"
//#import "SupermarketMyOrderController.h"
//#import "SupermarketMineHeaderView.h"
//#import "SupermarketCheckExpressController.h"
//#import "UIButton+Badge.h"
//#import "SupermarketRefundController.h"
//#import "SupermarketMineData.h"
//#import "SupermarketApplyRefundController.h"
//#import "SupermarketAboutViewController.h"
//#import "SupermarketMyOrderController.h"
//
//#import "SupermarketWaitPayController.h"
////#import "SupermarketWaitSendController.h"
////#import "SupermarketWaitPickController.h"
//#import "SupermarketWaitReceiveController.h"
//#import "SupermarketWaitCommentController.h"
//#import "SupermarketMyAddressViewController.h"
//#import "SupermarketRefundDetailController.h"
//#import "SupermarketMyOrderController.h"
//#import "SupermarketMyCommentController.h"
//
//#define ItemWidth APPScreenWidth/3.0
//
//@interface SupermarketMineViewController ()<UITableViewDelegate, UITableViewDataSource>
//
//@property(nonatomic, strong) UITableView *tableView;
//@property(nonatomic, strong) UIView *navBG;
//
//@end
//
//@implementation SupermarketMineViewController {
//    NSArray *_imageNames;
//    NSArray *_titles;
//    NSArray *_footerImageNames;
//
//    SupermarketMineHeaderView *headerView;
//
//    UIButton *_waitPay;
//    UIButton *_waitSend;
//    UIButton *_waitPick;
//    UIButton *_waitReceive;
//    UIButton *_waitCommet;
//
//    SupermarketMineData *mineData;
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    self.navigationController.navigationBar.hidden = YES;
//}
//
//- (void)checkLogStatus {
//    [self requestData];
////    [KLHttpTool getToken:^(id token) {
////        if (token) {
////            [self performSelector:@selector(requestData) withObject:nil afterDelay:0];
////        }
////    } failure:^(NSError *errToken) {
////
////    }];
//
//}
//
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//
//    //    NSArray *array = self.navigationController.navigationBar.subviews;
//    //    UIView *view = array.firstObject;
//    //    view.alpha = 1;
//    //
//    //    self.automaticallyAdjustsScrollViewInsets = YES;
//    //    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.hidden = NO;
//
//}
//
//
//-(void)setDivCode:(NSString *)divCode{
//    _divCode = [divCode copy];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkLogStatus) name:SupermarketSelectTabBar object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUIWithNotLogin) name:TokenWrong object:nil];
//    [self checkLogStatus];
//    // selftitle = @"我的奢厨";
//    self.navigationItem.title = @"我的奢厨";
//    self.view.backgroundColor = [UIColor redColor];
//
//    _imageNames = @[@"Iocn_landmark",@"Iocn_hik",@"Iocn_about",@"icon_my_comment"];
//    _titles = @[NSLocalizedString(@"SupermarketMyOrderWaitPay", nil),/*@"待发货",@"待自提",*/NSLocalizedString(@"SupermarketMyOrderWaitReceive", nil),NSLocalizedString(@"SupermarketMyOrderWaitComment", nil)];
//    _footerImageNames = @[@"Icon_stay",/*@"Iocn_fh",@"Iocn_zt",*/@"Iocn_sh",@"Iocn_evaluate"];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logInNotification:) name:@"YCAccountIsLogin" object:nil];
//
//    [self createSubViews];
//
//    //    [self requestData];
//
//    // Do any additional setup after loading the view.
//}
//
//- (void)logInNotification:(NSNotification *)notification {
//    BOOL isLogin = [YCAccountModel islogin];
//
//    if (isLogin) {
//        [self requestData];
//    }
//
//}
//
//- (void)createSubViews {
//    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//    [self.view addSubview:_tableView];
//    _tableView.contentInset = UIEdgeInsetsMake(-45, 0, 0, 0);
//
//    headerView = [[SupermarketMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 250)];
//    headerView.controllerType = self.controllerType;
//    headerView.divCode = _divCode;
//    _tableView.tableHeaderView = headerView;
//
//}
//
//- (void)requestData {
//    if (self.controllerType == ControllerTypeDepartmentStores) {
//        NSLog(@"=======百货======");
//        [KLHttpTool getSupermarketMineDataWithappType:8 success:^(id response) {
//            NSLog(@"%@",response);
//            NSNumber *status = response[@"status"];
//            if (status.integerValue == 1) {
//                NSDictionary *data = response[@"data"];
//                mineData = [NSDictionary getMineDataWithDic:data];
//                [self reloadUI];
//            }
//        } failure:^(NSError *err) {
//
//        }];
//
//    } else {
//        [KLHttpTool getSupermarketMineDataWithappType:6 success:^(id response) {
//            NSLog(@"%@",response);
//            NSNumber *status = response[@"status"];
//            if (status.integerValue == 1) {
//                NSDictionary *data = response[@"data"];
//                mineData = [NSDictionary getMineDataWithDic:data];
//                [self reloadUI];
//            }
//        } failure:^(NSError *err) {
//
//        }];
//    }
//}
//
//- (void)reloadUI {
//    headerView.data = mineData;
//    if (mineData.waitPayCount.integerValue > 0) {
//        NSString *waitPay = mineData.waitPayCount.stringValue;
//        _waitPay.badgeValue = waitPay;
//    }
//
//    if (mineData.waitSendCount.integerValue > 0) {
//        NSString *waitSend = mineData.waitSendCount.stringValue;
//        _waitSend.badgeValue = waitSend;
//    }
//
//    //    _waitPick.badgeValue = mineData.waitPickCount.stringValue;
//    if (mineData.waitReceiveCount.integerValue > 0) {
//        _waitReceive.badgeValue = mineData.waitReceiveCount.stringValue;
//    }
//
//    if (mineData.waitCommentCount.integerValue > 0) {
//        _waitCommet.badgeValue = mineData.waitCommentCount.stringValue;
//    }
//}
//
//- (void)refreshUIWithNotLogin {
//    _waitPay.badgeValue = nil;
//    _waitSend.badgeValue = nil;
//    _waitReceive.badgeValue = nil;
//    _waitCommet.badgeValue = nil;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    }
//    return 4;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 10;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        return 80;
//    }
//    return 0.1f;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"minecell"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.textLabel.textColor = [UIColor darkcolor];
//    cell.textLabel.font = [UIFont systemFontOfSize:17];
//
//    if (indexPath.section == 0) {
//        cell.textLabel.text = NSLocalizedString(@"SupermarketHomeMyOrder", nil);
//    } else if (indexPath.section == 1) {
//        UIImage *icon = [UIImage imageNamed:_imageNames[indexPath.row]];
//        CGSize itemSize = CGSizeMake(18, 20);
//        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
//        CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
//        [icon drawInRect:imageRect];
//        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        if (indexPath.row == 0) {
//            cell.textLabel.text = NSLocalizedString(@"SupermaketHomeMyAddress", nil);
//        }
//        if (indexPath.row == 1) {
//            cell.textLabel.text = NSLocalizedString(@"SMOrderRefundTitle", nil);
//        }
//        if (indexPath.row == 2) {
//            cell.textLabel.text = NSLocalizedString(@"SMMineAboutUs", nil);
//        }
//        if (indexPath.row == 3) {
//            cell.textLabel.text = NSLocalizedString(@"SMMineMyComment", nil);
//        }
//    }
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 50;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 80)];
//        bgView.backgroundColor = [UIColor whiteColor];
//        for (int i = 0; i < 3; i++) {
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ItemWidth*i, 0, ItemWidth, 80)];
//            [bgView addSubview:view];
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = CGRectMake(ItemWidth/2 - 15, view.center.y-25, 30, 30);
//            [button setImage:[UIImage imageNamed:_footerImageNames[i]] forState:UIControlStateNormal];
//            button.badgeBGColor = [UIColor whiteColor];
//            [view addSubview:button];
//
//            if (i == 0) {
//                _waitPay = button;
//                [_waitPay addTarget:self action:@selector(goWaitPay) forControlEvents:UIControlEventTouchUpInside];
//            }
//            if (i == 1) {
//                _waitReceive = button;
//                [_waitReceive addTarget:self action:@selector(goWaitReceive) forControlEvents:UIControlEventTouchUpInside];
//            }
//            if (i == 2) {
//                _waitCommet = button;
//                [_waitCommet addTarget:self action:@selector(goWaitComment) forControlEvents:UIControlEventTouchUpInside];
//            }
//            if (i == 3) {
//                _waitReceive = button;
//                [_waitReceive addTarget:self action:@selector(goWaitReceive) forControlEvents:UIControlEventTouchUpInside];
//            }
//            if (i == 4) {
//                _waitCommet = button;
//                [_waitCommet addTarget:self action:@selector(goWaitComment) forControlEvents:UIControlEventTouchUpInside];
//            }
//
//            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame), view.frame.size.width, 20)];
//            title.textAlignment = NSTextAlignmentCenter;
//            title.text = _titles[i];
//            title.font = [UIFont systemFontOfSize:14];
//            title.textColor = [UIColor darkcolor];
//            [view addSubview:title];
//
//        }
//        return bgView;
//    }
//    return nil;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    BOOL islogIn = [YCAccountModel islogin];
//    if (!islogIn) {
//        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"您还未登录,请先登录!"];
//        return;
//    }
//
//    if (indexPath.section == 1) {
//        if (indexPath.row == 0) {
//            SupermarketMyAddressViewController *vc = [[SupermarketMyAddressViewController alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.isPageView = NO;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        if (indexPath.row == 1) {
//            SupermarketRefundController *vc = [[SupermarketRefundController alloc] init];
//            //            SupermarketRefundDetailController *vc = [[SupermarketRefundDetailController alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.controllerType = self.controllerType;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        if (indexPath.row == 2) {
//            //            [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"暂未开放"];
//            SupermarketAboutViewController *vc = [[SupermarketAboutViewController alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        if (indexPath.row == 3) {
//            //            return;
//            //            SupermarketAboutViewController *vc = [[SupermarketAboutViewController alloc] init];
//            //            vc.hidesBottomBarWhenPushed = YES;
//            //            [self.navigationController pushViewController:vc animated:YES];
//            SupermarketMyCommentController *myComment = [[SupermarketMyCommentController alloc] init];
//            myComment.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:myComment animated:YES];
//        }
//    } else {
//        SupermarketMyOrderController *vc = [[SupermarketMyOrderController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.controllerType = self.controllerType;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}
//
//
//- (void)goWaitPay {
//    //    [self checkLoginStatus];
//    BOOL islogIn = [YCAccountModel islogin];
//    if (!islogIn) {
//        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"您还未登录,请先登录!"];
//        return;
//    }
//
//
//    //    SupermarketWaitPayController *vc = [[SupermarketWaitPayController alloc] init];
//    SupermarketMyOrderController *vc = [[SupermarketMyOrderController alloc] init];
//    vc.title = @"待付款";
//    vc.pageIndex = 1;
//    vc.controllerType = self.controllerType;
//    __weak typeof(self) weakself = self;
//    vc.refresh = ^{
//        __strong typeof(weakself) strongself = weakself;
//        [strongself checkLogStatus];
//    };
//
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (void)goWaitSend {
//    //    [self checkLoginStatus];
//    BOOL islogIn = [YCAccountModel islogin];
//    if (!islogIn) {
//        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"您还未登录,请先登录!"];
//        return;
//    }
//
//
//    //    SupermarketWaitSendController *vc = [[SupermarketWaitSendController alloc] init];
//    SupermarketMyOrderController *vc = [[SupermarketMyOrderController alloc] init];
//    vc.title = @"待发货";
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (void)goWaitSelfPick {
//    //    [self checkLoginStatus];
//    BOOL islogIn = [YCAccountModel islogin];
//    if (!islogIn) {
//        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"您还未登录,请先登录!"];
//        return;
//    }
//
//
//    //    SupermarketWaitPickController *vc = [[SupermarketWaitPickController alloc] init];
//    //    vc.title = @"待自提";
//    //    vc.hidesBottomBarWhenPushed = YES;
//    //    [self.navigationController pushViewController:vc animated:YES];
//
//}
//
//- (void)goWaitReceive {
//    //    [self checkLoginStatus];
//    BOOL islogIn = [YCAccountModel islogin];
//    if (!islogIn) {
//        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"您还未登录,请先登录!"];
//        return;
//
//    }
//
//
//    //    SupermarketWaitReceiveController *vc = [[SupermarketWaitReceiveController alloc] init];
//    SupermarketMyOrderController *vc = [[SupermarketMyOrderController alloc] init];
//    vc.title = @"待收货";
//    vc.pageIndex = 3;
//    vc.controllerType = self.controllerType;
//    __weak typeof(self) weakself = self;
//    vc.refresh = ^{
//        __strong typeof(weakself) strongself = weakself;
//        [strongself checkLogStatus];
//    };
//
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//
//}
//
//- (void)goWaitComment {
//    //    [self checkLoginStatus];
//
//
//    BOOL islogIn = [YCAccountModel islogin];
//    if (!islogIn) {
//        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"您还未登录,请先登录!"];
//        return;
//    }
//
//
//    //    SupermarketWaitCommentController *vc = [[SupermarketWaitCommentController alloc] init];
//    SupermarketMyOrderController *vc = [[SupermarketMyOrderController alloc] init];
//    vc.title = @"待评价";
//    vc.pageIndex = 4;
//    vc.controllerType = self.controllerType;
//    __weak typeof(self) weakself = self;
//    vc.refresh = ^{
//        __strong typeof(weakself) strongself = weakself;
//        [strongself checkLogStatus];
//    };
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//
//}
//
//- (void)checkLoginStatus {
//    BOOL islogIn = [YCAccountModel islogin];
//    if (!islogIn) {
//        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"您还未登录,请先登录!"];
//        return;
//    }
//}
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    SupermarketMyOrderController *vc = [SupermarketMyOrderController new];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
// #pragma mark - Navigation
//
// // In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// // Get the new view controller using [segue destinationViewController].
// // Pass the selected object to the new view controller.
// }
// */
//
//@end


