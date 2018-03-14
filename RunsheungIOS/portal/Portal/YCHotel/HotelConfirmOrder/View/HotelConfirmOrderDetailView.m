//
//  HotelConfirmOrderDetailView.m
//  Portal
//
//  Created by ifox on 2017/4/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelConfirmOrderDetailView.h"
#import "UILabel+CreateLabel.h"

@interface HotelConfirmOrderDetailView()<UITableViewDataSource, UITableViewDelegate>;

@property(nonatomic, strong)UITableView *tableview;

@end

@implementation HotelConfirmOrderDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self createView];
    }
    return self;
}

- (void)createView {
    UILabel *title = [UILabel createLabelWithFrame:CGRectMake(0, 0, APPScreenWidth, 40) textColor:HotelLightGrayColor font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"HotelDetail", nil)];
    [self addSubview:title];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame), APPScreenHeight, 0.7f)];
    line.backgroundColor = BorderColor;
 
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), APPScreenWidth, self.frame.size.height - 40) style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.separatorColor = [UIColor clearColor];
    _tableview.delegate = self;
    [self addSubview:_tableview];
}

- (void)setPoint:(NSString *)point {
    _point = point;
    [self.tableview reloadData];
}

- (void)setRealMoney:(NSString *)realMoney {
    _realMoney = realMoney;
    [self.tableview reloadData];
}

- (void)setOrderMoney:(NSString *)orderMoney {
    _orderMoney = orderMoney;
    [self.tableview reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 45;
        } else if (indexPath.row == 3) {
            return 45;
        }else {
            return 30;
        }
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"HotelConfirmTotalMoney", nil);
        cell.textLabel.textColor = HotelBlackColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        cell.detailTextLabel.text = self.orderMoney;
    }
    if (indexPath.row == 1) {
//        cell.textLabel.text = @"2017-03-20";
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = HotelLightGrayColor;
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"HotelConfirmUsePoint", nil);
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = HotelLightGrayColor;
        
        cell.detailTextLabel.text = self.point;
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = NSLocalizedString(@"HorelOrderDetailMsgTitle_4", nil);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = HotelBlackColor;
        cell.detailTextLabel.text = self.realMoney;
    }
    
    return cell;
}

@end
