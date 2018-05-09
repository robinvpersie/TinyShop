
//
//  TinyShopMainController.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "TinyShopMainController.h"
#import "ChoiceHeadView.h"
#import "MainTableViewCell.h"
#import "NumDomainView.h"
#import "ShowLocationView.h"
#import "SupermarketHomeViewController.h"
#import "SupermarketSearchController.h"
#import "TSearchViewController.h"
#import "DomainCell.h"
#import "ADMainCell.h"
#import <MJRefresh/MJRefresh.h>

typedef NS_ENUM(NSInteger, sectionType) {
    domain,
    list
};

typedef NS_ENUM(NSInteger, fetchType) {
    topRefresh,
    loadmore
};

@interface TinyShopMainController ()<UITableViewDelegate, UITableViewDataSource>{
	UIView *blackView;
	int paged;
	BOOL first;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)ChoiceHeadView *choiceHeadView;
@property (nonatomic, assign)BOOL isFetching;
@property (nonatomic, strong)ShowLocationView *locationView;
@property(nonatomic, strong)NSMutableArray *mutaleData;


@end

@implementation TinyShopMainController


- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.barTintColor = RGB(253, 253, 253);
	
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	first= YES;
	[self setNaviBar];
	

}
- (void)viewDidLoad {
	[super viewDidLoad];
    [self commonInit];
	[self location];
	[self createLocationView];
    [self createTableview];
}

-(void)commonInit {
    paged = 1;
    self.isFetching = NO;
    self.mutaleData = [NSMutableArray array];
}


- (void)loadMainDataWithType:(fetchType)type finish:(void(^)())finish {
    
    if (self.isFetching) {
        finish();
        return;
    }
    self.isFetching = YES;
    
    if (type == topRefresh) {
        paged = 1;
    } else {
        paged = paged + 1;
    }
    
    __weak typeof(self) weakSelf = self;
	 [KLHttpTool TinyRequestMainDataUrl:@"StoreCate/requestStoreCateList"
                                Withpg:[NSString stringWithFormat:@"%d", paged]
                          WithPagesize:@"10"
                        WithCustomlev1:@"13"
                        WithCustomlev2:@"1"
                        WithCustomlev3:@"1"
                          Withlatitude:GetUserDefault(@"latitude")
                         Withlongitude:GetUserDefault(@"longtitude")
                          Withorder_by:@"2"
                               success:^(id response)
    {
        weakSelf.isFetching = NO;
        if ([response[@"status"] intValue] == 1) {
            NSArray *data = response[@"storelist"];
            if (type == topRefresh) {
                [weakSelf.mutaleData removeAllObjects];
                self.mutaleData = [data mutableCopy];
            } else {
                for (NSDictionary *dic in data) {
                    [weakSelf.mutaleData addObject:dic];
                }
            }
           }
           [[NSOperationQueue mainQueue] addOperationWithBlock:^{
              [weakSelf.tableView reloadData];
           }];

           finish();

        } failure:^(NSError *err) {
            finish();
			UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:@"인터넷 연결 또는 서버에 문제 있습니다." preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"SMAlertSureTitle", nil) style:UIAlertActionStyleCancel handler:nil];
			[alertController addAction:ok];
			[self presentViewController:alertController animated:YES completion:nil];
		}];
}


- (void)createTableview{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[DomainCell class] forCellReuseIdentifier:@"domain"];
    [self.tableView registerClass:[ADMainCell class] forCellReuseIdentifier:@"admain"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.separatorColor = RGB(245, 245, 245);
    self.tableView.backgroundColor = RGB(245, 245, 245);
    __weak typeof(self) weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadMainDataWithType:topRefresh finish:^{
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView.mj_footer resetNoMoreData];
        }];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself loadMainDataWithType:loadmore finish:^{
            [weakself.tableView.mj_footer endRefreshing];
        }];
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView.mj_header beginRefreshing];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == domain) {
        return 1;
    }
    if (self.mutaleData.count > 0) {
        [tableView.mj_footer setHidden:NO];
    } else {
        [tableView.mj_footer setHidden:YES];
    }
	return self.mutaleData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == domain) {
        DomainCell * cell = [tableView dequeueReusableCellWithIdentifier:@"domain" forIndexPath:indexPath];
        return cell;
    } else {
        ADMainCell * cell = [tableView dequeueReusableCellWithIdentifier:@"admain" forIndexPath:indexPath];
        cell.dic = self.mutaleData[indexPath.row];
        return  cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == domain) {
        return 3 * SCREEN_WIDTH / 5.0 + 80;
    } else {
        return 80;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == domain) {
        return  0.01f;
    }
	return 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == list) {
        UILabel *views = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 15)];
        views.text = @"    여러분을 위해 골라봤어요";
        views.font = [UIFont systemFontOfSize:13];
        views.textColor = RGB(46, 46, 46);
        return views;
    }
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
		NSDictionary *dic = self.mutaleData[indexPath.row];
		SupermarketHomeViewController *shopDetailed = [[SupermarketHomeViewController alloc] init];
		shopDetailed.hidesBottomBarWhenPushed = YES;
		shopDetailed.dic = dic;
		[self.navigationController pushViewController:shopDetailed animated:YES];
}

-(void)location {
	
	[YCLocationService turnOn];
	[YCLocationService singleUpdate:^(CLLocation * location) {
		
		//保存定位经纬度
		CLLocationCoordinate2D location2d = location.coordinate;
		NSString *latitude = [NSString stringWithFormat:@"%f",location2d.latitude] ;
		NSString *longtitude =  [NSString stringWithFormat:@"%f",location2d.longitude];
		SetUserDefault(@"latitude", latitude);
		SetUserDefault(@"longtitude", longtitude);
		
		[YCLocationService turnOff];
		CLGeocoder *geocoder = [[CLGeocoder alloc] init];
		[geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
			if (placemarks.count > 0) {
				NSString *address = placemarks.firstObject.name;
			
				SetUserDefault(@"Address", address);
				self.choiceHeadView.addressName = address;
				if (first) {
                    [self loadMainDataWithType:topRefresh finish:^{
                        
                    }];
					first = NO;
				}
			} else {
				self.choiceHeadView.addressName =  NSLocalizedString(@"定位失败", nil) ;
			};
		}];
	} failure:^(NSError * error) {
		[YCLocationService turnOff];
		self.choiceHeadView.addressName = NSLocalizedString(@"定位失败", nil) ;
	}];
}

-(ShowLocationView *)locationView {
	if (_locationView == nil) {
		_locationView = [[ShowLocationView alloc] init];
	}
	return _locationView;
}


- (void)SearchBtn:(UIButton*)sender{

	
	//创建热搜的数组
	NSArray *hotSeaches = [NSArray array];
	//创建搜索结果的控制器
	PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索关键字", nil)  didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText)
    {
		TSearchViewController *searchResultVC = [[TSearchViewController alloc] init];
		searchResultVC.searchKeyWord = searchText;
		searchResultVC.navigationItem.title = NSLocalizedString(@"搜索结果", nil) ;
		[searchViewController.navigationController pushViewController:searchResultVC animated:YES];
		
		
	}];
	//创建搜索的控制器
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
	[self presentViewController:nav  animated:NO completion:nil];
	

}

#pragma mark -- 右边点击方法
- (void)rightAction:(UIButton*)sender{

             if (sender.tag == 2004) {

                ZFScanViewController *scanVC = [[ZFScanViewController alloc] init];
                 scanVC.autoGoBack = YES;
                __weak typeof(self) weakself = self;
                scanVC.returnScanBarCodeValue = ^(NSString *barCodeString) {
                    NSURLComponents *components = [[NSURLComponents alloc] initWithString:barCodeString];
                    if ([components.scheme isEqualToString:@"giga"]) {
                        if ([components.host isEqualToString:@"qrPay"]) {
                            NSString *numcode = components.query;
                            InputAmountController *input = [[InputAmountController alloc] init];
                            input.hidesBottomBarWhenPushed = YES;
                            input.numcode = numcode;
                            input.payCompletion = ^(BOOL state) {
                                if (state) {
                                    [weakself.navigationController popViewControllerAnimated:YES];
                                }
                            };
                            [weakself.navigationController pushViewController:input animated:YES];
                        }
                    }

                };
                [self presentViewController:scanVC animated:YES completion:nil];

            }else if (sender.tag == 2005){

//				LGwebViewController *lgupay = [LGwebViewController new];
//				lgupay.hidesBottomBarWhenPushed = YES;
//				[lgupay loadRequestUrlWithOrderNumber:@"1021804110000000011W" OrderMoney:@"1800" OrderUserName:@"%EA%B9%80%EB%8F%84%EC%84%B1" GiftInfo:@"api%EC%83%88%EB%A1%9C%20%EB%B0%9B%EC%9D%84%EA%B2%83"];
//				[self.navigationController pushViewController:lgupay animated:YES];
//
            }
}

#pragma mark -- 设置导航栏
- (void)setNaviBar{
	
	self.navigationController.navigationBar.barTintColor = RGB(60, 60, 60);
	
	UIButton *right1Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
	[right1Btn setImage:[UIImage imageNamed:@"icon_scanss"] forState:UIControlStateNormal];
	right1Btn.imageEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
	right1Btn.tag = 2004;
	[right1Btn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *right1Item = [[UIBarButtonItem alloc]initWithCustomView:right1Btn];
	
	UIButton *right2Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 30)];
	[right2Btn setImage:[UIImage imageNamed:@"icon_searchhotel"] forState:UIControlStateNormal];
	UIBarButtonItem *right2Item = [[UIBarButtonItem alloc]initWithCustomView:right2Btn];
	[right2Btn addTarget:self action:@selector(SearchBtn:) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationItem setRightBarButtonItems:@[right1Item,right2Item]];
	
	UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
	[leftBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
	leftBtn.tag = 2005;
	[self.navigationItem setLeftBarButtonItems:@[leftItem]];
	
}

- (void)createLocationView{
    
	self.choiceHeadView = [[ChoiceHeadView alloc]initWithFrame:CGRectMake(0, 0, 200, 30) withTextColor:RGB(253, 253, 253) withData:@[@"icon_location",@"icon_arrow_bottom"]];
	__weak typeof(self) weakSelf = self;
	self.choiceHeadView.showAction = ^{
		[weakSelf.locationView showInView:weakSelf.view.window];
		weakSelf.locationView.location = ^{
//			[weakSelf location];
		};
		weakSelf.locationView.map = ^{
			AroundMapController * around = [[AroundMapController alloc] init];
			around.hidesBottomBarWhenPushed = YES;
			[weakSelf.navigationController pushViewController:around animated:YES];
		};
	};
	self.navigationItem.titleView = self.choiceHeadView;
	
}



- (void)pop:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end

