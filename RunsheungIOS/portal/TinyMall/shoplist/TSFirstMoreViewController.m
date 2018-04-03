//
//  FirstMoreViewController.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/17.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "TSFirstMoreViewController.h"
#import "TSCategoryController.h"

@interface TSFirstMoreViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,retain)UITableView *leftTableview;
@property (nonatomic,retain)UITableView *rightTableview;
@property (nonatomic,retain)NSMutableDictionary *dict;
@property (nonatomic,retain)NSArray *firstData;
@property (nonatomic,retain)NSMutableArray *secondData;
@property (nonatomic,copy)NSString *leve2;


@end

@implementation TSFirstMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createTableview];
	[self loadData];

}

#pragma mark -- 加载数据
- (void)loadData{
	[KLHttpTool TinyRequestGetCategory1And2ListWithCustom_lev1:self.level1 WithLangtype:@"kor" success:^(id response) {
		if ([response[@"status"] intValue] == 1) {
			self.firstData = response[@"lev1s"];
			self.secondData = response[@"lev2s"];
			[self.leftTableview reloadData];
			[self.rightTableview reloadData];

		}
		
	} failure:^(NSError *err) {
		
	}];
}

- (void)loadDataClick:(NSString*)clickLev{
	[KLHttpTool TinyRequestGetCategory1And2ListWithCustom_lev1:clickLev WithLangtype:@"kor" success:^(id response) {
		if ([response[@"status"] intValue] == 1) {
			
			self.secondData = response[@"lev2s"];
			[self.rightTableview reloadData];
			
		}
		
	} failure:^(NSError *err) {
		
	}];
}

- (void)createTableview{
	if (self.leftTableview == nil) {
		
		self.leftTableview =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
		self.leftTableview.tag = 1001;
		[self.leftTableview registerNib:[UINib nibWithNibName:@"ChoiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChoiceTableViewCellID"];
		self.leftTableview.delegate = self;
		self.leftTableview.dataSource = self;
		self.leftTableview.estimatedRowHeight = 0;
		self.leftTableview.estimatedSectionHeaderHeight = 0;
		self.leftTableview.estimatedSectionFooterHeight = 0;
		self.leftTableview.separatorColor = RGB(255, 255, 255);
		self.leftTableview.tableFooterView = [[UIView alloc]init];
		[self.view addSubview:self.leftTableview];
		[self.leftTableview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.top.bottom.mas_equalTo(self.view);
			make.width.mas_equalTo(140);
		}];
		
	}
	
	if (self.rightTableview == nil) {
		
		self.rightTableview =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
		self.rightTableview.tag = 1002;
		[self.rightTableview registerNib:[UINib nibWithNibName:@"ChoiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChoiceTableViewCellID"];
		self.rightTableview.delegate = self;
		self.rightTableview.dataSource = self;
		self.rightTableview.estimatedRowHeight = 0;
		self.rightTableview.estimatedSectionHeaderHeight = 0;
		self.rightTableview.estimatedSectionFooterHeight = 0;
		self.rightTableview.separatorColor = RGB(255, 255, 255);
		self.rightTableview.tableFooterView = [[UIView alloc]init];
		[self.view addSubview:self.rightTableview];
		[self.rightTableview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.bottom.trailing.mas_equalTo(self.view);
			make.leading.mas_equalTo(self.leftTableview.mas_trailing);
		}];
		
	}

	
}

#pragma mark -- 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (tableView.tag == 1001) {
		return self.firstData.count;
	}else{
		return self.secondData.count;

	}
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = [[UITableViewCell alloc]init];
	CGRect frameline;
	
	NSDictionary *dic;
	if (tableView.tag == 1001) {
		dic = self.firstData[indexPath.row];
		cell.contentView.backgroundColor = RGB(235, 235, 235);
		frameline = CGRectMake(0, 0, 80, 1);
		cell.textLabel.text = dic[@"lev_name"];
	}else {
		dic = self.secondData[indexPath.row];
		frameline = CGRectMake(0, 0, APPScreenWidth - 80, 1);
		cell.textLabel.text = dic[@"lev_name"];
	}
	UILabel *line = [[UILabel alloc]initWithFrame:frameline];
	line.backgroundColor = RGB(244, 244, 244);
	[cell.contentView addSubview:line];
	
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	
	return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (tableView.tag == 1001) {
		NSDictionary *dic = self.firstData[indexPath.row];
		self.leve2 = dic[@"lev"];
		[self loadDataClick:self.leve2];

	}else{
		TSCategoryController *cateVC = [[TSCategoryController alloc]init];
		cateVC.hidesBottomBarWhenPushed = YES;
		NSDictionary *dicss = self.secondData[indexPath.row];
		cateVC.leves = @[dicss[@"lev1"],dicss[@"lev"],@"1"].mutableCopy;
		[self.navigationController pushViewController:cateVC animated:YES];
		

//		if (self.choiceBlock) {
//
//			self.choiceBlock(self.secondData[indexPath.row]);
//			[self.navigationController popViewControllerAnimated:YES];
//		}
	}
}

@end
