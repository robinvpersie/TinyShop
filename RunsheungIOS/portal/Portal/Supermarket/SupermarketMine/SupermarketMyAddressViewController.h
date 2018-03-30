//
//  SupermarketMyAddressViewController.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/13.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketBaseViewController.h"
#import "SupermarketAddressModel.h"
#import "MarketModel.h"

@protocol MyAddressDelegete <NSObject>

@optional

- (void)addNewAddressButtonPreessed;

//- (void)editAddressButtonPressed:(SupermarketAddressModel *)addressModel;

- (void)editAddressButtonPressed:(MarketModel *)addressModel;

//- (void)selectedAddress:(SupermarketAddressModel *)address;

- (void)selectedAddress:(MarketModel *)address;

@end

@interface SupermarketMyAddressViewController : SupermarketBaseViewController

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *data;
@property (nonatomic, weak) id<MyAddressDelegete> delegate;
@property (nonatomic, assign) BOOL isPageView;
@property (nonatomic, assign) BOOL isCreateOrder;//是否是在创建订单的时候
@property (nonatomic, copy) NSString *divCode;//在创建订单的时候传值

@end
