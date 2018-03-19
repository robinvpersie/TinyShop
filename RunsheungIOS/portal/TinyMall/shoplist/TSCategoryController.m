//
//  ChoiceCategoryController.m
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/8.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import "TSCategoryController.h"
#import "ChoiceHeadView.h"
#import "ChoiceSegmentView.h"
#import "ChoiceTableViewCell.h"
#import "SegmentItem.h"
#import "TSFirstMoreViewController.h"
#import "TSItemView.h"
#import "MemberEnrollController.h"


@interface TSCategoryController ()<UITableViewDelegate,UITableViewDataSource,WJClickItemsDelegate>

@property (nonatomic,retain)UITableView *tableview;

@property (nonatomic,retain)NSDictionary *returnDit;

@property (nonatomic,retain)NSMutableDictionary *allDic;

@property (nonatomic,retain)ChoiceSegmentView *segmentView;

@property (nonatomic,retain)SegmentItem *SegmentItem;

@property (nonatomic,retain)TSItemView *ItemView;

@property (nonatomic,assign)BOOL extend;

@end

@implementation TSCategoryController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setNaviBar];
	self.extend = NO;
	self.view.backgroundColor = RGB(250, 250, 250);
	
	
	[self createSemgentViews];
	[self createTableview];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PushEditAction:) name:@"EDITACTIONNOTIFICATIONS" object:nil];
}

- (void)PushEditAction:(NSNotification*)notice{
	NSString *notices = notice.object;
	if ([notices isEqualToString:@"1"]) {
		TSFirstMoreViewController *firstMore = [TSFirstMoreViewController new];
		firstMore.title = @"添加更多";
		firstMore.choiceBlock = ^(NSString *selectItem) {
			[self.allDic setObject:@[@"新添加1",@"新添加2",@"新添加3",@"新添加4",@"新添加5"] forKey:selectItem];
			self.segmentView.dataDic = self.allDic;
		};
		[self.navigationController pushViewController:firstMore animated:YES];
	}else{
		self.extend = !self.extend;
		[self.tableview reloadData];
	}
	
}

- (void)createTableview{
	if (self.tableview == nil) {
		
		self.tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView.frame)+10, APPScreenWidth, APPScreenHeight - CGRectGetMaxY(self.segmentView.frame) - 74) style:UITableViewStylePlain];
		self.tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView.frame), APPScreenWidth, APPScreenHeight - CGRectGetMaxY(self.segmentView.frame) - 10) style:UITableViewStylePlain];
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
	if (section == 0) {
		return 1;
	}
	
	return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) {
		UITableViewCell *cell = [[UITableViewCell alloc]init];
		
		if (self.extend) {
			self.ItemView =[[TSItemView alloc]initWithFrame:CGRectMake(10, 10, APPScreenWidth - 20, 130) withData:@[@"宇成国际酒店",@"九龙城国际酒店",@"速8酒店",@"汉庭酒店",@"希尔顿酒店",@"宇成国际酒店",@"九龙城国际酒店",@"速8酒店",@"汉庭酒店",@"希尔顿酒店",@"宇成国际酒店",@"九龙城国际酒店",@"速8酒店",@"汉庭酒店",@"希尔顿酒店"]];
			self.ItemView.wjitemdelegate = self;
			
			[cell.contentView addSubview:self.ItemView];
			
		}else{
			
			self.SegmentItem = [[SegmentItem alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 50)];
			[cell.contentView addSubview:self.SegmentItem];
			
		}
		
		return cell;
	} else {
		ChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceTableViewCellID"];
		cell.starValue = 1;
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
			return 50.0f;
			
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
	
}

#pragma  mark --创建选择试图
- (void)createSemgentViews{
	
	self.allDic= @{@"音乐":@[@"通俗",@"民歌",@"乡村",@"流行"],@"科技":@[@"科技1",@"科技2",@"科技3",@"科技4"],@"贴吧":@[@"贴吧1",@"贴吧2",@"贴吧3",@"贴吧4"],@"超市":@[@"超市1",@"超市2",@"超市3",@"超市4"],@"酒店":@[@"酒店1",@"酒店2",@"酒店3",@"酒店4"],@"影院":@[@"影院1",@"影院2",@"影院3",@"影院4"],@"服装":@[@"服装1",@"服装2",@"服装3",@"服装4"]}.mutableCopy;
	
	if (self.segmentView == nil) {
		self.segmentView = [[ChoiceSegmentView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 110) withData:self.allDic];
		[self.view addSubview:self.segmentView];
	}
}

- (void)setNaviBar{
	
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
	
	
	ChoiceHeadView *choiceHeadView = [[ChoiceHeadView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    //__weak typeof(self) weakSelf = self;
    choiceHeadView.showAction = ^{
        [YCLocationService turnOn];
        [YCLocationService singleUpdate:^(CLLocation * location) {
            [YCLocationService turnoff];
        } failure:^(NSError * error) {
            [YCLocationService turnoff];
        }];
    };
	self.navigationItem.titleView = choiceHeadView;
	
	
}

#pragma mark -- 右边点击方法
- (void)rightAction:(UIButton*)sender{
	if (sender.tag == 2004) {
		MemberEnrollController *memberEnroll = [[MemberEnrollController alloc] init];
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:memberEnroll];
		[self presentViewController:nav animated:YES completion:nil];
		
	}
	
}

//点击单个的项目响应
- (void)wjClickItems:(NSString*)item{
	
}
@end

