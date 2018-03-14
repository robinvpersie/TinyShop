//
//  IntergrationController.m
//  Portal
//
//  Created by ifox on 2017/1/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "IntergrationController.h"
#import "YCSlideView.h"
//#import "LGSegment.h"

#import "UILabel+WidthAndHeight.h"
#import "AllIntergrationControllerController.h"
#import "InIntergrationController.h"
#import "OutIntergrationController.h"

@interface IntergrationController ()<UIScrollViewDelegate/*, SegmentDelegate*/>

//@property(nonatomic, strong) LGSegment *segment;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation IntergrationController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BGColor;
    
//    [self initNavigationBar];
    
    [self createView];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
//    NSArray *array = self.navigationController.navigationBar.subviews;
//    UIView *view = array.firstObject;
//    view.alpha = 1;
}

- (void)initNavigationBar {
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    
    NSArray *array = self.navigationController.navigationBar.subviews;
    UIView *view = array.firstObject;
    view.alpha = 0;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:17];
    title.textColor = [UIColor whiteColor];
    title.text = NSLocalizedString(@"SMMyPointTitle", nil);
    self.navigationItem.titleView = title;
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)createView {
    
    UIView *headerBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenWidth/2)];
    headerBg.backgroundColor = RGB(103, 208, 122);
    [self.view addSubview:headerBg];
    if (self.controllerType == ControllerTypeDepartmentStores) {
        headerBg.backgroundColor = RGB(240,128,128);
    }
    
    UILabel *currentAmount = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 0, 70)];
    
    [KLHttpTool supermarketGetPointWithOption:1 pageIndex:1 success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSDictionary *pointBalance = data[@"PointBalance"];
            NSString *totalPoint = ((NSNumber *)pointBalance[@"tot_mysave"]).stringValue;
            currentAmount.text = totalPoint;
            currentAmount.textColor = [UIColor whiteColor];
            currentAmount.font = [UIFont systemFontOfSize:60];
            CGFloat width = [UILabel getWidthWithTitle:currentAmount.text font:currentAmount.font];
            currentAmount.frame = CGRectMake(15, 80, width, 70);
            self.titleLabel.frame = CGRectMake(CGRectGetMaxX(currentAmount.frame), CGRectGetMaxY(currentAmount.frame) - 35, 100, 30);

        }
    } failure:^(NSError *err) {
        
    }];

    

//    }
//    currentAmount.text = point;
    currentAmount.textColor = [UIColor whiteColor];
    currentAmount.font = [UIFont systemFontOfSize:60];
    CGFloat width = [UILabel getWidthWithTitle:currentAmount.text font:currentAmount.font];
    currentAmount.frame = CGRectMake(15, 80, width, 70);
    [headerBg addSubview:currentAmount];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(currentAmount.frame), CGRectGetMaxY(currentAmount.frame) - 35, 100, 30)];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:17];
    title.text = NSLocalizedString(@"SMPoint", nil);
    self.titleLabel = title;
    [headerBg addSubview:title];
    
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(currentAmount.frame), APPScreenWidth - 20, 40)];
    msg.numberOfLines = 2;
    msg.textColor = [UIColor whiteColor];
    msg.font = [UIFont systemFontOfSize:16];
    msg.text = NSLocalizedString(@"SMPointMsg", nil);
    [headerBg addSubview:msg];
    
    CGRect bgframe = headerBg.frame;
    bgframe.size.height = CGRectGetMaxY(msg.frame)+20;
    headerBg.frame = bgframe;
    
    UIView *signBg = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerBg.frame)+ 10, APPScreenWidth, 60)];
    signBg.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:signBg];
    
    UIButton *signButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signButton.frame = CGRectMake(APPScreenWidth - 15 - 90, 12, 90, 35);
    signButton.backgroundColor = GreenColor;
    [signButton addTarget:self action:@selector(signAction:) forControlEvents:UIControlEventTouchUpInside];
    [signButton setTitle:@"连签1天" forState:UIControlStateNormal];
    [signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signButton.layer.cornerRadius = 35/2;
    [signBg addSubview:signButton];
    
    UILabel *signAmout = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 0, 25)];
    signAmout.textColor = GreenColor;
    signAmout.text = @"5";
    signAmout.font = [UIFont systemFontOfSize:25];
    CGFloat signAmoutWidth = [UILabel getWidthWithTitle:signAmout.text font:signAmout.font];
    signAmout.frame = CGRectMake(15, 10, signAmoutWidth, 25);
    [signBg addSubview:signAmout];
    
    UILabel *integrationTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(signAmout.frame), CGRectGetMaxY(signAmout.frame)-15, 80, 15)];
    integrationTitle.text = NSLocalizedString(@"SMPoint", nil);
    integrationTitle.textColor = [UIColor darkcolor];
    integrationTitle.font = [UIFont systemFontOfSize:14];
    [signBg addSubview:integrationTitle];
    
    UILabel *integrationMsg = [[UILabel alloc] initWithFrame:CGRectMake(signAmout.frame.origin.x, CGRectGetMaxY(signAmout.frame), 200, 15)];
    integrationMsg.text = @"购物可抵扣0.05元";
    integrationMsg.textColor = [UIColor darkcolor];
    integrationMsg.font = [UIFont systemFontOfSize:14];
    [signBg addSubview:integrationMsg];
    
    CGFloat height = APPScreenHeight - CGRectGetMaxY(headerBg.frame) - 10 - 45;
    
    AllIntergrationControllerController *all = [AllIntergrationControllerController new];
    all.height = height;
    InIntergrationController *inVC = [InIntergrationController new];
    inVC.height = height;
    OutIntergrationController *outVC = [OutIntergrationController new];
    outVC.height = height;
    
    NSArray *viewControllers = @[@{NSLocalizedString(@"SMPointAll", nil):all},@{NSLocalizedString(@"SMPointIn", nil):inVC},@{NSLocalizedString(@"SMPointOut", nil):outVC}];
    
     YCSlideView * view = [[YCSlideView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headerBg.frame)+10, APPScreenWidth, APPScreenHeight) WithViewControllers:viewControllers];
    view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view];
    
    UILabel *nav_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    nav_title.center = CGPointMake(self.view.center.x, 20+15+5);
    nav_title.textAlignment = NSTextAlignmentCenter;
    nav_title.font = [UIFont systemFontOfSize:17];
    nav_title.textColor = [UIColor whiteColor];
    nav_title.text = NSLocalizedString(@"SMMyPointTitle", nil);
    [self.view addSubview:nav_title];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];;
    back.frame = CGRectMake(15, 25, 25, 25);
    [back setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
//    back.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 15);
    back.tintColor = [UIColor whiteColor];
    back.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [back addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];

}
- (void)signAction:(UIButton *)button {
    [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"暂未开放"];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setControllerType:(ControllerType)controllerType {
    _controllerType = controllerType;
    
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
