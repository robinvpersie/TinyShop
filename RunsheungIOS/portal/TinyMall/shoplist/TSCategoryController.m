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




@interface TSCategoryController ()<UITableViewDelegate,UITableViewDataSource,WJClickItemsDelegate,SingleSegmentDelegate,SegmentItemDelegate>{
	NSString *Level1;
	NSString *Level2;
	NSString *Level3;
	NSString *orderBy;
	int paged ;
}

@property (nonatomic,retain)UITableView *tableview;

@property (nonatomic,retain)NSMutableDictionary *allDic;

@property (nonatomic,retain)SingleSegmentView *segmentView1;

@property (nonatomic,retain)SingleSegmentView *segmentView2;

@property (nonatomic,retain)SegmentItem *SegmentItem;

@property (nonatomic,retain)TSItemView *ItemView;

@property (nonatomic,assign)BOOL extend;

@property (nonatomic, strong)ShowLocationView * locationView;

@property (nonatomic, strong)ChoiceHeadView *choiceHeadView;

@property (nonatomic,strong)NSDictionary *responseDit;

@property (nonatomic,retain)NSMutableArray *shoplistData;



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

- (void)loadStoreListwithLeve1:(NSString*)leve1 withLeve2:(NSString*)leve2 withLeve3:(NSString*)leve3 withorderBy:(NSString*)order_by withPg:(NSString *)pg{
	YCAccountModel *account = [YCAccountModel getAccount];

	
	[KLHttpTool TinyShoprequestStoreCateListwithCustom_code:account.customCode withpg:pg withtoken:account.token withcustom_lev1:leve1 withcustom_lev2:leve2 withcustom_lev3:leve3 withlatitude:GetUserDefault(@"latitude") withlongitude:GetUserDefault(@"longtitude") withorder_by:order_by success:^(id response) {
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

			
			
		}
		
	} failure:^(NSError *err) {
		
		
		
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
		self.segmentView1.tag = 1001;
		self.segmentView1.delegate =self;
		[self.view addSubview:self.segmentView1];
		


	}
	[self createSecSegmentView:leve3Mutables];
	
	
}

- (void)createSecSegmentView:(NSMutableArray*)array{
	
	if (self.segmentView2 == nil) {
		self.segmentView2 = [[SingleSegmentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView1.frame)+10, APPScreenWidth, 50) withdit:self.responseDit  withData:array withLineBottomColor:RGB(33, 192, 67)];
		self.segmentView2.tag = 1002;
		self.segmentView2.delegate = self;
		[self.view addSubview:self.segmentView2];
	}
	[self.view addSubview:self.SegmentItem];
	[self createSegmentItem];
	
}

- (void)createSegmentItem{
	if (self.SegmentItem == nil) {
		self.SegmentItem = [[SegmentItem alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView2.frame)+10, APPScreenWidth, 50)];
		self.SegmentItem.delegate = self;
		
		[self.view addSubview:self.SegmentItem];
		
	}
}

- (void)createItemView:(NSMutableArray*)array{
	if (self.ItemView == nil) {
		self.ItemView =[[TSItemView alloc]initWithFrame:CGRectMake(10, 120, APPScreenWidth - 20, 50) withData:array];
		self.ItemView.wjitemdelegate = self;
		
		[self.view addSubview:self.ItemView];
		
		self.SegmentItem.hidden = YES;
		
	}
	
}
- (void)loadThirdData{
    [KLHttpTool TinyRequestGetCategory3ListWithCustom_lev1:Level1 WithCustom_lev2:Level2 WithLangtype:@"kor" success:^(id response) {
        if ([response[@"status"] intValue] == 1) {
            NSArray *dicArray = response[@"lev3s"];
            NSMutableArray *lev3sArray = [NSMutableArray array];
            
            for (int i =0; i<dicArray.count; i++) {
                NSDictionary *dic = dicArray[i];
                [lev3sArray addObject:dic[@"lev_name"]];
                
            }
            [self createItemView:lev3sArray];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)PushEditAction:(NSNotification*)notice{
	NSString *notices = notice.object;
	if ([notices isEqualToString:@"1"]) {
		TSFirstMoreViewController *firstMore = [TSFirstMoreViewController new];
		firstMore.title = @"더보기";
		firstMore.level1 = Level1;
		firstMore.choiceBlock = ^(NSString *selectItem) {
		};
		[self.navigationController pushViewController:firstMore animated:YES];
		
	}else{
		if (self.ItemView !=nil) {
			
			self.ItemView.hidden = YES;
			self.ItemView = nil;
			self.SegmentItem.hidden = YES;
			self.SegmentItem = nil;
			
			[self createSegmentItem];
		}else{
			[self loadThirdData];
			
		}
		
		
		
	}
	
}


- (void)createTableview{
	
	if (self.tableview == nil) {
		
		self.tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 170, APPScreenWidth, APPScreenHeight - 234) style:UITableViewStylePlain];
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
     return  120.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSDictionary *dic = self.shoplistData[indexPath.row];
	SupermarketHomeViewController *shopDetailed = [[SupermarketHomeViewController alloc] init];
	shopDetailed.hidesBottomBarWhenPushed = YES;
	shopDetailed.dic = dic;
	[self.navigationController pushViewController:shopDetailed animated:YES];
}

    
- (void)setNaviBar{
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationController.navigationBar.translucent = NO;
	UIButton *right1Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
	[right1Btn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
	right1Btn.imageEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
	right1Btn.tag = 2004;
	[right1Btn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *right1Item = [[UIBarButtonItem alloc]initWithCustomView:right1Btn];
	
	UIButton *right2Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
	[right2Btn setImage:[UIImage imageNamed:@"icon_map1"] forState:UIControlStateNormal];
	UIBarButtonItem *right2Item = [[UIBarButtonItem alloc]initWithCustomView:right2Btn];
	[right2Btn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
	right2Btn.tag = 2005;
	[self.navigationItem setRightBarButtonItems:@[right1Item,right2Item]];
	
	
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
			AroundMapController * around = [[AroundMapController alloc] init];
			around.hidesBottomBarWhenPushed = YES;
			[self.navigationController pushViewController:around animated:YES];
		}

}

#pragma mark --
- (void)clickItem:(NSString*)itemIndex{
        self.segmentView2.hidden = YES;
        self.segmentView2 = nil;
        self.SegmentItem.hidden = YES;
        self.SegmentItem = nil;
        self.ItemView.hidden = YES;
        self.ItemView = nil;
        Level2 = itemIndex;
	    [self.shoplistData removeAllObjects];
        [self loadStoreListwithLeve1:Level1 withLeve2:Level2 withLeve3:@"1" withorderBy:@"1" withPg:@"1"];
}

- (void)clickItemsec:(NSString*)itemIndex{
        self.SegmentItem.hidden = YES;
        self.SegmentItem = nil;
        Level3 = itemIndex;
        self.ItemView.hidden = YES;
        self.ItemView = nil;
	
	    [self.shoplistData removeAllObjects];
        [self loadStoreListwithLeve1:Level1 withLeve2:Level2 withLeve3:Level3 withorderBy:@"1" withPg:@"1"];
}
//
- (void)clickSegment:(int)index{
	[self.shoplistData removeAllObjects];
	
	[self loadStoreListwithLeve1:Level1 withLeve2:Level2 withLeve3:Level3 withorderBy:[NSString stringWithFormat:@"%d",index] withPg:@"1"];
}

//点击单个的项目响应
- (void)wjClickItems:(NSString*)item{

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
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PushEditAction:) name:@"EDITACTIONNOTIFICATIONS" object:nil];
	
	

}

    
@end
    
    
