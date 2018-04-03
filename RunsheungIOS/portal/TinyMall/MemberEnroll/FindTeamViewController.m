//
//  FindTeamViewController.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "FindTeamViewController.h"
#import "FindSearchView.h"
#import "ProtectItemsController.h"
@interface FindTeamViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)UITableView *tableView;

@property (nonatomic,retain)NSMutableArray *searchResults;

@property(nonatomic,assign) int paged;

@property (nonatomic,copy)NSString*searchKeyWord;

@end

@implementation FindTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.searchResults = @[].mutableCopy;
	[self InitUI];
}

- (void)InitUI{
	self.paged = 1;
	self.title = @"회원가입";
	[self createTableview];
}

#pragma mark -- 加载搜索数据
- (void)loadSearchResultsData:(NSString*)keysearchword{
	if (self.searchKeyWord.length) {
		keysearchword = self.searchKeyWord;
	}
	keysearchword = @"";
	
	[KLHttpTool TinyLoginSearchTeamDataUrl:@"Group/requestGroupList" WithSword:keysearchword WithPg:[NSString stringWithFormat:@"%d",self.paged] success:^(id response) {
		if([response[@"status"] intValue] == 1){
			NSArray *searchs = response[@"data"];
			if (searchs.count) {
				
				[self.searchResults addObjectsFromArray:searchs];
				[self.tableView reloadData];
				++self.paged;
				[self.tableView.mj_footer setState:MJRefreshStateIdle];

			}else {
				[self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
			}
		}
	} failure:^(NSError *err) {
		
	}];
}

#pragma mark --创建表视图
- (void)createTableview{
	if (self.tableView ==nil) {
		self.tableView = [UITableView new];
		self.tableView.tableFooterView = [UIView new];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.separatorColor = RGB(245, 245, 245);
		self.tableView.backgroundColor = RGB(255, 255, 255);
		FindSearchView *findsearchview = [[FindSearchView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 80)];
		findsearchview.inputkeyworkBlock = ^(NSString *keyword) {
			
			[self loadSearchResultsData:keyword];
			self.searchKeyWord = keyword;
		};
		self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadSearchResultsData:)];
		self.tableView.tableHeaderView = findsearchview;
		[self.view addSubview:self.tableView];
		[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.mas_equalTo(self.view);
		}];
	}
}

//表视图代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.searchResults.count;
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [[UITableViewCell alloc]init];
	
	UILabel *noLab = [UILabel new];
	[cell.contentView addSubview:noLab];
	[noLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(15);
		make.leading.mas_equalTo(25);
		make.bottom.mas_equalTo(-15);
		make.width.mas_equalTo(30);
		
	}];
	
	UILabel *name = [UILabel new];
	name.textAlignment = NSTextAlignmentCenter;
	[cell.contentView addSubview:name];
	[name mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(noLab.mas_trailing).offset(15);
		make.top.mas_equalTo(15);
		make.width.mas_equalTo(150);
		make.bottom.mas_equalTo(-15);
		
	}];
	
	UILabel *content = [UILabel new];
	content.textAlignment = NSTextAlignmentRight;
	[cell.contentView addSubview:content];
	[content mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.mas_equalTo(-15);
		make.top.mas_equalTo(15);
		make.leading.mas_equalTo(name.mas_trailing).offset(5);
		make.bottom.mas_equalTo(-15);
		
	}];
	
	switch (indexPath.row) {
		case 0:
		{
			cell.contentView.backgroundColor = RGB(80, 80, 80);
			noLab.text = @"NO. ";
			noLab.textColor = [UIColor whiteColor];
			name.text = @"단체명";
			name.textColor = [UIColor whiteColor];
			content.text = @"단체대표";
			content.textColor = [UIColor whiteColor];

		}
			break;
		default:
		{
			NSDictionary *dic = self.searchResults[indexPath.row - 1];
			noLab.text = dic[@"rum"];
			name.text = dic[@"custom_name"];
			content.text =  dic[@"kor_addr"];

		}
			break;
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row != 0) {
		ProtectItemsController *personalVC = [[ProtectItemsController alloc]init];
		[self presentViewController:personalVC animated:YES completion:nil];
	}
}

- (void)pop:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
	
}

 @end
