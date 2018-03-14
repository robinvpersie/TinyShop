//
//  RSStudentViewController.m
//  Portal
//
//  Created by zhengzeyou on 2018/1/13.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "RSDetailViewController.h"
#import "RSApplyViewController.h"
@interface RSDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIButton *submit;
@end

@implementation RSDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setnavigation];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _submit.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createTableView];
    [self createBottom];
    
}
- (void)createBottom{
    if (_submit == nil) {
        
        _submit =[[UIButton alloc]initWithFrame:CGRectMake(0, APPScreenHeight - 50, APPScreenWidth, 50)];
        _submit.backgroundColor = RGB(34, 193, 67);
        [_submit setTitle:@"申请" forState:UIControlStateNormal];
        [_submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:_submit];
    }
 
}

- (void)submit:(UIButton*)sender{
    RSApplyViewController *vc = [[RSApplyViewController alloc]init];
    NSMutableArray *nextData;
    if ([self.title containsString:@"学生"]) {
        nextData = @[@{@"账号":@"电话号码"},@{@"学校名字":@"请输入学校名"},@{@"学系名":@"请输入学系名"},@{@"名字":@"请输入姓名"},@{@"联系方式":@"请输入联系方式"},@{@"学号":@"请输入学号"},@{@"学校地址":@"请输入学校地址"}].mutableCopy;
        
    }else  if ([self.title containsString:@"医院"]) {
         nextData = @[@{@"账号":@"电话号码"},@{@"医院名":@"请输入医院名"},@{@"医院座机电话":@"请输入座机号码"},@{@"名字":@"请输入姓名"},@{@"联系方式":@"请输入联系方式"},@{@"医院地址":@"请输入医院地址"},@{@"医生资格证号码":@"请输入医生资格证号码"}].mutableCopy;
        
    }else{
         nextData = @[@{@"账号":@"电话号码"},@{@"名字":@"请输入姓名"},@{@"联系方式":@"请输入联系方式"}].mutableCopy;
    }
    vc.data = nextData;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)createTableView{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight - 50) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.estimatedRowHeight = 0;
        _tableview.estimatedSectionHeaderHeight = 0;
        _tableview.estimatedSectionFooterHeight = 0;
        _tableview.separatorColor = RGB(219, 219, 219);
        _tableview.backgroundColor = RGB(240, 240, 240);
        _tableview.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableview];
        
    }
    
}
#pragma mark - - tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *titleStr =[self.title substringToIndex:2];
    NSMutableArray*defualtData = @[@[[NSString stringWithFormat:@"什么是%@销售？",titleStr],@"福利？",@"申请过程？",@"申请资格？"]].mutableCopy;
    if (_contentdata != nil) {
        [defualtData addObject:_contentdata];
    }
    

    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont systemFontOfSize:20];
         cell.textLabel.text = defualtData[0][indexPath.section];
    }else{
       
        NSInteger height = 50;
        if (indexPath.section == 0||indexPath.section == 1) {
            height = 90;
        }
        UITextView *textview =[[UITextView alloc]initWithFrame:CGRectMake(10, 0, APPScreenWidth - 30,height)];
        textview.textColor = RGB(103, 103, 103);
        textview.editable = NO;
        [[UITextView appearance] setTintColor:[UIColor blackColor]];
        textview.font = [UIFont systemFontOfSize:18];
        textview.text = defualtData[1][indexPath.section];
        [cell.contentView addSubview:textview];
    }
   
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if ((indexPath.section == 0&&indexPath.row == 1)||(indexPath.section == 1&&indexPath.row == 1)) {
        return 90;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return  0.01f;
    }
    return 20;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.01f;
}

- (void)setnavigation{

    _submit.hidden = NO;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"shengqing_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backitem;
    
}
- (void)pop:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
