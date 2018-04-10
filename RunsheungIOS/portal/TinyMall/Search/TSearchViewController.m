//
//  TSearchViewController.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/26.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "TSearchViewController.h"
#import "ChoiceTableViewCell.h"
#import "SupermarketHomeViewController.h"

@interface TSearchViewController ()<UITableViewDelegate, UITableViewDataSource>{
	int paged;
}

@property (nonatomic, strong)UITableView *searchResultTableView;
@property (nonatomic, strong)NSMutableArray *searchResultData;
@end

@implementation TSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	paged = 1;
	[self createSearchResultTableView];
	[self loadSearchResultData];
}
#pragma mark -- 加载数据
- (void)loadSearchResultData{
	
	[KLHttpTool TinySearchShopMainDataUrl:@"StoreCate/requestSearchWordStoreList"
                             Withlatitude:GetUserDefault(@"latitude")
                            Withlongitude:GetUserDefault(@"longtitude")
                                   Withpg:[NSString stringWithFormat:@"%d",paged]
                             WithPagesize:@"5"
                           WithSearchword:self.searchKeyWord
                                  success:^(id response)
    {
		self.searchResultData = [NSMutableArray array];
		if ([response[@"status"] intValue] == 1) {
			[self.searchResultData addObjectsFromArray:response[@"storelist"]];
			[self.searchResultTableView reloadData];
		}
    } failure:^(NSError *err) {
		
	}];
	
}

#pragma mark -- 创建搜索结果表示图
- (void)createSearchResultTableView{
	if (self.searchResultTableView == nil) {
	
		self.searchResultTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
		[self.searchResultTableView registerNib:[UINib nibWithNibName:@"ChoiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChoiceTableViewCellID"];
		self.searchResultTableView.delegate = self;
		self.searchResultTableView.dataSource = self;
		self.searchResultTableView.estimatedRowHeight = 0;
		self.searchResultTableView.estimatedSectionHeaderHeight = 0;
		self.searchResultTableView.estimatedSectionFooterHeight = 0;
		self.searchResultTableView.tableFooterView = [[UIView alloc] init];
		[self.view addSubview:self.searchResultTableView];

	}
	
}

#pragma mark -- 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.searchResultData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	ChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceTableViewCellID"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	NSDictionary *dics = self.searchResultData[indexPath.row];
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
	NSDictionary *dic = self.searchResultData[indexPath.row];
	SupermarketHomeViewController *shopDetailed = [[SupermarketHomeViewController alloc] init];
	shopDetailed.hidesBottomBarWhenPushed = YES;
	shopDetailed.dic = dic;
	[self.navigationController pushViewController:shopDetailed animated:YES];
}


@end
