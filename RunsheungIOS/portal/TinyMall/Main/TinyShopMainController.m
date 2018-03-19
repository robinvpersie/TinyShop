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
@interface TinyShopMainController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)UIScrollView *scrollview;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)UIView *numberDomainview;


@end

@implementation TinyShopMainController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setNaviBar];
	[self createScrollview];
	
}

- (void)createScrollview{
	if (self.scrollview ==nil) {
		self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight - 44)];
		self.scrollview.backgroundColor = RGB(252, 252, 252);
		[self.view addSubview:self.scrollview];
		
	}
	
	self.numberDomainview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 300)];
	self.numberDomainview.backgroundColor = RGB(60, 60, 60);
	[self.scrollview addSubview:self.numberDomainview];
	
	//创建标示图
	[self createTableview];
}

- (void)createTableview{
	if (self.tableView ==nil) {
		self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numberDomainview.frame), APPScreenWidth, 60+100*7) style:UITableViewStyleGrouped];
		self.tableView.tableFooterView = [UIView new];
		[self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"MainTableViewCell"];
		self.tableView.delegate = self;
		self.tableView.scrollEnabled = NO;
		self.tableView.dataSource = self;
		self.tableView.separatorColor = RGB(255, 255, 255);
		self.tableView.backgroundColor = RGB(255, 255, 255);
		[self.scrollview addSubview:self.tableView];
		
		self.scrollview.contentSize = CGSizeMake(APPScreenWidth, CGRectGetMaxY(self.tableView.frame));
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section == 0) {
		return 3;
	}
	return 4;
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [[UITableViewCell alloc]init];
	if (indexPath.section == 0) {
		UIImageView *showImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, APPScreenWidth - 20, 90)];
		[showImg setImage:[UIImage imageNamed:@"banner01"]];
		[cell.contentView addSubview:showImg];
	}else{
		MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell" forIndexPath:indexPath];
		return cell;
	}

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	
	return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 10.01f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	UILabel *view = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 10)];
	view.text = @"    고객만고만고객";
	view.textColor = RGB(46, 46, 46);
	return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
}

#pragma mark -- 设置导航栏
- (void)setNaviBar{
	self.navigationController.navigationBar.barTintColor = RGB(60, 60, 60);
	
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
	
	
	UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
	[leftBtn setImage:[UIImage imageNamed:@"icon_searchhotel"] forState:UIControlStateNormal];
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
	[leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationItem setLeftBarButtonItems:@[leftItem]];
		
	ChoiceHeadView *choiceHeadView = [[ChoiceHeadView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
	self.navigationItem.titleView = choiceHeadView;
	
}
- (void)leftBtn:(UIButton*)sender{
	
}

#pragma mark -- 右边点击方法
- (void)rightAction:(UIButton*)sender{
	if (sender.tag == 2004) {
		MemberEnrollController *memberEnroll = [[MemberEnrollController alloc] init];
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:memberEnroll];
		[self presentViewController:nav animated:YES completion:nil];
		
	}
	
}

- (void)pop:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
