////
////  SupermarketMineHeaderView.m
////  Portal
////
////  Created by ifox on 2016/12/23.
////  Copyright © 2016年 linpeng. All rights reserved.
////
//
#import "SupermarketMineHeaderView.h"
#import "UILabel+WidthAndHeight.h"
#import "SupermarketMyOrderController.h"
#import "SupermarketCouponController.h"
#import "IntergrationController.h"
#import "LZCartViewController.h"
#import "AllCouponViewController.h"
#import "SupermarketMyCollectionViewController.h"
#import "UILabel+CreateLabel.h"

#define BigItemWidth self.frame.size.width / 2

@implementation SupermarketMineHeaderView {
    UILabel *_coupon;
    UILabel *_point;
    UILabel *_collection;
    UIImageView *avatar;
    UILabel *phoneNumber;
    UILabel *userName;
    UITapGestureRecognizer *goLogin;
    UIView *bgView ;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BGColor;
        [self createSubview];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUIWithNotLogin) name:TokenWrong object:nil];

    }
    return self;
}

- (void)createSubview {

    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bgView.backgroundColor = GreenColor;
    [self addSubview:bgView];

    avatar = [[UIImageView alloc] initWithFrame:CGRectMake(25, bgView.center.y - 25 + 20, 60, 60)];
    avatar.clipsToBounds = YES;
    avatar.image = [UIImage imageNamed:@"supermarket_defaultIcon"];
    avatar.layer.cornerRadius = 30;
    avatar.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:avatar];

    UIView *avartarBgView = [[UIView alloc] init];
    avartarBgView.bounds = CGRectMake(0, 0, 70, 70);
    avartarBgView.center = avatar.center;
    avartarBgView.layer.cornerRadius = 70/2;
    avartarBgView.layer.borderWidth = 0.7f;
    avartarBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    [bgView insertSubview:avartarBgView belowSubview:avatar];

    phoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avartarBgView.frame) + 15, avartarBgView.frame.origin.y+10, 250, 25)];
    phoneNumber.textColor = [UIColor whiteColor];
    phoneNumber.font = [UIFont systemFontOfSize:20];
    //phoneNumber.text = NSLocalizedString(@"SMMineLogInTitle", nil);
    phoneNumber.text = @"로그인 하기";
    phoneNumber.userInteractionEnabled = YES;
    [bgView addSubview:phoneNumber];

    userName = [UILabel createLabelWithFrame:CGRectMake(phoneNumber.frame.origin.x,
                                             CGRectGetMaxY(avartarBgView.frame)-20-10, 250, 20) textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:@""];
    [bgView addSubview:userName];

    goLogin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goLogin:)];
    [phoneNumber addGestureRecognizer:goLogin];

//    for (int i = 0; i < 2; i++) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * BigItemWidth, self.frame.size.height/3*2, BigItemWidth, self.frame.size.height/3)];
//        view.userInteractionEnabled = YES;
//        view.tag = 100+i;
//        view.backgroundColor = [UIColor whiteColor];
//        view.userInteractionEnabled = YES;
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewAction:)];
//        [view addGestureRecognizer:tap];
//
//        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height/2 - 20, view.frame.size.width, 20)];
//        numberLabel.textAlignment = NSTextAlignmentCenter;
//        numberLabel.font = [UIFont systemFontOfSize:20];
//        [view addSubview:numberLabel];
//
//        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(numberLabel.frame), view.frame.size.width, 20)];
//        title.textAlignment = NSTextAlignmentCenter;
//        title.font = [UIFont systemFontOfSize:14];
//        title.textColor = [UIColor darkGrayColor];
//        [view addSubview:title];
//        if (i == 0) {
////            numberLabel.textColor = RGB(255, 153, 27);
//            numberLabel.textColor = RGB(250, 52, 53);
//            numberLabel.text = @"-";
//            numberLabel.tag = 111;
//            title.tag = 1111;
//            title.text = NSLocalizedString(@"SMPoint", nil);
//            _coupon = numberLabel;
//        } else if (i == 1) {
////            numberLabel.textColor = RGB(250, 52, 53);
//            numberLabel.textColor = RGB(38, 160, 242);
//            numberLabel.text = @"-";
//            numberLabel.tag = 222;
//            title.tag = 2222;
//            title.text = NSLocalizedString(@"SMGoodsDetailCollection", nil);
//            _point = numberLabel;
//        } else {
//            numberLabel.textColor = RGB(38, 160, 242);
//            numberLabel.text = @"-";
//            numberLabel.tag = 333;
//            title.tag = 3333;
//            title.text = @"收藏";
//            _collection = numberLabel;
//        }
//        [self addSubview:view];
//    }
//
//    for (int i = 0; i < 2; i++) {
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(BigItemWidth * (i+1), self.frame.size.height/3*2, 1, self.frame.size.height/3)];
//        line.backgroundColor = BGColor;
//        [self addSubview:line];
//    }

}

//-(void)setDivCode:(NSString *)divCode{
//    _divCode = [divCode copy];
//}

- (void)viewAction:(UITapGestureRecognizer *)tap {
//    UIView *view = tap.view;
//    NSInteger tag = view.tag - 100;

    BOOL islogIn = [YCAccountModel islogin];
    if (!islogIn) {
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:NSLocalizedString(@"SMMineNoLogInMsg", nil)];
        return;
    }

//
//    if (tag == 0) {
////        AllCouponViewController *vc = [[AllCouponViewController alloc] init];
////        vc.hidesBottomBarWhenPushed = YES;
////        [self.navigationController pushViewController:vc animated:YES];
////        [self.viewController.navigationController pushViewController:vc animated:YES];
//        IntergrationController *vc = [IntergrationController new];
//        vc.controllerType = self.controllerType;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.viewController.navigationController pushViewController:vc animated:YES];
//    } else if (tag == 1) {
//        SupermarketMyCollectionViewController *vc = [[SupermarketMyCollectionViewController alloc] init];
//        vc.controllerType = self.controllerType;
//        vc.divCode = _divCode;
//        __weak typeof(self) weakself = self;
//        vc.refresh = ^{
//            __strong typeof(self) strongself = weakself;
//            if ([strongself.viewController isKindOfClass:[SupermarketMineViewController class]]){
//               SupermarketMineViewController * mine = (SupermarketMineViewController *)strongself.viewController;
//                [mine checkLogStatus];
//            }
//        };
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.viewController.navigationController pushViewController:vc animated:YES];
//
//    } else if (tag == 2) {
//
//    }
}

- (void)goLogin:(UITapGestureRecognizer *)tap {

	[KLHttpTool getToken:^(id token) {
		if (token) {
			
		}else{
			MemberEnrollController *logIN = [[MemberEnrollController alloc] init];
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logIN];
			[self.viewController presentViewController:nav animated:YES completion:nil];

		}
		
	} failure:^(NSError *errToken) {
		
	}];
	
}

- (void)setData:(SupermarketMineData *)data {
    _data = data;

    YCAccountModel *accout = [YCAccountModel getAccount];
    [UIImageView setimageWithImageView:avatar UrlString:data.header_url imageVersion:nil];
    phoneNumber.text = accout.customId;
    userName.text = accout.userName;
    [phoneNumber removeGestureRecognizer:goLogin];
}

- (void)setControllerType:(ControllerType)controllerType {
    _controllerType = controllerType;
    if (controllerType == ControllerTypeDepartmentStores) {
        bgView.backgroundColor = RGB(240,128,128);
    }
}

- (void)refreshUIWithNotLogin {
    _coupon.text = @"-";
    _point.text = @"-";
    _collection.text = @"-";
    phoneNumber.text = NSLocalizedString(@"SMMineLogInTitle", nil);
    [phoneNumber addGestureRecognizer:goLogin];
    avatar.image = [UIImage imageNamed:@""];
}

-(void)refreshUIWithPhone:(NSString *)phone nickName:(NSString *)nickName avatarUrlString:(NSString *)url {
    phoneNumber.text = phone;
    userName.text = nickName;
    [UIImageView setimageWithImageView:avatar UrlString:url imageVersion:nil];
}


@end

//#import "SupermarketMineHeaderView.h"
//#import "UILabel+WidthAndHeight.h"
//#import "UIView+ViewController.h"
//#import "SupermarketMyOrderController.h"
//#import "SupermarketCouponController.h"
//#import "IntergrationController.h"
//#import "LZCartViewController.h"
//#import "AllCouponViewController.h"
//#import "SupermarketMyCollectionViewController.h"
//#import "UILabel+CreateLabel.h"
//#import "RSLoginContainerController.h"
//
//#define BigItemWidth self.frame.size.width / 2
//
//@implementation SupermarketMineHeaderView {
//    UILabel *_coupon;
//    UILabel *_point;
//    UILabel *_collection;
//    UIImageView *avatar;
//    UILabel *phoneNumber;
//    UILabel *userName;
//    UITapGestureRecognizer *goLogin;
//    UIView *bgView ;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = BGColor;
//        [self createSubview];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUIWithNotLogin) name:TokenWrong object:nil];
//    }
//    return self;
//}
//
//- (void)createSubview {
//
//    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/3*2)];
//    bgView.backgroundColor = GreenColor;
//    [self addSubview:bgView];
//
//    avatar = [[UIImageView alloc] initWithFrame:CGRectMake(25, bgView.center.y - 25 + 20, 60, 60)];
//    avatar.clipsToBounds = YES;
//    avatar.image = [UIImage imageNamed:@"supermarket_defaultIcon"];
//    avatar.layer.cornerRadius = 30;
//    avatar.backgroundColor = [UIColor whiteColor];
//    [bgView addSubview:avatar];
//
//    UIView *avartarBgView = [[UIView alloc] init];
//    avartarBgView.bounds = CGRectMake(0, 0, 70, 70);
//    avartarBgView.center = avatar.center;
//    avartarBgView.layer.cornerRadius = 70/2;
//    avartarBgView.layer.borderWidth = 0.7f;
//    avartarBgView.layer.borderColor = [UIColor whiteColor].CGColor;
//    [bgView insertSubview:avartarBgView belowSubview:avatar];
//
//    //    phoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avartarBgView.frame) + 15, avartarBgView.center.y - 12, 250, 25)];
//    phoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avartarBgView.frame) + 15, avartarBgView.frame.origin.y+10, 250, 25)];
//    phoneNumber.textColor = [UIColor whiteColor];
//    phoneNumber.font = [UIFont systemFontOfSize:20];
//    phoneNumber.text = NSLocalizedString(@"SMMineLogInTitle", nil);
//    phoneNumber.userInteractionEnabled = YES;
//    [bgView addSubview:phoneNumber];
//
//    userName = [UILabel createLabelWithFrame:CGRectMake(phoneNumber.frame.origin.x, CGRectGetMaxY(avartarBgView.frame)-20-10, 250, 20) textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:@""];
//    [bgView addSubview:userName];
//
//    goLogin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goLogin:)];
//    [phoneNumber addGestureRecognizer:goLogin];
//
//    for (int i = 0; i < 2; i++) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * BigItemWidth, self.frame.size.height/3*2, BigItemWidth, self.frame.size.height/3)];
//        view.userInteractionEnabled = YES;
//        view.tag = 100+i;
//        view.backgroundColor = [UIColor whiteColor];
//        view.userInteractionEnabled = YES;
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewAction:)];
//        [view addGestureRecognizer:tap];
//
//        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height/2 - 20, view.frame.size.width, 20)];
//        numberLabel.textAlignment = NSTextAlignmentCenter;
//        numberLabel.font = [UIFont systemFontOfSize:20];
//        [view addSubview:numberLabel];
//
//        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(numberLabel.frame), view.frame.size.width, 20)];
//        title.textAlignment = NSTextAlignmentCenter;
//        title.font = [UIFont systemFontOfSize:14];
//        title.textColor = [UIColor darkGrayColor];
//        [view addSubview:title];
//        if (i == 0) {
//            //            numberLabel.textColor = RGB(255, 153, 27);
//            numberLabel.textColor = RGB(250, 52, 53);
//            numberLabel.text = @"-";
//            numberLabel.tag = 111;
//            title.tag = 1111;
//            title.text = NSLocalizedString(@"SMPoint", nil);
//            _coupon = numberLabel;
//        } else if (i == 1) {
//            //            numberLabel.textColor = RGB(250, 52, 53);
//            numberLabel.textColor = RGB(38, 160, 242);
//            numberLabel.text = @"-";
//            numberLabel.tag = 222;
//            title.tag = 2222;
//            title.text = NSLocalizedString(@"SMGoodsDetailCollection", nil);
//            _point = numberLabel;
//        } else {
//            numberLabel.textColor = RGB(38, 160, 242);
//            numberLabel.text = @"-";
//            numberLabel.tag = 333;
//            title.tag = 3333;
//            title.text = @"收藏";
//            _collection = numberLabel;
//        }
//        [self addSubview:view];
//    }
//
//    for (int i = 0; i < 2; i++) {
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(BigItemWidth * (i+1), self.frame.size.height/3*2, 1, self.frame.size.height/3)];
//        line.backgroundColor = BGColor;
//        [self addSubview:line];
//    }
//
//}
//
//-(void)setDivCode:(NSString *)divCode{
//    _divCode = [divCode copy];
//}
//
//- (void)viewAction:(UITapGestureRecognizer *)tap {
//    UIView *view = tap.view;
//    NSInteger tag = view.tag - 100;
//
//    BOOL islogIn = [YCAccountModel islogin];
//    if (!islogIn) {
//        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:NSLocalizedString(@"SMMineNoLogInMsg", nil)];
//        return;
//    }
//
//
//    if (tag == 0) {
//        //        AllCouponViewController *vc = [[AllCouponViewController alloc] init];
//        //        vc.hidesBottomBarWhenPushed = YES;
//        //        [self.navigationController pushViewController:vc animated:YES];
//        //        [self.viewController.navigationController pushViewController:vc animated:YES];
//        IntergrationController *vc = [IntergrationController new];
//        vc.controllerType = self.controllerType;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.viewController.navigationController pushViewController:vc animated:YES];
//    } else if (tag == 1) {
//        SupermarketMyCollectionViewController *vc = [[SupermarketMyCollectionViewController alloc] init];
//        vc.controllerType = self.controllerType;
//        vc.divCode = _divCode;
//        __weak typeof(self) weakself = self;
//        vc.refresh = ^{
//            __strong typeof(self) strongself = weakself;
//            if ([strongself.viewController isKindOfClass:[SupermarketMineViewController class]]){
//                SupermarketMineViewController * mine = (SupermarketMineViewController *)strongself.viewController;
//                [mine checkLogStatus];
//            }
//        };
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.viewController.navigationController pushViewController:vc animated:YES];
//
//    } else if (tag == 2) {
//
//    }
//}
//
//- (void)goLogin:(UITapGestureRecognizer *)tap {
//
//    RSLoginContainerController *logIN = [[RSLoginContainerController alloc] init];
//
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logIN];
//
//    [self.viewController presentViewController:nav animated:YES completion:nil];
//}
//
//- (void)setData:(SupermarketMineData *)data {
//    _data = data;
//
//    YCAccountModel *accout = [YCAccountModel getAccount];
//
//    _coupon.text = [NSString stringWithFormat:@"%@",data.point];
//    _point.text = data.collection_count.stringValue;
//    [[NSUserDefaults standardUserDefaults] setObject:data.point forKey:@"SupermarketPointRemain"];
//    _collection.text = data.collection_count.stringValue;
//    [UIImageView setimageWithImageView:avatar UrlString:data.header_url imageVersion:nil];
//    phoneNumber.text = accout.customId;
//    userName.text = accout.userName;
//    [phoneNumber removeGestureRecognizer:goLogin];
//}
//
//- (void)setControllerType:(ControllerType)controllerType {
//    _controllerType = controllerType;
//    if (controllerType == ControllerTypeDepartmentStores) {
//        bgView.backgroundColor = RGB(240,128,128);
//    }
//}
//
//- (void)refreshUIWithNotLogin {
//    _coupon.text = @"-";
//    _point.text = @"-";
//    _collection.text = @"-";
//    phoneNumber.text = NSLocalizedString(@"SMMineLogInTitle", nil);
//    [phoneNumber addGestureRecognizer:goLogin];
//    avatar.image = [UIImage imageNamed:@""];
//}
//
//
//@end

