//
//  RSAgencyViewController.m
//  Portal
//
//  Created by zhengzeyou on 2018/1/13.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "RSAgencyViewController.h"
#import "RSDetailViewController.h"

#import "RSApplyViewController.h"


@interface RSAgencyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableview;
@end

@implementation RSAgencyViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setnavigation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代理店申请";
    [self createTableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pop) name:@"NSDISMISSNOTIFICATION" object:nil];
    
}

- (void)createTableView{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.estimatedRowHeight = 0;
        _tableview.estimatedSectionHeaderHeight = 0;
        _tableview.estimatedSectionFooterHeight = 0;
        _tableview.backgroundColor =  RGB(240, 240, 240);
        _tableview.separatorColor = RGB(240, 240, 240);
        [self.view addSubview:_tableview];
        
    }

}
#pragma mark - - tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.contentView.backgroundColor =  RGB(240, 240, 240);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *defualtData = @[@[@"default_student",@"default_hospital",@"default_wechat"],@[@"什么是学生代表",@"医院销售申请",@"微商销售申请"]];
    
    UIView *cellBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth - 20, 120)];
    cellBg.backgroundColor = [UIColor whiteColor];
    cellBg.layer.cornerRadius = 5;
    cellBg.layer.masksToBounds = YES;
    [cell.contentView addSubview:cellBg];
    
    UIImageView *headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:defualtData[0][indexPath.section]]];
    headImg.frame = CGRectMake(15, 30, 60, 60);
    headImg.layer.cornerRadius = CGRectGetWidth(headImg.frame)/2.0f;
    headImg.layer.masksToBounds = YES;
    [cellBg addSubview:headImg];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame) + 20, 45, 200, 30)];
    label.text = defualtData[1][indexPath.section];
    label.textAlignment = NSTextAlignmentLeft;
    [cellBg addSubview:label];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(cellBg.frame) - 30, 53, 10, 14)];
    icon.image = [UIImage imageNamed:@"rs_arrow"];
    [cellBg addSubview:icon];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RSDetailViewController * vc = [[RSDetailViewController alloc]init];;
    
    if (indexPath.section == 0) {
        vc.contentdata = @[@"如果拿到了人生药业的销售权，就可以在所在的学校销售人生药业的商品.通过销售商品获得大量收益。",@"· 人生药业 商品销售培训. \n· 根据销售成果支付提成. \n· 提供参与人生药业与多样的活动的机会.",@"申请 > 提交申请书> 批准.",@"现在是学生身份的在校生."];
        vc.title = @"学生销售申请";
    }else if(indexPath.section == 1){
       
       
        vc.contentdata = @[@"如果拿到了人生药业的销售权，就可以在所在的学校销售人生药业的商品.通过销售商品获得大量收益。",@"· 人生药业商品销售培训. \n·根据销售成果支付提成. \n· 促销/活动 支援.",@"申请 > 提交申请书> 批准.",@"拥有医师资格证的在医院供职的人."];
        vc.title = @"医院销售申请";
    }else{
        vc.contentdata = @[@"如果拿到了人生药业的销售权，就可以在所在的学校销售人生药业的商品.通过销售商品获得大量收益。",@"· 人生药业商品销售培训. \n·根据销售成果支付提成. \n· 促销/活动 支援.",@"申请 > 提交申请书> 批准.",@"能做好微商销售角色的充满热情的人."];
        vc.title = @"微商销售申请";
        
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setnavigation{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"shengqing_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backitem;
    
}
- (void)pop{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
