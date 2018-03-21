//
//  FirstMoreViewController.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/17.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "TSFirstMoreViewController.h"

@interface TSFirstMoreViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,retain)UITableView *leftTableview;
@property (nonatomic,retain)UITableView *rightTableview;
@property (nonatomic,retain)NSMutableDictionary *dict;
@property (nonatomic,retain)NSArray *firstData;
@property (nonatomic,retain)NSMutableArray *secondData;

@end

@implementation TSFirstMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createTableview];
	self.dict = @{
                  @"音乐":@[@"通俗",@"民歌",@"乡村",@"流行"],
                  @"科技":@[@"科技1",@"科技2",@"科技3",@"科技4"],
                  @"贴吧":@[@"贴吧1",@"贴吧2",@"贴吧3",@"贴吧4"],
                  @"超市":@[@"超市1",@"超市2",@"超市3",@"超市4"],
                  @"酒店":@[@"酒店1",@"酒店2",@"酒店3",@"酒店4"],
                  @"影院":@[@"影院1",@"影院2",@"影院3",@"影院4"],
                  @"服装":@[@"服装1",@"服装2",@"服装3",@"服装4"]
                 }.mutableCopy;
	self.firstData = self.dict.allKeys;
	self.secondData = self.dict[self.dict.allKeys.firstObject];
	
}
- (void)createTableview{
	if (self.leftTableview == nil) {
		
		self.leftTableview =[[UITableView alloc]initWithFrame:CGRectMake(0,0, 80,APPScreenHeight) style:UITableViewStylePlain];
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
		
	}
	
	if (self.rightTableview == nil) {
		
		self.rightTableview =[[UITableView alloc]initWithFrame:CGRectMake(80,0,APPScreenWidth - 80,APPScreenHeight) style:UITableViewStylePlain];
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
	
	if (tableView.tag == 1001) {
		cell.contentView.backgroundColor = RGB(235, 235, 235);
		frameline = CGRectMake(0, 0, 80, 1);
		cell.textLabel.text = self.firstData[indexPath.row];
	}else {
		frameline = CGRectMake(0, 0, APPScreenWidth - 80, 1);
		cell.textLabel.text = self.secondData[indexPath.row];
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
		NSString *keys = self.firstData[indexPath.row];
		self.secondData = self.dict[keys];
		[self.rightTableview reloadData];
	}else{
		if (self.choiceBlock) {
			
			self.choiceBlock(self.secondData[indexPath.row]);
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}

@end
