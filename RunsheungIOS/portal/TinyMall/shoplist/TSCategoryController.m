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

@interface TSCategoryController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSArray * moderArr;
@property (nonatomic, copy) NSArray * moderArr1;
@property (nonatomic, copy) NSArray * moderArr2;

@property (nonatomic,retain)UITableView *tableview;

@property (nonatomic,retain)NSDictionary *returnDit;

@property (nonatomic,retain)NSArray *allData;

@property (nonatomic,retain)ChoiceSegmentView *segmentView;

@end

@implementation TSCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setNaviBar];
	
	
	self.view.backgroundColor = RGB(250, 250, 250);
	
	
	[self createSemgentViews];
	[self createTableview];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PushEditAction) name:@"EDITACTIONNOTIFICATIONS" object:nil];
}

- (void)PushEditAction{
}

- (void)createTableview{
	if (self.tableview == nil) {
		
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	
	return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	ChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceTableViewCellID"];
	cell.starValue = 1;
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return  120;
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
	self.moderArr = self.returnDit[@"cate1"];
	self.moderArr1 = self.returnDit[@"cate2"];

	self.moderArr2 = @[@"",@"음식",@"의류"];
	
	NSMutableArray *cate2 = @[@{@"音乐":@[@{@"通俗":@[@"通俗1",@"通俗2",@"通俗3"]},@{@"民歌":@[@"民歌1",@"民歌2",@"民歌3"]},@{@"流行":@[@"流行1",@"流行2",@"流行3"]},@{@"摇滚":@[@"摇滚1",@"摇滚2",@"摇滚3"]},@{@"嘻哈":@[@"嘻哈1",@"嘻哈2",@"嘻哈3"]}]},@{@"人文":@[@{@"人文1":@[@"人文11",@"人文12",@"人文13"]},@{@"人文2":@[@"人文21",@"人文22",@"人文23"]},@{@"人文3":@[@"人文31",@"人文32",@"人文33"]},@{@"人文4":@[@"人文41",@"人文42",@"人文43"]}]},@{@"科技":@[@{@"科技1":@[@"科技11",@"科技12",@"科技13"]},@{@"科技2":@[@"科技21",@"科技22",@"科技23"]},@{@"科技3":@[@"科技31",@"科技32",@"科技33"]},@{@"科技4":@[@"科技41",@"科技42",@"科技43"]},@{@"科技5":@[@"科技51",@"科技52",@"科技53"]}]},@{@"趣事":@[@{@"趣事1":@[@"趣事11",@"趣事12",@"趣事13"]},@{@"趣事2":@[@"趣事21",@"趣事22",@"趣事23"]},@{@"趣事3":@[@"趣事31",@"趣事32",@"趣事33"]}]},@{@"贴吧":@[@{@"贴吧1":@[@"贴吧11",@"贴吧12",@"贴吧13"]},@{@"贴吧2":@[@"贴吧21",@"贴吧22",@"贴吧23"]},@{@"贴吧3":@[@"贴吧31",@"贴吧32",@"贴吧33"]},@{@"贴吧4":@[@"贴吧41",@"贴吧42",@"贴吧43"]},@{@"贴吧5":@[@"贴吧51",@"贴吧52",@"贴吧53"]}]},@{@"论坛":@[@{@"论坛1":@[@"论坛11",@"论坛12",@"论坛13"]},@{@"论坛2":@[@"论坛21",@"论坛22",@"论坛23"]},@{@"论坛3":@[@"论坛31",@"论坛32",@"论坛33"]},@{@"论坛4":@[@"论坛41",@"论坛42",@"论坛43"]},@{@"论坛5":@[@"论坛51",@"论坛52",@"论坛53"]}]}].mutableCopy;
	
	if (self.segmentView == nil) {
		self.segmentView = [[ChoiceSegmentView alloc]initWithFrame:CGRectMake(0, 64, APPScreenWidth, 170) withData:cate2];
		[self.view addSubview:self.segmentView];
	}
}

- (void)setNaviBar{
	
	UIButton *right1Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
	[right1Btn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
	right1Btn.imageEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
	UIBarButtonItem *right1Item = [[UIBarButtonItem alloc]initWithCustomView:right1Btn];
	
	UIButton *right2Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
	[right2Btn setImage:[UIImage imageNamed:@"icon_map1"] forState:UIControlStateNormal];
	UIBarButtonItem *right2Item = [[UIBarButtonItem alloc]initWithCustomView:right2Btn];
	
	[self.navigationItem setRightBarButtonItems:@[right1Item,right2Item]];
	
	
	ChoiceHeadView *choiceHeadView = [[ChoiceHeadView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
	self.navigationItem.titleView = choiceHeadView;
	
	
}

@end
