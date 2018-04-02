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
@end

@implementation FindTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"회원가입";
	
	[self InitUI];
}

- (void)InitUI{
	[self createTableview];
}

- (void)createTableview{
	if (self.tableView ==nil) {
		self.tableView = [UITableView new];
		self.tableView.tableFooterView = [UIView new];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.separatorColor = RGB(255, 255, 255);
		self.tableView.backgroundColor = RGB(255, 255, 255);
		self.tableView.tableHeaderView = [[FindSearchView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 80)];
		[self.view addSubview:self.tableView];
		[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.mas_equalTo(self.view);
		}];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 4;
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [[UITableViewCell alloc]init];
	
	UILabel *noLab = [UILabel new];
	[cell.contentView addSubview:noLab];
	[noLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(15);
		make.leading.mas_equalTo(25);
		make.bottom.mas_equalTo(-15);
		make.width.mas_equalTo(50);
		
	}];
	
	UILabel *name = [UILabel new];
	name.textAlignment = NSTextAlignmentCenter;
	[cell.contentView addSubview:name];
	[name mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(noLab.mas_trailing).offset(15);
		make.top.mas_equalTo(15);
		make.width.mas_equalTo(100);
		make.bottom.mas_equalTo(-15);
		
	}];
	
	UILabel *content = [UILabel new];
	content.textAlignment = NSTextAlignmentRight;
	[cell.contentView addSubview:content];
	[content mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.mas_equalTo(-15);
		make.top.mas_equalTo(15);
		make.width.mas_equalTo(100);
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
			noLab.text = [NSString stringWithFormat:@"%d",(int)indexPath.row];
			name.text = @"가발협회";
			content.text = @"홍길동";

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
