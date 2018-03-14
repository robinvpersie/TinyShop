//
//  SupermarketChekRefundProgressController.m
//  Portal
//
//  Created by ifox on 2017/1/12.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketChekRefundProgressController.h"
#import "UILabel+WidthAndHeight.h"
#import "SupermarketRefundInfoData.h"
#import "SupermarketRefundData.h"

@interface SupermarketChekRefundProgressController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation SupermarketChekRefundProgressController {
    UILabel *_code;
    UILabel *_time;
    UILabel *_type;
    UILabel *_status;
    UILabel *_money;
    
    SupermarketRefundData *refundData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = NSLocalizedString(@"SMRefundDetailTitle", nil);
    
    [self createView];
    
    [self requetData];
    
    // Do any additional setup after loading the view.
}

- (void)createView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 0)];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *codeMsg = [self createLabelWithTitle:NSLocalizedString(@"SMRefundCode", nil) textColor:[UIColor grayColor] frame:CGRectMake(20, 25, 0, 20)];
    [header addSubview:codeMsg];
    _code = [self createLabelWithTitle:@"54378797987979797922" textColor:[UIColor darkcolor] frame:CGRectMake(CGRectGetMaxX(codeMsg.frame)+10, codeMsg.frame.origin.y, 0, codeMsg.frame.size.height)];
    [header addSubview:_code];
    
    UILabel *timeMsg = [self createLabelWithTitle:NSLocalizedString(@"SMRefundTime", nil) textColor:[UIColor grayColor] frame:CGRectMake(codeMsg.frame.origin.x, CGRectGetMaxY(codeMsg.frame)+10, 0, codeMsg.frame.size.height)];
    [header addSubview:timeMsg];
    _time = [self createLabelWithTitle:@"2016-06-09" textColor:[UIColor darkcolor] frame:CGRectMake(CGRectGetMaxX(timeMsg.frame)+10, timeMsg.frame.origin.y, 0, timeMsg.frame.size.height)];
    [header addSubview:_time];
    
    UILabel *typeMsg = [self createLabelWithTitle:NSLocalizedString(@"SMRefundType", nil) textColor:[UIColor grayColor] frame:CGRectMake(codeMsg.frame.origin.x, CGRectGetMaxY(timeMsg.frame)+10, 0, codeMsg.frame.size.height)];
    [header addSubview:typeMsg];
    _type = [self createLabelWithTitle:@"商品质量问题" textColor:[UIColor darkcolor] frame:CGRectMake(CGRectGetMaxX(typeMsg.frame)+10, typeMsg.frame.origin.y, 0, typeMsg.frame.size.height)];
    [header addSubview:_type];
    
    UILabel *statusMsg = [self createLabelWithTitle:NSLocalizedString(@"SMRefundState", nil) textColor:[UIColor grayColor] frame:CGRectMake(codeMsg.frame.origin.x, CGRectGetMaxY(typeMsg.frame)+10, 0, codeMsg.frame.size.height)];
    [header addSubview:statusMsg];
    _status = [self createLabelWithTitle:@"卖家已退货,等待卖家确认收货" textColor:[UIColor darkcolor] frame:CGRectMake(CGRectGetMaxX(statusMsg.frame)+10, statusMsg.frame.origin.y, 0, statusMsg.frame.size.height)];
    [header addSubview:_status];
    
    UILabel *moneyMsg = [self createLabelWithTitle:NSLocalizedString(@"SMRefundMoney", nil) textColor:[UIColor grayColor] frame:CGRectMake(codeMsg.frame.origin.x, CGRectGetMaxY(statusMsg.frame)+10, 0, codeMsg.frame.size.height)];
    [header addSubview:moneyMsg];
    _money = [self createLabelWithTitle:@"149元" textColor:[UIColor redColor] frame:CGRectMake(CGRectGetMaxX(moneyMsg.frame)+10, moneyMsg.frame.origin.y, 0, moneyMsg.frame.size.height)];
    [header addSubview:_money];
    
    CGRect headerFrame = header.frame;
    headerFrame.size.height = CGRectGetMaxY(moneyMsg.frame) + 20;
    header.frame = headerFrame;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = header;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)requetData {
    [KLHttpTool getSupermarketRefundDetailWithOrderID:@"4A112010D0" success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            refundData = [NSDictionary getRefundDataWithDic:data];
            [self reloadUI];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)reloadUI {
    _code.text = refundData.refundBill;
    _time.text = refundData.submitDate;
    _type.text = refundData.refundType;
    _status.text = refundData.status;
    _money.text = [NSString stringWithFormat:@"%@%@",refundData.refundPrice.stringValue,NSLocalizedString(@"SMYuan", nil)];
    
    [self resetFrame];
    [_tableView reloadData];
}

- (void)resetFrame {
    _code.frame = CGRectMake(_code.frame.origin.x, _code.frame.origin.y, [UILabel getWidthWithTitle:_code.text font:_code.font], _code.frame.size.height);
    _time.frame = CGRectMake(_time.frame.origin.x, _time.frame.origin.y, [UILabel getWidthWithTitle:_time.text font:_time.font], _time.frame.size.height);
    _type.frame = CGRectMake(_type.frame.origin.x, _type.frame.origin.y, [UILabel getWidthWithTitle:_type.text font:_type.font], _type.frame.size.height);
    _status.frame = CGRectMake(_status.frame.origin.x, _status.frame.origin.y, [UILabel getWidthWithTitle:_status.text font:_status.font], _status.frame.size.height);
    _money.frame = CGRectMake(_money.frame.origin.x, _money.frame.origin.y, [UILabel getWidthWithTitle:_money.text font:_money.font], _money.frame.size.height);
//    NSLog(@"-------");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (refundData.refundFollow.count > 0) {
        return refundData.refundFollow.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    UIImageView *iconGreen = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 15, 15)];
    iconGreen.image = [UIImage imageNamed:@"circle"];
    [cell.contentView addSubview:iconGreen];
    iconGreen.hidden = YES;
    
    UIImageView *iconGray = [[UIImageView alloc] initWithFrame:CGRectMake(22, 17, 11, 11)];
    iconGray.backgroundColor = BGColor;
    iconGray.layer.cornerRadius = 11/2.0;
    [cell.contentView addSubview:iconGray];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(iconGray.center.x, CGRectGetMaxY(iconGreen.frame), 1.0f, 70)];
    line.backgroundColor = BGColor;
    [cell.contentView insertSubview:line belowSubview:iconGreen];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconGreen.frame)+20, 0, 300, 15)];
    time.font = [UIFont systemFontOfSize:11];
    time.textColor = [UIColor grayColor];
    [cell.contentView addSubview:time];
    
    UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(time.frame.origin.x, CGRectGetMaxY(time.frame)+5, APPScreenWidth, 20)];
    status.font = [UIFont systemFontOfSize:16];
    status.textColor = [UIColor darkcolor];
    [cell.contentView addSubview:status];
    
    if (refundData.refundFollow.count > 0) {
        SupermarketRefundInfoData *data = refundData.refundFollow[indexPath.row];
        time.text = data.refundDate;
        status.text = data.refundLocation;
        
        if (data.hasCurrent.integerValue == 1) {
            iconGreen.hidden = NO;
            iconGray.hidden = YES;
            time.textColor = GreenColor;
            status.textColor = GreenColor;
        }
    }
    
    if (indexPath.row == refundData.refundFollow.count-1) {
        line.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UILabel *)createLabelWithTitle:(NSString *)title
                         textColor:(UIColor *)textColor
                             frame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:15];
    CGFloat width = [UILabel getWidthWithTitle:title font:label.font];
    label.frame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
    label.text = title;
    return label;
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
