//
//  ChoiceCategoryController.m
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/8.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import "TSCategoryController.h"
#import "ChoiceHeadView.h"
#import "ChoiceTableViewCell.h"
#import "SegmentItem.h"
#import "TSFirstMoreViewController.h"
#import "TSItemView.h"
#import "MemberEnrollController.h"
#import "SupermarketHomeViewController.h"
#import "ShowLocationView.h"
#import "SingleSegmentView.h"
#import "SupermarketSearchController.h"
#import "TSearchViewController.h"
#import "CoverMaskView.h"




@interface TSCategoryController() <SaixuanDegate,UITableViewDelegate, UITableViewDataSource, WJClickItemsDelegate, SingleSegmentDelegate, SegmentItemDelegate>{
	NSString *Level1;
	NSString *Level2;
	NSString *Level3;
	NSString *orderBy;
	int paged ;
}

@property (nonatomic,strong)CoverMaskView *maskview;
@property (nonatomic, strong)UITableView *tableview;

@property (nonatomic, strong)NSMutableDictionary *allDic;

@property (nonatomic, strong)SingleSegmentView *segmentView1;

@property (nonatomic, strong)SegmentItem *SegmentItem;

@property (nonatomic, assign)BOOL extend;

@property (nonatomic, strong)ShowLocationView * locationView;

@property (nonatomic, strong)ChoiceHeadView *choiceHeadView;

@property (nonatomic, strong)NSDictionary *responseDit;

@property (nonatomic, strong)NSMutableArray *shoplistData;

@property (nonatomic, strong)NSMutableArray *dic3sArray;


@end

@implementation TSCategoryController

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	if (self.leves.count) {
		
		[self setNavi];
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setNaviBar];
	[self setInitData];
	[self location];
	[self createTableview];
	
}

- (void)setLeves:(NSMutableArray *)leves{
	_leves = leves;
	[self location];
	
}

- (void)loadStoreListwithLeve1:(NSString*)leve1
					 withLeve2:(NSString*)leve2
					 withLeve3:(NSString*)leve3
				   withorderBy:(NSString*)order_by
						withPg:(NSString *)pg
{
	
	YCAccountModel *account = [YCAccountModel getAccount];
	[KLHttpTool TinyShoprequestStoreCateListwithCustom_code:account.customCode
													 withpg:pg
												  withtoken:account.token
											withcustom_lev1:leve1
											withcustom_lev2:leve2
											withcustom_lev3:leve3
											   withlatitude:GetUserDefault(@"latitude")
											  withlongitude:GetUserDefault(@"longtitude")
											   withorder_by:order_by
													success:^(id response)
	 {
		 if ([response[@"status"] intValue] == 1) {
			 self.responseDit = response;
			 
			 [self transferResponse];
			 NSArray *datas = self.responseDit[@"storelist"];
			 
			 if (datas.count) {
				 [self.shoplistData addObjectsFromArray:datas];
				 [self.tableview reloadData];
				 ++paged;
				 [self.tableview.mj_footer setState:MJRefreshStateIdle];
				 
			 }else{
				 [self.tableview.mj_footer endRefreshingWithNoMoreData];
			 }
		 } else {
			 [self.tableview.mj_footer endRefreshingWithNoMoreData];
		 }
	 } failure:^(NSError *err) {
		 [self.tableview.mj_footer endRefreshingWithNoMoreData];
	 }];
}

- (void)transferResponse{
	
	NSArray *leve2s = self.responseDit[@"lev2s"];
	NSArray *leve3s = self.responseDit[@"lev3s"];
	NSMutableArray *leve2Mutables  = @[].mutableCopy;
	NSMutableArray *leve3Mutables  = @[].mutableCopy;
	
	for (int i = 0; i<leve2s.count; i++) {
		NSDictionary *dic2 = leve2s[i];
		[leve2Mutables addObject:dic2[@"lev_name"]];
	}
	
	for (int i = 0; i<leve3s.count; i++) {
		NSDictionary *dic3 = leve3s[i];
		[leve3Mutables addObject:dic3[@"lev_name"]];
	}
	if (self.segmentView1 == nil) {
		self.segmentView1 = [[SingleSegmentView alloc]initWithFrame:CGRectMake(0,10, APPScreenWidth, 50) withdit:self.responseDit  withData:leve2Mutables withLineBottomColor:RGB(33, 192, 67)];
		self.segmentView1.delegate =self;
		[self.view addSubview:self.segmentView1];
	}
	if (self.SegmentItem == nil) {
		self.SegmentItem = [[SegmentItem alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView1.frame)+10, APPScreenWidth, 50)];
		self.SegmentItem.delegate = self;
		[self.view addSubview:self.SegmentItem];
		
	}
}

- (void)createTableview{
	
	if (self.tableview == nil) {
		
		self.tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 120, APPScreenWidth, APPScreenHeight - 234) style:UITableViewStylePlain];
		[self.tableview registerNib:[UINib nibWithNibName:@"ChoiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChoiceTableViewCellID"];
		self.tableview.delegate = self;
		self.tableview.dataSource = self;
		self.tableview.estimatedRowHeight = 0;
		self.tableview.estimatedSectionHeaderHeight = 0;
		self.tableview.estimatedSectionFooterHeight = 0;
		self.tableview.tableFooterView = [[UIView alloc]init];
		self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
		[self.tableview.mj_footer beginRefreshing];
		[self.view addSubview:self.tableview];
		
		
		
	}
}

- (void)footerRefresh{
	[self loadStoreListwithLeve1:Level1 withLeve2:Level2 withLeve3:Level3 withorderBy:orderBy withPg:[NSString stringWithFormat:@"%d",paged]];
}
#pragma mark -- 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.shoplistData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	ChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceTableViewCellID"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	NSDictionary *dics = self.shoplistData[indexPath.row];
	cell.dic = dics;
	cell.starValue = [dics[@"score"] floatValue];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 120.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSDictionary *dic = self.shoplistData[indexPath.row];
	BusinessHomeController *shopDetailed = [[BusinessHomeController alloc] init];
	shopDetailed.hidesBottomBarWhenPushed = YES;
    shopDetailed.dic = dic;
	[self.navigationController pushViewController:shopDetailed animated:YES];
}


- (void)setNaviBar{
	
	self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = nil;

	UIButton *right1Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
	[right1Btn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
	right1Btn.imageEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
	right1Btn.tag = 2004;
	[right1Btn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *right1Item = [[UIBarButtonItem alloc] initWithCustomView:right1Btn];
	
	UIButton *right2Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
	[right2Btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
	UIBarButtonItem *right2Item = [[UIBarButtonItem alloc] initWithCustomView:right2Btn];
	[right2Btn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
	right2Btn.tag = 2005;
	[self.navigationItem setRightBarButtonItems:@[right1Item]];
	
	self.choiceHeadView = [[ChoiceHeadView alloc]initWithFrame:CGRectMake(0, 0, 200, 30) withTextColor:RGB(25, 25, 25) withData:@[@"icon_location",@"icon_arrow_bottom"]];
	__weak typeof(self) weakSelf = self;
	self.choiceHeadView.showAction = ^{
		[weakSelf.locationView showInView:weakSelf.view.window];
		weakSelf.locationView.location = ^{
			[weakSelf location];
		};
		weakSelf.locationView.map = ^{
			AroundMapController * around = [[AroundMapController alloc] init];
			around.hidesBottomBarWhenPushed = YES;
			[weakSelf.navigationController pushViewController:around animated:YES];
		};
	};
	self.navigationItem.titleView = self.choiceHeadView;
}

-(void)location {
	[YCLocationService turnOn];
	[YCLocationService singleUpdate:^(CLLocation * location) {
		[YCLocationService turnOff];
		
		//保存定位经纬度
		CLLocationCoordinate2D location2d = location.coordinate;
		NSString *latitude = [NSString stringWithFormat:@"%f",location2d.latitude] ;
		NSString *longtitude =  [NSString stringWithFormat:@"%f",location2d.longitude];
		[[NSUserDefaults standardUserDefaults] setObject:latitude forKey:@"latitude"];
		[[NSUserDefaults standardUserDefaults] setObject:longtitude forKey:@"longtitude"];
		[[NSUserDefaults standardUserDefaults]synchronize];
		
		CLGeocoder *geocoder = [[CLGeocoder alloc] init];
		[geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
			if (placemarks.count > 0) {
				NSString *address = placemarks.firstObject.name;
				self.choiceHeadView.addressName = address;
			} else {
				self.choiceHeadView.addressName =  NSLocalizedString(@"定位失败", nil) ;
			};
		}];
	} failure:^(NSError * error) {
		[YCLocationService turnOff];
		self.choiceHeadView.addressName =  NSLocalizedString(@"定位失败", nil) ;
	}];
}

-(ShowLocationView *)locationView {
	if (_locationView == nil) {
		_locationView = [[ShowLocationView alloc] init];
	}
	return _locationView;
}

#pragma mark -- 右边点击方法
- (void)rightAction:(UIButton*)sender{
	if (sender.tag == 2004) {
		
		
		//创建热搜的数组
		NSArray *hotSeaches = @[];
		//创建搜索结果的控制器
		PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"검색어입력" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
			TSearchViewController *searchResultVC = [[TSearchViewController alloc] init];
			searchResultVC.searchKeyWord = searchText;
			searchResultVC.navigationItem.title = @"검색결과";
			[searchViewController.navigationController pushViewController:searchResultVC animated:YES];
			
			
		}];
		//创建搜索的控制器
		
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
		[self presentViewController:nav  animated:NO completion:nil];
		
		
		
	}else{
		//			AroundMapController * around = [[AroundMapController alloc] init];
		//			around.hidesBottomBarWhenPushed = YES;
		//			[self.navigationController pushViewController:around animated:YES];
	}
	
}

#pragma mark --
- (void)clickItem:(int)itemIndex{
	self.maskview.hidden = YES;
	self.maskview = nil;
	self.maskview.hidden = !self.maskview.hidden;
	NSArray*lev2s = self.responseDit[@"lev2s"];
	NSDictionary*selectLev2s = lev2s[itemIndex];
	Level2 = selectLev2s[@"lev"];
	[self.shoplistData removeAllObjects];
	[self loadStoreListwithLeve1:Level1 withLeve2:Level2 withLeve3:@"1" withorderBy:@"1" withPg:@"1"];
}

- (void)clickSegment:(int)index{
	
	if (index == 1001) {
		NSArray*lev3s = self.responseDit[@"lev3s"];
		NSLog(@"------------lev3s---------:%@",lev3s);
		if (self.maskview == nil) {
			//获取状态栏的rect
			CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
			//获取导航栏的rect
			CGRect navRect = self.navigationController.navigationBar.frame;
			
			self.maskview = [[CoverMaskView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.SegmentItem.frame)+statusRect.size.height+navRect.size.height, SCREEN_WIDTH, SCREEN_HEIGHT)];
			self.maskview.data = lev3s;
			self.maskview.sxdegate = self;
			[[UIApplication sharedApplication].keyWindow addSubview:_maskview];
		}else{
			self.maskview.hidden = !self.maskview.hidden;
			
		}
		
	}else{
		self.maskview.hidden = YES;
		self.maskview = nil;
		[self.shoplistData removeAllObjects];
		NSLog(@"%d",index);
		[self loadStoreListwithLeve1:Level1 withLeve2:Level2 withLeve3:Level3 withorderBy:[NSString stringWithFormat:@"%d",index] withPg:@"1"];
		
	}
}



- (void)setNavi{
	UIButton *popBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
	[popBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
	[popBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
	[popBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
	[popBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:popBtn];
	[self.navigationItem setLeftBarButtonItem:item];
	
}

- (void)pop:(UIButton*)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 初始化分类级别数据
- (void)setInitData{
	
	self.shoplistData = @[].mutableCopy;
	if (self.leves.count) {
		Level1 = self.leves.firstObject;
		Level2 = self.leves[1];
		Level3 = self.leves.lastObject;
		orderBy = @"1";
		
	}else{
		Level1 = @"13";
		Level2 = @"1";
		Level3 = @"1";
		orderBy = @"1";
		
	}
	paged = 1;
	SetUserDefault(@"Level1", Level1);
	SetUserDefault(@"Level2", Level2);
	SetUserDefault(@"Level3", Level3);
	SetUserDefault(@"orderBy", orderBy);
	
	self.extend = NO;
	self.allDic = @{}.mutableCopy;
	
}

#pragma mark ---saixuan
-(void)clickSaixuan:(int)index{
	self.maskview.hidden = YES;
	self.maskview = nil;
	
	if ( index != 101) {
		
		NSString*lev3 = [NSString stringWithFormat:@"%d",index];
		SetUserDefault(@"Level3", lev3);
		[self.shoplistData removeAllObjects];
		if (index == 0) {
			[self loadStoreListwithLeve1:Level1 withLeve2:Level2 withLeve3:@"" withorderBy:@"1" withPg:@"1"];
		}else{
			[self loadStoreListwithLeve1:Level1 withLeve2:Level2 withLeve3:lev3 withorderBy:@"1" withPg:@"1"];
		}
	}
	
}


@end


