//
//  SupermarketMyOrderController.m
//  Portal
//
//  Created by ifox on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketMyOrderController.h"
#import "NinaPagerView.h"
#import "SupermarketAllOrderController.h"
#import "SupermarketWaitPayController.h"
//#import "SupermarketWaitSendController.h"
//#import "SupermarketWaitPickController.h"
#import "SupermarketWaitReceiveController.h"
#import "SupermarketWaitCommentController.h"
#import "SupermarketOrderDetaiController.h"
#import "SupermarketOrderWaitPayDetailController.h"
#import "SupermarketReleaseCommentController.h"
#import "SupermarketReleaseCommentsController.h"
#import "SupermarketApplyRefundController.h"
#import "SupermarketWaitDeliverOrderController.h"
#import "SupermarketConfrimOrderByNumbersController.h"
#import "SupermarketOrderGoodsData.h"
#import "SupermarketHomeViewController.h"
#import "LZCartViewController.h"
#import "LZCartModel.h"

@interface SupermarketMyOrderController ()

@end

@implementation SupermarketMyOrderController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = NO;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"shengqing_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backitem;
    
}

- (void)pop:(UIButton*)sender{
	
	if (self.presentingViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
		
	} else {
		NSArray *controllers = self.navigationController.viewControllers;
		if (controllers.count>2) {
			for (UIViewController *vc in controllers) {
				if ([vc isMemberOfClass:[SupermarketHomeViewController class]]||[vc isMemberOfClass:[LZCartViewController class]]) {
					[self.navigationController popToViewController:vc animated:YES];
                } else {
                    [self.navigationController popViewControllerAnimated: YES];
                }
			}

		} else {
			[self.navigationController popViewControllerAnimated:YES];
		}
		
	}
	
	
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.automaticallyAdjustsScrollViewInsets == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (self.navigationController.navigationBar.translucent == NO) {
        self.navigationController.navigationBar.translucent = YES;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"SupermarketHomeMyOrder", nil);
    [self createView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveClick:) name:@"clickOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goComment:) name:SendGoodsCommentsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goApplyRefund:) name:GoApplyRefund object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBuyAgaion:) name:BuyAgainNotification object:nil];
    self.navigationItem.leftBarButtonItem = nil;
    
//    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
//    self.navigationItem.leftBarButtonItem = back;
    
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)popController{

    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)createView {
    SupermarketAllOrderController *allOrder = [SupermarketAllOrderController new];
    allOrder.isPageView = YES;
    allOrder.controllerType = self.controllerType;
    
    SupermarketWaitPayController *waitPay = [SupermarketWaitPayController new];
    waitPay.isPageView = YES;
    waitPay.controllerType = self.controllerType;
    
    SupermarketWaitDeliverOrderController *waitDeliver = [SupermarketWaitDeliverOrderController new];
    waitDeliver.isPageView = YES;
    waitDeliver.controllerType = self.controllerType;
    
    SupermarketWaitReceiveController *waitReceive = [SupermarketWaitReceiveController new];
    waitReceive.isPageView = YES;
    waitReceive.controllerType = self.controllerType;
    
    SupermarketWaitCommentController *waitComment = [SupermarketWaitCommentController new];
    waitComment.isPageView = YES;
    waitComment.controllerType = self.controllerType;
    
    NSArray *colorArray = @[
                            GreenColor, /**< 选中的标题颜色 Title SelectColor  **/
                            [UIColor darkGrayColor], /**< 未选中的标题颜色  Title UnselectColor **/
                            GreenColor, /**< 下划线颜色或滑块颜色 Underline or SlideBlock Color   **/
                            [UIColor whiteColor], /**<  上方菜单栏的背景颜色 TopTab Background Color   **/
                            ];
    
    NinaPagerView *pageView = [[NinaPagerView alloc] initWithTitles:@[NSLocalizedString(@"SupermarketMyOrderAll", nil),NSLocalizedString(@"SupermarketMyOrderWaitPay", nil),NSLocalizedString(@"SupermarketMyOrderWaitDeliver", nil),/*,@"待自提",*/NSLocalizedString(@"SupermarketMyOrderWaitReceive", nil),NSLocalizedString(@"SupermarketMyOrderWaitComment", nil)] WithVCs:@[allOrder,waitPay,waitDeliver,/*waitSend,waitPick,*/waitReceive,waitComment] WithColorArrays:colorArray];
    pageView.pushEnabled = YES;
    pageView.currentPage = self.pageIndex;
    [self.view addSubview:pageView];
}

- (void)goBuyAgaion:(NSNotification *)notification {
    SupermarketOrderData *data = notification.object;
    SupermarketConfrimOrderByNumbersController *confirmOrder = [SupermarketConfrimOrderByNumbersController new];
    confirmOrder.totalPrice = data.totalPrice;
    NSMutableArray *shopCartArr = @[].mutableCopy;
    for (SupermarketOrderGoodsData *goods in data.goodList) {
        LZCartModel *model = [[LZCartModel alloc] init];
        model.item_code = goods.item_code;
        model.image_url = goods.image_url;
        model.number = goods.amount.integerValue;
        model.price = goods.price.stringValue;
        model.divCode = data.divCode;
		model.sale_custom_code = data.sale_custom_code;
        [shopCartArr addObject:model];
    }
    confirmOrder.dataArray = shopCartArr.copy;
    
    confirmOrder.controllerType = self.controllerType;
    [self.navigationController pushViewController:confirmOrder animated:YES];
}

- (void)receiveClick:(NSNotification *)notification {
    SupermarketOrderData *data = notification.object;
    if (data.status == OrderWaitPay && data.syncPaymentStatus.integerValue == 0) {
        SupermarketOrderWaitPayDetailController *orderWaitPayDetail = [[SupermarketOrderWaitPayDetailController alloc] init];
        orderWaitPayDetail.data = data;
        orderWaitPayDetail.controllerType = self.controllerType;
         [self.navigationController pushViewController:orderWaitPayDetail animated:YES];
    } else {
        SupermarketOrderDetaiController *orderDetail = [[SupermarketOrderDetaiController alloc] init];
        orderDetail.orderID = data.order_code;
        orderDetail.orderStatus = data.status;
        orderDetail.data = data;
        orderDetail.controllerType = self.controllerType;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}

- (void)goComment:(NSNotification *)notification {
    SupermarketOrderData *data = notification.object;
    
    if (data.goodList.count > 1) {
        SupermarketReleaseCommentsController *vc = [[SupermarketReleaseCommentsController alloc] init];
        vc.data = data;
//        NSMutableArray *goodslist = data.goodList.mutableCopy;
//        NSMutableArray *goodsList2 = data.goodList.mutableCopy;
//        for (SupermarketOrderGoodsData *goods in goodslist) {
//            if (goods.need_assess.integerValue == 0 || goods.need_assess.integerValue == 2) {
//                [goodsList2 removeObject:goods];
//            }
//        }
//        vc.waitCommentGoodsArr = goodsList2.copy;
        [self.navigationController pushViewController:vc animated:YES];
    }  else {
        SupermarketReleaseCommentController *vc = [[SupermarketReleaseCommentController alloc] init];
        vc.orderData = data;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)goApplyRefund:(NSNotification *)notification {
    SupermarketOrderData *data = notification.object;
    
    SupermarketApplyRefundController *vc = [[SupermarketApplyRefundController alloc] init];
    vc.orderData = data;
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
