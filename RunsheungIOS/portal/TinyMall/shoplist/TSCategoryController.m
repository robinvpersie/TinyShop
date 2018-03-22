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



@interface TSCategoryController ()<UITableViewDelegate,UITableViewDataSource,WJClickItemsDelegate,SingleSegmentDelegate,SegmentItemDelegate>{
	MBProgressHUD *hudloading;
	NSString *Level1;
	NSString *Level2;
	NSString *Level3;
	NSString *orderBy;
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

@property (nonatomic,retain)NSArray *shoplistData;



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
	
	self.extend = NO;
	self.view.backgroundColor = RGB(250, 250, 250);
	self.allDic = @{}.mutableCopy;
	hudloading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self location];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PushEditAction:) name:@"EDITACTIONNOTIFICATIONS" object:nil];
	[self loadStoreListwithLeve1:Level1  withLeve2:Level2 withLeve3:Level3 withorderBy:orderBy];
	[self createTableview];

}

- (void)setLeves:(NSMutableArray *)leves{
	_leves = leves;
}

- (void)loadStoreListwithLeve1:(NSString*)leve1 withLeve2:(NSString*)leve2 withLeve3:(NSString*)leve3 withorderBy:(NSString*)order_by{
	YCAccountModel *account = [YCAccountModel getAccount];
	NSString *latitude = [[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"];
	NSString *longitude = [[NSUserDefaults standardUserDefaults]objectForKey:@"longtitude"];
	[KLHttpTool TinyShoprequestStoreCateListwithCustom_code:account.customCode withpg:@"1" withtoken:account.token withcustom_lev1:leve1 withcustom_lev2:leve2 withcustom_lev3:leve3 withlatitude:latitude withlongitude:longitude withorder_by:order_by success:^(id response) {
		if ([response[@"status"] intValue] == 1) {
			[hudloading hideAnimated:YES afterDelay:2];
			self.responseDit = response;
			[self transferResponse];
			self.shoplistData = self.responseDit[@"storelist"];
			[self.tableview reloadData];
		}
		
	} failure:^(NSError *err) {
		hudloading.mode = MBProgressHUDModeText;
		hudloading.label.text = @"可能网络出现问题！";
		[hudloading hideAnimated:YES afterDelay:2.0f];
		
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
		self.segmentView1 = [[SingleSegmentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView1.frame)+10, APPScreenWidth, 50) withdit:self.responseDit  withData:leve2Mutables withLineBottomColor:RGB(33, 192, 67)];
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

- (void)PushEditAction:(NSNotification*)notice{
	NSString *notices = notice.object;
	if ([notices isEqualToString:@"1"]) {
		TSFirstMoreViewController *firstMore = [TSFirstMoreViewController new];
		firstMore.title = @"添加更多";
		firstMore.choiceBlock = ^(NSString *selectItem) {
//			[self.allDic setObject:@[@"新添加1",@"新添加2",@"新添加3",@"新添加4",@"新添加5"] forKey:selectItem];
//			self.segmentView.dataDic = self.allDic;
		};
		[self.navigationController pushViewController:firstMore animated:YES];
	}else{
		self.extend = !self.extend;
		CGRect frams = self.tableview.frame;
		if (self.extend) {
			frams.origin.y = 110;
			self.SegmentItem.hidden = YES;
		}else{
			frams.origin.y = 170;
			self.SegmentItem.hidden = NO;
		}
		self.tableview.frame = frams;

		[self.tableview reloadData];
	}
	
}

- (void)createTableview{
	
	if (self.tableview == nil) {
		
		self.tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 170, APPScreenWidth, APPScreenHeight - CGRectGetMaxY(self.segmentView2.frame) - 10) style:UITableViewStylePlain];
		[self.tableview registerNib:[UINib nibWithNibName:@"ChoiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChoiceTableViewCellID"];
		self.tableview.delegate = self;
		self.tableview.dataSource = self;
		self.tableview.estimatedRowHeight = 0;
		self.tableview.estimatedSectionHeaderHeight = 0;
		self.tableview.estimatedSectionFooterHeight = 0;
		self.tableview.tableFooterView = [[UIView alloc]init];
		[self.view addSubview:self.tableview];
		
	}
	
}

#pragma mark -- 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section == 0&&self.extend ) {
		return 1;
	}
	
	return self.shoplistData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) {
		UITableViewCell *cell = [[UITableViewCell alloc]init];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		if (self.extend) {
			self.ItemView =[[TSItemView alloc]initWithFrame:CGRectMake(10, 10, APPScreenWidth - 20, 130) withData:@[@"宇成国际酒店",@"九龙城国际酒店",@"速8酒店",@"汉庭酒店",@"希尔顿酒店",@"宇成国际酒店",@"九龙城国际酒店",@"速8酒店",@"汉庭酒店",@"希尔顿酒店",@"宇成国际酒店",@"九龙城国际酒店",@"速8酒店",@"汉庭酒店",@"希尔顿酒店"]];
			self.ItemView.wjitemdelegate = self;
			[cell.contentView addSubview:self.ItemView];
			
		}
		
		return cell;
	} else {
		ChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceTableViewCellID"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		NSDictionary *dics = self.shoplistData[indexPath.row];
		cell.dic = dics;
		cell.starValue = [dics[@"score"] floatValue];
		return cell;
		
	}
	ChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceTableViewCellID"];
	cell.starValue = 1;
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.section == 0) {
		if (self.extend) {
			return 150.0f;
			
		}else{
			return 0.0f;
			
		}
	}
	return  120.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section ==1) {
		NSDictionary *dic = self.shoplistData[indexPath.row];
		SupermarketHomeViewController *shopDetailed = [[SupermarketHomeViewController alloc] init];
		shopDetailed.hidesBottomBarWhenPushed = YES;

		shopDetailed.dic = dic;
		[self.navigationController pushViewController:shopDetailed animated:YES];
    }
}


- (void)setNaviBar{
	
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
				self.choiceHeadView.addressName = @"定位失败";
			};
		}];
	} failure:^(NSError * error) {
		[YCLocationService turnOff];
		self.choiceHeadView.addressName = @"定位失败";
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
		MemberEnrollController *memberEnroll = [[MemberEnrollController alloc] init];
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:memberEnroll];
		[self presentViewController:nav animated:YES completion:nil];
		
	}
	
}

#pragma mark --
- (void)clickItem:(NSString*)itemIndex{
	self.segmentView2 = nil;
	self.SegmentItem = nil;
	Level2 = itemIndex;
	self.extend = NO;
	CGRect frams = self.tableview.frame;
	frams.origin.y = 170;
	self.tableview.frame = frams;
	[self.tableview reloadData];

	[self loadStoreListwithLeve1:Level1 withLeve2:Level2 withLeve3:@"1" withorderBy:@"1"];
}
- (void)clickItemsec:(NSString*)itemIndex{
	self.SegmentItem = nil;
	Level3 = itemIndex;
	self.extend = NO;
	CGRect frams = self.tableview.frame;
	frams.origin.y = 170;
	self.tableview.frame = frams;
	[self.tableview reloadData];

	[self loadStoreListwithLeve1:Level1 withLeve2:Level2 withLeve3:Level3 withorderBy:@"1"];
}

- (void)clickSegment:(int)index{
	[self loadStoreListwithLeve1:Level1 withLeve2:Level2 withLeve3:Level3 withorderBy:[NSString stringWithFormat:@"%d",index]];
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

@end





