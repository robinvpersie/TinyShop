//
//  SupermarketCheckExpressController.m
//  Portal
//
//  Created by ifox on 2017/1/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketCheckExpressController.h"
#import "UILabel+WidthAndHeight.h"
#import "SupermarketExpressData.h"
#import "SupermarketExpInfoData.h"
#import "UIImageView+ImageCache.h"

@interface SupermarketCheckExpressController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation SupermarketCheckExpressController {
    SupermarketExpressData *expressData;
    
    UIImageView *icon;//头像
    UILabel *expressStatus;//物流状态
    UILabel *code;//运单编号
    UILabel *amountAll;//总计数量
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"查看物流";
    
    [self createView];
    
    [self requestData];
    
    
    // Do any additional setup after loading the view.
}

- (void)createView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = BGColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    UIView *headerBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 130)];
    headerBg.backgroundColor = BGColor;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 120)];
    header.backgroundColor = [UIColor whiteColor];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 90, 90)];
    icon.image = [UIImage imageNamed:@"avatar"];
    icon.clipsToBounds = YES;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [header addSubview:icon];
    
    CGFloat width = [UILabel getWidthWithTitle:@"物流状态" font:[UIFont systemFontOfSize:15]];
    
    UILabel *expressStatusMsg = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+15, 15, width, 90.0/3.0)];
    expressStatusMsg.font = [UIFont systemFontOfSize:15];
    expressStatusMsg.text = @"物流状态";
    expressStatusMsg.textColor = [UIColor grayColor];
    [header addSubview:expressStatusMsg];
    
    expressStatus = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(expressStatusMsg.frame)+10, expressStatusMsg.frame.origin.y, APPScreenWidth, expressStatusMsg.frame.size.height)];
    expressStatus.textColor = GreenColor;
    expressStatus.font = expressStatusMsg.font;
    expressStatus.text = @"运输中";
    [header addSubview:expressStatus];
    
    
    UILabel *expressCode = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+15, 90.0/3.0+15, width, 90.0/3.0)];
    expressCode.font = [UIFont systemFontOfSize:15];
    expressCode.text = @"运单编号";
    expressCode.textColor = [UIColor grayColor];
    [header addSubview:expressCode];
    
    code = [[UILabel alloc] initWithFrame:CGRectMake(expressStatus.frame.origin.x, expressCode.frame.origin.y, APPScreenWidth, expressCode.frame.size.height)];
    code.font = expressCode.font;
    code.textColor = RGB(104, 104, 104);
    code.text = @"15418964567891";
    [header addSubview:code];
    
    UILabel *amount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+15, 90.0/3.0*2+15, width, 90.0/3.0)];
    amount.text = @"货物数量";
    amount.textColor = [UIColor grayColor];
    amount.font = [UIFont systemFontOfSize:15];
    [header addSubview:amount];
    
    amountAll = [[UILabel alloc] initWithFrame:CGRectMake(expressStatus.frame.origin.x, amount.frame.origin.y, APPScreenWidth, amount.frame.size.height)];
    amountAll.textColor = code.textColor;
    amountAll.font = code.font;
    amountAll.text = @"5件";
    [header addSubview:amountAll];
    
    [headerBg addSubview:header];
    _tableView.tableHeaderView = headerBg;
}

- (void)requestData {
    [KLHttpTool getSupermarketExpressDetailsuccess:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            expressData = [NSDictionary getExpDataWithDic:data];
            [self reloadUI];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)reloadUI {
    [UIImageView setimageWithImageView:icon UrlString:expressData.item_url imageVersion:nil];
    expressStatus.text = expressData.status;
    code.text = expressData.bill;
    amountAll.text = [NSString stringWithFormat:@"%@件",expressData.count];
    
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (expressData != nil) {
        return expressData.expFollow.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"expressCell"];
    UIImageView *circleGreen =[[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 12, 12)];
    circleGreen.image = [UIImage imageNamed:@"circle"];
    [cell.contentView addSubview:circleGreen];
    
    UIImageView *circleGray = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    circleGray.layer.cornerRadius = 5.0f;
    circleGray.backgroundColor = BGColor;
    circleGray.center = circleGreen.center;
    [cell.contentView addSubview:circleGray];
    
    if (indexPath.row == 0) {
        circleGray.hidden = YES;
        circleGreen.hidden = NO;
    } else {
        circleGray.hidden = NO;
        circleGreen.hidden = YES;
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(circleGreen.center.x, CGRectGetMaxY(circleGreen.frame), 1.0f, 80-CGRectGetMaxY(circleGreen.frame) + 30)];
    line.backgroundColor = BGColor;
    [cell.contentView addSubview:line];
    
    if (indexPath.row == 9) {
        line.hidden = YES;
    }
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, APPScreenWidth - 30, 20)];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.text = @"2016-12-14      08:15:45";
    [cell.contentView addSubview:timeLabel];
    
    UILabel *express = [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.frame.origin.x, CGRectGetMaxY(timeLabel.frame), APPScreenWidth, 20)];
    express.font = [UIFont systemFontOfSize:16];
    express.text = @"长沙市转运中心 已发出";
    [cell.contentView addSubview:express];
    
    if (indexPath.row == 0) {
        timeLabel.textColor = GreenColor;
        express.textColor = GreenColor;
    } else {
        timeLabel.textColor = [UIColor grayColor];
        express.textColor = [UIColor darkcolor];
    }
    
    if (expressData != nil) {
        SupermarketExpInfoData *data = expressData.expFollow[indexPath.row];
        timeLabel.text = data.expDate;
        express.text = data.expLocation;
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 40)];
    bg.backgroundColor = [UIColor whiteColor];
    
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 120, 40)];
    msg.font = [UIFont systemFontOfSize:15];
    msg.textColor = [UIColor darkcolor];
    msg.text = @"物流详情";
    [bg addSubview:msg];
    
    UIButton *phone = [UIButton buttonWithType:UIButtonTypeCustom];
    phone.frame = CGRectMake(APPScreenWidth - 15 - 25, 7, 25, 25);
    [phone setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [bg addSubview:phone];
    
    [phone addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, APPScreenWidth, 1)];
    line.backgroundColor = BGColor;
    [bg addSubview:line];
    
    return bg;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)callPhone {
    NSString *mobile = expressData.mobile;
    NSLog(@"%@",mobile);
    
    [NSString stringWithFormat:@"打电话给%@?",mobile];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"打电话给%@?",mobile] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",mobile]]];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:ok];
    [alert addAction:cancle];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
