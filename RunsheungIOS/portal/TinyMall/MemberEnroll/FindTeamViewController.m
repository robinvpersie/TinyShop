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
		self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
		self.tableView.tableFooterView = [UIView new];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.separatorColor = RGB(255, 255, 255);
		self.tableView.backgroundColor = RGB(255, 255, 255);
		self.tableView.tableHeaderView = [[FindSearchView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 80)];
		[self.view addSubview:self.tableView];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 4;
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [[UITableViewCell alloc]init];
	UILabel *noLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 15, 50, 30)];
	[cell.contentView addSubview:noLab];
	
	UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(noLab.frame), 15, 100, 30)];
	name.textAlignment = NSTextAlignmentCenter;
	[cell.contentView addSubview:name];
	
	UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(APPScreenWidth - 125, 15, 100, 30)];
	content.textAlignment = NSTextAlignmentRight;
	[cell.contentView addSubview:content];
	if (indexPath.row == 0) {
		
		cell.contentView.backgroundColor = RGB(80, 80, 80);
		noLab.text = @"NO. ";
		noLab.textColor = [UIColor whiteColor];
		name.text = @"단체명";
		name.textColor = [UIColor whiteColor];
		content.text = @"단체대표";
		content.textColor = [UIColor whiteColor];


	}else{
		noLab.text = [NSString stringWithFormat:@"%d",(int)indexPath.row];
		name.text = @"가발협회";
		content.text = @"홍길동";
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
	ProtectItemsController *personalVC = [[ProtectItemsController alloc]init];
	[self presentViewController:personalVC animated:YES completion:nil];
	

}

- (void)pop:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
	
}





@end
