
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



@interface TinyShopMainController ()<UITableViewDelegate,UITableViewDataSource>{
	UIView *blackView;
	int paged;
}

@property (nonatomic,retain)UIScrollView *scrollview;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)UIView *numberDomainview;
@property (nonatomic, strong)ChoiceHeadView *choiceHeadView;

@property (nonatomic, strong)ShowLocationView * locationView;

@property(nonatomic,strong)NSMutableArray*mutaleData;


@end

@implementation TinyShopMainController
-(void)viewDidLayoutSubviews{
	[super viewDidLayoutSubviews];
}
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.barTintColor = RGB(253, 253, 253);
	
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	[self setNaviBar];
	

}
- (void)viewDidLoad {
	[super viewDidLoad];
	paged = 1;
	self.mutaleData = @[].mutableCopy;
	[self location];
	[self createLocationView];
	[self createScrollview];
	
}
- (void)loadMainDataWith:(NSString*)pg withPageSize:(NSString*)pagesize{

	__weak __typeof(self) weakSelf = self;
	
	[KLHttpTool TinyRequestMainDataUrl:@"StoreCate/requestStoreCateList" Withpg:pg WithPagesize:pagesize WithCustomlev1:@"13" WithCustomlev2:@"1" WithCustomlev3:@"1" Withlatitude:GetUserDefault(@"latitude") Withlongitude:GetUserDefault(@"longtitude") Withorder_by:@"1" success:^(id response) {
			
			if ([response[@"status"] intValue] == 1) {
				
				NSArray *data = response[@"storelist"];
				if (data.count) {
					for (NSDictionary *dic in data) {
						
						[self.mutaleData  addObject:dic];
						[self.tableView reloadData];
						CGRect fram = self.tableView.frame;
						fram.size.height = self.mutaleData.count *120+15;
						self.tableView.frame = fram;
						self.scrollview.contentSize = CGSizeMake(APPScreenWidth, CGRectGetMaxY(self.tableView.frame));
						
					}
					++paged;
					[weakSelf.scrollview.mj_footer setState:MJRefreshStateIdle];

				}else{
					
					[weakSelf.scrollview.mj_footer endRefreshingWithNoMoreData];

				}
				
			}
			
		} failure:^(NSError *err) {
			
		}];

}
- (void)createScrollview{
	if (self.scrollview ==nil) {
		self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight - 44)];
		self.scrollview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
		[self.view addSubview:self.scrollview];
		
	}
	blackView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width ,3*(self.view.frame.size.width - 30)/5+70 )];
	blackView.backgroundColor = RGB(60, 60, 60);
	[self.scrollview addSubview:blackView];

	self.numberDomainview = [[NumDomainView alloc]initWithFrame:CGRectMake(15, 10, self.view.frame.size.width - 30,3*(self.view.frame.size.width - 30)/5+60 )];
	self.numberDomainview.backgroundColor = RGB(60, 60, 60);
	[blackView addSubview:self.numberDomainview];

	//创建标示图
	[self createTableview];

}

- (void)createTableview{
	if (self.tableView ==nil) {
		self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(blackView.frame), APPScreenWidth, 0) style:UITableViewStyleGrouped];
		self.tableView.tableFooterView = [UIView new];
		[self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"MainTableViewCell"];
		self.tableView.scrollEnabled = NO;
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		
		UIView *tableheadview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 10)];
		self.tableView.tableHeaderView = tableheadview;
		self.tableView.estimatedRowHeight = 0;
		self.tableView.estimatedSectionFooterHeight = 0;
		self.tableView.estimatedSectionHeaderHeight = 0;
		self.tableView.separatorColor = RGB(237, 237, 237);
		self.tableView.backgroundColor = RGB(237, 237, 237);
	
		[self.scrollview addSubview:self.tableView];
		[self.scrollview.mj_footer beginRefreshing];
		
	}
}

#pragma mark --上拉刷新
- (void)footerRefresh{
	
	[self loadMainDataWith:[NSString stringWithFormat:@"%d",paged] withPageSize:@"5"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return self.mutaleData.count;
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = [[UITableViewCell alloc]init];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	NSDictionary *dic = self.mutaleData[indexPath.row];
	UIImageView *showImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, APPScreenWidth - 20, 110)];
	[showImg sd_setImageWithURL:[NSURL URLWithString:dic[@"shop_thumnail_image"]] placeholderImage:[UIImage imageNamed:@"banner01"]];
	showImg.userInteractionEnabled = YES;
	[cell.contentView addSubview:showImg];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	
	return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 15.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	UILabel *views = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 15)];
	views.text = @"    여러분을 위해 골라봤어요";
	views.font = [UIFont systemFontOfSize:13];
	views.textColor = RGB(46, 46, 46);
	return views;
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
	NSArray *hotSeaches = @[];
	//创建搜索结果的控制器
	PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索关键字", nil)  didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
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
				
				ZFScanViewController *scanVC = [ZFScanViewController new];
				scanVC.returnScanBarCodeValue = ^(NSString *barCodeString) {
					
				
				};
				[self presentViewController:scanVC animated:YES completion:nil];
				
			}else if (sender.tag == 2005){
			

				

			}
}

#pragma mark -- 设置导航栏
- (void)setNaviBar{
	
	self.navigationController.navigationBar.barTintColor = RGB(60, 60, 60);
	UIButton *right1Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
	[right1Btn setImage:[UIImage imageNamed:@"icon_scanss"] forState:UIControlStateNormal];
	right1Btn.imageEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
	right1Btn.tag = 2004;
	[right1Btn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *right1Item = [[UIBarButtonItem alloc]initWithCustomView:right1Btn];
	
	UIButton *right2Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
	[right2Btn setImage:[UIImage imageNamed:@"icon_live_bottom"] forState:UIControlStateNormal];
	UIBarButtonItem *right2Item = [[UIBarButtonItem alloc]initWithCustomView:right2Btn];
	[right2Btn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
	right2Btn.tag = 2005;
	[self.navigationItem setRightBarButtonItems:@[right1Item,right2Item]];
	
	UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
	[leftBtn setImage:[UIImage imageNamed:@"icon_searchhotel"] forState:UIControlStateNormal];
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
	[leftBtn addTarget:self action:@selector(SearchBtn:) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationItem setLeftBarButtonItems:@[leftItem]];
	
}

- (void)createLocationView{
	self.choiceHeadView = [[ChoiceHeadView alloc]initWithFrame:CGRectMake(0, 0, 200, 30) withTextColor:RGB(253, 253, 253) withData:@[@"icon_location",@"icon_arrow_bottom"]];
	
	
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



- (void)pop:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end

